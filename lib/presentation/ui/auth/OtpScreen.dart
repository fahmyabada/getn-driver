import 'dart:async';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/auth/CarRegistrationScreen.dart';
import 'package:getn_driver/presentation/ui/auth/DriverInformationScreen.dart';
import 'package:getn_driver/presentation/ui/auth/SignUpDetailsScreen.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/RequestTabsScreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {Key? key,
      required this.phone,
      required this.countryId,
      required this.type,
      required this.phoneWithCountry,
      this.countryName})
      : super(key: key);

  final String phone;
  final String phoneWithCountry;
  final String countryId;
  final String type;
  final String? countryName;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Duration duration = const Duration(minutes: 1);
  Timer? timer;
  bool openResend = false;
  bool openNext = false;
  String? verificationId, authStatus = "", otp;
  bool load = false;

  @override
  void initState() {
    super.initState();

    verifyPhone(widget.phoneWithCountry);

    startTimer();

    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }
  }

  void startTimer() {
    timer =
        Timer.periodic(const Duration(seconds: 1), (timer) => subtractTime());
  }

  void subtractTime() {
    const subtractSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds - subtractSeconds;
      if (seconds < 0) {
        timer!.cancel();
        openResend = true;
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void nextButton(BuildContext context) async {
    if (verificationId != null) {
      FocusScope.of(context).requestFocus(FocusNode());
      AuthCredential authCreds = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: otp!);
      try {
        final result =
            await FirebaseAuth.instance.signInWithCredential(authCreds);
        if (result.user != null) {
          if (kDebugMode) {
            print('refreshToken11***********}');
          }
          final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
          getIt<SharedPreferences>().setString('firebaseToken', idToken);

          if (widget.type == "login") {
            SignCubit.get(context)
                .makeLogin(widget.phone, widget.countryId, idToken);
          } else {
            if (getIt<SharedPreferences>().getString('firebaseToken') != null) {
              setState(() {
                load = false;
              });
              navigateTo(
                  context,
                  SignUpDetailsScreen(
                    phone: widget.phone,
                    countryId: widget.countryId,
                    countryName: widget.countryName,
                    firebaseToken:
                        getIt<SharedPreferences>().getString('firebaseToken')!,
                  ));
            }
          }
        } else {
          if (kDebugMode) {
            print("Error");
          }
          setState(() {
            load = false;
          });

          showToastt(
              text: LanguageCubit.get(context)
                  .getTexts('UncorrectCode')
                  .toString(),
              state: ToastStates.error,
              context: context);
        }
      } catch (error) {
        setState(() {
          load = false;
          // openResend = true;
        });
        print("Exception*************${error}");
        if (widget.type == "login") {
          showToastt(
              text: handleErrorFirebase("login", error.toString()),
              state: ToastStates.error,
              context: context);
        } else {
          showToastt(
              text: handleErrorFirebase("register", error.toString()),
              state: ToastStates.error,
              context: context);
        }
      }
    } else {
      load = false;
      showToastt(
          text: "wait OTP message please..",
          state: ToastStates.error,
          context: context);
    }
  }

  Future<void> verifyPhone(phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(

        /// Make sure to prefix with your country code
        phoneNumber: phoneNumber,

        ///No duplicated SMS will be sent out upon re-entry (before timeout).
        timeout: const Duration(seconds: 5),

        /// If the SIM (with phoneNumber) is in the current device this function is called.
        /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
        /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
        verificationCompleted: (AuthCredential authResult) {
          if (kDebugMode) {
            print('verifyPhone***********$phoneNumber');
          }
          authStatus = "Your account is successfully verified";
        },

        /// Called when the verification is failed
        verificationFailed: (final authException) {
          if (kDebugMode) {
            print('verificationFailed***********${authException.message!}');
          }
          authStatus = "Authentication failed";
        },

        /// This is called after the OTP is sent. Gives a `verificationId` and `code`
        codeSent: (String verId, [int? forceResend]) {
          print('codeSent***********$verId');
          verificationId = verId;
          authStatus = "OTP has been successfully send";

        },

        /// After automatic code retrival `tmeout` this function is called
        codeAutoRetrievalTimeout: (String verId) {
          print('codeAutoRetrievalTimeout***********$verId');
          verificationId = verId;
          authStatus = "TIMEOUT";
        });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LanguageCubit.get(context).isEn
          ? ui.TextDirection.ltr
          : ui.TextDirection.rtl,
      child: BlocProvider(
        create: (context) => SignCubit(),
        child: BlocConsumer<SignCubit, SignState>(listener: (context1, state) {
          if (state is SendOtpSuccessState) {
            if (kDebugMode) {
              print('OtpScreen*******SendOtpSuccessState');
            }
            setState(() {
              openResend = false;
              openNext = false;
              duration = const Duration(minutes: 1);
            });
            startTimer();
          } else if (state is SendOtpErrorState) {
            if (kDebugMode) {
              print('OtpScreen*******SendOtpErrorState');
            }

            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          } else if (state is SignInSuccessState) {
            setState(() {
              load = false;
            });
            if (kDebugMode) {
              print('OtpScreen*******SignInSuccessState');
            }
            showToastt(
                text: LanguageCubit.get(context)
                    .getTexts('LoginSuccessfully')
                    .toString(),
                state: ToastStates.success,
                context: context);
            if (state.data.phone != null) {
              getIt<SharedPreferences>().setString('phone', state.data.phone!);
            }
            if (state.data.name != null) {
              getIt<SharedPreferences>().setString('name', state.data.name!);
            }
            if (state.data.token != null) {
              getIt<SharedPreferences>().setString('token', state.data.token!);
            }
            if (state.data.image != null) {
              getIt<SharedPreferences>()
                  .setString('userImage', state.data.image!.src!);
            }
            getIt<SharedPreferences>().setString('countryId', widget.countryId);

            if (state.data.frontNationalImage == null) {
              getIt<SharedPreferences>().setString('typeSign', "sign");
              navigateAndFinish(context, const DriverInformationScreen());
            } else if (state.data.hasCar != null && !state.data.hasCar!) {
              getIt<SharedPreferences>()
                  .setString('typeSign', "signWithInformation");
              navigateAndFinish(context, const CarRegistrationScreen());
            } else if (state.data.hasCar != null &&
                state.data.hasCar! &&
                state.data.frontNationalImage != null) {
              getIt<SharedPreferences>()
                  .setString('typeSign', "signWithCarRegistration");
              navigateAndFinish(context, const RequestTabsScreen());
            }
          } else if (state is SignInErrorState) {
            if (kDebugMode) {
              print('OtpScreen*******SignInErrorState');
            }

            setState(() {
              load = false;
            });
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
        }, builder: (context, state) {
          return Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: black,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: white,
              elevation: 0.0,
              iconTheme: const IconThemeData(color: black),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Directionality(
                      textDirection: LanguageCubit.get(context).isEn
                          ? ui.TextDirection.ltr
                          : ui.TextDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.r),
                        child: Text(
                          "${LanguageCubit.get(context).getTexts('Enter6-digit').toString()} \n ${widget.phoneWithCountry}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.sp,
                              color: black),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.r),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        pastedTextStyle: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if(v!.contains(' ')){
                            return LanguageCubit.get(context)
                                .getTexts('emptyOTP')
                                .toString();
                          }
                          else if (v.length < 3) {
                            return LanguageCubit.get(context)
                                .getTexts('EnterCode')
                                .toString();
                          } else {
                            return null;
                          }
                        },
                        obscureText: false,
                        errorTextSpace: 30.h,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            inactiveColor: blueLight),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) {
                          debugPrint("Completed");
                        },
                        onChanged: (value) {
                          debugPrint(value);
                           if (value.length == 6 && !value.contains(' ')) {
                            setState(() {
                              otp = value;
                              openResend = false;
                              openNext = true;
                            });
                          } else {
                            setState(() {
                              // openResend = true;
                              openNext = false;
                            });
                          }
                        },
                        enablePinAutofill: true,

                        beforeTextPaste: (text) {
                          debugPrint("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          if(RegExp(r'^[0-9]+$').hasMatch(text!)){
                            return true;

                          }else {
                            return false;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(height: 35.h),
                    buildTime(context),
                    SizedBox(height: 32.h),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 25.r, vertical: 30.r),
                      child: load
                          ? loading()
                          : defaultButton3(
                              press: () {
                                load = true;
                                nextButton(context);
                              },
                              disablePress: openNext,
                              text: LanguageCubit.get(context)
                                  .getTexts('Next')
                                  .toString(),
                              backColor: accentColor,
                              textColor: white),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildTime(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        openResend
            ? InkWell(
                onTap: () {
                  setState(() {
                    openResend = false;
                    openNext = false;
                    duration = const Duration(minutes: 1);
                  });
                  startTimer();
                  verifyPhone(widget.phoneWithCountry);
                  print('object********${timer!.isActive}');
                },
                child: Text(
                  LanguageCubit.get(context).getTexts('resend').toString(),
                  style: TextStyle(color: blueColor, fontSize: 18.sp),
                ),
              )
            : Text(
                LanguageCubit.get(context).getTexts('resend').toString(),
                style: TextStyle(color: greyColor, fontSize: 18.sp),
              ),
        Text(
          LanguageCubit.get(context).getTexts('codeIn').toString(),
          style: TextStyle(color: black, fontSize: 18.sp),
        ),
        timer!.isActive
            ? Text(
                "$minutes:$seconds",
                style: TextStyle(color: black, fontSize: 18.sp),
              )
            : Text(
                "00:00",
                style: TextStyle(color: black, fontSize: 18.sp),
              ),
      ],
    );
  }
}

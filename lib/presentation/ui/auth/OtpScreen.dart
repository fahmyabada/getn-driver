import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:getn_driver/presentation/ui/request/requestTabs/RequestTabsScreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {Key? key,
      required this.phone,
      required this.countryId,
      required this.type,
      this.verificationId,
      required this.phoneWithCountry,
      this.countryName})
      : super(key: key);

  final String phone;
  final String phoneWithCountry;
  final String? verificationId;
  final String countryId;
  final String type;
  final String? countryName;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String signature = "{{ app signature }}";
  Duration duration = const Duration(minutes: 1);
  Timer? timer;
  bool openResend = false;
  bool openNext = false;
  String? verificationId, authStatus = "", otp;
  bool load = false;

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

  void startTimer() {
    timer =
        Timer.periodic(const Duration(seconds: 1), (timer) => subtractTime());
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    verificationId = widget.verificationId;
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void nextButton() async {
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
          load = false;
        }
      } else {
        if (kDebugMode) {
          print("Error");
        }
        load = false;
        showToastt(
            text: "uncorrect code", state: ToastStates.error, context: context);
      }
    } catch (error) {
      load = false;
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
          setState(() {
            authStatus = "Your account is successfully verified";
          });
        },

        /// Called when the verification is failed
        verificationFailed: (final authException) {
          if (kDebugMode) {
            print('verificationFailed***********${authException.message!}');
          }
          setState(() {
            authStatus = "Authentication failed";
          });
        },

        /// This is called after the OTP is sent. Gives a `verificationId` and `code`
        codeSent: (String verId, [int? forceResend]) {
          print('codeSent***********$verId');
          setState(() {
            verificationId = verId;
            authStatus = "OTP has been successfully send";
          });
        },

        /// After automatic code retrival `tmeout` this function is called
        codeAutoRetrievalTimeout: (String verId) {
          print('codeAutoRetrievalTimeout***********$verId');
          setState(() {
            verificationId = verId;
            authStatus = "TIMEOUT";
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignCubit, SignState>(listener: (context1, state) {
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
      }
      else if (state is SendOtpErrorState) {
        if (kDebugMode) {
          print('OtpScreen*******SendOtpErrorState');
        }

        showToastt(
            text: state.message, state: ToastStates.error, context: context);
      }
      else if (state is SignInSuccessState) {
        load = false;
        if (kDebugMode) {
          print('OtpScreen*******SignInSuccessState');
        }
        showToastt(
            text: "login successfully",
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
        if (state.data.frontNationalImage?.src == null) {
          getIt<SharedPreferences>().setString('typeSign', "sign");
          navigateTo(context, const DriverInformationScreen());
        } else if (state.data.hasCar != null && !state.data.hasCar!) {
          getIt<SharedPreferences>()
              .setString('typeSign', "signWithInformation");
          navigateTo(context, const CarRegistrationScreen());
        } else if (state.data.hasCar != null &&
            state.data.hasCar! &&
            state.data.frontNationalImage?.src != null) {
          getIt<SharedPreferences>()
              .setString('typeSign', "signWithCarRegistration");
          navigateTo(context, const RequestTabsScreen());
        }
      }
      else if (state is SignInErrorState) {
        if (kDebugMode) {
          print('OtpScreen*******SignInErrorState');
        }

        load = false;
        showToastt(
            text: state.message, state: ToastStates.error, context: context);
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.r),
                  child: Text(
                    "Enter the 6- digit code sent to \n ${widget.phoneWithCountry}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp,
                        color: black),
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.r),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 3) {
                        return "Enter Code Please...";
                      } else {
                        return null;
                      }
                    },
                    obscureText: false,
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
                      if (value.length == 6) {
                        setState(() {
                          otp = value;
                          openResend = false;
                          openNext = true;
                          if (timer!.isActive) {
                            timer!.cancel();
                          }
                        });
                      } else {
                        setState(() {
                          openResend = true;
                          openNext = false;
                        });
                      }
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                // SelectableText("App Signature : $signature",
                //     enableInteractiveSelection: true),
                // ElevatedButton(
                //   child: const Text('Get app signature'),
                //   onPressed: () async {
                //     signature = await SmsAutoFill().getAppSignature;
                //     setState(() {});
                //   },
                // ),
                SizedBox(height: 35.h),
                buildTime(context),
                SizedBox(height: 32.h),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
                  child: load?
                  const Center(
                      child: CircularProgressIndicator(
                        color: black,
                      )):
                  defaultButton3(
                      press: () {
                        load = true;
                        nextButton();
                      },
                      disablePress: openNext,
                      text: "Next",
                      backColor: accentColor,
                      textColor: white),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
                },
                child: Text(
                  "resend ",
                  style: TextStyle(color: blueColor, fontSize: 18.sp),
                ),
              )
            : Text(
                "resend ",
                style: TextStyle(color: greyColor, fontSize: 18.sp),
              ),
        Text(
          "code in ",
          style: TextStyle(color: black, fontSize: 18.sp),
        ),
        Text(
          "$minutes:$seconds",
          style: TextStyle(color: black, fontSize: 18.sp),
        ),
      ],
    );
  }
}

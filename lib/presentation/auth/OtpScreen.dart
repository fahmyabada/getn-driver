import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/auth/DriverInformationScreen.dart';
import 'package:getn_driver/presentation/auth/SignUpDetails.dart';
import 'package:getn_driver/presentation/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/request/RequestScreen.dart';
import 'package:getn_driver/presentation/request/request_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key,
    required this.phone,
    required this.countryId,
    required this.type,
    this.verificationId})
      : super(key: key);

  final String phone;
  final String? verificationId;
  final String countryId;
  final String type;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String signature = "{{ app signature }}";
  Duration duration = const Duration(seconds: 15);
  Timer? timer;
  bool openResend = false;
  bool openNext = false;
  String? verificationId, authStatus = "", otp;

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
    AuthCredential authCreds =
    PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otp!);
    print('verificationId***********$verificationId*************$otp');
    try{
      final result = await FirebaseAuth.instance.signInWithCredential(authCreds);
      if (result.user != null) {
        if (kDebugMode) {
          print('refreshToken11***********}');
        }
        final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
        getIt<SharedPreferences>().setString(
            'firebaseToken', idToken);
        if (widget.type == "login") {
          SignCubit.get(context).makeLogin(
              widget.phone,
              widget.countryId,
              idToken);
        } else {
          if (getIt<SharedPreferences>()
              .getString('firebaseToken') !=
              null) {
            navigateTo(
                context,
                SignUpDetailsScreen(
                  phone: widget.phone,
                  countryId: widget.countryId,
                  firebaseToken: getIt<SharedPreferences>()
                      .getString('firebaseToken')!,
                ));
          }
        }
      }
      else {
        if (kDebugMode) {
          print("Error");
        }
        showToastt(
            text: "uncorrect code", state: ToastStates.error, context: context);

      }
    }on Exception catch(error){
      print("Exception*************${error}");
      showToastt(
          text: handleErrorFirebase(error.toString()), state: ToastStates.error, context: context);
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

  // void listenOtp() async {
  //   await SmsAutoFill().unregisterListener();
  //   await SmsAutoFill().listenForCode();
  //   await SmsAutoFill().listenForCode;
  // }

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
          duration = const Duration(seconds: 15);
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
        if (kDebugMode) {
          print('OtpScreen*******SignInSuccessState');
        }
        showToastt(
            text: "user already have account",
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
        if (state.data.frontNationalImage!.src != null) {
          getIt<SharedPreferences>()
              .setString('typeSign', "signWithInformation");
          navigateTo(
              context,
              BlocProvider(
                  create: (context) => RequestCubit(),
                  child: const RequestScreen()));
        } else {
          getIt<SharedPreferences>().setString('typeSign', "sign");
          navigateTo(context, const DriverInformationScreen());
        }
      }
      else if (state is SignInErrorState) {
        if (kDebugMode) {
          print('OtpScreen*******SignInErrorState');
        }

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
                    "Enter the 4- digit code sent to \n ${widget.phone}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp,
                        color: black),
                  ),
                ),
                SizedBox(height: 30.h),
             /*   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 60.w,
                      child: defaultFormField(
                        controller: pin1Controller,
                        type: TextInputType.number,
                        textSize: 25,
                        autoFocus: true,
                        borderColor: black,
                        borderRadius: 15,
                        changed: (value) {
                          nextField(value, pin2FocusNode);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 60.w,
                      child: defaultFormField(
                        controller: pin2Controller,
                        type: TextInputType.number,
                        textSize: 25,
                        foucsnode: pin2FocusNode,
                        borderColor: black,
                        borderRadius: 15,
                        changed: (value) {
                          nextField(value, pin3FocusNode);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 60.w,
                      child: defaultFormField(
                        controller: pin3Controller,
                        type: TextInputType.number,
                        textSize: 25,
                        foucsnode: pin3FocusNode,
                        borderColor: black,
                        borderRadius: 15,
                        changed: (value) {
                          nextField(value, pin4FocusNode);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 60.w,
                      child: defaultFormField(
                        controller: pin4Controller,
                        type: TextInputType.number,
                        textSize: 25,
                        foucsnode: pin4FocusNode,
                        borderColor: black,
                        borderRadius: 15,
                        changed: (value) {
                          if (value.length == 1) {
                            pin4FocusNode!.unfocus();
                            if (pin1Controller.text.isNotEmpty &&
                                pin2Controller.text.isNotEmpty &&
                                pin3Controller.text.isNotEmpty &&
                                pin4Controller.text.isNotEmpty) {
                              setState(() {
                                openResend = false;
                                openNext = true;
                                timer!.cancel();
                              });
                            }
                            // Then you need to check is the code is correct or not
                          }
                        },
                      ),
                    ),
                  ],
                ),*/
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.r),
                  child: PinFieldAutoFill(
                    decoration: UnderlineDecoration(
                        textStyle:
                            TextStyle(fontSize: 20.sp, color: Colors.black),
                        colorBuilder: const FixedColorBuilder(yellowLightColor),
                        bgColorBuilder: const FixedColorBuilder(blueLight),
                        gapSpace: 30.w),
                    codeLength: 6,
                    currentCode: otp??"",
                    onCodeSubmitted: (code) {},
                    onCodeChanged: (code) {
                      if (code!.length == 6) {
                          FocusScope.of(context).requestFocus(FocusNode());
                            openResend = false;
                          openNext = true;
                          timer!.cancel();
                          setState(() {
                            otp = code.toString();
                        });
                      }
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
                defaultButton3(
                    press: ()  {
                      nextButton();
                    },
                    disablePress: openNext,
                    text: "Next",
                    backColor: accentColor,
                    textColor: white),
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
              duration = const Duration(seconds: 15);
            });
            startTimer();
            verifyPhone(
                '${widget.countryId}${widget.phone}');

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

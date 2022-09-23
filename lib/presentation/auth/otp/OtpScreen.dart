import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/auth/driverInformation/DriverInformationScreen.dart';
import 'package:getn_driver/presentation/auth/signUpDetails/SignUpDetails.dart';
import 'package:getn_driver/presentation/dashBoard/DashBoardScreen.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key,
    required this.phone,
    required this.countryId,
    required this.isAlreadyUser,
    this.code})
      : super(key: key);

  final String phone;
  final String? code;
  final String countryId;
  final bool isAlreadyUser;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _code = "";
  String signature = "{{ app signature }}";
  Duration duration = const Duration(seconds: 15);
  Timer? timer;
  bool openResend = false;
  bool openNext = false;

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
    print("phoneOtpScreen******************${widget.phone}");
    startTimer();
    listenOtp();
    if (widget.code != null) {
      _code = widget.code!;
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    timer!.cancel();
    super.dispose();
  }

  void listenOtp() async {
    await SmsAutoFill().unregisterListener();
    await SmsAutoFill().listenForCode();
    await SmsAutoFill().listenForCode;
    print("listenOtp******************");
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignCubit, SignState>(listener: (context, state) {
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
      } else if (state is SendOtpErrorState) {
        if (kDebugMode) {
          print('OtpScreen*******SendOtpErrorState');
        }

        showToastt(
            text: state.message, state: ToastStates.error, context: context);
      }else  if (state is SignInSuccessState) {
        if (kDebugMode) {
          print('OtpScreen*******SignInSuccessState');
        }

          // if (state.data.frontNationalImage != null) {
          //   navigateTo(
          //       context, const DriverInformationScreen());
          // }
        // } else {
        //   navigateTo(context, const DashBoardScreen());
        // }
      } else if (state is SignInErrorState) {
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.r),
                  child: PinFieldAutoFill(
                    decoration: UnderlineDecoration(
                        textStyle:
                        TextStyle(fontSize: 20.sp, color: Colors.black),
                        colorBuilder: const FixedColorBuilder(yellowLightColor),
                        bgColorBuilder: const FixedColorBuilder(grey),
                        gapSpace: 30.w),
                    currentCode: _code,
                    codeLength: 4,
                    onCodeSubmitted: (code) {},
                    onCodeChanged: (code) {
                      listenOtp();
                      if (code!.length == 4) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (widget.code != null) {
                          openResend = false;
                          openNext = true;
                          timer!.cancel();
                        } else {
                          setState(() {
                            openNext = true;
                            openResend = false;
                            timer!.cancel();
                            _code = code.toString();
                          });
                        }
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
                    press: () {
                      if (widget.isAlreadyUser) {
                        SignCubit.get(context).makeLogin(
                            widget.phone, widget.countryId, _code);
                      } else {
                        navigateTo(
                            context,
                            SignUpDetailsScreen(
                              phone: widget.phone,
                              countryId: widget.countryId,
                              codeOtp: _code,
                            ));
                      }
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
            SignCubit.get(context)
                .sendOtp("otp", widget.phone, widget.countryId);
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

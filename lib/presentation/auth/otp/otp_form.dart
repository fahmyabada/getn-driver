import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

/*
class OtpForm extends StatefulWidget {
  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 60.w,
              child: defaultFormField(
                type: TextInputType.number,
                textSize: 25,
                autoFocus: true,
                borderColor: black,
                changed: (value) {
                  nextField(value, pin2FocusNode);
                },
              ),
            ),
            SizedBox(
              width: 60.w,
              child: defaultFormField(
                type: TextInputType.number,
                textSize: 25,
                foucsnode: pin2FocusNode,
                borderColor: black,
                changed: (value) {
                  nextField(value, pin3FocusNode);
                },
              ),
            ),
            SizedBox(
              width: 60.w,
              child: defaultFormField(
                type: TextInputType.number,
                textSize: 25,
                foucsnode: pin3FocusNode,
                borderColor: black,
                changed: (value) {
                  nextField(value, pin4FocusNode);
                },
              ),
            ),
            SizedBox(
              width: 60.w,
              child: defaultFormField(
                type: TextInputType.number,
                textSize: 25,
                foucsnode: pin4FocusNode,
                borderColor: black,
                changed: (value) {
                  if (value.length == 1) {
                    pin4FocusNode!.unfocus();
                    // Then you need to check is the code is correct or not
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  State<OtpForm> createState() => _MyAppState();
}

class _MyAppState extends State<OtpForm> {
  final int _otpCodeLength = 4;
  bool _isLoadingButton = false;
  bool _enableButton = false;
  String _otpCode = "";
  final intRegex = RegExp(r'\d+', multiLine: true);
  TextEditingController textEditingController = TextEditingController(text: "");
  Duration duration = const Duration(seconds: 5);
  Timer? timer;

  bool isCountDown = true;

  void subtractTime() {
    const subtractSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds - subtractSeconds;
      if (seconds < 0) {
        timer!.cancel();
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
    _getSignatureCode();
    _startListeningSms();
  }

  @override
  void dispose() {
    super.dispose();
    SmsVerification.stopListening();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  /// get signature code
  _getSignatureCode() async {
    String? signature = await SmsVerification.getAppSignature();
    print("signature $signature");
  }

  /// listen sms
  _startListeningSms() {
    SmsVerification.startListeningSms().then((message) {
      setState(() {
        _otpCode = SmsVerification.getCode(message, intRegex);
        textEditingController.text = _otpCode;
        _onOtpCallBack(_otpCode, true);
      });
    });
  }

  _onSubmitOtp() {
    setState(() {
      _isLoadingButton = !_isLoadingButton;
      _verifyOtpCode();
    });
  }

  _onClickRetry() {
    _startListeningSms();
  }

  _onOtpCallBack(String otpCode, bool isAutofill) {
    setState(() {
      _otpCode = otpCode;
      if (otpCode.length == _otpCodeLength && isAutofill) {
        _enableButton = false;
        _isLoadingButton = true;
        _verifyOtpCode();
      } else if (otpCode.length == _otpCodeLength && !isAutofill) {
        _enableButton = true;
        _isLoadingButton = false;
      } else {
        _enableButton = false;
      }
    });
  }

  _verifyOtpCode() {
    FocusScope.of(context).requestFocus(FocusNode());
    Timer(const Duration(milliseconds: 4000), () {
      setState(() {
        _isLoadingButton = false;
        _enableButton = false;
      });

      showToastt(
          text: "Verification OTP Code $_otpCode Success",
          state: ToastStates.success,
          context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFieldPin(
              textController: textEditingController,
              autoFocus: true,
              codeLength: _otpCodeLength,
              alignment: MainAxisAlignment.center,
              defaultBoxSize: 46.0,
              margin: 10,
              selectedBoxSize: 46.0,
              textStyle: const TextStyle(fontSize: 16),
              defaultDecoration: _pinPutDecoration.copyWith(
                  border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.6))),
              selectedDecoration: _pinPutDecoration,
              onChange: (code) {
                _onOtpCallBack(code, false);
              }),
          SizedBox(height: 35.h),
          buildTime(),
          SizedBox(height: 32.h),
          defaultButton3(
              press: () {
                setState(() {
                  duration = const Duration(seconds: 5);
                  startTimer();
                });
              },
              text: "Next",
              backColor: accentColor,
              textColor: white),
          const SizedBox(
            height: 32,
          ),
          SizedBox(
            width: double.maxFinite,
            child: MaterialButton(
              onPressed: _enableButton ? _onSubmitOtp : null,
              color: Colors.blue,
              disabledColor: Colors.blue[100],
              child: _setUpButtonChild(),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: TextButton(
              onPressed: _onClickRetry,
              child: const Text(
                "Retry",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    print("***************minutes = $minutes ******* seconds = $seconds");

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "resend ",
          style: TextStyle(color: blueColor, fontSize: 18.sp),
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

  Widget _setUpButtonChild() {
    if (_isLoadingButton) {
      return const SizedBox(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return const Text(
        "Verify",
        style: TextStyle(color: Colors.white),
      );
    }
  }
}

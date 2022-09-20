import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/auth/otp/otp_form.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.phone}) : super(key: key);

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 25.r),
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
              const OtpForm(),

            ],
          ),
        ),
      ),
    );
  }


}

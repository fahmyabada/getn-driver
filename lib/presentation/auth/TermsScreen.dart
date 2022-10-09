import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/auth/cubit/cubit.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70.h,
                    ),
                    Text(
                      'Terms & Cnditions',
                      style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      'Assigment',
                      style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Contrary to popular belief, Lorem Inosimplyrandom and text. It has roots in a piece of classical Latin literature 45 BC, making it over 2000 years old. ',
                      style: TextStyle(fontSize: 18.sp, color: primaryColor),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'select an offer',
                      style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Contrary to popular belief, Lorem Inosimplyrandom and text. It has roots in a piece of classical Latin literature 45 BC, making it over 2000 years old. ',
                      style: TextStyle(fontSize: 18.sp, color: primaryColor),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Driver Pass price',
                      style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Contrary to popular belief, Lorem Inosimplyrandom and text. It has roots in a piece of classical Latin literature 45 BC, making it over 2000 years old. ',
                      style: TextStyle(fontSize: 18.sp, color: primaryColor),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
                child: defaultButton3(
                    press: () {
                      SignCubit.get(context).setTerms(true);
                      Navigator.of(context).pop();
                    },
                    text: "Accept",
                    backColor: accentColor,
                    textColor: white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  void initState() {
    super.initState();

    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LanguageCubit.get(context).isEn
          ? ui.TextDirection.ltr
          : ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LanguageCubit.get(context).getTexts('Terms&Condition').toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Assignment',
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
              defaultButton3(
                  press: () {
                    Navigator.of(context).pop(true);
                  },
                  text: LanguageCubit.get(context).getTexts('Accept').toString(),
                  backColor: accentColor,
                  textColor: white),
            ],
          ),
        ),
      ),
    );
  }
}

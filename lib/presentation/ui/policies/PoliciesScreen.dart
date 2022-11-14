import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/policies/PolicyDetailsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoliciesScreen extends StatefulWidget {
  const PoliciesScreen({Key? key}) : super(key: key);

  @override
  State<PoliciesScreen> createState() => _PoliciesScreenState();
}

class _PoliciesScreenState extends State<PoliciesScreen> {
  bodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.r,
          vertical: 8.r,
        ),
        child: Column(
          children: [
            buildSettingItem(
              context: context,
              title: LanguageCubit.get(context)
                  .getTexts('Terms&Condition')
                  .toString(),
              onClick: () {
                navigateTo(
                    context,
                    PolicyDetailsScreen(
                      title: LanguageCubit.get(context)
                          .getTexts('Terms&Condition')
                          .toString(),
                    ));
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            buildSettingItem(
              context: context,
              title: LanguageCubit.get(context)
                  .getTexts('PrivacyPolicy')
                  .toString(),
              onClick: () {
                navigateTo(
                    context,
                    PolicyDetailsScreen(
                      title: LanguageCubit.get(context)
                          .getTexts('PrivacyPolicy')
                          .toString(),
                    ));
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            buildSettingItem(
              context: context,
              title: LanguageCubit.get(context).getTexts('AboutUs').toString(),
              onClick: () {
                navigateTo(
                    context,
                    PolicyDetailsScreen(
                      title: LanguageCubit.get(context)
                          .getTexts('AboutUs')
                          .toString(),
                    ));
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            buildSettingItem(
              context: context,
              title:
                  LanguageCubit.get(context).getTexts('ContactUs').toString(),
              onClick: () {
                navigateTo(
                    context,
                    PolicyDetailsScreen(
                      title: LanguageCubit.get(context)
                          .getTexts('ContactUs')
                          .toString(),
                    ));
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            buildSettingItem(
              context: context,
              title: LanguageCubit.get(context).getTexts('FAQs').toString(),
              onClick: () {
                navigateTo(
                    context,
                    PolicyDetailsScreen(
                      title: LanguageCubit.get(context)
                          .getTexts('FAQs')
                          .toString(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingItem({
    required BuildContext context,
    required String title,
    required VoidCallback onClick,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: primaryColor,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        size: 20.sp,
        color: primaryColor,
      ),
      onTap: onClick,
      tileColor: const Color(0xFFF8F8F8),
    );
  }

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
            LanguageCubit.get(context).getTexts('Policies').toString(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: bodyWidget(context),
        ),
      ),
    );
  }
}

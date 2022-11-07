import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/policies/PolicyDetailsScreen.dart';
import 'dart:ui' as ui;

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
              title: "Terms & Conditions",
              onClick: () {
                navigateTo(
                    context,
                    const PolicyDetailsScreen(
                      title: 'Terms & Conditions',
                    ));
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            buildSettingItem(
              context: context,
              title: "Privacy Policy",
              onClick: () {
                navigateTo(
                    context,
                    const PolicyDetailsScreen(
                      title: 'Privacy Policy',
                    ));
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            buildSettingItem(
              context: context,
              title: 'About Us',
              onClick: () {
                navigateTo(
                    context,
                    const PolicyDetailsScreen(
                      title: 'About Us',
                    ));
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            buildSettingItem(
              context: context,
              title: 'Contact Us',
              onClick: () {
                navigateTo(
                    context,
                    const PolicyDetailsScreen(
                      title: 'Contact Us',
                    ));
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            buildSettingItem(
              context: context,
              title: 'FAQs',
              onClick: () {
                navigateTo(
                    context,
                    const PolicyDetailsScreen(
                      title: 'FAQs',
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
            'Policies',
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

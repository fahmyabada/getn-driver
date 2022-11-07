import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/editProfile/EditProfileScreen.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/myCar/MyCarScreen.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool? isEn;

  @override
  void initState() {
    super.initState();

    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      isEn = getIt<SharedPreferences>().getBool("isEn")!;
    }
  }

  bodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.r,
          vertical: 8.r,
        ),
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  Text(
                    LanguageCubit.get(context)
                        .getTexts("Arabic")
                        .toString(),
                    style: TextStyle(
                        color: black,
                        fontSize: 20.sp),
                  ),
                  Switch(
                    activeColor: primaryColor,
                    value:
                    LanguageCubit.get(context)
                        .isEn,
                    onChanged: (value) {
                      setState(() {
                        LanguageCubit.get(context)
                            .changeLan(value);
                      });
                    },
                  ),
                  Text(
                    LanguageCubit.get(context)
                        .getTexts("English")
                        .toString(),
                    style: TextStyle(
                        color: black,
                        fontSize: 20.sp),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            buildSettingItem(
              context: context,
              title: "My Account",
              onClick: () {
                navigateTo(
                    context,
                    const EditProfileScreen());
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            buildSettingItem(
              context: context,
              title: "My Car",
              onClick: () {
                navigateTo(
                    context,
                    const MyCarScreen());
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
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LanguageCubit.get(context).isEn
          ? ui.TextDirection.ltr
          : ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Setting',
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

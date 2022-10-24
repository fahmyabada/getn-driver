import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/editProfile/EditProfileScreen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

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
    return Scaffold(
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
    );
  }
}

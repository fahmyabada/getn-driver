import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/auth/SignInScreen.dart';
import 'package:getn_driver/presentation/ui/policies/PoliciesScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/request_cubit.dart';
import 'package:getn_driver/presentation/ui/setting/SettingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDialog extends StatelessWidget {
  final String? title, description, type, id;
  final VoidCallback? press;
  final Color? backgroundColor,
      titleColor,
      descColor,
      btnOkColor,
      btnCancelColor;

  var commentController = TextEditingController();
  var formKeyRequest = GlobalKey<FormState>();

  CustomDialog({
    Key? key,
    required this.title,
    required this.description,
    this.press,
    this.type,
    this.backgroundColor,
    this.titleColor,
    this.descColor,
    this.btnOkColor,
    this.btnCancelColor,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestCubit, RequestState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(
                top: 40.r, bottom: 20.r, left: 16.r, right: 16.r),
            margin: EdgeInsets.only(top: 50.r),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10.r,
                ),
                Text(
                  title!,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: titleColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16.r,
                ),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, color: descColor),
                ),
                SizedBox(
                  height: 44.h,
                ),
                Form(
                  key: formKeyRequest,
                  child: defaultFormField(
                      controller: commentController,
                      type: TextInputType.text,
                      label: "comment",
                      textSize: 15,
                      borderRadius: 50,
                      border: false,
                      borderColor: white,
                      validatorText: commentController.text,
                      validatorMessage: "Enter Comment First Please..",
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      }),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state is! RequestEditInitial
                        ? MaterialButton(
                            height: 30.h,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                            color: btnOkColor,
                            minWidth: 80.w,
                            onPressed: () {
                              if (formKeyRequest.currentState!.validate()) {
                                RequestCubit.get(context).editRequest(
                                    id!,
                                    "reject",
                                    commentController.text.toString());
                              }
                            },
                            child: Text(
                              'Ok',
                              style: TextStyle(color: white, fontSize: 15.sp),
                            ))
                        : Center(
                            child: CircularProgressIndicator(
                              color: btnOkColor,
                            ),
                          ),
                    SizedBox(
                      width: 30.w,
                    ),
                    MaterialButton(
                        height: 30.h,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        color: btnCancelColor,
                        onPressed: () => Navigator.pop(context),
                        minWidth: 80.w,
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: black, fontSize: 15.sp),
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomDialog2 extends StatelessWidget {
  final String? title, description, type, id;
  final VoidCallback? press;
  final Color? backgroundColor,
      titleColor,
      descColor,
      btnOkColor,
      btnCancelColor;

  var commentController = TextEditingController();
  var formKeyRequest = GlobalKey<FormState>();

  CustomDialog2({
    Key? key,
    required this.title,
    required this.description,
    this.press,
    this.type,
    this.backgroundColor,
    this.titleColor,
    this.descColor,
    this.btnOkColor,
    this.btnCancelColor,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestCubit, RequestState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(
                top: 40.r, bottom: 20.r, left: 16.r, right: 16.r),
            margin: EdgeInsets.only(top: 50.r),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10.r,
                ),
                Text(
                  title!,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: titleColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16.r,
                ),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, color: descColor),
                ),
                SizedBox(
                  height: 44.h,
                ),
                Form(
                  key: formKeyRequest,
                  child: defaultFormField(
                      controller: commentController,
                      type: TextInputType.text,
                      label: "comment",
                      textSize: 15,
                      borderRadius: 50,
                      border: false,
                      borderColor: white,
                      validatorText: commentController.text,
                      validatorMessage: "Enter Comment First Please..",
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      }),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state is! RequestEditInitial
                        ? MaterialButton(
                            height: 30.h,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                            color: btnOkColor,
                            minWidth: 80.w,
                            onPressed: () {
                              if (formKeyRequest.currentState!.validate()) {
                                RequestCubit.get(context).editRequest(
                                    id!,
                                    "reject",
                                    commentController.text.toString());
                              }
                            },
                            child: Text(
                              'Ok',
                              style: TextStyle(color: white, fontSize: 15.sp),
                            ))
                        : Center(
                            child: CircularProgressIndicator(
                              color: btnOkColor,
                            ),
                          ),
                    SizedBox(
                      width: 30.w,
                    ),
                    MaterialButton(
                        height: 30.h,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        color: btnCancelColor,
                        onPressed: () => Navigator.pop(context),
                        minWidth: 80.w,
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: black, fontSize: 15.sp),
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xff47B5FF)),
            child: SizedBox(
              height: 200,
              child: Padding(
                  padding: EdgeInsets.only(
                    top: 30.r,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Color(0xFF778899),
                        backgroundImage: NetworkImage(
                            "https://www.pphfoundation.ca/wp-content/uploads/2018/05/default-avatar.png"), // for Network image
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getIt<SharedPreferences>().getString("name") ?? "",
                            style: TextStyle(
                                color: white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "+20${getIt<SharedPreferences>().getString("phone")}",
                            style: TextStyle(
                              color: white,
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
          ListTile(
            title: Text(
              "Home",
              style: TextStyle(
                color: grey2,
                fontSize: 20.sp,
              ),
            ),
            leading: const Icon(Icons.home, color: grey2),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              "Wallet",
              style: TextStyle(
                color: grey2,
                fontSize: 20.sp,
              ),
            ),
            leading: const Icon(
              Icons.account_balance_wallet,
              color: grey2,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              "Notification",
              style: TextStyle(
                color: grey2,
                fontSize: 20.sp,
              ),
            ),
            leading: const Icon(Icons.notifications, color: grey2),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              "Settings",
              style: TextStyle(
                color: grey2,
                fontSize: 20.sp,
              ),
            ),
            leading: const Icon(Icons.settings, color: grey2),
            onTap: () {
              navigateTo(context, const SettingScreen());
            },
          ),
          ListTile(
            title: Text(
              "Policies",
              style: TextStyle(
                color: grey2,
                fontSize: 20.sp,
              ),
            ),
            leading: const Icon(
              Icons.policy,
              color: grey2,
            ),
            onTap: () {
              navigateTo(context, PoliciesScreen());
            },
          ),
          ListTile(
            title: Text(
              "SignOut",
              style: TextStyle(
                color: grey2,
                fontSize: 20.sp,
              ),
            ),
            leading: const Icon(Icons.exit_to_app, color: grey2),
            onTap: () {
              getIt<SharedPreferences>()
                  .clear().then((value) {
                navigateAndFinish(context, const SignInScreen());
              });
            },
          ),
        ],
      ),
    );
  }
}

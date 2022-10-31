import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/main_cubit.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/auth/SignInScreen.dart';
import 'package:getn_driver/presentation/ui/notifications/NotificationScreen.dart';
import 'package:getn_driver/presentation/ui/notifications/notification_cubit.dart';
import 'package:getn_driver/presentation/ui/policies/PoliciesScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/request_details_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/request_cubit.dart';
import 'package:getn_driver/presentation/ui/setting/SettingScreen.dart';
import 'package:getn_driver/presentation/ui/trip/tripDetails/trip_details_cubit.dart';
import 'package:getn_driver/presentation/ui/wallet/WalletScreen.dart';
import 'package:getn_driver/presentation/ui/wallet/wallet_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDialogRequestTabs extends StatelessWidget {
  final String? title, description, id;
  final Color? backgroundColor,
      titleColor,
      descColor,
      btnOkColor,
      btnCancelColor;

  var commentController = TextEditingController();
  var formKeyRequest = GlobalKey<FormState>();

  CustomDialogRequestTabs({
    Key? key,
    required this.title,
    required this.description,
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
      listener: (context, state) {
        if (state is RequestEditSuccessState) {
          if (state.data!.status! == "reject") {
            Navigator.pop(context);
            MainCubit.get(context).tabController!.animateTo(2);
          }
        } else if (state is RequestEditErrorState) {
          Navigator.pop(context);
          showToastt(
              text: state.message, state: ToastStates.error, context: context);
        }
      },
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
                        : loading(),
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

class CustomDialogLocation extends StatelessWidget {
  final String? title, description, id, type;
  final Color? backgroundColor,
      titleColor,
      descColor,
      btnOkColor,
      btnCancelColor;

  var commentController = TextEditingController();
  var formKeyRequest = GlobalKey<FormState>();

  CustomDialogLocation({
    Key? key,
    required this.title,
    required this.description,
    this.backgroundColor,
    this.titleColor,
    this.descColor,
    this.btnOkColor,
    this.btnCancelColor,
    this.id,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding:
            EdgeInsets.only(top: 40.r, bottom: 20.r, left: 16.r, right: 16.r),
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
              height: 24.h,
            ),
            type == "checkLocationDenied"
                ? MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                    color: btnOkColor,
                    onPressed: () => Navigator.pop(context),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.r, horizontal: 8.r),
                      child: Text(
                        "ok",
                        style: TextStyle(color: white, fontSize: 15.sp),
                      ),
                    ))
                : type == "checkLocationDeniedForever"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                              height: 30.h,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              color: btnOkColor,
                              minWidth: 80.w,
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "ok",
                                style: TextStyle(color: white, fontSize: 15.sp),
                              )),
                          SizedBox(
                            width: 30.w,
                          ),
                          MaterialButton(
                              height: 30.h,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              color: btnCancelColor,
                              onPressed: () =>
                                  AppSettings.openLocationSettings(),
                              minWidth: 80.w,
                              child: Text(
                                "Setting",
                                style: TextStyle(color: black, fontSize: 15.sp),
                              )),
                        ],
                      )
                    : Container()
          ],
        ),
      ),
    );
  }
}

class CustomDialogRequestDetails extends StatelessWidget {
  final String? title, description, id, type;

  var commentController = TextEditingController();
  var formKeyRequest = GlobalKey<FormState>();

  CustomDialogRequestDetails({
    Key? key,
    this.title,
    this.description,
    this.id,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestDetailsCubit(),
      child: BlocConsumer<RequestDetailsCubit, RequestDetailsState>(
        listener: (context, state) {
          if (state is RequestDetailsEditSuccessState) {
            Navigator.pop(context);
            MainCubit.get(context).refresh = true;
          } else if (state is RequestDetailsEditErrorState) {
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
        },
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
                color: white,
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
                        color: accentColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.r,
                  ),
                  Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.sp, color: black),
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
                      state is! RequestDetailsEditRejectInitial
                          ? MaterialButton(
                              height: 30.h,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              color: accentColor,
                              minWidth: 80.w,
                              onPressed: () {
                                if (formKeyRequest.currentState!.validate()) {
                                  RequestDetailsCubit.get(context).editRequest(
                                      id!,
                                      type!,
                                      commentController.text.toString());
                                }
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(color: white, fontSize: 15.sp),
                              ))
                          : loading(),
                      SizedBox(
                        width: 30.w,
                      ),
                      MaterialButton(
                          height: 30.h,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                          color: grey,
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
      ),
    );
  }
}

class CustomDialogTripDetails extends StatelessWidget {
  final String? title, description, id;

  var commentController = TextEditingController();
  var formKeyRequest = GlobalKey<FormState>();

  CustomDialogTripDetails({
    Key? key,
    this.title,
    this.description,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripDetailsCubit(),
      child: BlocConsumer<TripDetailsCubit, TripDetailsState>(
        listener: (context, state) {
          if (state is TripDetailsEditSuccessState) {
            Navigator.pop(context);
            MainCubit.get(context).refresh = true;
          } else if (state is TripDetailsEditErrorState) {
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
        },
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
                color: white,
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
                        color: accentColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.r,
                  ),
                  Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.sp, color: black),
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
                      state is! TripDetailsEditRejectInitial
                          ? MaterialButton(
                              height: 30.h,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              color: accentColor,
                              minWidth: 80.w,
                              onPressed: () {
                                if (formKeyRequest.currentState!.validate()) {
                                  TripDetailsCubit.get(context).editTrip(
                                      TripDetailsCubit.get(context)
                                          .tripDetails!
                                          .id!,
                                      "reject",
                                      commentController.text.toString());
                                }
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(color: white, fontSize: 15.sp),
                              ))
                          : loading(),
                      SizedBox(
                        width: 30.w,
                      ),
                      MaterialButton(
                          height: 30.h,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                          color: grey,
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
      ),
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
            decoration: const BoxDecoration(color: blueColor),
            child: SizedBox(
              height: 200.h,
              child: Padding(
                  padding: EdgeInsets.only(
                    top: 30.r,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: grey3,
                        backgroundImage: NetworkImage(getIt<SharedPreferences>()
                                .getString('userImage') ??
                            "https://www.pphfoundation.ca/wp-content/uploads/2018/05/default-avatar.png"), // for Network image
                      ),
                      SizedBox(
                        width: 15.w,
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
            onTap: () {
              Navigator.pop(context);
            },
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
            onTap: () {
              navigateTo(
                  context,
                  BlocProvider(
                      create: (context) => WalletCubit(),
                      child: const WalletScreen()));
            },
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
            onTap: () {
              navigateTo(
                  context,
                  BlocProvider(
                      create: (context) => NotificationCubit(),
                      child: const NotificationScreen()));
            },
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
              getIt<SharedPreferences>().clear().then((value) {
                navigateAndFinish(context, const SignInScreen());
              });
            },
          ),
        ],
      ),
    );
  }
}

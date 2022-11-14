import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/auth/SignInScreen.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
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
import 'dart:ui' as ui;

class CustomDialogRequestTabs extends StatefulWidget {
  final String? title, description, id;
  final Color? backgroundColor,
      titleColor,
      descColor,
      btnOkColor,
      btnCancelColor;


  const CustomDialogRequestTabs({
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
  State<CustomDialogRequestTabs> createState() => _CustomDialogRequestTabsState();
}

class _CustomDialogRequestTabsState extends State<CustomDialogRequestTabs> {
  var commentController = TextEditingController();

  var formKeyRequest = GlobalKey<FormState>();

  bool loadingEditDialogPending = false;


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestCubit, RequestState>(
      listener: (context, state) {
        if (state is RequestEditSuccessState) {
          setState(() {
            loadingEditDialogPending = false;
          });
        } else if (state is RequestEditErrorState) {
          setState(() {
            loadingEditDialogPending = false;
          });
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: LanguageCubit.get(context).isEn
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Dialog(
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
                color: widget.backgroundColor,
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
                    widget.title!,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: widget.titleColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.r,
                  ),
                  Text(
                    widget.description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.sp, color: widget.descColor),
                  ),
                  SizedBox(
                    height: 44.h,
                  ),
                  Form(
                    key: formKeyRequest,
                    child: defaultFormField(
                        controller: commentController,
                        type: TextInputType.text,
                        label: LanguageCubit.get(context).getTexts('comment').toString(),
                        textSize: 15,
                        borderRadius: 50,
                        border: false,
                        borderColor: white,
                        validatorText: commentController.text,
                        validatorMessage: LanguageCubit.get(context).getTexts('EnterComment').toString(),
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
                      loadingEditDialogPending
                          ? loading()
                          : MaterialButton(
                          height: 30.h,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                          color: widget.btnOkColor,
                          minWidth: 80.w,
                          onPressed: () {
                            if (formKeyRequest.currentState!.validate()) {
                              RequestCubit.get(context).editRequest(widget.id!, "reject",
                                  commentController.text.toString());
                              setState(() {
                                loadingEditDialogPending = true;
                              });
                            }
                          },
                          child: Text(
                            LanguageCubit.get(context).getTexts('Ok').toString(),
                            style: TextStyle(color: white, fontSize: 15.sp),
                          )),
                      SizedBox(
                        width: 30.w,
                      ),
                      MaterialButton(
                          height: 30.h,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                          color: widget.btnCancelColor,
                          onPressed: () => Navigator.pop(context),
                          minWidth: 80.w,
                          child: Text(
                            LanguageCubit.get(context).getTexts('Cancel').toString(),
                            style: TextStyle(color: black, fontSize: 15.sp),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomDialogLocation extends StatefulWidget {
  final String? title, description, id, type;
  final Color? backgroundColor,
      titleColor,
      descColor,
      btnOkColor,
      btnCancelColor;


  const CustomDialogLocation({
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
  State<CustomDialogLocation> createState() => _CustomDialogLocationState();
}

class _CustomDialogLocationState extends State<CustomDialogLocation> {
  var commentController = TextEditingController();

  var formKeyRequest = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LanguageCubit.get(context).isEn
          ? ui.TextDirection.ltr
          : ui.TextDirection.rtl,
      child: Dialog(
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
            color: widget.backgroundColor,
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
                widget.title!,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: widget.titleColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.r,
              ),
              Text(
                widget.description!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, color: widget.descColor),
              ),
              SizedBox(
                height: 24.h,
              ),
              widget.type == "checkLocationDenied"
                  ? MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      color: widget.btnOkColor,
                      onPressed: () => Navigator.pop(context),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.r, horizontal: 8.r),
                        child: Text(
                          "ok",
                          style: TextStyle(color: white, fontSize: 15.sp),
                        ),
                      ))
                  : widget.type == "checkLocationDeniedForever"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                                height: 30.h,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                                color: widget.btnOkColor,
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
                                color: widget.btnCancelColor,
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
      ),
    );
  }
}

class CustomDialogImage extends StatefulWidget {
  final String? title, description, id, type;
  final Color? backgroundColor,
      titleColor,
      descColor,
      btnOkColor,
      btnCancelColor;


  const CustomDialogImage({
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
  State<CustomDialogImage> createState() => _CustomDialogImageState();
}

class _CustomDialogImageState extends State<CustomDialogImage> {
  var commentController = TextEditingController();

  var formKeyRequest = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LanguageCubit.get(context).isEn
          ? ui.TextDirection.ltr
          : ui.TextDirection.rtl,
      child: Dialog(
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
            color: widget.backgroundColor,
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
                widget.title!,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: widget.titleColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.r,
              ),
              Text(
                widget.description!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, color: widget.descColor),
              ),
              SizedBox(
                height: 24.h,
              ),
              widget.type == "checkImageDenied"
                  ? MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      color: widget.btnOkColor,
                      onPressed: () => Navigator.pop(context),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.r, horizontal: 8.r),
                        child: Text(
                          "ok",
                          style: TextStyle(color: white, fontSize: 15.sp),
                        ),
                      ))
                  : widget.type == "checkImageDeniedForever"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                                height: 30.h,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                                color: widget.btnOkColor,
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
                                color: widget.btnCancelColor,
                                onPressed: () => AppSettings.openAppSettings(),
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
      ),
    );
  }
}

class CustomDialogRejectRequestDetails extends StatefulWidget {
  final String? title, description, id, type;


  const CustomDialogRejectRequestDetails({
    Key? key,
    this.title,
    this.description,
    this.id,
    this.type,
  }) : super(key: key);

  @override
  State<CustomDialogRejectRequestDetails> createState() => _CustomDialogRejectRequestDetailsState();
}

class _CustomDialogRejectRequestDetailsState
    extends State<CustomDialogRejectRequestDetails> {
  var commentController = TextEditingController();

  var formKeyRequest = GlobalKey<FormState>();

  bool loadingRejectRequestDetails = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestDetailsCubit, RequestDetailsState>(
      listener: (context, state) {
        if (state is RequestDetailsEditSuccessState) {
          setState(() {
            loadingRejectRequestDetails = false;
          });
        } else if (state is RequestDetailsEditErrorState) {
          setState(() {
            loadingRejectRequestDetails = false;
          });
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: LanguageCubit.get(context).isEn
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Dialog(
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
                    widget.title!,
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
                    widget.description!,
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
                        label: LanguageCubit.get(context).getTexts('comment').toString(),
                        textSize: 15,
                        borderRadius: 50,
                        border: false,
                        borderColor: white,
                        validatorText: commentController.text,
                        validatorMessage: LanguageCubit.get(context).getTexts('EnterComment').toString(),
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
                      loadingRejectRequestDetails
                          ? loading()
                          : MaterialButton(
                              height: 30.h,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              color: accentColor,
                              minWidth: 80.w,
                              onPressed: () {
                                if (formKeyRequest.currentState!.validate()) {
                                  RequestDetailsCubit.get(context).editRequest(
                                      widget.id!,
                                      widget.type!,
                                      commentController.text.toString());

                                  setState(() {
                                    loadingRejectRequestDetails = true;
                                  });
                                }
                              },
                              child: Text(
                                LanguageCubit.get(context).getTexts('Ok').toString(),
                                style: TextStyle(color: white, fontSize: 15.sp),
                              )),
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
                            LanguageCubit.get(context).getTexts('Cancel').toString(),
                            style: TextStyle(color: black, fontSize: 15.sp),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomDialogEndRequestDetails extends StatefulWidget {
  final String? title, description, id,  status;

  const CustomDialogEndRequestDetails({
    Key? key,
    this.title,
    this.description,
    this.id,
    this.status,
  }) : super(key: key);

  @override
  State<CustomDialogEndRequestDetails> createState() => _CustomDialogEndRequestDetailsState();
}

class _CustomDialogEndRequestDetailsState
    extends State<CustomDialogEndRequestDetails> {
  bool loadingEndRequestDetails = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestDetailsCubit, RequestDetailsState>(
      listener: (context, state) {
        if (state is RequestDetailsEditSuccessState) {
          setState(() {
            loadingEndRequestDetails = false;
          });
        } else if (state is RequestDetailsEditErrorState) {
          setState(() {
            loadingEndRequestDetails = false;
          });
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: LanguageCubit.get(context).isEn
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Dialog(
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
                    widget.title!,
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
                    widget.description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.sp, color: black),
                  ),
                  SizedBox(
                    height: 44.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loadingEndRequestDetails
                          ? loading()
                          : MaterialButton(
                              height: 30.h,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              color: accentColor,
                              minWidth: 80.w,
                              onPressed: () {
                                RequestDetailsCubit.get(context)
                                    .editRequest(widget.id!, widget.status!, "");

                                setState(() {
                                  loadingEndRequestDetails = true;
                                });
                              },
                              child: Text(
                                LanguageCubit.get(context).getTexts('Ok').toString(),
                                style: TextStyle(color: white, fontSize: 15.sp),
                              )),
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
                            LanguageCubit.get(context).getTexts('Cancel').toString(),
                            style: TextStyle(color: black, fontSize: 15.sp),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomDialogRejectTripDetails extends StatefulWidget {
  final String? title, description, id;


  const CustomDialogRejectTripDetails({
    Key? key,
    this.title,
    this.description,
    this.id,
  }) : super(key: key);

  @override
  State<CustomDialogRejectTripDetails> createState() => _CustomDialogRejectTripDetailsState();
}

class _CustomDialogRejectTripDetailsState
    extends State<CustomDialogRejectTripDetails> {
  var commentController = TextEditingController();

  var formKeyRequest = GlobalKey<FormState>();

  bool loadingRejectTripDetails = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripDetailsCubit, TripDetailsState>(
      listener: (context, state) {
        if (state is TripDetailsEditSuccessState) {
          setState(() {
            loadingRejectTripDetails = false;
          });
        } else if (state is TripDetailsEditErrorState) {
          setState(() {
            loadingRejectTripDetails = false;
          });
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: LanguageCubit.get(context).isEn
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Dialog(
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
                    widget.title!,
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
                    widget.description!,
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
                        label: LanguageCubit.get(context).getTexts('comment').toString(),
                        textSize: 15,
                        borderRadius: 50,
                        border: false,
                        borderColor: white,
                        validatorText: commentController.text,
                        validatorMessage: LanguageCubit.get(context).getTexts('EnterComment').toString(),
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
                      loadingRejectTripDetails
                          ? loading()
                          : MaterialButton(
                              height: 30.h,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              color: accentColor,
                              minWidth: 80.w,
                              onPressed: () {
                                if (formKeyRequest.currentState!.validate()) {
                                  TripDetailsCubit.get(context).editTrip(
                                      widget.id!,
                                      "reject",
                                      commentController.text.toString());

                                  setState(() {
                                    loadingRejectTripDetails = true;
                                  });
                                }
                              },
                              child: Text(
                                LanguageCubit.get(context).getTexts('Ok').toString(),
                                style: TextStyle(color: white, fontSize: 15.sp),
                              )),
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
                            LanguageCubit.get(context).getTexts('Cancel').toString(),
                            style: TextStyle(color: black, fontSize: 15.sp),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomDialogEndTripDetails extends StatefulWidget {
  final String? title, description, id, status;

  const CustomDialogEndTripDetails({
    Key? key,
    this.title,
    this.description,
    this.id,
    this.status,
  }) : super(key: key);

  @override
  State<CustomDialogEndTripDetails> createState() => _CustomDialogEndTripDetailsState();
}

class _CustomDialogEndTripDetailsState
    extends State<CustomDialogEndTripDetails> {
  bool loadingEndTripDetails = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripDetailsCubit, TripDetailsState>(
      listener: (context, state) {
        if (state is TripDetailsEditSuccessState) {
          setState(() {
            loadingEndTripDetails = false;
          });
        } else if (state is TripDetailsEditErrorState) {
          setState(() {
            loadingEndTripDetails = false;
          });
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: LanguageCubit.get(context).isEn
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Dialog(
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
                    widget.title!,
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
                    widget.description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.sp, color: black),
                  ),
                  SizedBox(
                    height: 44.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loadingEndTripDetails
                          ? loading()
                          : MaterialButton(
                              height: 30.h,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              color: accentColor,
                              minWidth: 80.w,
                              onPressed: () {
                                TripDetailsCubit.get(context).editTrip(
                                    widget.id!, widget.status!, "comment");

                                setState(() {
                                  loadingEndTripDetails = true;
                                });
                              },
                              child: Text(
                                LanguageCubit.get(context).getTexts('Ok').toString(),
                                style: TextStyle(color: white, fontSize: 15.sp),
                              )),
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
                            LanguageCubit.get(context).getTexts('Cancel').toString(),
                            style: TextStyle(color: black, fontSize: 15.sp),
                          )),
                    ],
                  ),
                ],
              ),
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
            decoration: const BoxDecoration(color: blueColor),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getIt<SharedPreferences>().getString("name") ?? "",
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
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
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              LanguageCubit.get(context).getTexts('Home').toString(),
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
              LanguageCubit.get(context).getTexts('Wallet').toString(),
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
              LanguageCubit.get(context).getTexts('Notifications').toString(),
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
              LanguageCubit.get(context).getTexts('Setting').toString(),
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
              LanguageCubit.get(context).getTexts('Policies').toString(),
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
              navigateTo(context, const PoliciesScreen());
            },
          ),
          ListTile(
            title: Text(
              LanguageCubit.get(context).getTexts('SignOut').toString(),
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

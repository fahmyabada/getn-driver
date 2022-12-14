import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/auth/CarRegistrationScreen.dart';
import 'package:getn_driver/presentation/ui/auth/VerifyImageScreen.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class DriverInformationScreen extends StatefulWidget {
  const DriverInformationScreen({Key? key}) : super(key: key);

  @override
  State<DriverInformationScreen> createState() =>
      _DriverInformationScreenState();
}

class _DriverInformationScreenState extends State<DriverInformationScreen> {
  bool frontNationalId = false;
  bool backNationalId = false;

  // bool frontPassport = false;
  // bool backPassport = false;
  bool frontDriverLicence = false;
  bool backDriverLicence = false;
  String frontNationalIdString = "";
  String backNationalIdString = "";
  bool driverInfoLoading = false;

  // String? frontPassportString;
  // String? backPassportString;
  String frontDriverLicenceString = "";
  String backDriverLicenceString = "";

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
    return BlocProvider(
      create: (context) => SignCubit(),
      child: BlocConsumer<SignCubit, SignState>(listener: (context, state) {
        if (state is EditSuccessState) {
          setState(() {
            driverInfoLoading = false;
          });
          print('*******EditSuccessState');
          getIt<SharedPreferences>().setString(
              'typeSign', "signWithInformation");
          navigateTo(context, const CarRegistrationScreen());
        } else if (state is EditErrorState) {
          print('*******EditErrorState');
          setState(() {
            driverInfoLoading = false;
          });
          showToastt(
              text: state.message, state: ToastStates.error, context: context);
        }
      }, builder: (context, state) {
        return Directionality(
          textDirection: LanguageCubit.get(context).isEn
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                LanguageCubit.get(context)
                    .getTexts('DriverInformation')
                    .toString(),
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              centerTitle: true,
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  //front NationalId
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.r, vertical: 15.r),
                        decoration: BoxDecoration(
                          color: white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LanguageCubit.get(context)
                                  .getTexts('FrontNationalId')
                                  .toString(),
                              style:
                              TextStyle(fontSize: 20.sp, color: primaryColor),
                            ),
                            frontNationalId
                                ? Icon(
                              Icons.done,
                              color: accentColor,
                              size: 25.w,
                            )
                                : Text(
                              LanguageCubit.get(context)
                                  .getTexts('Update')
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 20.sp, color: accentColor),
                            )
                          ],
                        )),
                    onTap: () async {
                      ImageVerify value = await navigateToWithRefreshPagePrevious(
                        context,
                        const VerifyImageScreen(
                          typeScreen: "frontNationalId",
                        ),
                      ) as ImageVerify;

                      print("VerifyImageScreen******** ${value.toString()}");
                      setState(() {
                        if (value.type == "frontNationalId") {
                          frontNationalIdString = value.imageValue!;
                          frontNationalId = value.isSelected!;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  //back NationalId
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.r, vertical: 15.r),
                        decoration: BoxDecoration(
                          color: white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LanguageCubit.get(context)
                                  .getTexts('BackNationalId')
                                  .toString(),
                              style:
                              TextStyle(fontSize: 20.sp, color: primaryColor),
                            ),
                            backNationalId
                                ? Icon(
                              Icons.done,
                              color: accentColor,
                              size: 25.w,
                            )
                                : Text(
                              LanguageCubit.get(context)
                                  .getTexts('Update')
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 20.sp, color: accentColor),
                            )
                          ],
                        )),
                    onTap: () async {
                      ImageVerify value = await navigateToWithRefreshPagePrevious(
                        context,
                        const VerifyImageScreen(
                          typeScreen: "backNationalId",
                        ),
                      ) as ImageVerify;

                      print("VerifyImageScreen******** ${value.toString()}");
                      setState(() {
                        if (value.type == "backNationalId") {
                          backNationalIdString = value.imageValue!;
                          backNationalId = value.isSelected!;
                        }
                      });
                    },
                  ),
                  /*  SizedBox(
                      height: 30.h,
                    ),
                    //front Passport
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.r, vertical: 15.r),
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Front Passport',
                                style: TextStyle(
                                    fontSize: 20.sp, color: primaryColor),
                              ),
                              SignCubit.get(context).frontPassport
                                  ? Icon(
                                      Icons.done,
                                      color: accentColor,
                                      size: 25.w,
                                    )
                                  : Text(
                                      'Update',
                                      style: TextStyle(
                                          fontSize: 20.sp, color: accentColor),
                                    )
                            ],
                          )),
                      onTap: () {
                        navigateTo(
                          context,
                          const VerifyImageScreen(
                            typeScreen: "frontPassport",
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    //back Passport
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.r, vertical: 15.r),
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Back Passport',
                                style: TextStyle(
                                    fontSize: 20.sp, color: primaryColor),
                              ),
                              SignCubit.get(context).backPassport
                                  ? Icon(
                                      Icons.done,
                                      color: accentColor,
                                      size: 25.w,
                                    )
                                  : Text(
                                      'Update',
                                      style: TextStyle(
                                          fontSize: 20.sp, color: accentColor),
                                    )
                            ],
                          )),
                      onTap: () {
                        navigateTo(
                          context,
                          const VerifyImageScreen(
                            typeScreen: "backPassport",
                          ),
                        );
                      },
                    ),*/
                  SizedBox(
                    height: 30.h,
                  ),
                  //front driver licence
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.r, vertical: 15.r),
                        decoration: BoxDecoration(
                          color: white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LanguageCubit.get(context)
                                  .getTexts('FrontDriverLicence')
                                  .toString(),
                              style:
                              TextStyle(fontSize: 20.sp, color: primaryColor),
                            ),
                            frontDriverLicence
                                ? Icon(
                              Icons.done,
                              color: accentColor,
                              size: 25.w,
                            )
                                : Text(
                              LanguageCubit.get(context)
                                  .getTexts('Update')
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 20.sp, color: accentColor),
                            )
                          ],
                        )),
                    onTap: () async {
                      ImageVerify value = await navigateToWithRefreshPagePrevious(
                        context,
                        const VerifyImageScreen(
                          typeScreen: "frontDriverLicence",
                        ),
                      ) as ImageVerify;

                      print("VerifyImageScreen******** ${value.toString()}");
                      setState(() {
                        if (value.type == "frontDriverLicence") {
                          frontDriverLicenceString = value.imageValue!;
                          frontDriverLicence = value.isSelected!;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  //back driver licence
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.r, vertical: 15.r),
                        decoration: BoxDecoration(
                          color: white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LanguageCubit.get(context)
                                  .getTexts('BackDriverLicence')
                                  .toString(),
                              style:
                              TextStyle(fontSize: 20.sp, color: primaryColor),
                            ),
                            backDriverLicence
                                ? Icon(
                              Icons.done,
                              color: accentColor,
                              size: 25.w,
                            )
                                : Text(
                              LanguageCubit.get(context)
                                  .getTexts('Update')
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 20.sp, color: accentColor),
                            )
                          ],
                        )),
                    onTap: () async {
                      ImageVerify value = await navigateToWithRefreshPagePrevious(
                        context,
                        const VerifyImageScreen(
                          typeScreen: "backDriverLicence",
                        ),
                      ) as ImageVerify;

                      print("VerifyImageScreen******** ${value.toString()}");
                      setState(() {
                        if (value.type == "backDriverLicence") {
                          backDriverLicenceString = value.imageValue!;
                          backDriverLicence = value.isSelected!;
                        }
                      });
                    },
                  ),

                  Container(
                    margin:
                    EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
                    child: driverInfoLoading
                        ? loading()
                        : defaultButton3(
                        press: () {
                          if (frontNationalIdString.isNotEmpty &&
                              backNationalIdString.isNotEmpty &&
                              frontDriverLicenceString.isNotEmpty &&
                              backDriverLicenceString.isNotEmpty) {
                            setState(() {
                              driverInfoLoading = true;
                            });
                            SignCubit.get(context).editInformation(
                                frontNationalIdString,
                                backNationalIdString,
                                frontDriverLicenceString,
                                backDriverLicenceString);
                          } else {
                            showToastt(
                                text: LanguageCubit.get(context)
                                    .getTexts('pleaseFillAllData')
                                    .toString(),
                                state: ToastStates.error,
                                context: context);
                          }
                        },
                        text: LanguageCubit.get(context)
                            .getTexts('Done')
                            .toString(),
                        backColor: accentColor,
                        textColor: white),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ImageVerify {
  ImageVerify({
    bool? isSelected,
    String? imageValue,
    String? type,
  }) {
    _isSelected = isSelected;
    _imageValue = imageValue;
    _type = type;
  }

  bool? _isSelected;
  String? _imageValue;
  String? _type;

  bool? get isSelected => _isSelected;

  String? get imageValue => _imageValue;

  String? get type => _type;

  @override
  String toString() {
    return 'ImageVerify{_isSelected: $_isSelected, _imageValue: $_imageValue, _type: $_type}';
  }
}

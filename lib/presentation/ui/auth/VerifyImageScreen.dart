import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/auth/DriverInformationScreen.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyImageScreen extends StatefulWidget {
  const VerifyImageScreen(
      {Key? key,
      this.fullName,
      this.phone,
      this.countryId,
      this.email,
      this.firebaseToken,
      this.role,
      this.typeScreen})
      : super(key: key);

  final String? typeScreen;
  final String? phone;
  final String? countryId;
  final String? email;
  final String? firebaseToken;
  final String? fullName;
  final String? role;

  @override
  State<VerifyImageScreen> createState() => _VerifyImageScreenState();
}

class _VerifyImageScreenState extends State<VerifyImageScreen> {
  dynamic _pickImageError;
  File? _imageFileList;
  final ImagePicker _picker = ImagePicker();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignCubit, SignState>(listener: (context, state) {
      if (state is RegisterSuccessState) {
        if (kDebugMode) {
          print('*******RegisterSuccessState');
        }

        getIt<SharedPreferences>().setString('typeSign', "sign");
        if (state.data.phone != null) {
          getIt<SharedPreferences>().setString('phone', state.data.phone!);
        }
        if (state.data.name != null) {
          getIt<SharedPreferences>().setString('name', state.data.name!);
        }
        if (state.data.token != null) {
          getIt<SharedPreferences>().setString('token', state.data.token!);
        }
        navigateTo(context, const DriverInformationScreen());
      } else if (state is RegisterErrorState) {
        showToastt(
            text: state.message, state: ToastStates.error, context: context);
      } else if (state is DriverInformationLoading) {
        Navigator.of(context).pop();
      }
    }, builder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40.r, vertical: 20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Verify your identity",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(
                  height: 30.h,
                ),
                InkWell(
                  child: Container(
                    height: 300.h,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      color: white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(color: Colors.black),
                    ),
                    child: _imageFileList != null
                        ? SizedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.r),
                              child: Image.file(
                                _imageFileList!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.person_pin_outlined,
                            color: Colors.black87,
                            size: 115.sp,
                          ),
                  ),
                  onTap: () {
                    selectImageSource(ImageSource.camera);
                  },
                ),
                SizedBox(
                  height: 30.h,
                ),
                widget.typeScreen == "register"
                    ? Text(
                        "Verify your identity by taking a selfie shot of your photo For the verification of something",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20.sp, color: primaryColor),
                      )
                    : widget.typeScreen == "frontNationalId"
                        ? Text(
                            "Verify your front NationalId by taking shot of your photo ",
                            textAlign: TextAlign.start,
                            style:
                                TextStyle(fontSize: 20.sp, color: primaryColor),
                          )
                        : widget.typeScreen == "backNationalId"
                            ? Text(
                                "Verify your back NationalId by taking shot of your photo ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 20.sp, color: primaryColor),
                              )
                            :
                            // widget.typeScreen == "frontPassport"
                            //                 ? Text(
                            //                     "Verify your front Passport by taking shot of your photo ",
                            //                     textAlign: TextAlign.start,
                            //                     style: TextStyle(
                            //                         fontSize: 20.sp, color: primaryColor),
                            //                   )
                            //                 : widget.typeScreen == "backPassport"
                            //                     ? Text(
                            //                         "Verify your back Passport by taking shot of your photo ",
                            //                         textAlign: TextAlign.start,
                            //                         style: TextStyle(
                            //                             fontSize: 20.sp,
                            //                             color: primaryColor),
                            //                       )
                            //                     :
                            widget.typeScreen == "frontDriverLicence"
                                        ? Text(
                                            "Verify your front driver licence by taking shot of your photo ",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: primaryColor),
                                          )
                                        : widget.typeScreen ==
                                                "backDriverLicence"
                                            ? Text(
                                                "Verify your back driver licence by taking shot of your photo ",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 20.sp,
                                                    color: primaryColor),
                                              )
                                            : Container(),
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
                  child: defaultButton3(
                      press: () {
                        if (_imageFileList != null) {
                          if (widget.typeScreen == "register") {
                            print('signModel verify image***************** ');
                            print("SignUpDetails***********::>> signModel");
                            print(
                                "SignUpDetails***********fullNameController::>> ${widget.fullName}");
                            print(
                                "SignUpDetails***********emailController::>> ${widget.email}");
                            print(
                                "SignUpDetails***********phone::>> ${widget.phone}");
                            print(
                                "SignUpDetails***********countryId::>> ${widget.countryId}");
                            print(
                                "SignUpDetails***********firebaseToken::>> ${widget.firebaseToken}");
                            print(
                                "SignUpDetails***********codeOtp::>> ${widget.role}");
                            print(
                                "SignUpDetails***********_imageFileList::>> ${_imageFileList!.path.toString()}}");
                            print(
                                "SignUpDetails***********terms::>> ${SignCubit.get(context).terms}}");

                            SignCubit.get(context).makeRegister(
                                widget.phone!,
                                widget.countryId!,
                                widget.email!,
                                widget.firebaseToken!,
                                widget.fullName!,
                                widget.role!,
                                SignCubit.get(context).terms,
                                _imageFileList!.path.toString());
                          }
                          else if (widget.typeScreen == "frontNationalId") {
                            SignCubit.get(context)
                                .setChangeUpdateBool("frontNationalId", true);
                            SignCubit.get(context).frontNationalIdString =
                                _imageFileList!.path.toString();
                          }
                          else if (widget.typeScreen == "backNationalId") {
                            SignCubit.get(context)
                                .setChangeUpdateBool("backNationalId", true);
                            SignCubit.get(context).backNationalIdString =
                                _imageFileList!.path.toString();
                          }
                          // else if (widget.typeScreen == "frontPassport") {
                          //   SignCubit.get(context)
                          //       .setChangeUpdateBool("frontPassport", true);
                          //   SignCubit.get(context).frontPassportString =
                          //       _imageFileList!.path.toString();
                          // } else if (widget.typeScreen == "backPassport") {
                          //   SignCubit.get(context)
                          //       .setChangeUpdateBool("backPassport", true);
                          //   SignCubit.get(context).backPassportString =
                          //       _imageFileList!.path.toString();
                          // }
                          else if (widget.typeScreen == "frontDriverLicence") {
                            SignCubit.get(context)
                                .setChangeUpdateBool("frontDriverLicence", true);
                            SignCubit.get(context).frontDriverLicenceString =
                                _imageFileList!.path.toString();
                          } else if (widget.typeScreen == "backDriverLicence") {
                            SignCubit.get(context)
                                .setChangeUpdateBool("backDriverLicence", true);
                            SignCubit.get(context).backDriverLicenceString =
                                _imageFileList!.path.toString();
                          }
                        } else {
                          showToastt(
                              text: "choose photo first please...",
                              state: ToastStates.error,
                              context: context);
                        }
                      },
                      text: "Done",
                      backColor: accentColor,
                      textColor: white),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future selectImageSource(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: imageSource,
        maxWidth: 200.w,
        maxHeight: 200.h,
      );

      setState(() {
        // for hide image if exist first time
        _imageFileList = File(pickedFile!.path);
        if (kDebugMode) {
          print('_imageFileList***************** =${_imageFileList!.path}}');
        }
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }
}

import 'dart:ui' as ui;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/auth/OtpScreen.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  Country? dropDownValueCountry;
  String splitPhone2 = "";
  bool signUpLoading = false;


  @override
  void initState() {
    super.initState();

    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }

    if(getIt<SharedPreferences>().getString("fcmToken") == null){
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      // print('token=****************** $idToken');
      messaging.getToken().then((token) {
        print('token fcm=****************** $token');
        getIt<SharedPreferences>().setString('fcmToken', token!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignCubit()..getCountries(),
      child: BlocConsumer<SignCubit, SignState>(listener: (context, state) {
        if (state is CountriesLoading) {
          if (kDebugMode) {
            print('SignUpScreen*******CountriesLoading');
          }
        } else if (state is CountriesErrorState) {
          if (kDebugMode) {
            print('SignUpScreen*******CountriesErrorState ${state.message}');
          }
          showToastt(
              text: state.message, state: ToastStates.error, context: context);
        } else if (state is CountriesSuccessState) {
          if (kDebugMode) {
            print(
                'SignUpScreen*******CountriesSuccessState${SignCubit.get(context).countries[0].icon!.src} ');
          }
          dropDownValueCountry = SignCubit.get(context).countries[0];
        } else if (state is SendOtpSignUpSuccessState) {
          if (kDebugMode) {
            print('SignUpScreen*******SendOtpSignUpSuccessState');
          }
          print(
              "phoneSignupScreen******************${dropDownValueCountry!.code}$splitPhone2");
          setState(() {
            signUpLoading = false;
          });
          navigateTo(
            context,
            OtpScreen(
              type: "register",
              phone: splitPhone2,
              countryId: dropDownValueCountry!.id!,
              countryName: LanguageCubit.get(context).isEn
                  ? dropDownValueCountry!.title!.en!
                  : dropDownValueCountry!.title!.ar!,
              phoneWithCountry: '${dropDownValueCountry!.code}$splitPhone2',
            ),
          );
        } else if (state is SendOtpSignUpErrorState) {
          setState(() {
            signUpLoading = false;
          });
          if (kDebugMode) {
            print('SignUpScreen*******SendOtpSignUpErrorState');
          }
          if (state.message == "{phone:  Already user}") {
            showToastt(
                text: LanguageCubit.get(context)
                    .getTexts('SignInPlease')
                    .toString(),
                state: ToastStates.error,
                context: context);
            Navigator.pop(context);
          } else {
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
        }
      }, builder: (context, state) {
        return Directionality(
          textDirection: LanguageCubit.get(context).isEn
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: black,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200.w,
                  child: Text(
                    LanguageCubit.get(context)
                        .getTexts('signUpWithMobileNumber')
                        .toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 23.sp,
                        color: primaryColor),
                  ),
                ),
                SizedBox(
                  height: 36.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.r),
                  margin: EdgeInsets.symmetric(horizontal: 20.r),
                  decoration: BoxDecoration(
                      color: white,
                      border: Border.all(color: Colors.black.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(50.r)),
                  child: Row(
                    children: [
                      state is CountriesLoading
                          ? Container(
                              margin: EdgeInsetsDirectional.only(end: 10.w),
                              child: loading(),
                            )
                          : SignCubit.get(context).countries.isNotEmpty
                              ? Expanded(
                                  flex: 2,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      //      value: controller.selectedCountry?.value,
                                      dropdownDecoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                        border: Border.all(
                                          width: 1,
                                          color:
                                              Colors.grey[400] ?? Colors.black,
                                        ),
                                      ),
                                      isExpanded: true,
                                      iconSize: 0.0,
                                      dropdownWidth: 350.w,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                      onChanged: (Country? value) {
                                        setState(() {
                                          dropDownValueCountry = value;
                                        });
                                      },
                                      hint: Center(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ImageTools.image(
                                              fit: BoxFit.contain,
                                              url: dropDownValueCountry!
                                                      .icon!.src ??
                                                  " ",
                                              height: 35.w,
                                              width: 35.w,
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              color: Color.fromARGB(
                                                  207, 204, 204, 213),
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                                dropDownValueCountry!.code ??
                                                    "",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.sp)),
                                          ],
                                        ),
                                      ),
                                      items: SignCubit.get(context)
                                          .countries
                                          .map((selectedCountry) {
                                        return DropdownMenuItem<Country>(
                                          value: selectedCountry,
                                          child: Row(
                                            children: [
                                              ImageTools.image(
                                                fit: BoxFit.contain,
                                                url:
                                                    selectedCountry.icon?.src ??
                                                        " ",
                                                height: 30.w,
                                                width: 30.w,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                                  LanguageCubit.get(context)
                                                          .isEn
                                                      ? selectedCountry
                                                              .title?.en ??
                                                          " "
                                                      : selectedCountry
                                                              .title?.ar ??
                                                          " ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.sp)),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(selectedCountry.code ?? "",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.sp)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: IconButton(
                                      icon: const Icon(Icons.cloud_upload,
                                          color: redColor),
                                      onPressed: () {
                                        SignCubit.get(context).getCountries();
                                      }),
                                ),

                      Expanded(
                        flex: 4,
                        child: Form(
                          key: formKey,
                          child: defaultFormField(
                              controller: phoneController,
                              type: TextInputType.number,
                              label: "123456789",
                              textSize: 25,
                              borderRadius: 50,
                              border: true,
                              borderColor: white,
                              validatorText: phoneController.text,
                              validatorMessage: LanguageCubit.get(context)
                                  .getTexts('EnterPhone')
                                  .toString(),
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
                  child: signUpLoading
                      ? loading()
                      : defaultButton3(
                          press: () {
                            if (dropDownValueCountry != null) {
                              if (formKey.currentState!.validate()) {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.focusedChild?.unfocus();
                                }
                                if (phoneController.text.startsWith('0') &&
                                    phoneController.text.length > 1) {
                                    final splitPhone =
                                        const TextEditingValue().copyWith(
                                      text: phoneController.text
                                          .replaceAll(RegExp(r'^0+(?=.)'), ''),
                                      selection:
                                          phoneController.selection.copyWith(
                                        baseOffset:
                                            phoneController.text.length - 1,
                                        extentOffset:
                                            phoneController.text.length - 1,
                                      ),
                                    );
                                    print(
                                        "phoneController*******${splitPhone.text.toString()}");
                                    setState(() {
                                      splitPhone2 = splitPhone.text.toString();
                                      signUpLoading = true;
                                    });
                                    SignCubit.get(context).sendOtp("register",
                                        splitPhone2, dropDownValueCountry!.id!);

                                } else {
                                    setState(() {
                                      signUpLoading = true;
                                    });
                                    splitPhone2 =
                                        phoneController.text.toString();
                                    SignCubit.get(context).sendOtp(
                                        "register",
                                        phoneController.text.toString(),
                                        dropDownValueCountry!.id!);
                                }
                              }
                            } else {
                              showToastt(
                                  text: LanguageCubit.get(context)
                                      .getTexts('CountryCodeMotFound')
                                      .toString(),
                                  state: ToastStates.error,
                                  context: context);
                            }
                          },
                          text: LanguageCubit.get(context)
                              .getTexts('Next')
                              .toString(),
                          backColor: accentColor,
                          textColor: white),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

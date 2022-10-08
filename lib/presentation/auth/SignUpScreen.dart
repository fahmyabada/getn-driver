import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/strings.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/auth/OtpScreen.dart';
import 'package:getn_driver/presentation/services/authenticate.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  Data? dropDownValueCountry;
  String splitPhone2 = "";
  String? verificationId, authStatus = "", otp;

  @override
  void initState() {
    super.initState();
    SignCubit.get(context).getCountries();
  }

  Future<void> verifyPhone(phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(

      /// Make sure to prefix with your country code
        phoneNumber: phoneNumber,

        ///No duplicated SMS will be sent out upon re-entry (before timeout).
        timeout: const Duration(seconds: 5),

        /// If the SIM (with phoneNumber) is in the current device this function is called.
        /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
        /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
        verificationCompleted: (AuthCredential authResult) {
          if (kDebugMode) {
            print('verifyPhone***********$phoneNumber');
          }
          // AuthService().auth(context, authResult);
          setState(() {
            authStatus = "Your account is successfully verified";
          });
        },

        /// Called when the verification is failed
        verificationFailed: (final authException) {
          if (kDebugMode) {
            print('verificationFailed***********${authException.message!}');
          }
          setState(() {
            authStatus = "Authentication failed";
          });
        },

        /// This is called after the OTP is sent. Gives a `verificationId` and `code`
        codeSent: (String verId, [int? forceResend]) {
          print('codeSent***********$verId');
          verificationId = verId;
          setState(() {
            authStatus = "OTP has been successfully send";
          });
          navigateTo(
            context,
            OtpScreen(
              type: "register",
              verificationId: verificationId,
              phone: splitPhone2,
              countryId: dropDownValueCountry!.id!,
              phoneWithCountry: '${dropDownValueCountry!.code}$splitPhone2',
            ),
          );
        },

        /// After automatic code retrival `tmeout` this function is called
        codeAutoRetrievalTimeout: (String verId) {
          print('codeAutoRetrievalTimeout***********$verId');
          verificationId = verId;
          setState(() {
            authStatus = "TIMEOUT";
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignCubit, SignState>(listener: (context, state) {
      if (state is CountriesLoading) {
        if (kDebugMode) {
          print('SignUpScreen*******CountriesLoading');
        }
      }
      else if (state is CountriesErrorState) {
        if (kDebugMode) {
          print('SignUpScreen*******CountriesErrorState ${state.message}');
        }
        showToastt(
            text: state.message, state: ToastStates.error, context: context);
      }
      else if (state is CountriesSuccessState) {
        if (kDebugMode) {
          print(
              'SignUpScreen*******CountriesSuccessState${SignCubit.get(context).countries[0].icon!.src} ');
        }
        dropDownValueCountry = SignCubit.get(context).countries[0];
      }
      else if (state is SendOtpSignUpSuccessState) {
        if (kDebugMode) {
          print('SignUpScreen*******SendOtpSignUpSuccessState');
        }
        print("phoneSignupScreen******************${splitPhone2}}");
        verifyPhone(
            '${dropDownValueCountry!.code}${phoneController.text}');
      } else if (state is SendOtpSignUpErrorState) {
        if (kDebugMode) {
          print('SignUpScreen*******SendOtpSignUpErrorState');
        }
        if (state.message == "{phone:  Already user}") {
          showToastt(
              text: "Already you have account \n SignIn please..", state: ToastStates.error, context: context);
          Navigator.pop(context);
        } else {
          showToastt(
              text: state.message, state: ToastStates.error, context: context);
        }
      }
    }, builder: (context, state) {
      return Scaffold(
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
                Strings.signUpWithMobileNumber,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
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
                      ? const CircularProgressIndicator(color: black)
                      : SignCubit.get(context).countries.isNotEmpty
                          ? SizedBox(
                              width: 100.w,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  //      value: controller.selectedCountry?.value,
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey[400] ?? Colors.black,
                                    ),
                                  ),
                                  isExpanded: true,
                                  iconSize: 0.0,
                                  dropdownWidth: 350.w,
                                  style: const TextStyle(color: Colors.grey),
                                  onChanged: (Data? value) {
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
                                          url:
                                              dropDownValueCountry!.icon!.src ??
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
                                        Text(dropDownValueCountry!.code ?? "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.sp)),
                                      ],
                                    ),
                                  ),
                                  items: SignCubit.get(context)
                                      .countries
                                      .map((selectedCountry) {
                                    return DropdownMenuItem<Data>(
                                      value: selectedCountry,
                                      child: Row(
                                        children: [
                                          ImageTools.image(
                                            fit: BoxFit.contain,
                                            url: selectedCountry.icon?.src ??
                                                " ",
                                            height: 30.w,
                                            width: 30.w,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(selectedCountry.title?.en ?? " ",
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
                          : IconButton(
                              icon: const Icon(Icons.cloud_upload,
                                  color: redColor),
                              onPressed: () {
                                SignCubit.get(context).getCountries();
                              }),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          label: "123456789",
                          textSize: 25,
                          borderRadius: 50,
                          border: true,
                          borderColor: white,
                          validatorText: phoneController.text,
                          validatorMessage: "Enter Phone Please..",
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          }),
                    ),
                  ),
                ],
              ),
            ),
            defaultButton3(
                press: () {
                  if (dropDownValueCountry != null) {
                    if (formKey.currentState!.validate()) {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.focusedChild?.unfocus();
                      }
                      if (phoneController.text.startsWith('0') &&
                          phoneController.text.length > 1) {
                        final splitPhone = const TextEditingValue().copyWith(
                          text: phoneController.text
                              .replaceAll(RegExp(r'^0+(?=.)'), ''),
                          selection: phoneController.selection.copyWith(
                            baseOffset: phoneController.text.length - 1,
                            extentOffset: phoneController.text.length - 1,
                          ),
                        );
                        setState(() {
                          splitPhone2 = splitPhone.text.toString();
                        });
                        SignCubit.get(context).sendOtp(
                            "register",
                            splitPhone2,
                            dropDownValueCountry!.id!);
                      } else {
                        splitPhone2 = phoneController.text.toString();
                        SignCubit.get(context).sendOtp(
                            "register",
                            phoneController.text.toString(),
                            dropDownValueCountry!.id!);
                      }
                    }
                  } else {
                    showToastt(
                        text: "country code note found",
                        state: ToastStates.error,
                        context: context);
                  }
                },
                text: "Next",
                backColor: accentColor,
                textColor: white),
          ],
        ),
      );
    });
  }
}

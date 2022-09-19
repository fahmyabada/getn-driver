import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/strings.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/auth/signIn/sign_in_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreenView extends StatefulWidget {
  const SignInScreenView({Key? key}) : super(key: key);

  @override
  State<SignInScreenView> createState() => _SignInScreenViewState();
}

class _SignInScreenViewState extends State<SignInScreenView> {
  var formKey = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  Data? dropDownValueCountry;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SignInCubit()..getCountries(),
        child:
            BlocConsumer<SignInCubit, SignInState>(listener: (context, state) {
          if (state is CountriesLoading) {
            if (kDebugMode) {
              print('*******CountriesLoading');
            }
          } else if (state is CountriesErrorState) {
            if (kDebugMode) {
              print('*******CountriesErrorState ${state.message}');
            }
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          } else if (state is CountriesSuccessState) {
            if (kDebugMode) {
              print(
                  '*******CountriesSuccessState${SignInCubit.get(context).countries[0].icon!.src} ');
            }
            dropDownValueCountry = SignInCubit.get(context).countries[0];
          } else if (state is SendOtpSuccessState) {
            if (kDebugMode) {
              print('*******SendOtpSuccessState');
            }
            if (state.data.isAlreadyUser!) {
            } else {
              showToastt(
                  text: "register first please...",
                  state: ToastStates.error,
                  context: context);
            }
          } else if (state is SendOtpErrorState) {
            if (kDebugMode) {
              print('*******SendOtpErrorState');
            }

            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
        }, builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      Strings.signIn,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
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
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(50.r)),
                    child: Row(
                      children: [
                        SignInCubit.get(context).countries.isNotEmpty
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
                                          Text(dropDownValueCountry!.code ?? "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20.sp)),
                                        ],
                                      ),
                                    ),
                                    items: SignInCubit.get(context)
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
                                            Text(
                                                selectedCountry.title?.en ??
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
                            : const CircularProgressIndicator(color: black),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: Form(
                            key: formKey,
                            child: defaultFormField(
                                controller: phoneController,
                                type: TextInputType.phone,
                                label: "1234567",
                                textSize: 25,
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
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.focusedChild?.unfocus();
                            }
                            if (phoneController.text.startsWith('0') && phoneController.text.length > 1) {
                              final splitPhone = const TextEditingValue().copyWith(
                                text: phoneController.text.replaceAll(RegExp(r'^0+(?=.)'), ''),
                                selection: phoneController.selection.copyWith(
                                  baseOffset: phoneController.text.length - 1,
                                  extentOffset: phoneController.text.length - 1,
                                ),
                              );
                              SignInCubit.get(context).sendOtp(
                                  splitPhone.text.toString(),
                                  dropDownValueCountry!.id!);
                            } else {
                              SignInCubit.get(context).sendOtp(
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
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Text('You Don\'t have an account,',style: TextStyle(color: black,fontSize: 16.sp),),
                      Text('Sign Up Now',style: TextStyle(color: accentColor,fontSize: 16.sp),)
                    ],
                  )
                ],
              ),
            ),
          );
        }));
  }
}

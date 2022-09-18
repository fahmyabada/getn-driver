import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';
import 'package:getn_driver/data/model/country/IconModel.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/strings.dart';

import 'package:google_fonts/google_fonts.dart';

class SignInScreenView extends StatefulWidget {
  const SignInScreenView({Key? key}) : super(key: key);

  @override
  State<SignInScreenView> createState() => _SignInScreenViewState();
}

class _SignInScreenViewState extends State<SignInScreenView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CountryData selectedCountry = CountryData(
      title: {"ar": "مصر", "en": "Egypt"},
      code: '+20',
      id: "62d6edd71da20a7e80892617",
      icon: IconModel(
          src:
          "https://apis.getn.re-comparison.com/upload/country/1658254219700icon-file.webp"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: signInWidget(context),
        ),
      ),
    );
  }

  signInWidget(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(
          left: 20.r,
          right: 20.r,
          top: 100.r),
      child: (Column(
        children: [
          Text(
            Strings.signIn,
            style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor),
          ),
           SizedBox(
            height: 36.h,
          ),
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.black.withOpacity(0.1)),
                      borderRadius:
                           BorderRadius.circular(30.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 55.h,
                        width: 150.w,
                        child: SizedBox(
                          // width: 400,
                          height: 55,

                          child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    width: 1.w,
                                    color: Colors.grey[400] ?? Colors.black,
                                  ),
                                ),
                                isExpanded: true,
                                iconSize: 0.0,
                                icon:
                                    const Icon(Icons.keyboard_arrow_up_sharp),
                                style: const TextStyle(color: Colors.grey),
                                iconEnabledColor: Colors.grey,
                                hint: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      ImageTools.image(
                                        fit: BoxFit.contain,
                                        url: selectedCountry.icon?.src ?? " ",
                                        height: 30.h,
                                        width: 30.w,
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Color.fromARGB(
                                            207, 204, 204, 213),
                                      ),
                                      Text(
                                         selectedCountry
                                                  .title?["en"] ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.black)),
                                       SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                          selectedCountry
                                                  .code ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                                onChanged: (CountryData? value) {
                                  selectedCountry = value!;
                                },
                                items: controller.countries
                                    .map((selectedCountry) {
                                  return DropdownMenuItem<CountryData>(
                                    value: selectedCountry,
                                    child: Row(
                                      children: [
                                        ImageTools.image(
                                          fit: BoxFit.contain,
                                          url: selectedCountry.icon?.src ??
                                              " ",
                                          height: 30.h,
                                          width: 30.h,
                                        ),
                                         SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                            selectedCountry
                                                    .title?["en"] ??
                                                " ",
                                            style: const TextStyle(
                                                color: Colors.black)),
                                         SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                            selectedCountry
                                                    .code ??
                                                "",
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width / 1.9,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            style: GoogleFonts.roboto(
                                color: greyColor, fontSize: 14.sp),
                            controller: controller.mobileController,
                            keyboardType: TextInputType.number,
                            validator: (String? value) {
// remover number 1 from string
                              value = (value?.startsWith("0", 0) ?? false)
                                  ? value?.substring(1)
                                  : value;
                              //     value = ;
                              controller.mobileController.text = value ?? "";
                              if (GetUtils.isPhoneNumber(value ?? " ")) {
                                return null;
                              } else {
                                return Strings.pleaseFillOutTheField;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: Strings.phone,
                              contentPadding:  EdgeInsets.symmetric(
                                  vertical: 10.r, horizontal: 10.r),
                              labelStyle: GoogleFonts.roboto(
                                  color: greyColor, fontSize: 14.sp),
                              // filled: true,
                              hintStyle: GoogleFonts.roboto(
                                  color: greyColor, fontSize: 14.sp),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(
                  height: 24.h,
                ),
              ],
            ),
          ),
           SizedBox(
            height:  36.h,
          ),

          GestureDetector(
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Center(
                child: Text(
                  Strings.next.toUpperCase(),
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onTap: () {
              if (_formKey.currentState!.validate() &&
                  controller.selectedCountry?.value.id != null) {
                controller.sendOTP(controller.mobileController.text,
                    controller.selectedCountry?.value.id ?? "");
                controller.setPhoneNumber(controller.mobileController.text);
                controller.setCountryId(controller.selectedCountry?.value.id);
              } else {
                showSnackbar("error", Strings.pleaseFillOutTheField);
              }
            },
          ),
        ],
      )),
    );
  }
}

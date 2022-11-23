import 'dart:convert';
import 'dart:ui' as ui;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/wallet/wallet_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestTransactionScreen extends StatefulWidget {
  const RequestTransactionScreen({Key? key}) : super(key: key);

  @override
  State<RequestTransactionScreen> createState() =>
      _RequestTransactionScreenState();
}

class _RequestTransactionScreenState extends State<RequestTransactionScreen> {
  int? groupPaymentMethod;
  String groupPaymentMethodValue = "phone";
  Country? dropDownValueCountry;
  var formPhoneKey = GlobalKey<FormState>();
  var formVisaKey = GlobalKey<FormState>();
  var formMountKey = GlobalKey<FormState>();
  TextEditingController? phoneController;
  TextEditingController? mountController = TextEditingController();
  TextEditingController? swiftCodeController = TextEditingController();
  TextEditingController? accountNameController = TextEditingController();
  TextEditingController? bankNameController = TextEditingController();
  TextEditingController? accountNumberController = TextEditingController();
  TextEditingController? ibanController = TextEditingController();
  bool load = false;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(
        text: getIt<SharedPreferences>().getString("phone"));
    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletCubit()..getCountries(),
      child: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is CountriesErrorState) {
            if (kDebugMode) {
              print(
                  'RequestTransactionScreen*******CountriesErrorState ${state.message}');
            }
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          } else if (state is CountriesSuccessState) {
            if (kDebugMode) {
              print('RequestTransactionScreen*******CountriesSuccessState');
            }

            dropDownValueCountry = WalletCubit.get(context)
                .countries
                .where((element) =>
                    element.id ==
                    getIt<SharedPreferences>().getString("countryId"))
                .first;
          } else if (state is CreateRequestSuccessState) {
            setState(() {
              load = false;
            });
            Navigator.pop(context);
            showToastt(
                text: LanguageCubit.get(context)
                    .getTexts('SuccessTransaction')
                    .toString(),
                state: ToastStates.success,
                context: context);
          } else if (state is CreateRequestErrorState) {
            setState(() {
              load = false;
            });
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: LanguageCubit.get(context).isEn
                ? ui.TextDirection.ltr
                : ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  LanguageCubit.get(context)
                      .getTexts('RequestTransaction')
                      .toString(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.r, vertical: 20.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      radioButtonVisitTypeDetailsLayout(context),
                      groupPaymentMethodValue == "phone"
                          ? Form(
                              key: formPhoneKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.r),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20.r),
                                    decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.1)),
                                        borderRadius:
                                            BorderRadius.circular(50.r)),
                                    child: Row(
                                      children: [
                                        state is CountriesLoading
                                            ? loading()
                                            : WalletCubit.get(context)
                                                    .countries
                                                    .isNotEmpty
                                                ? Expanded(
                                                    flex: 2,
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton2(
                                                        //      value: controller.selectedCountry?.value,
                                                        dropdownDecoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      14.r),
                                                          border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey[
                                                                    400] ??
                                                                Colors.black,
                                                          ),
                                                        ),
                                                        isExpanded: true,
                                                        iconSize: 0.0,
                                                        dropdownWidth: 350.w,
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                        onChanged:
                                                            (Country? value) {
                                                          setState(() {
                                                            dropDownValueCountry =
                                                                value;
                                                          });
                                                        },
                                                        hint: Center(
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ImageTools.image(
                                                                fit: BoxFit
                                                                    .contain,
                                                                url: dropDownValueCountry!
                                                                        .icon!
                                                                        .src ??
                                                                    " ",
                                                                height: 35.w,
                                                                width: 35.w,
                                                              ),
                                                              const Icon(
                                                                Icons
                                                                    .keyboard_arrow_down_sharp,
                                                                color: Color
                                                                    .fromARGB(
                                                                        207,
                                                                        204,
                                                                        204,
                                                                        213),
                                                              ),
                                                              SizedBox(
                                                                width: 2.w,
                                                              ),
                                                              Text(
                                                                  dropDownValueCountry!
                                                                          .code ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          20.sp)),
                                                            ],
                                                          ),
                                                        ),
                                                        items: WalletCubit.get(
                                                                context)
                                                            .countries
                                                            .map(
                                                                (selectedCountry) {
                                                          return DropdownMenuItem<
                                                              Country>(
                                                            value:
                                                                selectedCountry,
                                                            child: Row(
                                                              children: [
                                                                ImageTools
                                                                    .image(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  url: selectedCountry
                                                                          .icon
                                                                          ?.src ??
                                                                      " ",
                                                                  height: 30.w,
                                                                  width: 30.w,
                                                                ),
                                                                SizedBox(
                                                                  width: 10.w,
                                                                ),
                                                                Text(
                                                                    LanguageCubit.get(
                                                                                context)
                                                                            .isEn
                                                                        ? selectedCountry.title?.en ??
                                                                            " "
                                                                        : selectedCountry.title?.ar ??
                                                                            " ",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20.sp)),
                                                                SizedBox(
                                                                  width: 10.w,
                                                                ),
                                                                Text(
                                                                    selectedCountry
                                                                            .code ??
                                                                        "",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20.sp)),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  )
                                                : Expanded(
                                                    child: IconButton(
                                                        icon: const Icon(
                                                            Icons.cloud_upload,
                                                            color: redColor),
                                                        onPressed: () {
                                                          WalletCubit.get(
                                                                  context)
                                                              .getCountries();
                                                        }),
                                                  ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: defaultFormField(
                                              controller: phoneController,
                                              type: TextInputType.phone,
                                              label: "123456789",
                                              textSize: 22,
                                              borderRadius: 50,
                                              border: true,
                                              borderColor: white,
                                              validatorText:
                                                  phoneController!.text,
                                              validatorMessage:
                                                  LanguageCubit.get(context)
                                                      .getTexts('EnterPhone')
                                                      .toString(),
                                              onEditingComplete: () {
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            )
                          : Form(
                              key: formVisaKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),

                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.r),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20.r),
                                    decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.1)),
                                        borderRadius:
                                            BorderRadius.circular(50.r)),
                                    child: defaultFormField(
                                        controller: accountNameController,
                                        type: TextInputType.text,
                                        label: LanguageCubit.get(context)
                                            .getTexts('AccountName')
                                            .toString(),
                                        textSize: 22,
                                        borderRadius: 50,
                                        border: true,
                                        borderColor: white,
                                        validatorText:
                                            accountNameController!.text,
                                        validatorMessage:
                                            LanguageCubit.get(context)
                                                .getTexts('EnterAccountName')
                                                .toString(),
                                        onEditingComplete: () {
                                          FocusScope.of(context).nextFocus();
                                        }),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.r),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20.r),
                                    decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.1)),
                                        borderRadius:
                                            BorderRadius.circular(50.r)),
                                    child: defaultFormField(
                                        controller: bankNameController,
                                        type: TextInputType.text,
                                        label: LanguageCubit.get(context)
                                            .getTexts('BankName')
                                            .toString(),
                                        textSize: 22,
                                        borderRadius: 50,
                                        border: true,
                                        borderColor: white,
                                        validatorText: bankNameController!.text,
                                        validatorMessage:
                                            LanguageCubit.get(context)
                                                .getTexts('EnterBankName')
                                                .toString(),
                                        onEditingComplete: () {
                                          FocusScope.of(context).nextFocus();
                                        }),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.r),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20.r),
                                    decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.1)),
                                        borderRadius:
                                            BorderRadius.circular(50.r)),
                                    child: defaultFormField(
                                        controller: accountNumberController,
                                        type: TextInputType.number,
                                        label: LanguageCubit.get(context)
                                            .getTexts('AccountNumber')
                                            .toString(),
                                        textSize: 22,
                                        borderRadius: 50,
                                        border: true,
                                        borderColor: white,
                                        validatorText:
                                            accountNumberController!.text,
                                        validatorMessage:
                                            LanguageCubit.get(context)
                                                .getTexts('EnterAccountNumber')
                                                .toString(),
                                        onEditingComplete: () {
                                          FocusScope.of(context).nextFocus();
                                        }),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.r),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20.r),
                                    decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.1)),
                                        borderRadius:
                                            BorderRadius.circular(50.r)),
                                    child: defaultFormField(
                                        controller: ibanController,
                                        type: TextInputType.text,
                                        label: LanguageCubit.get(context)
                                            .getTexts('iban')
                                            .toString(),
                                        textSize: 22,
                                        borderRadius: 50,
                                        border: true,
                                        borderColor: white,
                                        validatorText: ibanController!.text,
                                        validatorMessage:
                                            LanguageCubit.get(context)
                                                .getTexts('EnterIban')
                                                .toString(),
                                        onEditingComplete: () {
                                          FocusScope.of(context).unfocus();
                                        }),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 15.r),
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 20.r),
                                    decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(
                                            color:
                                            Colors.black.withOpacity(0.1)),
                                        borderRadius:
                                        BorderRadius.circular(50.r)),
                                    child: defaultFormField(
                                        controller: swiftCodeController,
                                        type: TextInputType.number,
                                        label: LanguageCubit.get(context)
                                            .getTexts('swiftCode')
                                            .toString(),
                                        textSize: 22,
                                        borderRadius: 50,
                                        border: true,
                                        borderColor: white,
                                        onEditingComplete: () {
                                          FocusScope.of(context).nextFocus();
                                        }),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            ),
                      Form(
                        key: formMountKey,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.r),
                          margin: EdgeInsets.symmetric(horizontal: 20.r),
                          decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(50.r)),
                          child: defaultFormField(
                              controller: mountController,
                              type: TextInputType.number,
                              label: LanguageCubit.get(context)
                                  .getTexts('amount')
                                  .toString(),
                              textSize: 22,
                              borderRadius: 50,
                              border: true,
                              borderColor: white,
                              validatorText: mountController!.text,
                              validatorMessage: LanguageCubit.get(context)
                                  .getTexts('EnterAmount')
                                  .toString(),
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 25.r, vertical: 30.r),
                        child: load
                            ? loading()
                            : defaultButton3(
                                press: () {
                                  load = true;
                                  if (groupPaymentMethodValue == "phone") {
                                    if (formPhoneKey.currentState!.validate() &&
                                        formMountKey.currentState!.validate() &&
                                        dropDownValueCountry != null) {
                                      var body = jsonEncode({
                                        "paymentMethod": "phone",
                                        "phone":
                                            phoneController!.text.toString(),
                                        "country": dropDownValueCountry!.id,
                                        "amount": mountController!.text.toString(),
                                      });

                                      WalletCubit.get(context)
                                          .createRequestTransaction(body);
                                    } else {
                                      setState(() {
                                        load = false;
                                      });
                                      showToastt(
                                          text: LanguageCubit.get(context)
                                              .getTexts('pleaseFillAllData')
                                              .toString(),
                                          state: ToastStates.error,
                                          context: context);
                                    }
                                  } else {
                                    if (formVisaKey.currentState!.validate() &&
                                        formMountKey.currentState!.validate()) {
                                      var body = jsonEncode({
                                        "paymentMethod": "visa",
                                        'paymentDetails': {
                                          'swiftCode': swiftCodeController!
                                              .text
                                              .toString(),
                                          'accountName': accountNameController!
                                              .text
                                              .toString(),
                                          'bankName': bankNameController!.text
                                              .toString(),
                                          'accountNumber':
                                              accountNumberController!.text
                                                  .toString(),
                                          'iban':
                                              ibanController!.text.toString()
                                        },
                                        "amount": mountController!.text.toString()
                                      });

                                      WalletCubit.get(context)
                                          .createRequestTransaction(body);
                                    } else {
                                      setState(() {
                                        load = false;
                                      });
                                      showToastt(
                                          text: LanguageCubit.get(context)
                                              .getTexts('pleaseFillAllData')
                                              .toString(),
                                          state: ToastStates.error,
                                          context: context);
                                    }
                                  }
                                },
                                text: LanguageCubit.get(context)
                                    .getTexts('Save')
                                    .toString(),
                                backColor: accentColor,
                                textColor: white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget radioButtonVisitTypeDetailsLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: grey,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                  value: 1,
                  groupValue: groupPaymentMethod ?? 1,
                  activeColor: primaryColor,
                  onChanged: (value) {
                    print("groupPaymentMethod***********$value");
                    setState(() {
                      groupPaymentMethod = value;
                      groupPaymentMethodValue = "phone";
                    });
                  },
                  // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Text(LanguageCubit.get(context).getTexts('Phone').toString(),
                    style: TextStyle(fontSize: 14.sp, color: black)),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: grey,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Radio(
                  value: 2,
                  groupValue: groupPaymentMethod,
                  activeColor: primaryColor,
                  onChanged: (value) {
                    setState(() {
                      print("groupPaymentMethod***********$value");
                      groupPaymentMethod = value;
                      groupPaymentMethodValue = "visa";
                    });
                  },
                  // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Text(
                  LanguageCubit.get(context).getTexts('Visa').toString(),
                  style: TextStyle(fontSize: 14.sp, color: black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

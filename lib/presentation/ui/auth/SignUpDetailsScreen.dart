import 'dart:io';
import 'dart:ui' as ui;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/auth/TermsScreen.dart';
import 'package:getn_driver/presentation/ui/auth/VerifyImageScreen.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SignUpDetailsScreen extends StatefulWidget {
  const SignUpDetailsScreen(
      {Key? key,
      required this.countryId,
      required this.phone,
      required this.firebaseToken,
      this.countryName})
      : super(key: key);

  final String phone;
  final String countryId;
  final String firebaseToken;
  final String? countryName;

  @override
  State<SignUpDetailsScreen> createState() => _SignUpDetailsScreenState();
}

class _SignUpDetailsScreenState extends State<SignUpDetailsScreen> {
  int groupValue = 0;
  var groupValueId = "";
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final birthDateController = TextEditingController();
  final addressController = TextEditingController();
  final whatsAppController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool terms = false;
  File? _imageUser;
  final ImagePicker _picker = ImagePicker();
  String userImage = "";
  dynamic _pickImageError;
  Country? dropDownValueCity;
  Country? dropDownValueArea;
  List<DateTime> availabilities = [];
  List<String> availabilitiesValues = [];
  Country? dropDownValueWhatsAppCountry;

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
      create: (context) => SignCubit()
      ..getCountries()
        ..getRole()
        ..getCity(widget.countryId),
      child: BlocConsumer<SignCubit, SignState>(listener: (context, state) {
        if (state is CountriesLoading) {
          if (kDebugMode) {
            print('SignInScreen*******CountriesLoading');
          }
        } else if (state is CountriesErrorState) {
          if (kDebugMode) {
            print('SignInScreen*******CountriesErrorState ${state.message}');
          }
          showToastt(
              text: state.message, state: ToastStates.error, context: context);
        }else if (state is CountriesSuccessState) {
          if (kDebugMode) {
            print(
                'SignInScreen*******CountriesSuccessState${SignCubit.get(context).countries[0].icon!.src} ');
          }
          dropDownValueWhatsAppCountry = SignCubit.get(context).countries[0];
        }else  if (state is RoleSuccessState) {
          print("RoleSuccessState**************${state.data![0].id}");
          groupValueId = state.data![0].id!;
        } else if (state is CitySuccessState) {
          if (state.data!.isNotEmpty) {
            setState(() {
              dropDownValueCity = state.data?.first;
            });
            SignCubit.get(context)
                .getArea(widget.countryId, dropDownValueCity!.id!);
          }
        } else if (state is AreaSuccessState) {
          if (state.data!.isNotEmpty) {
            dropDownValueArea = state.data?.first;
          }
        }
      }, builder: (context, state) {
        return Directionality(
          textDirection: LanguageCubit.get(context).isEn
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: accentColor,
              leading: const Icon(
                Icons.arrow_back,
                size: 0,
                color: black,
              ),
              title: Text(
                LanguageCubit.get(context)
                    .getTexts('CompleteRegistration')
                    .toString(),
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: white),
              ),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: () => Future.delayed(
                  const Duration(seconds: 2),
                      () {
                    SignCubit.get(context).getCountries();
                    SignCubit.get(context).getRole();
                    SignCubit.get(context).getCity(widget.countryId);
                  }),
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(start: 25.r,end: 25.r, top: 30.r,bottom: 30.r),
                child: Column(
                  children: [
                    Center(
                      child: InkWell(
                          onTap: () async {
                            _showImageSourceActionSheet(context);
                          },
                          borderRadius: BorderRadius.circular(20.r),
                          child: _imageUser != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Stack(
                                    fit: StackFit.loose,
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20.r),
                                        child: Image.file(
                                          _imageUser!,
                                          width: 150.w,
                                          height: 150.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      PositionedDirectional(
                                        bottom: 10,
                                        start: 10,
                                        child: CircleAvatar(
                                          radius: 20.sp,
                                          backgroundColor: black,
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 150.w,
                                  height: 150.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Stack(
                                    children:  [
                                      const Center(
                                        child: Text(
                                          'No image',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      PositionedDirectional(
                                        bottom: 10,
                                        start: 10,
                                        child: CircleAvatar(
                                          radius: 20.sp,
                                          backgroundColor: black,
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 25.sp,
                          color: grey2,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('PersonalInformation')
                              .toString(),
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          defaultFormField(
                            controller: fullNameController,
                            type: TextInputType.text,
                            label: LanguageCubit.get(context)
                                .getTexts('FullName')
                                .toString(),
                            textSize: 20,
                            border: false,
                            borderRadius: 50,
                            validatorText: fullNameController.text,
                            validatorMessage: LanguageCubit.get(context)
                                .getTexts('EnterFullName')
                                .toString(),
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          defaultFormField(
                            controller: emailController,
                            type: TextInputType.text,
                            label: LanguageCubit.get(context)
                                .getTexts('Email')
                                .toString(),
                            textSize: 20,
                            border: false,
                            borderRadius: 50,
                            validatorText: emailController.text,
                            validatorMessage: LanguageCubit.get(context)
                                .getTexts('EnterEmail')
                                .toString(),
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.r),
                            decoration: BoxDecoration(
                                color: white,
                                border: Border.all(color: black),
                                borderRadius: BorderRadius.circular(50.r)),
                            child: Row(
                              children: [
                                state is CountriesLoading
                                    ? Container(
                                        margin:
                                            EdgeInsetsDirectional.only(end: 10.w),
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
                                                    color: Colors.grey[400] ??
                                                        Colors.black,
                                                  ),
                                                ),
                                                isExpanded: true,
                                                iconSize: 0.0,
                                                dropdownWidth: 350.w,
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                                onChanged: (Country? value) {
                                                  setState(() {
                                                    dropDownValueWhatsAppCountry = value;
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
                                                        url: dropDownValueWhatsAppCountry!
                                                                .icon!.src ??
                                                            " ",
                                                        height: 35.w,
                                                        width: 35.w,
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .keyboard_arrow_down_sharp,
                                                        color: Color.fromARGB(
                                                            207, 204, 204, 213),
                                                      ),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Text(
                                                          dropDownValueWhatsAppCountry!
                                                                  .code ??
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
                                                          url: selectedCountry
                                                                  .icon?.src ??
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
                                                                ? selectedCountry
                                                                        .title
                                                                        ?.en ??
                                                                    " "
                                                                : selectedCountry
                                                                        .title
                                                                        ?.ar ??
                                                                    " ",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 20.sp)),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        Text(
                                                            selectedCountry.code ??
                                                                "",
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
                                                  SignCubit.get(context)
                                                      .getCountries();
                                                }),
                                          ),
                                Expanded(
                                  flex: 4,
                                  child: defaultFormField(
                                    controller: whatsAppController,
                                    type: TextInputType.number,
                                    label: LanguageCubit.get(context)
                                        .getTexts('WhatsApp')
                                        .toString(),
                                    textSize: 20,
                                    border: true,
                                    borderColor: white,
                                    borderRadius: 50,
                                    validatorText: whatsAppController.text,
                                    validatorMessage: LanguageCubit.get(context)
                                        .getTexts('EnterWhatsApp')
                                        .toString(),
                                    onEditingComplete: () {
                                      FocusScope.of(context).nextFocus();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InkWell(
                            child: IgnorePointer(
                              ignoring: true,
                              child: defaultFormField(
                                controller: birthDateController,
                                type: TextInputType.text,
                                label: LanguageCubit.get(context)
                                    .getTexts('Birthday')
                                    .toString(),
                                textSize: 20,
                                border: false,
                                borderRadius: 50,
                                validatorText: birthDateController.text,
                                validatorMessage: LanguageCubit.get(context)
                                    .getTexts('EnterBirthday')
                                    .toString(),
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            ),
                            onTap: () async {
                              final now = DateTime.now();
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: DateTime(now.year - 100),
                                lastDate: now,
                              );

                              if (pickedDate != null) {
                                birthDateController.text =
                                    DateFormat("yyyy-MM-dd").format(pickedDate);
                              }
                            },
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 2.h, color: black),
                    SizedBox(
                      height: 32.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 25.sp,
                          color: grey2,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('Address')
                              .toString(),
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Container(
                      width: 1.sw,
                      padding: EdgeInsets.symmetric(vertical:  15.r,horizontal: 25.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      child: Text(
                        widget.countryName!,
                        style: TextStyle(fontSize: 20.sp, color: black),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    SignCubit.get(context).loadingCity
                        ? loading()
                        : SignCubit.get(context).failureCity.isNotEmpty
                            ? errorMessage2(
                                message: LanguageCubit.get(context)
                                    .getTexts('ErrorGetCites')
                                    .toString(),
                                press: () {
                                  SignCubit.get(context)
                                      .getCity(widget.countryId);
                                },
                                context: context)
                            : SignCubit.get(context).city.isNotEmpty
                                ? Container(
                                    width: 1.sw,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.r),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        //      value: controller.selectedCountry?.value,
                                        dropdownDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        isExpanded: true,
                                        iconSize: 40.sp,
                                        icon: Container(
                                          margin: EdgeInsetsDirectional.only(
                                              end: 18.r),
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            color: grey2,
                                            size: 40.sp,
                                          ),
                                        ),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        onChanged: (Country? value) {
                                          setState(() {
                                            dropDownValueCity = value;
                                            SignCubit.get(context).getArea(
                                                widget.countryId,
                                                dropDownValueCity!.id!);
                                          });
                                        },
                                        hint: Container(
                                          width: 1.sw,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.r),
                                          child: Text(
                                              LanguageCubit.get(context).isEn
                                                  ? dropDownValueCity
                                                          ?.title?.en! ??
                                                      "Country"
                                                  : dropDownValueCity
                                                          ?.title?.ar! ??
                                                      "دولة",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontSize: 20.sp)),
                                        ),
                                        items: SignCubit.get(context)
                                            .city
                                            .map((selectedCountry) {
                                          return DropdownMenuItem<Country>(
                                            value: selectedCountry,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    LanguageCubit.get(context)
                                                            .isEn
                                                        ? selectedCountry
                                                                .title?.en ??
                                                            ""
                                                        : selectedCountry
                                                                .title?.ar ??
                                                            "",
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontSize: 20.sp)),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                // divider
                                                Container(
                                                  width: 1.sw,
                                                  height: 1.h,
                                                  color: Colors.grey[400],
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                : Container(),
                    SizedBox(
                      height: 16.h,
                    ),
                    SignCubit.get(context).loadingArea
                        ? loading()
                        : SignCubit.get(context).failureArea.isNotEmpty
                            ? errorMessage2(
                                message: LanguageCubit.get(context)
                                    .getTexts('ErrorGetArea')
                                    .toString(),
                                press: () {
                                  SignCubit.get(context).getArea(
                                      widget.countryId, dropDownValueCity!.id!);
                                },
                               context: context)
                            : SignCubit.get(context).area.isNotEmpty
                                ? Container(
                                    width: 1.sw,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.r),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        //      value: controller.selectedCountry?.value,
                                        dropdownDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        isExpanded: true,
                                        iconSize: 40.sp,
                                        icon: Container(
                                          margin: EdgeInsetsDirectional.only(
                                              end: 18.r),
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            color: grey2,
                                            size: 40.sp,
                                          ),
                                        ),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        onChanged: (Country? value) {
                                          setState(() {
                                            dropDownValueArea = value;
                                          });
                                        },
                                        hint: Container(
                                          width: 1.sw,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.r),
                                          child: Text(
                                              LanguageCubit.get(context).isEn
                                                  ? dropDownValueArea
                                                          ?.title?.en! ??
                                                      "Country"
                                                  : dropDownValueArea
                                                          ?.title?.ar! ??
                                                      "دولة",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontSize: 20.sp)),
                                        ),
                                        items: SignCubit.get(context)
                                            .area
                                            .map((selectedCountry) {
                                          return DropdownMenuItem<Country>(
                                            value: selectedCountry,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    LanguageCubit.get(context)
                                                            .isEn
                                                        ? selectedCountry
                                                                .title?.en ??
                                                            ""
                                                        : selectedCountry
                                                                .title?.ar ??
                                                            "",
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontSize: 20.sp)),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                // divider
                                                Container(
                                                  width: 1.sw,
                                                  height: 1.h,
                                                  color: Colors.grey[400],
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                : Container(),
                    SizedBox(
                      height: 16.h,
                    ),
                    defaultFormField(
                      controller: addressController,
                      type: TextInputType.text,
                      label: LanguageCubit.get(context)
                          .getTexts('Address')
                          .toString(),
                      textSize: 20,
                      border: false,
                      borderRadius: 50,
                      validatorText: addressController.text,
                      validatorMessage: LanguageCubit.get(context)
                          .getTexts('EnterAddress')
                          .toString(),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 25.sp,
                          color: grey2,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('Availabilities')
                              .toString(),
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.multiple,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      children: [
                        Text(
                          LanguageCubit.get(context).getTexts('Role').toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: black),
                        ),
                        state is RoleLoading
                            ? Container(
                                margin: EdgeInsetsDirectional.only(start: 30.r),
                                child: loading(),
                              )
                            : SignCubit.get(context).roles.isNotEmpty
                                ? Expanded(
                                    child: radioButtonTypeDriverLayout(context),
                                  )
                                : Container(
                                    margin:
                                        EdgeInsetsDirectional.only(start: 30.r),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.cloud_upload,
                                          color: redColor,
                                          size: 60.sp,
                                        ),
                                        onPressed: () {
                                          SignCubit.get(context).getRole();
                                        }),
                                  ),
                      ],
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          focusColor: Theme.of(context).focusColor,
                          //   activeColor: Theme.of(context).colorScheme.secondary,
                          value: terms,
                          onChanged: (value) {
                            setState(() {
                              terms = value!;
                            });
                          },
                        ),
                        SizedBox(width: 20.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                LanguageCubit.get(context)
                                    .getTexts('read&agree')
                                    .toString(),
                                style: TextStyle(fontSize: 17.sp, color: black)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    bool value =
                                        await navigateToWithRefreshPagePrevious(
                                            context, const TermsScreen());

                                    setState(() {
                                      terms = value;
                                    });
                                  },
                                  child: Text(
                                      LanguageCubit.get(context)
                                          .getTexts('Terms&Condition')
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 17.sp, color: accentColor)),
                                ),
                                Text(
                                    LanguageCubit.get(context)
                                        .getTexts('AndPrivacyPolicy')
                                        .toString(),
                                    style:
                                        TextStyle(fontSize: 17.sp, color: black)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(
                          start: 25.r, end: 25.r, top: 30.r),
                      child: defaultButton3(
                          press: () {
                            if (formKey.currentState!.validate() &&
                                dropDownValueCity != null &&
                                dropDownValueArea != null &&
                                userImage.isNotEmpty &&
                                availabilitiesValues.isNotEmpty) {
                              if (terms) {
                                String whatsApp = "";
                                if (whatsAppController.text.startsWith('0') &&
                                    whatsAppController.text.length > 1) {
                                  final splitPhone =
                                      const TextEditingValue().copyWith(
                                    text: whatsAppController.text
                                        .replaceAll(RegExp(r'^0+(?=.)'), ''),
                                    selection:
                                        whatsAppController.selection.copyWith(
                                      baseOffset:
                                          whatsAppController.text.length - 1,
                                      extentOffset:
                                          whatsAppController.text.length - 1,
                                    ),
                                  );
                                  whatsApp = splitPhone.text.toString();
                                } else {
                                  whatsApp = whatsAppController.text.toString();
                                }
                                navigateTo(
                                  context,
                                  VerifyImageScreen(
                                      typeScreen: "register",
                                      fullName:
                                          fullNameController.text.toString(),
                                      email: emailController.text.toString(),
                                      phone: widget.phone,
                                      birthDate:
                                          birthDateController.text.toString(),
                                      countryId: widget.countryId,
                                      cityId: dropDownValueCity!.id!,
                                      areaId: dropDownValueArea!.id!,
                                      address: addressController.text.toString(),
                                      availabilities: availabilitiesValues,
                                      firebaseToken: widget.firebaseToken,
                                      role: groupValueId,
                                      terms: terms,
                                      userImage: userImage,
                                      whatsApp: whatsApp,
                                      whatsappCountry : dropDownValueWhatsAppCountry!.id!),
                                );
                              } else {
                                showToastt(
                                    text: LanguageCubit.get(context)
                                        .getTexts('CheckTerms&Condition')
                                        .toString(),
                                    state: ToastStates.error,
                                    context: context);
                              }
                            } else {
                              showToastt(
                                  text: LanguageCubit.get(context)
                                      .getTexts('FillAllData')
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
            ),
          ),
        );
      }),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Camera'),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Gallery'),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.gallery);
              },
            )
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            tileColor: white,
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Gallery'),
            tileColor: white,
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.gallery);
            },
          ),
        ]),
      );
    }
  }

  Future selectImageSource(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: imageSource);
      if (pickedFile == null) {
        print('_imageUserSignUp***************** =$pickedFile');
        return;
      }

      setState(() {
        _imageUser = File(pickedFile.path);
        userImage = _imageUser!.path.toString();
        if (kDebugMode) {
          print('_imageUser***************** =${_imageUser!.path}');
        }
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
        if (kDebugMode) {
          print('imageErrorSignUp***************** =$_pickImageError');
        }
        if (e.toString() ==
            "PlatformException(camera_access_denied, The user did not allow camera access., null, null)") {
          showDialog(
            context: context,
            barrierDismissible: false,
            // outside to dismiss
            builder: (BuildContext context) {
              return CustomDialogImage(
                title:
                    LanguageCubit.get(context).getTexts('TakeImage').toString(),
                description: LanguageCubit.get(context)
                    .getTexts('CameraPermissions')
                    .toString(),
                type: "checkImageDeniedForever",
                backgroundColor: white,
                btnOkColor: accentColor,
                btnCancelColor: grey,
                titleColor: accentColor,
                descColor: black,
              );
            },
          );
        } else {
          showToastt(
              text: e.toString(), state: ToastStates.error, context: context);
        }
      });
    }
  }

  Widget radioButtonTypeDriverLayout(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(start: 50.r),
          decoration: BoxDecoration(
            color: grey,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                value: 0,
                groupValue: groupValue,
                activeColor: accentColor,
                onChanged: (value) {
                  setState(() {
                    groupValue = value!;
                    groupValueId = SignCubit.get(context).roles[0].id!;
                  });
                },
              ),
              Text(SignCubit.get(context).roles[0].title!,
                  style: TextStyle(fontSize: 18.sp)),
            ],
          ),
        ),
        SizedBox(
          height: 15.w,
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 50.r),
          decoration: BoxDecoration(
            color: grey,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Radio(
                value: 1,
                groupValue: groupValue,
                activeColor: accentColor,
                onChanged: (value) {
                  setState(() {
                    groupValue = value!;
                    groupValueId = SignCubit.get(context).roles[1].id!;
                  });
                },
                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(
                SignCubit.get(context).roles[1].title!,
                style: TextStyle(fontSize: 18.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is List<DateTime>) {
        setState(() {
          availabilities = args.value;
          availabilitiesValues =
              availabilities.map((e) => DateFormat('yyyy-MM-dd').format(e).toString()).toList();
        });
      }
    });
  }
}

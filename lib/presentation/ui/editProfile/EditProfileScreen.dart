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
import 'package:getn_driver/presentation/ui/editProfile/edit_profile_cubit.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final formKeyAddress = GlobalKey<FormState>();

  dynamic _pickImageError;
  File? _imageUser;
  final ImagePicker _picker = ImagePicker();
  String userImage = "";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final whatsAppController = TextEditingController();
  final birthDateController = TextEditingController();
  final addressController = TextEditingController();

  Country? dropDownValueCountries;
  Country? dropDownValueCity;
  Country? dropDownValueArea;
  Country? dropDownValueWhatsAppCountry;
  bool imageRemote = false;
  bool isEn = true;
  List<DateTime> availabilities = [];
  List<String> availabilitiesValues = [];

  @override
  void initState() {
    super.initState();

    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;

      isEn = getIt<SharedPreferences>().getBool("isEn")!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileCubit()..getProfileDetails(),
      child: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is GetProfileDetailsSuccessState) {
            if (state.data!.country!.id != null) {
              setState(() {
                dropDownValueCountries = state.data!.country!;
                dropDownValueWhatsAppCountry = state.data!.country!;
                EditProfileCubit.get(context).getCountries();
              });
            }
            if (state.data!.availabilities!.isNotEmpty) {
              setState(() {
                for (var element in state.data!.availabilities!) {
                  availabilities.add(DateTime.parse(element));
                }
                availabilitiesValues = state.data!.availabilities!;
              });
            }
            if (state.data!.image!.src != null) {
              setState(() {
                userImage = state.data!.image!.src!;
                imageRemote = true;
              });
            }
            if (state.data!.email != null) {
              setState(() {
                emailController.text = state.data!.email!;
              });
            }
            if (state.data!.name != null) {
              setState(() {
                nameController.text = state.data!.name!;
              });
            }
            if (state.data!.address != null) {
              setState(() {
                addressController.text = state.data!.address!;
              });
            }
            if (state.data!.whatsApp != null) {
              setState(() {
                whatsAppController.text = state.data!.whatsApp!;
              });
            }
            if (state.data!.birthDate != null) {
              setState(() {
                final DateFormat displayFormater =
                    DateFormat('yyyy-MM-ddTHH:mm');
                final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
                final DateTime displayDate =
                    displayFormater.parse(state.data!.birthDate!);
                final String formatted = serverFormater.format(displayDate);
                birthDateController.text = formatted;
              });
            }
          } else if (state is CountriesSuccessState) {
            EditProfileCubit.get(context).getCity(dropDownValueCountries!.id!);
          } else if (state is CitySuccessState) {
            if (state.data!.isNotEmpty) {
              setState(() {
                dropDownValueCity = state.data?.first;
              });
              EditProfileCubit.get(context)
                  .getArea(dropDownValueCountries!.id!, dropDownValueCity!.id!);
            }
          } else if (state is AreaSuccessState) {
            if (state.data!.isNotEmpty) {
              dropDownValueArea = state.data?.first;
            }
          } else if (state is EditProfileSuccessState) {
            if (state.data.phone != null) {
              getIt<SharedPreferences>().setString('phone', state.data.phone!);
            }
            if (state.data.name != null) {
              getIt<SharedPreferences>().setString('name', state.data.name!);
            }
            if (state.data.image!.src != null) {
              getIt<SharedPreferences>()
                  .setString('userImage', state.data.image!.src!);
            }

            LanguageCubit.get(context).changeLan(isEn);

            Navigator.pop(context);
          } else if (state is EditProfileErrorState) {
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
                    LanguageCubit.get(context).getTexts('MyAccount').toString(),
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: black),
                  ),
                  centerTitle: true,
                ),
                body: state is GetProfileDetailsLoading
                    ? loading()
                    : EditProfileCubit.get(context).failure.isNotEmpty
                        ? errorMessage2(
                            message: EditProfileCubit.get(context).failure,
                            press: () {
                              EditProfileCubit.get(context).getProfileDetails();
                            },
                            context: context)
                        : RefreshIndicator(
                            onRefresh: () => Future.delayed(
                                const Duration(seconds: 2),
                                () => EditProfileCubit.get(context)
                                    .getProfileDetails()),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.r, horizontal: 16.r),
                                child: Column(
                                  children: [
                                    Center(
                                      child: InkWell(
                                        onTap: () async {
                                          _showImageSourceActionSheet(context);
                                        },
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        child: _imageUser == null
                                            ? EditProfileCubit.get(context)
                                                        .profileDetails
                                                        ?.image
                                                        ?.src !=
                                                    null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                    child: Stack(
                                                      children: [
                                                        ImageTools.image(
                                                            fit: BoxFit.fill,
                                                            url: EditProfileCubit
                                                                    .get(
                                                                        context)
                                                                .profileDetails
                                                                ?.image
                                                                ?.src,
                                                            height: 150.w,
                                                            width: 150.w),
                                                        const Positioned(
                                                          bottom: 10,
                                                          right: 10,
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.grey,
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            LanguageCubit.get(
                                                                    context)
                                                                .getTexts(
                                                                    'NoImage')
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        const Positioned(
                                                          bottom: 10,
                                                          right: 10,
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                            : Stack(
                                                fit: StackFit.loose,
                                                alignment: Alignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                    child: Image.file(
                                                      _imageUser!,
                                                      width: 150.w,
                                                      height: 150.w,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    bottom: 10,
                                                    right: 10,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 32.h,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
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
                                            controller: nameController,
                                            type: TextInputType.text,
                                            label: LanguageCubit.get(context)
                                                .getTexts('Name')
                                                .toString(),
                                            textSize: 20,
                                            border: false,
                                            borderRadius: 50,
                                            validatorText: nameController.text,
                                            validatorMessage:
                                                LanguageCubit.get(context)
                                                    .getTexts('EnterName')
                                                    .toString(),
                                            onEditingComplete: () {
                                              FocusScope.of(context)
                                                  .nextFocus();
                                            },
                                          ),
                                          SizedBox(
                                            height: 16.h,
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
                                            validatorMessage:
                                                LanguageCubit.get(context)
                                                    .getTexts('EnterEmail')
                                                    .toString(),
                                            onEditingComplete: () {
                                              FocusScope.of(context)
                                                  .nextFocus();
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
                                                            EdgeInsetsDirectional
                                                                .only(end: 10.w),
                                                        child: loading(),
                                                      )
                                                    : EditProfileCubit.get(
                                                                context)
                                                            .countries
                                                            .isNotEmpty
                                                        ? Expanded(
                                                            flex: 2,
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2(
                                                                //      value: controller.selectedCountry?.value,
                                                                dropdownDecoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14.r),
                                                                  border:
                                                                      Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                                .grey[
                                                                            400] ??
                                                                        Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                isExpanded: true,
                                                                iconSize: 0.0,
                                                                dropdownWidth:
                                                                    350.w,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                                onChanged:
                                                                    (Country?
                                                                        value) {
                                                                  setState(() {
                                                                    dropDownValueWhatsAppCountry =
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
                                                                      ImageTools
                                                                          .image(
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        url: dropDownValueWhatsAppCountry!
                                                                                .icon!
                                                                                .src ??
                                                                            " ",
                                                                        height:
                                                                            35.w,
                                                                        width:
                                                                            35.w,
                                                                      ),
                                                                      const Icon(
                                                                        Icons
                                                                            .keyboard_arrow_down_sharp,
                                                                        color: Color.fromARGB(
                                                                            207,
                                                                            204,
                                                                            204,
                                                                            213),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            2.w,
                                                                      ),
                                                                      Text(
                                                                          dropDownValueWhatsAppCountry!.code ??
                                                                              "",
                                                                          style: TextStyle(
                                                                              color:
                                                                                  Colors.black,
                                                                              fontSize: 20.sp)),
                                                                    ],
                                                                  ),
                                                                ),
                                                                items: EditProfileCubit
                                                                        .get(
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
                                                                          url: selectedCountry.icon?.src ??
                                                                              " ",
                                                                          height:
                                                                              30.w,
                                                                          width:
                                                                              30.w,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10.w,
                                                                        ),
                                                                        Text(
                                                                            LanguageCubit.get(context).isEn
                                                                                ? selectedCountry.title?.en ??
                                                                                    " "
                                                                                : selectedCountry.title?.ar ??
                                                                                    " ",
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 20.sp)),
                                                                        SizedBox(
                                                                          width:
                                                                              10.w,
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
                                                                icon: const Icon(
                                                                    Icons
                                                                        .cloud_upload,
                                                                    color:
                                                                        redColor),
                                                                onPressed: () {
                                                                  EditProfileCubit
                                                                          .get(
                                                                              context)
                                                                      .getCountries();
                                                                }),
                                                          ),
                                                Expanded(
                                                  flex: 4,
                                                  child: defaultFormField(
                                                    controller:
                                                        whatsAppController,
                                                    type: TextInputType.number,
                                                    label:
                                                        LanguageCubit.get(context)
                                                            .getTexts('WhatsApp')
                                                            .toString(),
                                                    textSize: 20,
                                                    border: true,
                                                    borderColor: white,
                                                    borderRadius: 50,
                                                    validatorText:
                                                        whatsAppController.text,
                                                    validatorMessage:
                                                        LanguageCubit.get(context)
                                                            .getTexts(
                                                                'EnterWhatsApp')
                                                            .toString(),
                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .nextFocus();
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
                                                label:
                                                    LanguageCubit.get(context)
                                                        .getTexts('Birthday')
                                                        .toString(),
                                                textSize: 20,
                                                border: false,
                                                borderRadius: 50,
                                                validatorText:
                                                    birthDateController.text,
                                                validatorMessage:
                                                    LanguageCubit.get(context)
                                                        .getTexts(
                                                            'EnterBirthday')
                                                        .toString(),
                                                onEditingComplete: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                              ),
                                            ),
                                            onTap: () async {
                                              final now = DateTime.now();
                                              final pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: now,
                                                firstDate:
                                                    DateTime(now.year - 100),
                                                lastDate: now,
                                              );

                                              if (pickedDate != null) {
                                                birthDateController.text =
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(pickedDate);
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    EditProfileCubit.get(context).loadingCountry
                                        ? loading()
                                        : EditProfileCubit.get(context)
                                                .failureCountry
                                                .isNotEmpty
                                            ? errorMessage2(
                                                message:
                                                    LanguageCubit.get(context)
                                                        .getTexts(
                                                            'ErrorGetCountries')
                                                        .toString(),
                                                press: () {
                                                  EditProfileCubit.get(context)
                                                      .getCountries();
                                                },
                                                context: context)
                                            : EditProfileCubit.get(context)
                                                    .countries
                                                    .isNotEmpty
                                                ? Container(
                                                    width: 1.sw,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.r),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Colors.black,
                                                      ),
                                                    ),
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
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        isExpanded: true,
                                                        iconSize: 40.sp,
                                                        icon: Container(
                                                          margin:
                                                              EdgeInsetsDirectional
                                                                  .only(
                                                                      end:
                                                                          18.r),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: grey2,
                                                            size: 40.sp,
                                                          ),
                                                        ),
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                        onChanged:
                                                            (Country? value) {
                                                          setState(() {
                                                            dropDownValueCountries =
                                                                value;
                                                            EditProfileCubit
                                                                    .get(
                                                                        context)
                                                                .getCity(
                                                                    dropDownValueCountries!
                                                                        .id!);
                                                          });
                                                        },
                                                        hint: Container(
                                                          width: 1.sw,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.r,
                                                                  vertical:
                                                                      5.r),
                                                          child: Center(
                                                            child: Text(
                                                                LanguageCubit.get(
                                                                            context)
                                                                        .isEn
                                                                    ? dropDownValueCountries
                                                                            ?.title
                                                                            ?.en! ??
                                                                        "Country"
                                                                    : dropDownValueCountries
                                                                            ?.title
                                                                            ?.ar! ??
                                                                        "دولة",
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20.sp)),
                                                          ),
                                                        ),
                                                        items: EditProfileCubit
                                                                .get(context)
                                                            .countries
                                                            .map(
                                                                (selectedCountry) {
                                                          return DropdownMenuItem<
                                                              Country>(
                                                            value:
                                                                selectedCountry,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    LanguageCubit.get(context)
                                                                            .isEn
                                                                        ? selectedCountry.title?.en ??
                                                                            ""
                                                                        : selectedCountry.title?.ar ??
                                                                            "",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20.sp)),
                                                                SizedBox(
                                                                  height: 5.h,
                                                                ),
                                                                // divider
                                                                Container(
                                                                  width: 1.sw,
                                                                  height: 1.h,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
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
                                    EditProfileCubit.get(context).loadingCity
                                        ? loading()
                                        : EditProfileCubit.get(context)
                                                .failureCity
                                                .isNotEmpty
                                            ? errorMessage2(
                                                message: LanguageCubit.get(
                                                        context)
                                                    .getTexts('ErrorGetCites')
                                                    .toString(),
                                                press: () {
                                                  EditProfileCubit.get(context)
                                                      .getCity(
                                                          dropDownValueCountries!
                                                              .id!);
                                                },
                                                context: context)
                                            : EditProfileCubit.get(context)
                                                    .city
                                                    .isNotEmpty
                                                ? Container(
                                                    width: 1.sw,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.r),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Colors.black,
                                                      ),
                                                    ),
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
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        isExpanded: true,
                                                        iconSize: 40.sp,
                                                        icon: Container(
                                                          margin:
                                                              EdgeInsetsDirectional
                                                                  .only(
                                                                      end:
                                                                          18.r),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: grey2,
                                                            size: 40.sp,
                                                          ),
                                                        ),
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                        onChanged:
                                                            (Country? value) {
                                                          setState(() {
                                                            dropDownValueCity =
                                                                value;
                                                            EditProfileCubit
                                                                    .get(
                                                                        context)
                                                                .getArea(
                                                                    dropDownValueCountries!
                                                                        .id!,
                                                                    dropDownValueCity!
                                                                        .id!);
                                                          });
                                                        },
                                                        hint: Container(
                                                          width: 1.sw,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.r,
                                                                  vertical:
                                                                      5.r),
                                                          child: Center(
                                                            child: Text(
                                                                LanguageCubit.get(
                                                                            context)
                                                                        .isEn
                                                                    ? dropDownValueCity
                                                                            ?.title
                                                                            ?.en! ??
                                                                        "Country"
                                                                    : dropDownValueCity
                                                                            ?.title
                                                                            ?.ar! ??
                                                                        "دولة",
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20.sp)),
                                                          ),
                                                        ),
                                                        items: EditProfileCubit
                                                                .get(context)
                                                            .city
                                                            .map(
                                                                (selectedCountry) {
                                                          return DropdownMenuItem<
                                                              Country>(
                                                            value:
                                                                selectedCountry,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    LanguageCubit.get(context)
                                                                            .isEn
                                                                        ? selectedCountry.title?.en ??
                                                                            ""
                                                                        : selectedCountry.title?.ar ??
                                                                            "",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20.sp)),
                                                                SizedBox(
                                                                  height: 5.h,
                                                                ),
                                                                // divider
                                                                Container(
                                                                  width: 1.sw,
                                                                  height: 1.h,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
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
                                    EditProfileCubit.get(context).loadingArea
                                        ? loading()
                                        : EditProfileCubit.get(context)
                                                .failureArea
                                                .isNotEmpty
                                            ? errorMessage2(
                                                message: LanguageCubit.get(
                                                        context)
                                                    .getTexts('ErrorGetArea')
                                                    .toString(),
                                                press: () {
                                                  EditProfileCubit.get(context)
                                                      .getArea(
                                                          dropDownValueCountries!
                                                              .id!,
                                                          dropDownValueCity!
                                                              .id!);
                                                },
                                                context: context)
                                            : EditProfileCubit.get(context)
                                                    .area
                                                    .isNotEmpty
                                                ? Container(
                                                    width: 1.sw,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.r),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Colors.black,
                                                      ),
                                                    ),
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
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        isExpanded: true,
                                                        iconSize: 40.sp,
                                                        icon: Container(
                                                          margin:
                                                              EdgeInsetsDirectional
                                                                  .only(
                                                                      end:
                                                                          18.r),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: grey2,
                                                            size: 40.sp,
                                                          ),
                                                        ),
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                        onChanged:
                                                            (Country? value) {
                                                          setState(() {
                                                            dropDownValueArea =
                                                                value;
                                                          });
                                                        },
                                                        hint: Container(
                                                          width: 1.sw,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.r,
                                                                  vertical:
                                                                      5.r),
                                                          child: Center(
                                                            child: Text(
                                                                LanguageCubit.get(
                                                                            context)
                                                                        .isEn
                                                                    ? dropDownValueArea
                                                                            ?.title
                                                                            ?.en! ??
                                                                        "Country"
                                                                    : dropDownValueArea
                                                                            ?.title
                                                                            ?.ar! ??
                                                                        "دولة",
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20.sp)),
                                                          ),
                                                        ),
                                                        items: EditProfileCubit
                                                                .get(context)
                                                            .area
                                                            .map(
                                                                (selectedCountry) {
                                                          return DropdownMenuItem<
                                                              Country>(
                                                            value:
                                                                selectedCountry,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    LanguageCubit.get(context)
                                                                            .isEn
                                                                        ? selectedCountry.title?.en ??
                                                                            ""
                                                                        : selectedCountry.title?.ar ??
                                                                            "",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20.sp)),
                                                                SizedBox(
                                                                  height: 5.h,
                                                                ),
                                                                // divider
                                                                Container(
                                                                  width: 1.sw,
                                                                  height: 1.h,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
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
                                    Form(
                                      key: formKeyAddress,
                                      child: defaultFormField(
                                        controller: addressController,
                                        type: TextInputType.text,
                                        label: LanguageCubit.get(context)
                                            .getTexts('Address')
                                            .toString(),
                                        textSize: 20,
                                        border: false,
                                        borderRadius: 50,
                                        validatorText: addressController.text,
                                        validatorMessage:
                                            LanguageCubit.get(context)
                                                .getTexts('EnterAddress')
                                                .toString(),
                                        onEditingComplete: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.language,
                                          size: 25.sp,
                                          color: grey2,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          LanguageCubit.get(context)
                                              .getTexts('lang')
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    ListTile(
                                      title: Row(
                                        children: [
                                          Text(
                                            LanguageCubit.get(context)
                                                .getTexts('Arabic')
                                                .toString(),
                                            style: TextStyle(
                                                color: black, fontSize: 20.sp),
                                          ),
                                          Switch(
                                            activeColor: primaryColor,
                                            value: isEn,
                                            onChanged: (value) {
                                              setState(() {
                                                isEn = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            LanguageCubit.get(context)
                                                .getTexts('English')
                                                .toString(),
                                            style: TextStyle(
                                                color: black, fontSize: 20.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    SfDateRangePicker(
                                      onSelectionChanged: _onSelectionChanged,
                                      selectionMode:
                                          DateRangePickerSelectionMode.multiple,
                                      initialSelectedDates: availabilities,
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    EditProfileCubit.get(context).loadingEdit
                                        ? loading()
                                        : defaultButton3(
                                            press: () {
                                              if (formKey.currentState!
                                                      .validate() &&
                                                  dropDownValueCountries !=
                                                      null &&
                                                  dropDownValueCity != null &&
                                                  dropDownValueArea != null &&
                                                  userImage.isNotEmpty &&
                                                  availabilities.isNotEmpty) {
                                                String whatsApp = "";
                                                if (whatsAppController.text
                                                        .startsWith('0') &&
                                                    whatsAppController
                                                            .text.length >
                                                        1) {
                                                  final splitPhone =
                                                      const TextEditingValue()
                                                          .copyWith(
                                                    text: whatsAppController
                                                        .text
                                                        .replaceAll(
                                                            RegExp(r'^0+(?=.)'),
                                                            ''),
                                                    selection:
                                                        whatsAppController
                                                            .selection
                                                            .copyWith(
                                                      baseOffset:
                                                          whatsAppController
                                                                  .text.length -
                                                              1,
                                                      extentOffset:
                                                          whatsAppController
                                                                  .text.length -
                                                              1,
                                                    ),
                                                  );
                                                  whatsApp = splitPhone.text
                                                      .toString();
                                                } else {
                                                  whatsApp = whatsAppController
                                                      .text
                                                      .toString();
                                                }

                                                FocusScopeNode currentFocus =
                                                    FocusScope.of(context);
                                                if (!currentFocus
                                                    .hasPrimaryFocus) {
                                                  currentFocus.focusedChild
                                                      ?.unfocus();
                                                }

                                                EditProfileCubit.get(context)
                                                    .editProfileDetails(
                                                        nameController.text
                                                            .toString(),
                                                        emailController.text
                                                            .toString(),
                                                        birthDateController.text
                                                            .toString(),
                                                        dropDownValueCountries!
                                                            .id!,
                                                        dropDownValueCity!.id!,
                                                        dropDownValueArea!.id!,
                                                        userImage,
                                                        availabilitiesValues,
                                                        imageRemote,
                                                        addressController.text
                                                            .toString(),
                                                        whatsApp,
                                                        LanguageCubit.get(
                                                                context)
                                                            .isEn,
                                                        dropDownValueWhatsAppCountry!
                                                            .id!);
                                              } else {
                                                showToastt(
                                                    text: LanguageCubit.get(
                                                            context)
                                                        .getTexts('FillAllData')
                                                        .toString(),
                                                    state: ToastStates.error,
                                                    context: context);
                                              }
                                            },
                                            text: LanguageCubit.get(context)
                                                .getTexts('Save')
                                                .toString(),
                                            backColor: accentColor,
                                            textColor: white),
                                  ],
                                ),
                              ),
                            ),
                          )),
          );
        },
      ),
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
        print('_imageUserEditProfile***************** =$pickedFile');
        return;
      }
      setState(() {
        _imageUser = File(pickedFile.path);
        userImage = _imageUser!.path.toString();
        imageRemote = false;
        if (kDebugMode) {
          print('_imageUser***************** =${_imageUser!.path}');
        }
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
        if (kDebugMode) {
          print('imageErrorEditProfile***************** =$_pickImageError');
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
          availabilitiesValues = availabilities
              .map((e) => DateFormat('yyyy-MM-dd').format(e).toString())
              .toList();
        });
      }
    });
  }
}

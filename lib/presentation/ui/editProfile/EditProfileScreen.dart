import 'dart:io';

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
import 'package:getn_driver/presentation/ui/editProfile/edit_profile_cubit.dart';
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
  bool imageRemote = false;
  List<DateTime> availabilities = [];
  List<String> availabilitiesValues = [];

  Future selectImageSource(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: imageSource,
        maxWidth: 200.w,
        maxHeight: 200.h,
      );

      setState(() {
        _imageUser = File(pickedFile!.path);
        userImage = _imageUser!.path.toString();
        imageRemote = false;
        if (kDebugMode) {
          print('_imageUser***************** =${_imageUser!.path}');
        }
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
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
            Navigator.pop(context);
          } else if (state is EditProfileErrorState) {
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  'My Account',
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
                          })
                      : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.r, horizontal: 16.r),
                            child: Column(
                              children: [
                                Center(
                                  child: InkWell(
                                    onTap: () async {
                                      selectImageSource(ImageSource.camera);
                                    },
                                    borderRadius: BorderRadius.circular(20.r),
                                    child: _imageUser == null
                                        ? EditProfileCubit.get(context)
                                                    .profileDetails
                                                    ?.image
                                                    ?.src !=
                                                null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                child: Stack(
                                                  children: [
                                                    ImageTools.image(
                                                        fit: BoxFit.fill,
                                                        url: EditProfileCubit
                                                                .get(context)
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
                                                          color: Colors.grey,
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
                                                  children: const [
                                                    Center(
                                                      child: Text(
                                                        'No image',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
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
                                              )
                                        : Stack(
                                            fit: StackFit.loose,
                                            alignment: Alignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
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
                                      'Personal Information',
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
                                        label: "Name",
                                        textSize: 20,
                                        border: false,
                                        borderRadius: 50,
                                        validatorText: nameController.text,
                                        validatorMessage: "Enter Name Please..",
                                        onEditingComplete: () {
                                          FocusScope.of(context).nextFocus();
                                        },
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                      defaultFormField(
                                        controller: emailController,
                                        type: TextInputType.text,
                                        label: "Email",
                                        textSize: 20,
                                        border: false,
                                        borderRadius: 50,
                                        validatorText: emailController.text,
                                        validatorMessage: "Enter Name Please..",
                                        onEditingComplete: () {
                                          FocusScope.of(context).nextFocus();
                                        },
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                      defaultFormField(
                                        controller: whatsAppController,
                                        type: TextInputType.number,
                                        label: "WhatsApp",
                                        textSize: 20,
                                        border: false,
                                        borderRadius: 50,
                                        validatorText: whatsAppController.text,
                                        validatorMessage:
                                            "Enter WhatsApp Please..",
                                        onEditingComplete: () {
                                          FocusScope.of(context).nextFocus();
                                        },
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
                                            label: "Birthday",
                                            textSize: 20,
                                            border: false,
                                            borderRadius: 50,
                                            validatorText:
                                                birthDateController.text,
                                            validatorMessage:
                                                "Enter Birthday Please..",
                                            onEditingComplete: () {
                                              FocusScope.of(context).unfocus();
                                            },
                                          ),
                                        ),
                                        onTap: () async {
                                          final now = DateTime.now();
                                          final pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: now,
                                            firstDate: DateTime(now.year - 100),
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
                                      'Address',
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
                                                'error occurred when get countries',
                                            press: () {
                                              EditProfileCubit.get(context)
                                                  .getCountries();
                                            })
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
                                                          BorderRadius.circular(
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
                                                              .only(end: 18.r),
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
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
                                                        EditProfileCubit.get(
                                                                context)
                                                            .getCity(
                                                                dropDownValueCountries!
                                                                    .id!);
                                                      });
                                                    },
                                                    hint: Container(
                                                      width: 1.sw,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.r,
                                                              vertical: 5.r),
                                                      child: Center(
                                                        child: Text(
                                                            dropDownValueCountries
                                                                    ?.title
                                                                    ?.en! ??
                                                                "Country",
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
                                                    items: EditProfileCubit.get(
                                                            context)
                                                        .countries
                                                        .map((selectedCountry) {
                                                      return DropdownMenuItem<
                                                          Country>(
                                                        value: selectedCountry,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                selectedCountry
                                                                        .title?.en ??
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
                                                                  .grey[400],
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
                                            message:
                                                'error occurred when get Cites',
                                            press: () {
                                              EditProfileCubit.get(context)
                                                  .getCity(
                                                      dropDownValueCountries!
                                                          .id!);
                                            })
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
                                                          BorderRadius.circular(
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
                                                              .only(end: 18.r),
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
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
                                                        EditProfileCubit.get(
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.r,
                                                              vertical: 5.r),
                                                      child: Center(
                                                        child: Text(
                                                            dropDownValueCity
                                                                    ?.title
                                                                    ?.en! ??
                                                                "Country",
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
                                                    items: EditProfileCubit.get(
                                                            context)
                                                        .city
                                                        .map((selectedCountry) {
                                                      return DropdownMenuItem<
                                                          Country>(
                                                        value: selectedCountry,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                selectedCountry
                                                                        .title?.en ??
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
                                                                  .grey[400],
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
                                            message:
                                                'error occurred when get Area',
                                            press: () {
                                              EditProfileCubit.get(context)
                                                  .getArea(
                                                      dropDownValueCountries!
                                                          .id!,
                                                      dropDownValueCity!.id!);
                                            })
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
                                                          BorderRadius.circular(
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
                                                              .only(end: 18.r),
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.r,
                                                              vertical: 5.r),
                                                      child: Center(
                                                        child: Text(
                                                            dropDownValueArea
                                                                    ?.title
                                                                    ?.en! ??
                                                                "Country",
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
                                                    items: EditProfileCubit.get(
                                                            context)
                                                        .area
                                                        .map((selectedCountry) {
                                                      return DropdownMenuItem<
                                                          Country>(
                                                        value: selectedCountry,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                selectedCountry
                                                                        .title?.en ??
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
                                                                  .grey[400],
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
                                    label: "Address",
                                    textSize: 20,
                                    border: false,
                                    borderRadius: 50,
                                    validatorText: addressController.text,
                                    validatorMessage: "Enter Address Please..",
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
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
                                      'Availabilities',
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25.h,
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
                                              dropDownValueCountries != null &&
                                              dropDownValueCity != null &&
                                              dropDownValueArea != null &&
                                              formKeyAddress.currentState!
                                                  .validate() &&
                                              userImage.isNotEmpty &&
                                              availabilities.isNotEmpty) {
                                            String whatsApp = "";
                                            if (whatsAppController.text
                                                    .startsWith('0') &&
                                                whatsAppController.text.length >
                                                    1) {
                                              final splitPhone =
                                                  const TextEditingValue()
                                                      .copyWith(
                                                text: whatsAppController.text
                                                    .replaceAll(
                                                        RegExp(r'^0+(?=.)'),
                                                        ''),
                                                selection: whatsAppController
                                                    .selection
                                                    .copyWith(
                                                  baseOffset: whatsAppController
                                                          .text.length -
                                                      1,
                                                  extentOffset:
                                                      whatsAppController
                                                              .text.length -
                                                          1,
                                                ),
                                              );
                                              whatsApp =
                                                  splitPhone.text.toString();
                                            } else {
                                              whatsApp = whatsAppController.text
                                                  .toString();
                                            }

                                            FocusScopeNode currentFocus =
                                                FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
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
                                                    dropDownValueCountries!.id!,
                                                    dropDownValueCity!.id!,
                                                    dropDownValueArea!.id!,
                                                    userImage,
                                                    availabilitiesValues,
                                                    imageRemote,
                                                    addressController.text
                                                        .toString(),
                                                    whatsApp);
                                          } else {
                                            showToastt(
                                                text:
                                                    'Be sure to choose image and fill personal information ,address and availability',
                                                state: ToastStates.error,
                                                context: context);
                                          }
                                        },
                                        text: "Save",
                                        backColor: accentColor,
                                        textColor: white),
                              ],
                            ),
                          ),
                        ));
        },
      ),
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
          availabilitiesValues = availabilities
              .map((e) => DateFormat('yyyy-MM-dd').format(e).toString())
              .toList();
        });
      }
    });
  }
}

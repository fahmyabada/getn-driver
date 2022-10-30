import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/auth/TermsScreen.dart';
import 'package:getn_driver/presentation/ui/auth/VerifyImageScreen.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  final formKeyAddress = GlobalKey<FormState>();
  bool terms = false;
  File? _imageUser;
  final ImagePicker _picker = ImagePicker();
  String userImage = "";
  dynamic _pickImageError;
  Country? dropDownValueCity;
  Country? dropDownValueArea;
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
      create: (context) => SignCubit()
        ..getRole()
        ..getCity(widget.countryId),
      child: BlocConsumer<SignCubit, SignState>(listener: (context, state) {
        if (state is RoleSuccessState) {
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
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: const Icon(
                Icons.arrow_back,
                size: 0,
                color: black,
              ),
              title: Text(
                "Complete your Registration",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
              child: Column(
                children: [
                  Center(
                    child: InkWell(
                        onTap: () async {
                          selectImageSource(ImageSource.camera);
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
                              )
                            : Container(
                                width: 150.w,
                                height: 150.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20.r),
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
                        'Personal Information',
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
                          label: "Full Name",
                          textSize: 20,
                          border: false,
                          borderRadius: 50,
                          validatorText: fullNameController.text,
                          validatorMessage: "Enter Full Name Please..",
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
                          label: "Email",
                          textSize: 20,
                          border: false,
                          borderRadius: 50,
                          validatorText: emailController.text,
                          validatorMessage: "Enter Email Please..",
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
                          validatorMessage: "Enter WhatsApp Please..",
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
                              validatorText: birthDateController.text,
                              validatorMessage: "Enter Birthday Please..",
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
                        'Address',
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
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                    child: Center(
                        child: Text(
                      widget.countryName!,
                      style: TextStyle(fontSize: 20.sp, color: black),
                    )),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  SignCubit.get(context).loadingCity
                      ? loading()
                      : SignCubit.get(context).failureCity.isNotEmpty
                          ? errorMessage2(
                              message: 'error occurred when get Cites',
                              press: () {
                                SignCubit.get(context)
                                    .getCity(widget.countryId);
                              })
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
                                            horizontal: 10.r, vertical: 5.r),
                                        child: Center(
                                          child: Text(
                                              dropDownValueCity?.title?.en! ??
                                                  "Country",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontSize: 20.sp)),
                                        ),
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
                                                  selectedCountry.title?.en ??
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
                              message: 'error occurred when get Area',
                              press: () {
                                SignCubit.get(context).getArea(
                                    widget.countryId, dropDownValueCity!.id!);
                              })
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
                                            horizontal: 10.r, vertical: 5.r),
                                        child: Center(
                                          child: Text(
                                              dropDownValueArea?.title?.en! ??
                                                  "Country",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontSize: 20.sp)),
                                        ),
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
                                                  selectedCountry.title?.en ??
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
                        "Role",
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
                          Text("i confirm that i have read & agree to the",
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
                                child: Text("Terms & condition ",
                                    style: TextStyle(
                                        fontSize: 17.sp, color: accentColor)),
                              ),
                              Text("and Privacy Policy",
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
                              formKeyAddress.currentState!.validate() &&
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
                                    whatsApp: whatsApp),
                              );
                            } else {
                              showToastt(
                                  text: "check in Terms & condition first..",
                                  state: ToastStates.error,
                                  context: context);
                            }
                          } else {
                            showToastt(
                                text:
                                    'Be sure to choose image and fill personal information ,address and availability',
                                state: ToastStates.error,
                                context: context);
                          }
                        },
                        text: "Next",
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
              availabilities.map((e) => e.toString()).toList();
        });
      }
    });
  }
}

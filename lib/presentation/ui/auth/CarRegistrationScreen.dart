import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';
import 'package:image_picker/image_picker.dart';

class CarRegistrationScreen extends StatefulWidget {
  const CarRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<CarRegistrationScreen> createState() => _CarRegistrationScreenState();
}

class _CarRegistrationScreenState extends State<CarRegistrationScreen> {
  final carModelController = TextEditingController();
  final carNumberController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  Data? dropDownValueCarModel;
  Data? dropDownValueCarCategory;
  Data? dropDownValueColor;
  dynamic _pickImageError;
  File? _imageFrontCar, _imageBackCar;
  final ImagePicker _picker = ImagePicker();
  String frontCarLicenseImage = "";
  String backCarLicenseImage = "";

  Future selectImageSource(ImageSource imageSource, String type) async {
    try {
      // final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      // print('idToken***************** =$idToken');

      final XFile? pickedFile = await _picker.pickImage(
        source: imageSource,
        maxWidth: 200.w,
        maxHeight: 200.h,
      );

      setState(() {
        if (type == "carFront") {
          // for hide image if exist first time
          _imageFrontCar = File(pickedFile!.path);
          frontCarLicenseImage = _imageFrontCar!.path.toString();
          if (kDebugMode) {
            print('_imageFrontCar***************** =${_imageFrontCar!.path}}');
          }
        } else if (type == "carBack") {
          // for hide image if exist first time
          _imageBackCar = File(pickedFile!.path);
          backCarLicenseImage = _imageBackCar!.path.toString();
          if (kDebugMode) {
            print('_imageBackCar***************** =${_imageBackCar!.path}}');
          }
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
        ..getColor()
        ..getCarModel()
        ..getCarCategory(),
      child: BlocConsumer<SignCubit, SignState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "Complete your Car Registration",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      // carModel
                      SignCubit.get(context).carCategoryLoading
                          ? const CircularProgressIndicator(color: black)
                          : Container(
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
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                  isExpanded: true,
                                  iconSize: 40.sp,
                                  icon: Container(
                                    margin:
                                        EdgeInsetsDirectional.only(end: 18.r),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: grey2,
                                      size: 40.sp,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.grey),
                                  onChanged: (Data? value) {
                                    setState(() {
                                      dropDownValueCarCategory = value;
                                    });
                                  },
                                  hint: Container(
                                    width: 1.sw,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.r, vertical: 5.r),
                                    child: Center(
                                      child: Text(
                                          dropDownValueCarCategory
                                                  ?.title?.en! ??
                                              "Car Model",
                                          maxLines: 2,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.black,
                                              fontSize: 20.sp)),
                                    ),
                                  ),
                                  items: SignCubit.get(context)
                                      .carCategory
                                      .map((selectedCountry) {
                                    return DropdownMenuItem<Data>(
                                      value: selectedCountry,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(selectedCountry.title?.en ?? "",
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
                            ),
                      SizedBox(
                        height: 20.h,
                      ),
                      // carModel
                      SignCubit.get(context).carModelLoading
                          ? const CircularProgressIndicator(color: black)
                          : Container(
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
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                  isExpanded: true,
                                  iconSize: 40.sp,
                                  icon: Container(
                                    margin:
                                        EdgeInsetsDirectional.only(end: 18.r),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: grey2,
                                      size: 40.sp,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.grey),
                                  onChanged: (Data? value) {
                                    setState(() {
                                      dropDownValueCarModel = value;
                                    });
                                  },
                                  hint: Container(
                                    width: 1.sw,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.r, vertical: 5.r),
                                    child: Center(
                                      child: Text(
                                          dropDownValueCarModel?.title?.en! ??
                                              "year",
                                          maxLines: 2,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.black,
                                              fontSize: 20.sp)),
                                    ),
                                  ),
                                  items: SignCubit.get(context)
                                      .carModel
                                      .map((selectedCountry) {
                                    return DropdownMenuItem<Data>(
                                      value: selectedCountry,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(selectedCountry.title?.en ?? "",
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
                            ),
                      SizedBox(
                        height: 20.h,
                      ),
                      // carColor
                      SignCubit.get(context).colorsLoading
                          ? const CircularProgressIndicator(color: black)
                          : Container(
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
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                            ),
                            isExpanded: true,
                            iconSize: 40.sp,
                            icon: Container(
                              margin:
                              EdgeInsetsDirectional.only(end: 18.r),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: grey2,
                                size: 40.sp,
                              ),
                            ),
                            style: const TextStyle(color: Colors.grey),
                            onChanged: (Data? value) {
                              setState(() {
                                dropDownValueColor = value;
                              });
                            },
                            hint: Container(
                              width: 1.sw,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.r, vertical: 5.r),
                              child: Center(
                                child: Text(
                                    dropDownValueColor?.title?.en! ??
                                        "Color",
                                    maxLines: 2,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                        fontSize: 20.sp)),
                              ),
                            ),
                            items: SignCubit.get(context)
                                .colors
                                .map((selectedCountry) {
                              return DropdownMenuItem<Data>(
                                value: selectedCountry,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(selectedCountry.title?.en ?? "",
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
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            defaultFormField(
                              controller: carNumberController,
                              type: TextInputType.text,
                              label: "Car Number",
                              textSize: 20,
                              border: false,
                              borderRadius: 50,
                              validatorText: carNumberController.text,
                              validatorMessage: "Enter Car Number Please..",
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            defaultFormField(
                              controller: cityController,
                              type: TextInputType.text,
                              label: "City",
                              textSize: 20,
                              border: false,
                              borderRadius: 50,
                              validatorText: cityController.text,
                              validatorMessage: "Enter City Please..",
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            defaultFormField(
                              controller: areaController,
                              type: TextInputType.text,
                              label: "Area",
                              textSize: 20,
                              border: false,
                              borderRadius: 50,
                              validatorText: areaController.text,
                              validatorMessage: "Enter Area Please..",
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            defaultFormField(
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "Front Car License Image ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      InkWell(
                        child: Container(
                          height: 250.h,
                          width: 300.w,
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: frontCarLicenseImage.isNotEmpty
                              ? SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.r),
                                    child: Image.file(
                                      _imageFrontCar!,
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
                          selectImageSource(ImageSource.camera, "carFront");
                        },
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "Back Car License Image ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      InkWell(
                        child: Container(
                          height: 250.h,
                          width: 300.w,
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: backCarLicenseImage.isNotEmpty
                              ? SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.r),
                                    child: Image.file(
                                      _imageBackCar!,
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
                          selectImageSource(ImageSource.camera, "carBack");
                        },
                      ),
                      SizedBox(
                        height: 20.h,
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
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/RequestTabsScreen.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarRegistrationScreen extends StatefulWidget {
  const CarRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<CarRegistrationScreen> createState() => _CarRegistrationScreenState();
}

class _CarRegistrationScreenState extends State<CarRegistrationScreen> {
  final carModelController = TextEditingController();
  final carNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Data? dropDownValueCarModel;
  Data? dropDownValueCarSubCategory;
  Data? dropDownValueColor;
  dynamic _pickImageError;
  File? _imageFrontCar, _imageBackCar;
  final ImagePicker _picker = ImagePicker();
  String frontCarLicenseImage = "";
  String backCarLicenseImage = "";
  List<File> listGallery = [File("")];
  List<MultipartFile> listGalleryValue = [];
  bool carLoading = false;

  Future selectImageSource(ImageSource imageSource, String type) async {
    try {
      // final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      // print('idToken***************** =$idToken');

      final XFile? pickedFile = await _picker.pickImage(
        source: imageSource,
        maxWidth: 200.w,
        maxHeight: 200.h,
      );

      setState(() async {
        if (type == "carFront") {
          _imageFrontCar = File(pickedFile!.path);
          frontCarLicenseImage = _imageFrontCar!.path.toString();
          if (kDebugMode) {
            print('_imageFrontCar***************** =${_imageFrontCar!.path}');
          }
        } else if (type == "carBack") {
          _imageBackCar = File(pickedFile!.path);
          backCarLicenseImage = _imageBackCar!.path.toString();
          if (kDebugMode) {
            print('_imageBackCar***************** =${_imageBackCar!.path}');
          }
        } else if (type == "galley") {
          listGallery.insert(listGallery.length - 1, File(pickedFile!.path));
          final data = await MultipartFile.fromFile(
              File(pickedFile.path).path.toString(),
              filename: File(pickedFile.path).path.toString(),
              contentType: MediaType("image", "jpeg"));
          listGalleryValue.add(data);
          // listGalleryValue.add(File(pickedFile.path).path.toString());
          // if (kDebugMode) {
          //   print('pickedFile***************** =${_imageBackCar!.path}');
          // }
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
        ..getCarSubCategory(),
      child: BlocConsumer<SignCubit, SignState>(
        listener: (context, state) {
          if (state is CarCreateSuccessState) {
            if (kDebugMode) {
              print('*******CarCreateSuccessState');
            }
            setState(() {
              carLoading = false;
            });
            if (state.data!.carModel != null && state.data!.carNumber != null) {
              getIt<SharedPreferences>()
                  .setString('typeSign', "signWithCarRegistration");

              showToastt(
                  text: "login successfully",
                  state: ToastStates.success,
                  context: context);

              navigateAndFinish(context, const RequestTabsScreen());
            }
          } else if (state is CarCreateErrorState) {
            setState(() {
              carLoading = false;
            });
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
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
                      SignCubit.get(context).carSubCategoryLoading
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
                                      dropDownValueCarSubCategory = value;
                                    });
                                  },
                                  hint: Container(
                                    width: 1.sw,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.r, vertical: 5.r),
                                    child: Center(
                                      child: Text(
                                          dropDownValueCarSubCategory
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
                                      .carSubCategory
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
                                FocusScope.of(context).nextFocus();
                              },
                            ),
                            SizedBox(
                              height: 20.h,
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
                      Text(
                        'Gallery',
                        style: TextStyle(
                            fontSize: 24.sp,
                            color: black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listGallery.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150.sp,
                            crossAxisSpacing: 20.w,
                            mainAxisSpacing: 20.h),
                        itemBuilder: (context, i) {
                          if (i == listGallery.length - 1) {
                            return Padding(
                              padding: EdgeInsets.all(20.r),
                              child: CircleAvatar(
                                backgroundColor: accentColor,
                                child: IconButton(
                                  icon: Icon(Icons.add,
                                      size: 35.sp, color: white),
                                  onPressed: () {
                                    selectImageSource(
                                        ImageSource.camera, "galley");
                                  },
                                ),
                              ),
                            );
                          } else {
                            return Stack(
                              children: [
                                Container(
                                  height: 200.h,
                                  width: 250.w,
                                  decoration: BoxDecoration(
                                    color: white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(25.r),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: SizedBox(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.r),
                                      child: Image.file(
                                        listGallery[i],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: CircleAvatar(
                                    backgroundColor: accentColor,
                                    child: IconButton(
                                      icon: Icon(Icons.close,
                                          size: 25.sp, color: white),
                                      onPressed: () {
                                        setState(() {
                                          listGallery.removeAt(i);
                                          listGalleryValue.removeAt(i);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      carLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: black,
                              ),
                            )
                          : defaultButton3(
                              press: () async {
                                print(
                                    "CarModel*****************${dropDownValueCarSubCategory?.title!.en} ++ ${dropDownValueCarSubCategory?.id!}");
                                print(
                                    "CarModelYear*****************${dropDownValueCarModel?.title!.en} ++ ${dropDownValueCarModel?.id!}");
                                print(
                                    "color*****************${dropDownValueColor?.title!.en} ++ ${dropDownValueColor?.id!}");
                                print(
                                    "CarNum*****************${carNumberController.text}");
                                print(
                                    "fontCar*****************$frontCarLicenseImage");
                                print(
                                    "backCar*****************$backCarLicenseImage");
                                print(
                                    "gallery*****************${listGalleryValue.toString()}");
                                if (dropDownValueCarSubCategory != null &&
                                    dropDownValueCarModel != null &&
                                    dropDownValueColor != null &&
                                    formKey.currentState!.validate() &&
                                    frontCarLicenseImage.isNotEmpty &&
                                    backCarLicenseImage.isNotEmpty ) {
                                  setState(() {
                                    carLoading = true;
                                  });
                                  var formData;
                                  if(listGalleryValue.isNotEmpty){
                                    formData = FormData.fromMap({
                                      'carModel':
                                      dropDownValueCarSubCategory?.id!,
                                      'carModelYear': dropDownValueCarModel?.id!,
                                      'carColor': dropDownValueColor?.id!,
                                      'carNumber':
                                      carNumberController.text.toString(),
                                      'gallery': listGalleryValue,
                                      'frontCarLicenseImage':
                                      await MultipartFile.fromFile(
                                          frontCarLicenseImage,
                                          filename: frontCarLicenseImage,
                                          contentType:
                                          MediaType("image", "jpeg")),
                                      'backCarLicenseImage':
                                      await MultipartFile.fromFile(
                                          backCarLicenseImage,
                                          filename: backCarLicenseImage,
                                          contentType:
                                          MediaType("image", "jpeg")),
                                    });
                                  }else{
                                    formData = FormData.fromMap({
                                      'carModel':
                                      dropDownValueCarSubCategory?.id!,
                                      'carModelYear': dropDownValueCarModel?.id!,
                                      'carColor': dropDownValueColor?.id!,
                                      'carNumber':
                                      carNumberController.text.toString(),
                                      'frontCarLicenseImage':
                                      await MultipartFile.fromFile(
                                          frontCarLicenseImage,
                                          filename: frontCarLicenseImage,
                                          contentType:
                                          MediaType("image", "jpeg")),
                                      'backCarLicenseImage':
                                      await MultipartFile.fromFile(
                                          backCarLicenseImage,
                                          filename: backCarLicenseImage,
                                          contentType:
                                          MediaType("image", "jpeg")),
                                    });
                                  }
                                  SignCubit.get(context).carCreate(formData);
                                } else {
                                  showToastt(
                                      text: "please fill all data first...",
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
              ),
            ),
          );
        },
      ),
    );
  }
}

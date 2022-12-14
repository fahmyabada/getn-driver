import 'dart:io';
import 'dart:ui' as ui;

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
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
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
  File? _imageFrontCar, _imageBackCar, _imageCarMain;
  final ImagePicker _picker = ImagePicker();
  String frontCarLicenseImage = "";
  String carMain = "";
  String backCarLicenseImage = "";
  List<File> listGallery = [File("")];
  List<MultipartFile> listGalleryValue = [];
  bool carLoading = false;

  Future selectImageSource(ImageSource imageSource, String type) async {
    try {
      // final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      // print('idToken***************** =$idToken');

      final XFile? pickedFile = await _picker.pickImage(source: imageSource);
      if (pickedFile == null) {
        print('_imageUserCarRegisteration***************** =$pickedFile');
        return;
      }

      if (type == "carFront") {
        setState(() {
          _imageFrontCar = File(pickedFile.path);
          frontCarLicenseImage = _imageFrontCar!.path.toString();
          if (kDebugMode) {
            print('_imageFrontCar***************** =${_imageFrontCar!.path}');
          }
        });
      } else if (type == "carBack") {
        setState(() {
          _imageBackCar = File(pickedFile.path);
          backCarLicenseImage = _imageBackCar!.path.toString();
          if (kDebugMode) {
            print('_imageBackCar***************** =${_imageBackCar!.path}');
          }
        });
      } else if (type == "carMain") {
        setState(() {
          _imageCarMain = File(pickedFile.path);
          carMain = _imageCarMain!.path.toString();
          if (kDebugMode) {
            print('_imageCarMain***************** =${_imageCarMain!.path}');
          }
        });
      } else if (type == "galley") {
        final data = await MultipartFile.fromFile(
            File(pickedFile.path).path.toString(),
            filename: File(pickedFile.path).path.toString(),
            contentType: MediaType("image", "jpeg"));
        setState(() {
          listGallery.insert(listGallery.length - 1, File(pickedFile.path));
          listGalleryValue.add(data);
        });
        // listGalleryValue.add(File(pickedFile.path).path.toString());
        // if (kDebugMode) {
        //   print('pickedFile***************** =${_imageBackCar!.path}');
        // }
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
        if (kDebugMode) {
          print(
              'imageErrorCarRegisteration***************** =$_pickImageError');
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
                  text: LanguageCubit.get(context)
                      .getTexts('LoginSuccessfully')
                      .toString(),
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
          return Directionality(
            textDirection: LanguageCubit.get(context).isEn
                ? ui.TextDirection.ltr
                : ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  LanguageCubit.get(context)
                      .getTexts('CarRegistration')
                      .toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                centerTitle: true,
              ),
              body: RefreshIndicator(
                onRefresh: () => Future.delayed(const Duration(seconds: 2), () {
                  SignCubit.get(context).getCarModel();
                  SignCubit.get(context).getColor();
                  SignCubit.get(context).getCarSubCategory();
                }),
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: 30.h,
                        // ),
                        // Text(
                        //   "Complete your Car Registration",
                        //   textAlign: TextAlign.start,
                        //   style: TextStyle(
                        //       fontSize: 25.sp,
                        //       fontWeight: FontWeight.bold,
                        //       color: primaryColor),
                        // ),
                        // SizedBox(
                        //   height: 50.h,
                        // ),
                        // carModel
                        SignCubit.get(context).carSubCategoryLoading
                            ? loading()
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
                                          horizontal: 25.r),
                                      child: Text(
                                          LanguageCubit.get(context).isEn
                                              ? dropDownValueCarSubCategory
                                                      ?.title?.en! ??
                                                  "Car Model"
                                              : dropDownValueCarSubCategory
                                                      ?.title?.ar! ??
                                                  "?????? ??????????????",
                                          maxLines: 2,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.black,
                                              fontSize: 20.sp)),
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
                                            Text(
                                                LanguageCubit.get(context).isEn
                                                    ? selectedCountry
                                                            .title?.en ??
                                                        ""
                                                    : selectedCountry
                                                            .title?.ar ??
                                                        "",
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style:
                                                    TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                            ? loading()
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
                                          horizontal: 25.r),
                                      child: Text(
                                          LanguageCubit.get(context).isEn
                                              ? dropDownValueCarModel
                                                      ?.title?.en! ??
                                                  "year"
                                              : dropDownValueCarModel
                                                      ?.title?.ar! ??
                                                  "??????",
                                          maxLines: 2,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.black,
                                              fontSize: 20.sp)),
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
                                            Text(
                                                LanguageCubit.get(context).isEn
                                                    ? selectedCountry
                                                            .title?.en ??
                                                        ""
                                                    : selectedCountry
                                                            .title?.ar ??
                                                        "",
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style:
                                                    TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                            ? loading()
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
                                          horizontal: 25.r),
                                      child: Text(
                                          LanguageCubit.get(context).isEn
                                              ? dropDownValueColor
                                                      ?.title?.en! ??
                                                  "Color"
                                              : dropDownValueColor
                                                      ?.title?.ar! ??
                                                  "??????????",
                                          maxLines: 2,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.black,
                                              fontSize: 20.sp)),
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
                                            Text(
                                                LanguageCubit.get(context).isEn
                                                    ? selectedCountry
                                                            .title?.en ??
                                                        ""
                                                    : selectedCountry
                                                            .title?.ar ??
                                                        "",
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style:
                                                    TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                label: LanguageCubit.get(context)
                                    .getTexts('CarNumber')
                                    .toString(),
                                textSize: 20,
                                border: false,
                                borderRadius: 50,
                                validatorText: carNumberController.text,
                                validatorMessage: LanguageCubit.get(context)
                                    .getTexts('EnterCarNumber')
                                    .toString(),
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
                          LanguageCubit.get(context)
                              .getTexts('CarMain')
                              .toString(),
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
                            child: carMain.isNotEmpty
                                ? SizedBox(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.r),
                                      child: Image.file(
                                        _imageCarMain!,
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
                            selectImageSource(ImageSource.camera, "carMain");
                          },
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('FrontCarLicenseImage')
                              .toString(),
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
                          LanguageCubit.get(context)
                              .getTexts('BackCarLicenseImage')
                              .toString(),
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
                          LanguageCubit.get(context)
                              .getTexts('Gallery')
                              .toString(),
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
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
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
                                        borderRadius:
                                            BorderRadius.circular(25.r),
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
                            ? loading()
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
                                      backCarLicenseImage.isNotEmpty) {
                                    setState(() {
                                      carLoading = true;
                                    });
                                    var formData;
                                    if (listGalleryValue.isNotEmpty) {
                                      formData = FormData.fromMap({
                                        'carModel':
                                            dropDownValueCarSubCategory?.id!,
                                        'carModelYear':
                                            dropDownValueCarModel?.id!,
                                        'carColor': dropDownValueColor?.id!,
                                        'carNumber':
                                            carNumberController.text.toString(),
                                        'gallery': listGalleryValue,
                                        'image': await MultipartFile.fromFile(
                                            carMain,
                                            filename: carMain,
                                            contentType:
                                                MediaType("image", "jpeg")),
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
                                    } else {
                                      formData = FormData.fromMap({
                                        'carModel':
                                            dropDownValueCarSubCategory?.id!,
                                        'carModelYear':
                                            dropDownValueCarModel?.id!,
                                        'carColor': dropDownValueColor?.id!,
                                        'carNumber':
                                            carNumberController.text.toString(),
                                        'image': await MultipartFile.fromFile(
                                            carMain,
                                            filename: carMain,
                                            contentType:
                                            MediaType("image", "jpeg")),
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
                                        text: LanguageCubit.get(context)
                                            .getTexts('pleaseFillAllData')
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
              ),
            ),
          );
        },
      ),
    );
  }
}

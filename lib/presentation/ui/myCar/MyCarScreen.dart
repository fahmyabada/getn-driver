import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart';
import 'package:getn_driver/data/model/carModel/FrontCarLicenseImage.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/auth/CarRegistrationScreen.dart';
import 'package:getn_driver/presentation/ui/myCar/my_car_screen_cubit.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:getn_driver/data/model/carModel/BackCarLicenseImage.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({Key? key}) : super(key: key);

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> {
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
  String carModelYear = "";
  List<String> listGallery = [""];
  List listGalleryFromServer = [];
  List<MultipartFile> listGalleryValue = [];
  bool editCarLoading = false;
  String id = "";
  FrontCarLicenseImage? frontCarLicenseImageFromServer;
  BackCarLicenseImage?  backCarLicenseImageFromServer;

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

        } else if (type == "galley") {
          final data = await MultipartFile.fromFile(
              File(pickedFile.path).path.toString(),
              filename: File(pickedFile.path).path.toString(),
              contentType: MediaType("image", "jpeg"));
          print('listGallery***************** =${pickedFile.path}');
          setState(() {
            listGallery.insert(listGallery.length - 1, pickedFile.path);
            listGalleryValue.add(data);
            // listGalleryFromServer.add(data);
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
                title: "Take Image",
                description:
                    'Camera permissions denied\n You must enable the access camera to take photo \n you can choose setting and enable camera then try back',
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyCarScreenCubit()
        ..getCar()
        ..getColor()
        ..getCarSubCategory(),
      child: BlocConsumer<MyCarScreenCubit, MyCarScreenState>(
        listener: (context, state) async{
          if (state is CarSuccessState) {

            // if(state.data!.gallery!.isNotEmpty){
            //   for (var i = 0; i < state.data!.gallery!.length; i++) {
            //     listGallery.insert(listGallery.length - 1, state.data!.gallery![i].src!);
            //     listGalleryFromServer.add(state.data!.gallery![i]);
            //   }
            // }
            setState(() {
              MyCarScreenCubit.get(context).getCarModel();
              id = state.data!.id!;
              dropDownValueColor = state.data!.carColor!;
              dropDownValueCarSubCategory = state.data!.carModel!;
              carModelYear = state.data!.carModelYear!;
              carNumberController.text = state.data!.carNumber!;
              if (state.data!.frontCarLicenseImage != null) {
                frontCarLicenseImage = state.data!.frontCarLicenseImage!.src!;
                frontCarLicenseImageFromServer = state.data!.frontCarLicenseImage!;
              }
              if (state.data!.backCarLicenseImage != null) {
                backCarLicenseImage = state.data!.backCarLicenseImage!.src!;
                backCarLicenseImageFromServer = state.data!.backCarLicenseImage!;
              }
            });
          } else if (state is CarErrorState) {
            setState(() {
              MyCarScreenCubit.get(context).carLoading = false;
            });

            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          } else if (state is CarModelSuccessState) {
            if (state.data!.isNotEmpty && carModelYear.isNotEmpty) {
              setState(() {
                dropDownValueCarModel = state.data!
                    .where((element) => element.id == carModelYear)
                    .first;
              });
            }
            MyCarScreenCubit.get(context).carLoading = false;
          }else if (state is CarEditSuccessState) {
            if (kDebugMode) {
              print('*******CarEditSuccessState');
            }
            setState(() {
              editCarLoading = false;
            });
          }else if (state is CarEditErrorState) {
            setState(() {
              editCarLoading = false;
            });
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
                "My Car",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              centerTitle: true,
            ),
            body: MyCarScreenCubit.get(context).carLoading
                ? loading()
                : MyCarScreenCubit.get(context).car!.id!.isEmpty
                    ? defaultButton3(
                        press: () {
                          navigateTo(context, const CarRegistrationScreen());
                        },
                        text: "Add Car",
                        backColor: accentColor,
                        textColor: white)
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.r, vertical: 30.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              // carModel
                              MyCarScreenCubit.get(context)
                                      .carSubCategoryLoading
                                  ? loading()
                                  : Container(
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.r),
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
                                          style: const TextStyle(
                                              color: Colors.grey),
                                          onChanged: (Data? value) {
                                            setState(() {
                                              dropDownValueCarSubCategory =
                                                  value;
                                            });
                                          },
                                          hint: Container(
                                            width: 1.sw,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.r,
                                                vertical: 5.r),
                                            child: Center(
                                              child: Text(
                                                  dropDownValueCarSubCategory
                                                          ?.title?.en! ??
                                                      "Car Model",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                      fontSize: 20.sp)),
                                            ),
                                          ),
                                          items: MyCarScreenCubit.get(context)
                                              .carSubCategory
                                              .map((selectedCountry) {
                                            return DropdownMenuItem<Data>(
                                              value: selectedCountry,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      selectedCountry
                                                              .title?.en ??
                                                          "",
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      style: TextStyle(
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
                              MyCarScreenCubit.get(context).carModelLoading
                                  ? loading()
                                  : Container(
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.r),
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
                                          style: const TextStyle(
                                              color: Colors.grey),
                                          onChanged: (Data? value) {
                                            setState(() {
                                              dropDownValueCarModel = value;
                                            });
                                          },
                                          hint: Container(
                                            width: 1.sw,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.r,
                                                vertical: 5.r),
                                            child: Center(
                                              child: Text(
                                                  dropDownValueCarModel
                                                          ?.title?.en! ??
                                                      "year",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                      fontSize: 20.sp)),
                                            ),
                                          ),
                                          items: MyCarScreenCubit.get(context)
                                              .carModel
                                              .map((selectedCountry) {
                                            return DropdownMenuItem<Data>(
                                              value: selectedCountry,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      selectedCountry
                                                              .title?.en ??
                                                          "",
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      style: TextStyle(
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
                              MyCarScreenCubit.get(context).colorsLoading
                                  ? loading()
                                  : Container(
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.r),
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
                                          style: const TextStyle(
                                              color: Colors.grey),
                                          onChanged: (Data? value) {
                                            setState(() {
                                              dropDownValueColor = value;
                                            });
                                          },
                                          hint: Container(
                                            width: 1.sw,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.r,
                                                vertical: 5.r),
                                            child: Center(
                                              child: Text(
                                                  dropDownValueColor
                                                          ?.title?.en! ??
                                                      "Color",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                      fontSize: 20.sp)),
                                            ),
                                          ),
                                          items: MyCarScreenCubit.get(context)
                                              .colors
                                              .map((selectedCountry) {
                                            return DropdownMenuItem<Data>(
                                              value: selectedCountry,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      selectedCountry
                                                              .title?.en ??
                                                          "",
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      style: TextStyle(
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
                                      label: "Car Number",
                                      textSize: 20,
                                      border: false,
                                      borderRadius: 50,
                                      validatorText: carNumberController.text,
                                      validatorMessage:
                                          "Enter Car Number Please..",
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
                                  child: _imageFrontCar == null
                                      ? MyCarScreenCubit.get(context)
                                                  .car!
                                                  .frontCarLicenseImage!
                                                  .src !=
                                              null
                                          ? SizedBox(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.r),
                                                child: ImageTools.image(
                                                  fit: BoxFit.fill,
                                                  url: MyCarScreenCubit.get(
                                                          context)
                                                      .car
                                                      ?.frontCarLicenseImage
                                                      ?.src,
                                                ),
                                              ),
                                            )
                                          : Icon(
                                              Icons.person_pin_outlined,
                                              color: Colors.black87,
                                              size: 115.sp,
                                            )
                                      : SizedBox(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25.r),
                                            child: Image.file(
                                              _imageFrontCar!,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                ),
                                onTap: () {
                                  selectImageSource(
                                      ImageSource.camera, "carFront");
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
                                    child: _imageBackCar == null
                                        ? MyCarScreenCubit.get(context)
                                                    .car!
                                                    .backCarLicenseImage!
                                                    .src !=
                                                null
                                            ? SizedBox(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.r),
                                                  child: ImageTools.image(
                                                    fit: BoxFit.fill,
                                                    url: MyCarScreenCubit.get(
                                                            context)
                                                        .car
                                                        ?.backCarLicenseImage
                                                        ?.src,
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                Icons.person_pin_outlined,
                                                color: Colors.black87,
                                                size: 115.sp,
                                              )
                                        : SizedBox(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25.r),
                                              child: Image.file(
                                                _imageBackCar!,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )),
                                onTap: () {
                                  selectImageSource(
                                      ImageSource.camera, "carBack");
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
                                            borderRadius:
                                                BorderRadius.circular(25.r),
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                          child: SizedBox(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25.r),
                                              child: ImageTools.image(
                                                url: listGallery[i],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional.bottomEnd,
                                          child: CircleAvatar(
                                            backgroundColor: accentColor,
                                            child: IconButton(
                                              icon: Icon(Icons.close,
                                                  size: 25.sp, color: white),
                                              onPressed: () {
                                                setState(() {
                                                  listGallery.removeAt(i);
                                                  listGalleryValue.removeAt(i);
                                                  // listGalleryFromServer.removeAt(i);
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
                              editCarLoading
                                  ? loading()
                                  : defaultButton3(
                                      press: () async {
                                        print(
                                            "id*****************$id ");
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
                                            "listGalleryValue*****************$listGalleryValue");

                                        // print(
                                        //     "gallery*****************${[...listGalleryValue,jsonEncode(listGalleryFromServer)]}");
                                        if (dropDownValueCarSubCategory !=
                                                null &&
                                            dropDownValueCarModel != null &&
                                            dropDownValueColor != null &&
                                            formKey.currentState!.validate() &&
                                            frontCarLicenseImage.isNotEmpty &&
                                            backCarLicenseImage.isNotEmpty) {
                                          setState(() {
                                            editCarLoading = true;
                                          });
                                          var formData;
                                          if (listGalleryValue.isNotEmpty) {
                                            // print(
                                            //     "listGallery*****************${listGalleryFromServer.toString()}");
                                            formData = FormData.fromMap({
                                              'carModel':
                                                  dropDownValueCarSubCategory
                                                      ?.id!,
                                              'carModelYear':
                                                  dropDownValueCarModel?.id!,
                                              'carColor':
                                                  dropDownValueColor?.id!,
                                              'carNumber': carNumberController
                                                  .text
                                                  .toString(),
                                              'gallery': listGalleryValue,
                                              'frontCarLicenseImage':
                                                  _imageFrontCar == null
                                                      ? jsonEncode(
                                                          frontCarLicenseImageFromServer)
                                                      : await MultipartFile.fromFile(
                                                          frontCarLicenseImage,
                                                          filename:
                                                              frontCarLicenseImage,
                                                          contentType:
                                                              MediaType("image",
                                                                  "jpeg")),
                                              'backCarLicenseImage': _imageBackCar ==
                                                      null
                                                  ? jsonEncode(
                                                      backCarLicenseImageFromServer)
                                                  : await MultipartFile.fromFile(
                                                      backCarLicenseImage,
                                                      filename:
                                                          backCarLicenseImage,
                                                      contentType: MediaType(
                                                          "image", "jpeg")),
                                            });
                                          } else {
                                            formData = FormData.fromMap({
                                              'carModel':
                                                  dropDownValueCarSubCategory
                                                      ?.id!,
                                              'carModelYear':
                                                  dropDownValueCarModel?.id!,
                                              'carColor':
                                                  dropDownValueColor?.id!,
                                              'carNumber': carNumberController
                                                  .text
                                                  .toString(),
                                              'frontCarLicenseImage':
                                                  _imageFrontCar == null
                                                      ? jsonEncode(
                                                          frontCarLicenseImageFromServer)
                                                      : await MultipartFile.fromFile(
                                                          frontCarLicenseImage,
                                                          filename:
                                                              frontCarLicenseImage,
                                                          contentType:
                                                              MediaType("image",
                                                                  "jpeg")),
                                              'backCarLicenseImage': _imageBackCar ==
                                                      null
                                                  ? jsonEncode(
                                                      backCarLicenseImageFromServer)
                                                  : await MultipartFile.fromFile(
                                                      backCarLicenseImage,
                                                      filename:
                                                          backCarLicenseImage,
                                                      contentType: MediaType(
                                                          "image", "jpeg")),
                                            });
                                          }
                                          MyCarScreenCubit.get(context).carEdit(formData,id);
                                        } else {
                                          showToastt(
                                              text:
                                                  "please fill all data first...",
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
          );
        },
      ),
    );
  }
}

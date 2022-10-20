// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:getn_driver/data/utils/colors.dart';
// import 'package:getn_driver/data/utils/image_tools.dart';
// import 'package:getn_driver/data/utils/widgets.dart';
// import 'package:getn_driver/presentation/ui/editProfile/edit_profile_cubit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
//
// class MyAccountScreen extends StatefulWidget {
//   const MyAccountScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MyAccountScreen> createState() => _MyAccountScreenState();
// }
//
// class _MyAccountScreenState extends State<MyAccountScreen> {
//   final formKey = GlobalKey<FormState>();
//
//   dynamic _pickImageError;
//
//   File? _imageFrontCar, _imageBackCar, _imageUser;
//
//   final ImagePicker _picker = ImagePicker();
//
//   String frontCarLicenseImage = "";
//
//   String backCarLicenseImage = "";
//
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final birthDateController = TextEditingController();
//
//
//   Future selectImageSource(ImageSource imageSource, String type) async {
//     try {
//       // final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
//       // print('idToken***************** =$idToken');
//
//       final XFile? pickedFile = await _picker.pickImage(
//         source: imageSource,
//         maxWidth: 200.w,
//         maxHeight: 200.h,
//       );
//
//       setState(() {
//         if (type == "carFront") {
//           _imageFrontCar = File(pickedFile!.path);
//           frontCarLicenseImage = _imageFrontCar!.path.toString();
//           if (kDebugMode) {
//             print('_imageFrontCar***************** =${_imageFrontCar!.path}');
//           }
//         } else if (type == "carBack") {
//           _imageBackCar = File(pickedFile!.path);
//           backCarLicenseImage = _imageBackCar!.path.toString();
//           if (kDebugMode) {
//             print('_imageBackCar***************** =${_imageBackCar!.path}');
//           }
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _pickImageError = e;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => EditProfileCubit()..getProfileDetails(),
//       child: BlocConsumer<EditProfileCubit, EditProfileState>(
//         listener: (context, state) {
//           // TODO: implement listener
//         },
//         builder: (context, state) {
//           return Scaffold(
//               appBar: AppBar(
//                 title: Text(
//                   'My Account',
//                   style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 centerTitle: true,
//               ),
//               body: state is EditProfileLoading
//                   ? const Center(
//                       child: CircularProgressIndicator(
//                       color: black,
//                     ))
//                   : state is EditProfileErrorState
//                       ? Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text(
//                                   'Something went wrong, please try again'),
//                               TextButton(
//                                 style: ElevatedButton.styleFrom(
//                                   foregroundColor: accentColor,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16.r),
//                                   ),
//                                 ),
//                                 onPressed: () {},
//                                 child: const Text('Retry'),
//                               )
//                             ],
//                           ),
//                         )
//                       : SingleChildScrollView(
//                           child: Form(
//                             key: formKey,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8.0, horizontal: 16),
//                               child: Column(
//                                 children: [
//                                   Center(
//                                     child: InkWell(
//                                       onTap: () async {
//                                         // await controller.captureImage(
//                                         //   ImageSource.gallery,
//                                         // );
//                                       },
//                                       borderRadius: BorderRadius.circular(20),
//                                       child: _imageUser == null
//                                           ? EditProfileCubit.get(context)
//                                                       .profileDetails
//                                                       ?.image
//                                                       ?.src !=
//                                                   null
//                                               ? ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(20),
//                                                   child: Stack(
//                                                     children: [
//                                                       ImageTools.image(
//                                                           fit: BoxFit.fill,
//                                                           url: EditProfileCubit
//                                                                   .get(context)
//                                                               .profileDetails
//                                                               ?.image
//                                                               ?.src,
//                                                           height: 70.w,
//                                                           width: 70.w),
//                                                       const Positioned(
//                                                         bottom: 10,
//                                                         right: 10,
//                                                         child: Center(
//                                                           child: Icon(
//                                                             Icons.camera_alt,
//                                                             color: Colors.grey,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//                                               : Container(
//                                                   width: 1.sw / 3,
//                                                   height: 1.sw / 3,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.grey,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20),
//                                                   ),
//                                                   child: Stack(
//                                                     children: const [
//                                                       Center(
//                                                         child: Text(
//                                                           'No image',
//                                                           style: TextStyle(
//                                                             color: Colors.white,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Positioned(
//                                                         bottom: 10,
//                                                         right: 10,
//                                                         child: Center(
//                                                           child: Icon(
//                                                             Icons.camera_alt,
//                                                             color:
//                                                                 Colors.white70,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//                                           : Stack(
//                                               fit: StackFit.loose,
//                                               alignment: Alignment.center,
//                                               children: [
//                                                 ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(20),
//                                                   child: Image.file(
//                                                     _imageUser!,
//                                                     width: 1.sw / 3,
//                                                     height: 1.sw / 3,
//                                                     fit: BoxFit.fill,
//                                                   ),
//                                                 ),
//                                                 const Positioned(
//                                                   bottom: 10,
//                                                   right: 10,
//                                                   child: Center(
//                                                     child: Icon(
//                                                       Icons.camera_alt,
//                                                       color: Colors.white70,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 32,
//                                   ),
//                                   const ListTile(
//                                     title: Text('Personal Information'),
//                                     leading: Icon(Icons.person),
//                                     contentPadding: EdgeInsets.all(0),
//                                   ),
//                                   defaultFormField(
//                                     controller: nameController,
//                                     type: TextInputType.text,
//                                     label: "Name",
//                                     textSize: 20,
//                                     border: false,
//                                     borderRadius: 50,
//                                     validatorText: nameController.text,
//                                     validatorMessage: "Enter Name Please..",
//                                     onEditingComplete: () {
//                                       FocusScope.of(context).unfocus();
//                                     },
//                                   ),
//
//                                   SizedBox(
//                                     height: 16.h,
//                                   ),
//                                   defaultFormField(
//                                     controller: emailController,
//                                     type: TextInputType.text,
//                                     label: "Email",
//                                     textSize: 20,
//                                     border: false,
//                                     borderRadius: 50,
//                                     validatorText: emailController.text,
//                                     validatorMessage: "Enter Name Please..",
//                                     onEditingComplete: () {
//                                       FocusScope.of(context).unfocus();
//                                     },
//                                   ),
//                                   SizedBox(
//                                     height: 16.h,
//                                   ),
//                                   InkWell(
//                                     child: IgnorePointer(
//                                       ignoring: true,
//                                       child: defaultFormField(
//                                         controller: birthDateController,
//                                         type: TextInputType.text,
//                                         label: "Birthday",
//                                         textSize: 20,
//                                         border: false,
//                                         borderRadius: 50,
//                                         validatorText: birthDateController.text,
//                                         validatorMessage: "Enter Name Please..",
//                                         onEditingComplete: () {
//                                           FocusScope.of(context).unfocus();
//                                         },
//                                       ),
//                                     ),
//                                     onTap: () async {
//                                       final now = DateTime.now();
//                                       final pickedDate = await showDatePicker(
//                                         context: context,
//                                         initialDate: now,
//                                         firstDate: DateTime(now.year - 100),
//                                         lastDate: now,
//                                       );
//
//                                       if (pickedDate != null) {
//                                         birthDateController.text =
//                                             DateFormat(
//                                                 "yyyy-MM-dd").format(pickedDate);
//                                       }
//                                     },
//                                   ),
//
//                                   SizedBox(
//                                     height: 16.h,
//                                   ),
//                                   const Divider(),
//                                   const ListTile(
//                                     title: Text('Address'),
//                                     leading: Icon(Icons.location_on_outlined),
//                                     contentPadding: EdgeInsets.all(0),
//                                   ),
//                                   CustomDropDown<ProfileCountry?>(
//                                     value: controller.selectedCountry.value,
//                                     items: controller.countries
//                                         .map(
//                                           (co) =>
//                                               DropdownMenuItem<ProfileCountry>(
//                                             value: co,
//                                             child: Text(co.title.en ?? ''),
//                                           ),
//                                         )
//                                         .toList(),
//                                     hint: controller.userProfile.value?.country
//                                             ?.title.en ??
//                                         '',
//                                     label: 'Country',
//                                     isDense: true,
//                                     onChanged: (country) async {
//                                       controller.selectedCountry.value =
//                                           country;
//                                       await controller.getCities(country!.id);
//                                     },
//                                     // onValidate: (value) {
//                                     //   if (value == null) {
//                                     //     return 'Enter your Country';
//                                     //   } else {
//                                     //     return null;
//                                     //   }
//                                     // },
//                                   ),
//                                   const SizedBox(
//                                     height: 16,
//                                   ),
//                                   CustomDropDown<CityModel?>(
//                                     value: controller.selectedCity.value,
//                                     items: controller.cities
//                                         .map(
//                                           (city) => DropdownMenuItem<CityModel>(
//                                             value: city,
//                                             child: Text(city.title.en ?? ''),
//                                           ),
//                                         )
//                                         .toList(),
//                                     hint: 'City',
//                                     label: 'City',
//                                     isDense: true,
//                                     onChanged: (city) async {
//                                       controller.selectedCity.value = city;
//                                       await controller.getAreas(
//                                         countryId: controller
//                                             .selectedCountry.value!.id,
//                                         cityId:
//                                             controller.selectedCity.value!.id,
//                                       );
//                                     },
//                                     // onValidate: (value) {
//                                     //   if (value == null) {
//                                     //     return 'Enter your city';
//                                     //   } else {
//                                     //     return null;
//                                     //   }
//                                     // },
//                                   ),
//                                   const SizedBox(
//                                     height: 16,
//                                   ),
//                                   CustomDropDown<AreaModel?>(
//                                     value: controller.selectedArea.value,
//                                     items: controller.areas
//                                         .map(
//                                           (area) => DropdownMenuItem<AreaModel>(
//                                             value: area,
//                                             child: Text(area.title.en ?? ''),
//                                           ),
//                                         )
//                                         .toList(),
//                                     hint: 'Area',
//                                     label: 'Area',
//                                     isDense: true,
//                                     onChanged: (area) {
//                                       controller.selectedArea.value = area;
//                                     },
//                                     // onValidate: (value) {
//                                     //   if (value == null) {
//                                     //     return 'Enter your area';
//                                     //   } else {
//                                     //     return null;
//                                     //   }
//                                     // },
//                                   ),
//                                   const SizedBox(
//                                     height: 16,
//                                   ),
//                                   CustomTextFormField(
//                                     controller: controller.addressController,
//                                     hint: 'Address',
//                                     label: 'Address',
//                                     inputType: TextInputType.streetAddress,
//                                     onValidate: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Enter your address';
//                                       } else {
//                                         return null;
//                                       }
//                                     },
//                                   ),
//                                   const SizedBox(
//                                     height: 40,
//                                   ),
//                                   RoundedLoadingButton(
//                                     controller: controller.submitBtnController,
//                                     width: Get.width,
//                                     color: CustomColor.primaryColor,
//                                     onPressed: controller.submitAccountEdit,
//                                     child: const Text("Submit"),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ));
//         },
//       ),
//     );
//   }
// }

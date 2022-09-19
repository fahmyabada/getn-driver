import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/country/IconModel.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/strings.dart';
import 'package:getn_driver/presentation/auth/signIn/sign_in_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreenView extends StatefulWidget {
  const SignInScreenView({Key? key}) : super(key: key);

  @override
  State<SignInScreenView> createState() => _SignInScreenViewState();
}

class _SignInScreenViewState extends State<SignInScreenView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  Data? dropDownValueCountry;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SignInCubit()..getCountries(),
        child:
            BlocConsumer<SignInCubit, SignInState>(listener: (context, state) {
          if (state is SignInLoading) {
            if (kDebugMode) {
              print('*******PlanVisitLoadingState');
            }
          } else if (state is SignInErrorState) {
            if (kDebugMode) {
              print('*******PlanVisitErrorState ${state.message}');
            }
          }
        }, builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.r),
                          child: Container(
                            padding: EdgeInsetsDirectional.all(10.r),
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: defaultFormField(
                                controller: serverController,
                                type: TextInputType.text,
                                label: LanguageCubit.get(context)
                                    .getTexts("Server Url")
                                    .toString(),
                                prefix: Icons.cast_connected_outlined,
                                validatorText: serverController.text,
                                validatorMessage: LanguageCubit.get(context)
                                    .getTexts("pleaseEnterServerUrl")
                                    .toString(),
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                }),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          );
        }));
  }

  signInWidget(BuildContext context, List<Data> list) {
    return Padding(
      padding: EdgeInsets.only(left: 20.r, right: 20.r, top: 100.r),
      child: (Column(
        children: [
          Text(
            Strings.signIn,
            style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor),
          ),
          SizedBox(
            height: 36.h,
          ),
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(30.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 55.h,
                        width: 150.w,
                        child: SizedBox(
                          // width: 400,
                          height: 55,

                          child: DropdownSearch<Data>(
                            //mode of dropdown
                            popupProps: PopupProps.menu(
                                fit: FlexFit.loose,
                                menuProps: MenuProps(
                                  backgroundColor: white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                itemBuilder: (context, data, isSelected) =>
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.r, vertical: 10.r),
                                      child: Row(
                                        children: [
                                          ImageTools.image(
                                            fit: BoxFit.contain,
                                            url: SignInCubit.get(context)
                                                    .selectedCountry!
                                                    .icon!
                                                    .src ??
                                                " ",
                                            height: 30.h,
                                            width: 30.h,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                              SignInCubit.get(context)
                                                      .selectedCountry!
                                                      .title!
                                                      .en ??
                                                  " ",
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                              SignInCubit.get(context)
                                                      .selectedCountry!
                                                      .code ??
                                                  "",
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    )),
                            selectedItem: dropDownValueCountry,
                            items: list.cast<Data>(),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.r, vertical: 10.r),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.r),
                                  borderSide:
                                      const BorderSide(color: primaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.r),
                                  borderSide:
                                      const BorderSide(color: primaryColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.r),
                                  borderSide:
                                      const BorderSide(color: primaryColor),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.r),
                                  borderSide:
                                      const BorderSide(color: primaryColor),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.r),
                                  borderSide:
                                      const BorderSide(color: primaryColor),
                                ),
                              ),
                            ),
                            dropdownButtonProps: DropdownButtonProps(
                              color: white,
                              icon: Icon(Icons.arrow_drop_down, size: 24.h),
                            ),
                            dropdownBuilder: (context, selectedItem) => Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ImageTools.image(
                                    fit: BoxFit.contain,
                                    url: selectedItem!.icon!.src ?? " ",
                                    height: 30,
                                    width: 30,
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: Color.fromARGB(207, 204, 204, 213),
                                  ),
                                  Text(selectedItem.title!.en ?? "",
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(selectedItem.code ?? "",
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                dropDownValueCountry = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width / 1.9,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            style: GoogleFonts.roboto(
                                color: greyColor, fontSize: 14.sp),
                            controller: controller.mobileController,
                            keyboardType: TextInputType.number,
                            validator: (String? value) {
// remover number 1 from string
                              value = (value?.startsWith("0", 0) ?? false)
                                  ? value?.substring(1)
                                  : value;
                              //     value = ;
                              controller.mobileController.text = value ?? "";
                              if (GetUtils.isPhoneNumber(value ?? " ")) {
                                return null;
                              } else {
                                return Strings.pleaseFillOutTheField;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: Strings.phone,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.r, horizontal: 10.r),
                              labelStyle: GoogleFonts.roboto(
                                  color: greyColor, fontSize: 14.sp),
                              // filled: true,
                              hintStyle: GoogleFonts.roboto(
                                  color: greyColor, fontSize: 14.sp),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36.h,
          ),
          GestureDetector(
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Center(
                child: Text(
                  Strings.next.toUpperCase(),
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onTap: () {
              if (_formKey.currentState!.validate() &&
                  controller.selectedCountry?.value.id != null) {
                controller.sendOTP(controller.mobileController.text,
                    controller.selectedCountry?.value.id ?? "");
                controller.setPhoneNumber(controller.mobileController.text);
                controller.setCountryId(controller.selectedCountry?.value.id);
              } else {
                showSnackbar("error", Strings.pleaseFillOutTheField);
              }
            },
          ),
        ],
      )),
    );
  }
}

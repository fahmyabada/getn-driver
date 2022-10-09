import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/auth/VerifyImage.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/request/RequestScreen.dart';
import 'package:getn_driver/presentation/request/request_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverInformationScreen extends StatefulWidget {
  const DriverInformationScreen({Key? key}) : super(key: key);

  @override
  State<DriverInformationScreen> createState() =>
      _DriverInformationScreenState();
}

class _DriverInformationScreenState extends State<DriverInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignCubit, SignState>(
        listener: (context, state) {
          if(state is EditSuccessState){
            print('*******EditSuccessState');
            getIt<SharedPreferences>().setString('typeSign', "signWithInformation");
            navigateTo(
                context,
                const RequestScreen());
          }else if (state is EditErrorState){
            print('*******EditErrorState');
            showToastt(
                text: state.message, state: ToastStates.error, context: context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "Driver Information",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    //front NationalId
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.r, vertical: 15.r),
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Front NationalId',
                                style: TextStyle(
                                    fontSize: 20.sp, color: primaryColor),
                              ),
                              SignCubit
                                  .get(context)
                                  .frontNationalId
                                  ? Icon(
                                Icons.done,
                                color: greenColor,
                                size: 25.w,
                              )
                                  : Text(
                                'Update',
                                style: TextStyle(
                                    fontSize: 20.sp, color: greenColor),
                              )
                            ],
                          )),
                      onTap: () {
                        navigateTo(
                          context,
                          const VerifyImageScreen(
                            typeScreen: "frontNationalId",
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    //back NationalId
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.r, vertical: 15.r),
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'back NationalId',
                                style: TextStyle(
                                    fontSize: 20.sp, color: primaryColor),
                              ),
                              SignCubit
                                  .get(context)
                                  .backNationalId
                                  ? Icon(
                                Icons.done,
                                color: greenColor,
                                size: 25.w,
                              )
                                  : Text(
                                'Update',
                                style: TextStyle(
                                    fontSize: 20.sp, color: greenColor),
                              )
                            ],
                          )),
                      onTap: () {
                        navigateTo(
                          context,
                          const VerifyImageScreen(
                            typeScreen: "backNationalId",
                          ),
                        );
                      },
                    ),
                    /*  SizedBox(
                      height: 30.h,
                    ),
                    //front Passport
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.r, vertical: 15.r),
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Front Passport',
                                style: TextStyle(
                                    fontSize: 20.sp, color: primaryColor),
                              ),
                              SignCubit.get(context).frontPassport
                                  ? Icon(
                                      Icons.done,
                                      color: greenColor,
                                      size: 25.w,
                                    )
                                  : Text(
                                      'Update',
                                      style: TextStyle(
                                          fontSize: 20.sp, color: greenColor),
                                    )
                            ],
                          )),
                      onTap: () {
                        navigateTo(
                          context,
                          const VerifyImageScreen(
                            typeScreen: "frontPassport",
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    //back Passport
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.r, vertical: 15.r),
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Back Passport',
                                style: TextStyle(
                                    fontSize: 20.sp, color: primaryColor),
                              ),
                              SignCubit.get(context).backPassport
                                  ? Icon(
                                      Icons.done,
                                      color: greenColor,
                                      size: 25.w,
                                    )
                                  : Text(
                                      'Update',
                                      style: TextStyle(
                                          fontSize: 20.sp, color: greenColor),
                                    )
                            ],
                          )),
                      onTap: () {
                        navigateTo(
                          context,
                          const VerifyImageScreen(
                            typeScreen: "backPassport",
                          ),
                        );
                      },
                    ),*/
                    SizedBox(
                      height: 30.h,
                    ),
                    //front driver licence
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.r, vertical: 15.r),
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Front Driver Licence',
                                style: TextStyle(
                                    fontSize: 20.sp, color: primaryColor),
                              ),
                              SignCubit
                                  .get(context)
                                  .frontDriverLicence
                                  ? Icon(
                                Icons.done,
                                color: greenColor,
                                size: 25.w,
                              )
                                  : Text(
                                'Update',
                                style: TextStyle(
                                    fontSize: 20.sp, color: greenColor),
                              )
                            ],
                          )),
                      onTap: () {
                        navigateTo(
                          context,
                          const VerifyImageScreen(
                            typeScreen: "frontDriverLicence",
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    //back driver licence
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.r, vertical: 15.r),
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Back Driver Licence',
                                style: TextStyle(
                                    fontSize: 20.sp, color: primaryColor),
                              ),
                              SignCubit
                                  .get(context)
                                  .backDriverLicence
                                  ? Icon(
                                Icons.done,
                                color: greenColor,
                                size: 25.w,
                              )
                                  : Text(
                                'Update',
                                style: TextStyle(
                                    fontSize: 20.sp, color: greenColor),
                              )
                            ],
                          )),
                      onTap: () {
                        navigateTo(
                          context,
                          const VerifyImageScreen(
                            typeScreen: "backDriverLicence",
                          ),
                        );
                      },
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
                      child: defaultButton3(
                          press: () {
                            if (SignCubit
                                .get(context)
                                .frontNationalIdString !=
                                null &&
                                SignCubit
                                    .get(context)
                                    .backNationalIdString !=
                                    null &&
                                // SignCubit.get(context).frontPassportString !=
                                //     null &&
                                // SignCubit.get(context).backPassportString !=
                                //     null &&
                                SignCubit
                                    .get(context)
                                    .frontDriverLicenceString !=
                                    null &&
                                SignCubit
                                    .get(context)
                                    .backDriverLicenceString !=
                                    null) {
                              SignCubit.get(context).editInformation(
                                  SignCubit
                                      .get(context)
                                      .frontNationalIdString!, SignCubit
                                  .get(context)
                                  .backNationalIdString!,
                                  SignCubit
                                      .get(context)
                                      .frontDriverLicenceString!,
                                  SignCubit
                                      .get(context)
                                      .backDriverLicenceString!);
                            } else {
                              showToastt(
                                  text: "please fill all data first...",
                                  state: ToastStates.error,
                                  context: context);
                            }
                          },
                          text: "Done",
                          backColor: accentColor,
                          textColor: white),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

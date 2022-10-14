import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/auth/TermsScreen.dart';
import 'package:getn_driver/presentation/ui/auth/VerifyImageScreen.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';

class SignUpDetailsScreen extends StatefulWidget {
  const SignUpDetailsScreen(
      {Key? key,
      required this.countryId,
      required this.phone,
      required this.firebaseToken})
      : super(key: key);

  final String phone;
  final String countryId;
  final String firebaseToken;

  @override
  State<SignUpDetailsScreen> createState() => _SignUpDetailsScreenState();
}

class _SignUpDetailsScreenState extends State<SignUpDetailsScreen> {
  int groupValue = 0;
  var groupValueId = "";
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SignCubit.get(context).getRole();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignCubit, SignState>(listener: (context, state) {
      if (state is RoleSuccessState) {
        print("RoleSuccessState**************${state.data![0].id}");
        groupValueId = state.data![0].id!;
      }
    }, builder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 1.sh,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "Complete your Registration",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          SizedBox(
                            height: 50.h,
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
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ],
                            ),
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
                                      margin: EdgeInsetsDirectional.only(
                                          start: 30.r),
                                      child: const CircularProgressIndicator(
                                          color: black),
                                    )
                                  : SignCubit.get(context).roles.isNotEmpty
                                      ? Expanded(
                                          child: radioButtonTypeDriverLayout(
                                              context),
                                        )
                                      : Container(
                                          margin: EdgeInsetsDirectional.only(
                                              start: 30.r),
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.cloud_upload,
                                                color: redColor,
                                                size: 60.sp,
                                              ),
                                              onPressed: () {
                                                SignCubit.get(context)
                                                    .getRole();
                                              }),
                                        ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10.0,
                              height: 24.0,
                              child: Checkbox(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                focusColor: Theme.of(context).focusColor,
                                //   activeColor: Theme.of(context).colorScheme.secondary,
                                value: SignCubit.get(context).terms,
                                onChanged: (value) {
                                  SignCubit.get(context).setTerms(value!);
                                },
                              ),
                            ),
                            SizedBox(width: 20.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "i confirm that i have read & agree to the",
                                    style: TextStyle(
                                        fontSize: 17.sp, color: black)),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        navigateTo(
                                            context, const TermsScreen());
                                      },
                                      child: Text("Terms & condition ",
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              color: accentColor)),
                                    ),
                                    Text("and Privacy Policy",
                                        style: TextStyle(
                                            fontSize: 17.sp, color: black)),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
                          child: defaultButton3(
                              press: () {
                                if (formKey.currentState!.validate()) {
                                  if (SignCubit.get(context).terms) {
                                    navigateTo(
                                      context,
                                      VerifyImageScreen(
                                        typeScreen: "register",
                                        fullName:
                                            fullNameController.text.toString(),
                                        email: emailController.text.toString(),
                                        phone: widget.phone,
                                        countryId: widget.countryId,
                                        firebaseToken: widget.firebaseToken,
                                        role: groupValueId,
                                      ),
                                    );
                                  } else {
                                    showToastt(
                                        text:
                                            "check in Terms & condition first..",
                                        state: ToastStates.error,
                                        context: context);
                                  }
                                }
                              },
                              text: "Next",
                              backColor: accentColor,
                              textColor: white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
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
}

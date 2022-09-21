import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';

class SignUpDetails extends StatefulWidget {
  const SignUpDetails({Key? key}) : super(key: key);

  @override
  State<SignUpDetails> createState() => _SignUpDetailsState();
}

class _SignUpDetailsState extends State<SignUpDetails> {
  var groupVisitType;
  var groupVisitTypeValue = "driver";
  bool terms = false;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Complete your Registration",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              SizedBox(
                height: 30.h,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultFormField(
                      controller: fullNameController,
                      type: TextInputType.text,
                      label: "Full Name",
                      textSize: 22,
                      border: false,
                      validatorText: fullNameController.text,
                      validatorMessage: "Enter Full Name Please..",
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    defaultFormField(
                      controller: emailController,
                      type: TextInputType.text,
                      label: "Email",
                      textSize: 22,
                      border: false,
                      validatorText: emailController.text,
                      validatorMessage: "Enter Email Please..",
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.r),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Role",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: black),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: radioButtonTypeDriverLayout(context),
                          ),
                        ],
                      ),
                    ),
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
                            value: terms,
                            onChanged: (value) {
                              setState(() {
                                terms = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 20.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("i confirm that i have read & agree to the",
                                style:
                                    TextStyle(fontSize: 20.sp, color: black)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Text("Terms & condition ",
                                      style: TextStyle(
                                          fontSize: 20.sp, color: accentColor)),
                                ),
                                Text("and Privacy Policy",
                                    style: TextStyle(
                                        fontSize: 20.sp, color: black)),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget radioButtonTypeDriverLayout(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: grey,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                value: 1,
                groupValue: groupVisitType ?? 1,
                activeColor: accentColor,
                onChanged: (value) {
                  setState(() {
                    groupVisitType = value;
                    groupVisitTypeValue = "driver";
                  });
                },
                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text('driver', style: TextStyle(fontSize: 20.sp)),
            ],
          ),
        ),
        SizedBox(
          height: 15.w,
        ),
        Container(
          decoration: BoxDecoration(
            color: grey,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Radio(
                value: 2,
                groupValue: groupVisitType,
                activeColor: accentColor,
                onChanged: (value) {
                  setState(() {
                    groupVisitType = value;
                    groupVisitTypeValue = "Driver and tour guide";
                  });
                },
                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(
                'Driver and tour guide',
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

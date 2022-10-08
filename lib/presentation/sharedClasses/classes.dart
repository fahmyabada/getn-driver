import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/request/request_cubit.dart';

class CustomDialog extends StatelessWidget {
  final String? title, description, type, id;
  final VoidCallback? press;
  final Color? backgroundColor,
      titleColor,
      descColor,
      btnOkColor,
      btnCancelColor;

  var commentController = TextEditingController();
  var formKeyRequest = GlobalKey<FormState>();

  CustomDialog({
    Key? key,
    required this.title,
    required this.description,
    this.press,
    this.type,
    this.backgroundColor,
    this.titleColor,
    this.descColor,
    this.btnOkColor,
    this.btnCancelColor,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestCubit, RequestState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(
                top: 40.r, bottom: 20.r, left: 16.r, right: 16.r),
            margin: EdgeInsets.only(top: 50.r),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10.r,
                ),
                Text(
                  title!,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: titleColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16.r,
                ),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, color: descColor),
                ),
                SizedBox(
                  height: 44.h,
                ),
                Form(
                  key: formKeyRequest,
                  child: defaultFormField(
                      controller: commentController,
                      type: TextInputType.text,
                      label: "comment",
                      textSize: 15,
                      borderRadius: 50,
                      border: false,
                      borderColor: white,
                      validatorText: commentController.text,
                      validatorMessage: "Enter Comment First Please..",
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      }),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state is! RequestEditInitial
                        ? MaterialButton(
                            height: 30.h,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                            color: btnOkColor,
                            minWidth: 80.w,
                            onPressed: () {
                              if (formKeyRequest.currentState!.validate()) {
                                RequestCubit.get(context).editRequest(
                                    id!,
                                    "reject",
                                    commentController.text.toString());
                              }
                            },
                            child: Text(
                              'Ok',
                              style: TextStyle(color: white, fontSize: 15.sp),
                            ))
                        : Center(
                            child: CircularProgressIndicator(
                              color: btnOkColor,
                            ),
                          ),
                    SizedBox(
                      width: 30.w,
                    ),
                    MaterialButton(
                        height: 30.h,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        color: btnCancelColor,
                        onPressed: () => Navigator.pop(context),
                        minWidth: 80.w,
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: black, fontSize: 15.sp),
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



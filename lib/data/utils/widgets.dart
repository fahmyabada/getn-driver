import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void navigatePop(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

Widget defaultFormField(
    {TextEditingController? controller,
      TextInputType? type,
      String? label,
      IconData? prefix,
      bool isPassword = false,
      String? validatorText,
      String? validatorMessage,
      bool suffix = false,
      VoidCallback? onEditingComplete,
      bool enabled = true,
      double textSize = 16,
      Function? submit,
      Function? changed,
      Function? tap,
      Function? suffixPressed}) =>
    TextFormField(
      enabled: enabled,
      enableInteractiveSelection: true,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      maxLines: isPassword ? 1 : null,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: 17.sp),
      // to move next editText
      onEditingComplete: onEditingComplete,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: textSize.sp,
          color: Colors.black38,
        ),
        prefixIcon: prefix != null
            ? Container(
          margin: EdgeInsetsDirectional.only(start: 5.r, end: 5.r),
          child: Icon(
            prefix,
            color: Colors.black87,
            size: 25.sm,
          ),
        )
            : null,
        filled: true,
        //to make background
        fillColor: Colors.white,
        //for background color
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.white),
        ),
        errorStyle: TextStyle(color: Colors.black, fontSize: 12.sm),
        suffixIcon: suffix
            ? IconButton(
            onPressed: () {
              suffixPressed != null ? suffixPressed() : null;
            },
            icon: Icon(
              isPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
              size: 25.sm,
            ))
            : null,
      ),
      onChanged: (s) {
        changed != null ? changed(s) : null;
      },
      validator: (validatorText) {
        if (validatorText!.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
      onFieldSubmitted: (s) {
        submit != null ? submit(s) : null;
      },
      onTap: () {
        tap != null ? tap() : null;
      },
    );
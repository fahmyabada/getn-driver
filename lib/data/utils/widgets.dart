import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:getn_driver/data/utils/colors.dart';

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
        bool border = false,
        bool autoFocus = false,
        Color? borderColor,
        FocusNode? foucsnode,
        Function? submit,
        Function? changed,
        Function? tap,
        Function? suffixPressed}) =>
    TextFormField(
      focusNode: foucsnode,
      autofocus: autoFocus,
      enabled: enabled,
      enableInteractiveSelection: true,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      maxLines: isPassword ? 1 : null,
      textAlign: !border ? TextAlign.center : TextAlign.start,
      style: TextStyle(fontSize: textSize.sp),
      // to move next editText
      onEditingComplete: onEditingComplete,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: !border ? EdgeInsets.symmetric(vertical: 15.r) : null,
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
        enabledBorder: border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide(color: borderColor!),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: const BorderSide(color: greyColor),
              ),
        focusedBorder: border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide(color: borderColor!),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: const BorderSide(color: greyColor),
              ),
        border: border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide(color: borderColor!),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: const BorderSide(color: greyColor),
              ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: BorderSide(color: borderColor!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: BorderSide(color: borderColor),
        ),
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

Widget defaultButton3(
        {required VoidCallback press,
        bool disablePress = true,
        required String text,
        required Color backColor,
        required Color textColor}) =>
    Container(
      margin: EdgeInsets.symmetric(horizontal: 25.r, vertical: 30.r),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disablePress ? press : null,
        style: TextButton.styleFrom(
          backgroundColor: backColor,
          foregroundColor: textColor,
          padding: EdgeInsets.symmetric(vertical: 15.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          textStyle: TextStyle(
              fontSize: 24.sm,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        child: Text(
          text,
        ),
      ),
    );

void showToastt({
  required String text,
  required ToastStates state,
  required BuildContext context,
}) =>
    showToast(
      text,
      context: context,
      backgroundColor: chooseToastColor(state),
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );

// enum
enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }

  return color;
}

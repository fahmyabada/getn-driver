import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Future<dynamic> navigateToWithRefreshPagePrevious(context, widget) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

Future<void> launchInMap(String sLat, String sLon, String dLat, String dLon,
    BuildContext context) async {
  if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
    await MapLauncher.showDirections(
      destination: Coords(
        double.parse(dLat),
        double.parse(dLon),
      ),
      destinationTitle: " Trip From",
      mapType: MapType.google,
      originTitle: 'Trip To',
      origin: Coords(
        double.parse(sLat),
        double.parse(sLon),
      ),
    );
  } else if (await MapLauncher.isMapAvailable(MapType.apple) ?? false) {
    await MapLauncher.showDirections(
      destination: Coords(
        double.parse(dLat),
        double.parse(dLat),
      ),
      destinationTitle: " Trip From",
      mapType: MapType.apple,
      originTitle: 'Trip To',
      origin: Coords(
        double.parse(sLat),
        double.parse(sLon),
      ),
    );
  } else {
    showToastt(
        text: LanguageCubit.get(context).getTexts('HaveNotMaps').toString(),
        state: ToastStates.error,
        context: context);
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<void> openWhatsapp(String whatsapp, BuildContext context) async {
  var androidUrl = "whatsapp://send?phone=$whatsapp";
  var iosUrl = "https://wa.me/$whatsapp";

  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception {
    showToastt(
        text: LanguageCubit.get(context)
            .getTexts('WhatsappNoInstalled')
            .toString(),
        state: ToastStates.error,
        context: context);
  }
}

Widget defaultFormField(
        {TextEditingController? controller,
        TextInputType? type,
        String? label,
        String? hint,
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
        int? borderRadius,
        FocusNode? foucsnode,
        Function? submit,
        Function? changed,
        Function? tap,
        Function? suffixPressed}) =>
    TextFormField(
      focusNode: foucsnode,
      autofocus: autoFocus,
      enabled: enabled,
      enableInteractiveSelection: false,
      controller: controller,
      keyboardType: type,
      inputFormatters: type == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      obscureText: isPassword,
      maxLines: isPassword ? 1 : null,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: textSize.sp),
      // to move next editText
      onEditingComplete: onEditingComplete,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: border
            ? null
            : EdgeInsets.symmetric(horizontal: 25.r, vertical: 20.r),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: textSize.sp,
          color: Colors.black38,
        ),
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
                  size: 25.sp,
                ),
              )
            : null,
        filled: true,
        //to make background
        fillColor: Colors.white,
        //for background color
        enabledBorder: border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius!.r),
                borderSide: BorderSide(color: borderColor!),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius!.r),
                borderSide: const BorderSide(color: greyColor),
              ),
        focusedBorder: border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius.r),
                borderSide: BorderSide(color: borderColor!),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius.r),
                borderSide: const BorderSide(color: greyColor),
              ),
        border: border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius.r),
                borderSide: BorderSide(color: borderColor!),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius.r),
                borderSide: const BorderSide(color: greyColor),
              ),
        focusedErrorBorder: border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius.r),
                borderSide: BorderSide(color: borderColor!),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius.r),
                borderSide: const BorderSide(color: redColor),
              ),
        errorBorder: border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide(color: borderColor!),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: const BorderSide(color: redColor),
              ),
        suffixIcon: suffix
            ? IconButton(
                onPressed: () {
                  suffixPressed != null ? suffixPressed() : null;
                },
                icon: Icon(
                  isPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                  size: 25.sp,
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

Widget defaultButton2(
        {required VoidCallback press,
        bool disablePress = true,
        required String text,
        required Color backColor,
        int fontSize = 24,
        int paddingVertical = 10,
        int paddingHorizontal = 35,
        int borderRadius = 20,
        bool colorBorder = false,
        required Color textColor}) =>
    ElevatedButton(
      onPressed: disablePress ? press : null,
      style: TextButton.styleFrom(
        backgroundColor: backColor,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(
            vertical: paddingVertical.r, horizontal: paddingHorizontal.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          side: colorBorder
              ? const BorderSide(color: grey2)
              : const BorderSide(color: Colors.transparent),
        ),
        textStyle: TextStyle(
            fontSize: fontSize.sp,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
      child: Text(
        text,
      ),
    );

Widget defaultButton3(
        {required VoidCallback press,
        bool disablePress = true,
        required String text,
        required Color backColor,
        required Color textColor}) =>
    SizedBox(
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
          textStyle: TextStyle(fontSize: 24.sp),
        ),
        child: Text(
          text,
        ),
      ),
    );

Widget defaultButtonWithIcon(
        {required VoidCallback press,
        bool disablePress = true,
        required String text,
        required Color backColor,
        int fontSize = 24,
        int paddingVertical = 10,
        int paddingHorizontal = 35,
        int borderRadius = 20,
        bool colorBorder = false,
        required IconData icon,
        required Color textColor}) =>
    ElevatedButton(
      onPressed: disablePress ? press : null,
      style: TextButton.styleFrom(
        backgroundColor: backColor,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(
            vertical: paddingVertical.r, horizontal: paddingHorizontal.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          side: colorBorder
              ? const BorderSide(color: grey2)
              : const BorderSide(color: Colors.transparent),
        ),
        textStyle: TextStyle(
            fontSize: fontSize.sp,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: white,
            size: 23.sp,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            text,
          ),
        ],
      ),
    );

Widget loading() {
  // return const Center(
  //   child: CircularProgressIndicator(
  //     color: black,
  //   ),
  // );

  return SpinKitRotatingCircle(
    color: Colors.blueAccent,
    size: 50.w,
  );
}

Widget errorMessage(
    {required String message,
    required VoidCallback press,
    required BuildContext context}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.r),
          margin: EdgeInsets.symmetric(horizontal: 37.r),
          decoration: BoxDecoration(
            color: blueLight,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.sm, color: white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 35.h,
              ),
              InkWell(
                onTap: press,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.r, vertical: 10.r),
                      child: Text(
                        LanguageCubit.get(context)
                            .getTexts('Refresh')
                            .toString(),
                        style: TextStyle(color: accentColor, fontSize: 20.sm),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget errorMessage2(
    {required String message,
    required VoidCallback press,
    required BuildContext context}) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(18.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            onPressed: press,
            child: Text(
              LanguageCubit.get(context).getTexts('Retry').toString(),
            ),
          )
        ],
      ),
    ),
  );
}

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

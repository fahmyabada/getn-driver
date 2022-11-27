import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/onBoarding/OnBoardScreenView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool isEnValue = true;
  String dropDownValueLanguage = 'English';
  List<String> listLanguage = ['English', 'العربية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r),
            child: Text(
              'Choose Language / اختيار اللغة',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40.r),
            decoration: BoxDecoration(
                color: white, borderRadius: BorderRadius.circular(20.r)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                dropdownDecoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(20.r)),
                isExpanded: true,
                iconSize: 0.0,
                focusColor: Colors.transparent,
                onChanged: (String? value) {
                  setState(() {
                    dropDownValueLanguage = value.toString();
                    if (dropDownValueLanguage == 'English') {
                      isEnValue = true;
                    } else {
                      isEnValue = false;
                    }
                  });
                },
                hint: Center(
                  // child: Text(dropDownValueLanguage.toString(),
                  //     style: TextStyle(color: black, fontSize: 23.sp)),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(dropDownValueLanguage.toString(),
                          style: TextStyle(color: black, fontSize: 23.sp)),
                      SizedBox(
                        width: 20.w,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: black,
                      ),
                    ],
                  ),

                ),
                items: listLanguage.map((selectedLanguage) {
                  return DropdownMenuItem<String>(
                    value: selectedLanguage,
                    child: Center(
                      child: Text(selectedLanguage,
                          style: TextStyle(
                              color: dropDownValueLanguage == selectedLanguage
                                  ? blueColor
                                  : black,
                              fontSize: 20.sp)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(vertical: 20.r),
            margin: EdgeInsets.symmetric(horizontal: 40.r),
            decoration: BoxDecoration(
                color: blueColor, borderRadius: BorderRadius.circular(30.r)),
            child: InkWell(
              child: Text(
                'Done',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23.sp,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                getIt<SharedPreferences>()
                    .setBool("isEn", isEnValue)
                    .then((value) {
                  LanguageCubit.get(context).changeLan(isEnValue);
                  navigateTo(context, const OnBoardScreenView());
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

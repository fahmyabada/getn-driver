import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:getn_driver/data/model/OnBoardingItem.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/strings.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/auth/SignInScreen.dart';


class OnBoardScreenView extends StatelessWidget {
   OnBoardScreenView({Key? key}) : super(key: key);

  final pages = <OnBoardingItem>[
    OnBoardingItem(
      title: Strings.title1,
      subTitle: Strings.subTitle1,
      image: 'assets/onboard/1.png',
    ),
    OnBoardingItem(
      title: Strings.title2,
      subTitle: Strings.subTitle2,
      image: 'assets/onboard/2.png',
    ),
    OnBoardingItem(
      title: Strings.title3,
      subTitle: Strings.subTitle3,
      image: 'assets/onboard/3.png',
    ),
    OnBoardingItem(
      title: Strings.title4,
      subTitle: Strings.subTitle4,
      image: 'assets/onboard/4.png',
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: PageView.builder(
          itemCount: pages.length,
          itemBuilder: (context, index) {
            OnBoardingItem oi = pages[index];
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    oi.title!,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold),
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    oi.subTitle!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                    ),
                  ),
                    SizedBox(
                    height: 60.h,
                  ),
                  index != (pages.length - 1)
                      ? Center(
                          child: SizedBox(
                            //   width: double.infinity,
                            height: 23.h,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: pages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return Center(
                                  child: Padding(
                                    padding:  EdgeInsets.all(2.r),
                                    child: Container(
                                      width: index == i ? 25.w : 20.w,
                                      decoration: BoxDecoration(
                                          color: index == i
                                              ? blueColor
                                              : Colors.white,
                                          borderRadius:  BorderRadius.circular(10.r)),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : GestureDetector(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 60.h,
                              width: 210.w,
                              decoration:  BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(30.r)),
                              child: Center(
                                child: Text(
                                  Strings.getStarted.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            navigateTo(context,const SignInScreen());
                          },
                        )
                ],
              ),
            );
          }),
    );
  }
}

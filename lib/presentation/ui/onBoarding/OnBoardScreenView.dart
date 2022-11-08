import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:getn_driver/data/model/OnBoardingItem.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/auth/SignInScreen.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';


class OnBoardScreenView extends StatefulWidget {
   const OnBoardScreenView({Key? key}) : super(key: key);

  @override
  State<OnBoardScreenView> createState() => _OnBoardScreenViewState();
}

class _OnBoardScreenViewState extends State<OnBoardScreenView> {
   List<OnBoardingItem> pages = [];

   @override
  void initState() {
    super.initState();

    pages =  <OnBoardingItem>[
      OnBoardingItem(
        title: LanguageCubit.get(context)
            .getTexts('title1')
            .toString(),
        subTitle: LanguageCubit.get(context)
            .getTexts('subTitle1')
            .toString(),
        image: 'assets/onboard/1.png',
      ),
      OnBoardingItem(
        title: LanguageCubit.get(context)
            .getTexts('title2')
            .toString(),
        subTitle: LanguageCubit.get(context)
            .getTexts('subTitle2')
            .toString(),
        image: 'assets/onboard/2.png',
      ),
      OnBoardingItem(
        title: LanguageCubit.get(context)
            .getTexts('title3')
            .toString(),
        subTitle: LanguageCubit.get(context)
            .getTexts('subTitle3')
            .toString(),
        image: 'assets/onboard/3.png',
      ),
      OnBoardingItem(
        title: LanguageCubit.get(context)
            .getTexts('title4')
            .toString(),
        subTitle: LanguageCubit.get(context)
            .getTexts('subTitle4')
            .toString(),
        image: 'assets/onboard/4.png',
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
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
                      : InkWell(
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
                                  LanguageCubit.get(context)
                                      .getTexts('getStarted')
                                      .toString().toUpperCase(),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:getn_driver/data/model/OnBoardingItem.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/strings.dart';
import 'package:google_fonts/google_fonts.dart';


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
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    oi.title!,
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    oi.subTitle!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  index != (pages.length - 1)
                      ? Center(
                          child: SizedBox(
                            //   width: double.infinity,
                            height: 20.0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: pages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      width: index == i ? 25 : 20.0,
                                      decoration: BoxDecoration(
                                          color: index == i
                                              ? blueColor
                                              : Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0))),
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
                              height: 50,
                              width: 200,
                              decoration: const BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30))),
                              child: Center(
                                child: Text(
                                  Strings.getStarted.toUpperCase(),
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            // navigateTo(context,);
                          },
                        )
                ],
              ),
            );
          }),
    );
  }
}
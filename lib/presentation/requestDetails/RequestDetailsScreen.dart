import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/presentation/requestDetails/request_details_cubit.dart';

class RequestDetailsScreen extends StatefulWidget {
  const RequestDetailsScreen({Key? key}) : super(key: key);

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  double _userRating = 3.0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestDetailsCubit, RequestDetailsState>(
      listener: (context, state) {
        if (state is RequestDetailsInitial) {
          if (kDebugMode) {
            print('*******StartState');
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Requests',
              style: TextStyle(color: primaryColor, fontSize: 20.sp),
            ),
            centerTitle: true,
            elevation: 1.0,
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: grey2,
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(2.r),
                            child: const Icon(
                              Icons.personal_injury,
                              color: redColor,
                            )),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Mohamed Fahmy Abada ',
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          color: black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'capTownCity',
                                style: TextStyle(fontSize: 18.sp, color: grey2),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              RatingBar.builder(
                                minRating: _userRating,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.w,
                                updateOnDrag: true,
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _userRating = rating;
                                  });
                                },
                                unratedColor: Colors.amber.withAlpha(50),
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    width: 1.sw,
                    height: 1.h,
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trip start and date',
                              style: TextStyle(
                                color: black,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Picked Location',
                              style: TextStyle(
                                  color: greenColor,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '11/12/2022',
                                style: TextStyle(color: grey2, fontSize: 16.sp),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Text(
                                '12:00 am',
                                style: TextStyle(
                                  color: grey2,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'City start , nasr city, cairo, egypt',
                            style: TextStyle(
                              color: grey2,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.r, vertical: 10.r),
                        child: Card(
                          elevation: 5.r,
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            color: white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10.r, horizontal: 15.r),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: greenColor,
                                      size: 20.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Picked Point',
                                            style: TextStyle(
                                                color: black,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            'Nasr City,Cairo,Egypt',
                                            style: TextStyle(
                                                color: grey2, fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '12:00 am',
                                          style: TextStyle(
                                            color: grey2,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        Text(
                                          '11/12/2022',
                                          style: TextStyle(
                                              color: grey2, fontSize: 15.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.r,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: redColor,
                                      size: 20.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Picked Point',
                                            style: TextStyle(
                                                color: black,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            'Nasr City,Cairo,Egypt',
                                            style: TextStyle(
                                                color: grey2, fontSize: 15.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '12:00 am',
                                          style: TextStyle(
                                            color: grey2,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        Text(
                                          '11/12/2022',
                                          style: TextStyle(
                                              color: grey2, fontSize: 15.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.r,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Card(
                                        color: yellowLightColor,
                                        child: Padding(
                                          padding: EdgeInsets.all(15.r),
                                          child: Column(children: [
                                            Text(
                                              'Distance',
                                              style: TextStyle(
                                                  color: grey2,
                                                  fontSize: 15.sp),
                                            ),
                                            SizedBox(
                                              height: 5.r,
                                            ),
                                            Text(
                                              '40 Km',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        color: Colors.redAccent.withOpacity(.3),
                                        child: Padding(
                                          padding: EdgeInsets.all(15.r),
                                          child: Column(children: [
                                            Text(
                                              'Points',
                                              style: TextStyle(
                                                  color: grey2,
                                                  fontSize: 15.sp),
                                            ),
                                            SizedBox(
                                              height: 5.r,
                                            ),
                                            Text(
                                              '15 ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        color: greenLightColor,
                                        child: Padding(
                                          padding: EdgeInsets.all(15.r),
                                          child: Column(children: [
                                            Text(
                                              'Pay',
                                              style: TextStyle(
                                                  color: grey2,
                                                  fontSize: 15.sp),
                                            ),
                                            SizedBox(
                                              height: 5.r,
                                            ),
                                            Text(
                                              '15E',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

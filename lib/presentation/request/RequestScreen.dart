import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/notificationService/local_notification_service.dart';
import 'package:getn_driver/presentation/request/request_cubit.dart';
import 'package:getn_driver/presentation/requestDetails/RequestDetailsScreen.dart';
import 'package:getn_driver/presentation/requestDetails/request_details_cubit.dart';
import 'package:intl/intl.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  TabController? _tabController;
  late ScrollController _controllerUpcoming;
  late ScrollController _controllerPast;
  late ScrollController _controllerPending;
  String typeRequest = "current";
  bool loadingUpComing = false;
  bool firstClickTabController = false;
  late FirebaseMessaging _messaging;
  double _userRating = 3.0;

  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize(context);
    registerNotification();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();

    // first load
    RequestCubit.get(context).getRequestCurrent(1);
    RequestCubit.get(context).getRequestUpComing(1);
    RequestCubit.get(context).getRequestPast(1);
    RequestCubit.get(context).getRequestPending(1);

    _controllerUpcoming = ScrollController();
    _controllerPast = ScrollController();
    _controllerPending = ScrollController();

    _tabController = TabController(length: 4, vsync: this);

    _tabController!.addListener(() {
      setState(() {
        print("_currentIndex*********** ${_tabController!.index}");
        _currentIndex = _tabController!.index;
        // if(_tabController!.indexIsChanging) {
        if (_currentIndex == 0) {
          RequestCubit.get(context).getRequestCurrent(1);
          typeRequest = "current";
        } else if (_currentIndex == 1) {
          RequestCubit.get(context).indexUpComing = 1;
          RequestCubit.get(context).getRequestUpComing(1);
          typeRequest = "upComing";
        } else if (_currentIndex == 2) {
          RequestCubit.get(context).indexPast = 1;
          RequestCubit.get(context).getRequestPast(1);
          typeRequest = "past";
        } else if (_currentIndex == 3) {
          RequestCubit.get(context).indexPending = 1;
          RequestCubit.get(context).getRequestPending(1);
          typeRequest = "pending";
        }
        // }
      });
    });
  }

  @override
  void dispose() {
    LocalNotificationService.didReceiveLocalNotificationStream.close();
    LocalNotificationService.selectNotificationStream.close();
    _tabController!.dispose();
    super.dispose();
    _controllerUpcoming.removeListener(_loadMoreUpComing);
    _controllerPast.removeListener(_loadMorePast);
    _controllerPending.removeListener(_loadMorePending);
  }

  void _loadMoreUpComing() {
    RequestCubit.get(context).loadingUpComing = false;

    RequestCubit.get(context)
        .getRequestUpComing(RequestCubit.get(context).indexUpComing);
  }

  void _loadMorePast() {
    RequestCubit.get(context).loadingPast = false;

    RequestCubit.get(context)
        .getRequestPast(RequestCubit.get(context).indexPast);
  }

  void _loadMorePending() {
    RequestCubit.get(context).loadingPending = false;

    RequestCubit.get(context)
        .getRequestPending(RequestCubit.get(context).indexPending);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestCubit, RequestState>(listener: (context, state) {
      if (state is RequestEditSuccessState) {
        if (kDebugMode) {
          print('*******RequestEditSuccessState');
        }
        RequestCubit.get(context).indexPending = 1;
        RequestCubit.get(context).getRequestPending(1);
        typeRequest = "pending";
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Requests',
            style: TextStyle(color: primaryColor, fontSize: 20.sp),
          ),
          centerTitle: true,
          elevation: 1.0,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            state is RequestCurrentInitial
                ? const Center(
                    child: CircularProgressIndicator(
                    color: black,
                  ))
                : ListView.builder(
                    // key: const PageStorageKey<String>('tab1'),
                    scrollDirection: Axis.vertical,
                    itemCount: RequestCubit.get(context).requestCurrent.length,
                    itemBuilder: (context, i) {
                      var current = RequestCubit.get(context).requestCurrent[i];
                      var startDate = DateTime.parse(current.from!.date!);
                      var endDate = DateTime.parse(current.to!);

                      return InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.r, vertical: 10.r),
                          child: Card(
                            elevation: 5.r,
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              color: white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.r, horizontal: 7.r),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              current.from!.placeTitle!,
                                              // current.from!.placeTitle!,
                                              style: TextStyle(
                                                  color: grey2,
                                                  fontSize: 16.sp),
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
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
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
                                    height: 10.h,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Card(
                                            color: yellowLightColor,
                                            child: Padding(
                                              padding: EdgeInsets.all(15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Days',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 13.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      '${current.days!.length} Days',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: rough,
                                            child: Padding(
                                              padding: EdgeInsets.all(15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Start Date',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 12.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd()
                                                          .format(startDate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'End Date',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 12.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd()
                                                          .format(endDate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: blueLight,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Cost',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 13.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      current.totalPrice
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          navigateTo(
                              context,
                              BlocProvider(
                                  create: (context) => RequestDetailsCubit()
                                    ..getRequestDetails(current.id!)
                                    ..getTripsRequestDetails(1, current.id!),
                                  child: const RequestDetailsScreen()));
                        },
                      );
                    },
                  ),
            state is RequestUpComingInitial
                ? const Center(
                    child: CircularProgressIndicator(
                    color: black,
                  ))
                : ListView.builder(
                    controller: _controllerUpcoming
                      ..addListener(() async {
                        if (_controllerUpcoming.position.extentAfter == 0) {
                          if (RequestCubit.get(context).loadingUpComing &&
                              typeRequest == "upComing") {
                            print("_controllerUpcoming*********** ");
                            _loadMoreUpComing();
                          }
                        }
                      }),
                    // key: const PageStorageKey<String>('tab2'),
                    scrollDirection: Axis.vertical,
                    itemCount: RequestCubit.get(context).requestUpComing.length,
                    itemBuilder: (context, i) {
                      var upComing =
                          RequestCubit.get(context).requestUpComing[i];
                      var startDate = DateTime.parse(upComing.from!.date!);
                      var endDate = DateTime.parse(upComing.to!);

                      return InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.r, vertical: 10.r),
                          child: Card(
                            elevation: 5.r,
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              color: white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.r, horizontal: 7.r),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              upComing.from!.placeTitle!,
                                              // upComing.from!.placeTitle!,
                                              style: TextStyle(
                                                  color: grey2,
                                                  fontSize: 16.sp),
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
                                              fontSize: 15.sp,
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
                                    height: 5.h,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Card(
                                            color: yellowLightColor,
                                            child: Padding(
                                              padding: EdgeInsets.all(15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Days',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 13.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      '${upComing.days!.length} Days',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: rough,
                                            child: Padding(
                                              padding: EdgeInsets.all(15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Start Date',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 12.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd()
                                                          .format(startDate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'End Date',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 13.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd()
                                                          .format(endDate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: blueLight,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Cost',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 13.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      upComing.totalPrice
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          navigateTo(
                              context,
                              BlocProvider(
                                  create: (context) => RequestDetailsCubit()
                                    ..getRequestDetails(upComing.id!)
                                    ..getTripsRequestDetails(1, upComing.id!),
                                  child: const RequestDetailsScreen()));
                        },
                      );
                    },
                  ),
            state is RequestPastInitial
                ? const Center(
                    child: CircularProgressIndicator(
                    color: black,
                  ))
                : ListView.builder(
                    controller: _controllerPast
                      ..addListener(() async {
                        if (_controllerPast.position.extentAfter == 0) {
                          print(
                              '_controllerPast00*******${RequestCubit.get(context).loadingPast}');
                          if (RequestCubit.get(context).loadingPast &&
                              typeRequest == "past") {
                            _loadMorePast();
                          }
                        }
                      }),
                    // key: const PageStorageKey<String>('tab2'),
                    scrollDirection: Axis.vertical,
                    itemCount: RequestCubit.get(context).requestPast.length,
                    itemBuilder: (context, i) {
                      var past = RequestCubit.get(context).requestPast[i];
                      var startDate = DateTime.parse(past.from!.date!);
                      var endDate = DateTime.parse(past.to!);

                      return InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.r, vertical: 10.r),
                          child: Card(
                            elevation: 5.r,
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              color: white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.r, horizontal: 7.r),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              past.from!.placeTitle!,
                                              // upComing.from!.placeTitle!,
                                              style: TextStyle(
                                                  color: grey2,
                                                  fontSize: 16.sp),
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
                                              fontSize: 15.sp,
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
                                    height: 5.h,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Card(
                                            color: yellowLightColor,
                                            child: Padding(
                                              padding: EdgeInsets.all(15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Days',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 13.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      '${past.days!.length} Days',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: rough,
                                            child: Padding(
                                              padding: EdgeInsets.all(15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Start Date',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 12.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd()
                                                          .format(startDate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'End Date',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 12.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd()
                                                          .format(endDate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: blueLight,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Cost',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 13.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      past.totalPrice
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          navigateTo(
                              context,
                              BlocProvider(
                                  create: (context) => RequestDetailsCubit()
                                    ..getRequestDetails(past.id!)
                                    ..getTripsRequestDetails(1, past.id!),
                                  child: const RequestDetailsScreen()));
                        },
                      );
                    },
                  ),
            state is RequestPendingInitial
                ? const Center(
                    child: CircularProgressIndicator(
                    color: black,
                  ))
                : ListView.builder(
                    controller: _controllerPending
                      ..addListener(() async {
                        if (_controllerPending.position.extentAfter == 0) {
                          if (kDebugMode) {
                            print(
                                '_controllerPending00*******${RequestCubit.get(context).loadingPending}');
                          }
                          if (RequestCubit.get(context).loadingPending &&
                              typeRequest == "pending") {
                            _loadMorePending();
                          }
                        }
                      }),
                    // key: const PageStorageKey<String>('tab2'),
                    scrollDirection: Axis.vertical,
                    itemCount: RequestCubit.get(context).requestPending.length,
                    itemBuilder: (context, i) {
                      var pending = RequestCubit.get(context).requestPending[i];
                      var startDate = DateTime.parse(pending.from!.date!);
                      var endDate = DateTime.parse(pending.to!);

                      return InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.r, vertical: 10.r),
                          child: Card(
                            elevation: 5.r,
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              color: white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.r, horizontal: 7.r),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    children: [
                                      ClipOval(
                                        clipBehavior: Clip.antiAlias,
                                        child: ImageTools.image(
                                            fit: BoxFit.fill,
                                            url: pending.client2!.image!.src,
                                            height: 70.w,
                                            width: 70.w),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.r),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      pending.client2!.name!,
                                                      style: TextStyle(
                                                          fontSize: 17.sp,
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                '${pending.client2!.country?.title!.en!}, ${pending.client2!.city?.title!.en!}, ${pending.client2!.area?.title!.en!}',
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: grey2),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              RatingBar.builder(
                                                minRating: _userRating,
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 17.w,
                                                updateOnDrag: true,
                                                onRatingUpdate: (rating) {
                                                  setState(() {
                                                    _userRating = rating;
                                                  });
                                                },
                                                unratedColor:
                                                    Colors.amber.withAlpha(50),
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
                                  // divider
                                  Container(
                                    width: 1.sw,
                                    height: 1.h,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              pending.referenceId!.toString(),
                                              // upComing.from!.placeTitle!,
                                              style: TextStyle(
                                                  color: grey2,
                                                  fontSize: 16.sp),
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
                                              fontSize: 15.sp,
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
                                    height: 5.h,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Card(
                                            color: yellowLightColor,
                                            child: Padding(
                                              padding: EdgeInsets.all(15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Days',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 13.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      '${pending.days!.length} Days',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: rough,
                                            child: Padding(
                                              padding: EdgeInsets.all(15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Start Date',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 12.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd()
                                                          .format(startDate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'End Date',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 12.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd()
                                                          .format(endDate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: blueLight,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.r),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Cost',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 13.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      pending.totalPrice
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      defaultButton2(
                                          press: () {
                                            RequestCubit.get(context)
                                                .editRequest(
                                                    pending.id!, "accept");
                                          },
                                          text: "Accept",
                                          backColor: greenColor,
                                          textColor: white),
                                      defaultButton2(
                                          press: () {
                                            RequestCubit.get(context)
                                                .editRequest(
                                                    pending.id!, "reject");
                                          },
                                          colorBorder: true,
                                          text: "Reject",
                                          backColor: white,
                                          textColor: grey2),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {},
                      );
                    },
                  ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _tabController!.animateTo(_currentIndex);
              // _tabController!.index = _currentIndex;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: primaryColor,
          selectedItemColor: accentColor,
          unselectedItemColor: grey,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "current "),
            BottomNavigationBarItem(
                icon: Icon(Icons.upcoming), label: "upcoming "),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_outlined), label: "past "),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_outlined), label: "pending "),
          ],
        ),
      );
    });
  }

  void registerNotification() async {
    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    print('token=****************** $idToken');
    _messaging.getToken().then((token) {
      // token = "d7HPsTnxS6y7vuIyPGv1xJ:APA91bFqL-P90luB2ciiYueBS2AbeanvodSA0MCmIsUuOQEJdWY8dzEtozkRyy8YV1z-YJiao1phhCu9Ej17gBWob9XqL1jZvsGHsCpBMpyncz14Ixbp1C0N-8RDLnZuPCcuNm9_4Jnb";
      print('token fcm=****************** $token');
    });
    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
      // 1. This method call when app in terminated state and you get a notification
      // when you click on notification app open from terminated state and you can get notification data in this method
      _messaging.getInitialMessage().then((RemoteMessage? message) {
        if (kDebugMode) {
          print(
              "FirebaseMessaging.instance.getInitialMessage********${message?.data}");
        }
        if (message != null) {
          if (kDebugMode) {
            print("New Notification********");
          }

          if (message.data['title_en'] != null) {}
        }
      });

      // 2. This method only call when App in forground it mean app must be opened
      FirebaseMessaging.onMessage.listen(
        (message) {
          if (kDebugMode) {
            print("FirebaseMessaging.onMessage.listenhhh********${message}");
          }
          RequestCubit.get(context).indexUpComing = 1;
          RequestCubit.get(context).getRequestUpComing(1);
          typeRequest = "upComing";
          _tabController!.animateTo(1);
          if (message.notification != null) {
            if (kDebugMode) {
              print("message.datatitle***** ${message.notification!.title}");
              print("message.databody***** ${message.notification!.body}");
              print("message.data11***** ${message.data}");
            }
            LocalNotificationService.createAndDisplayNotification(message);
          }
        },
      );

      // 3. This method only call when App in background and not terminated(not closed)
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) {
          if (kDebugMode) {
            print(
                "FirebaseMessaging.onMessageOpenedApp.listen********${message.data}");
          }
          if (message.notification != null) {
            if (kDebugMode) {
              print(message.notification!.title);
              print(message.notification!.body);
              print("message.data22 ********${message.data}");
            }
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => const RequestScreen(),
            //   ),
            // );
            // LocalNotificationService.createAndDisplayNotification(message);
          }
        },
      );
    }
  }

  void _configureSelectNotificationSubject() {
    LocalNotificationService.selectNotificationStream.stream
        .listen((String? payload) async {
      print("payload************ $payload");
      // RequestCubit.get(context).indexUpComing = 1;
      // RequestCubit.get(context).getRequestUpComing(1);
      // typeRequest = "upComing";
      // _tabController!.animateTo(1);
      // await Navigator.of(context).push(MaterialPageRoute<void>(
      //   builder: (BuildContext context) => SecondPage(payload),
      // ));
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    LocalNotificationService.didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                print(
                    "_configureDidReceiveLocalNotificationSubject*************");
                // await Navigator.of(context).push(
                //   MaterialPageRoute<void>(
                //     builder: (BuildContext context) =>
                //         SecondPage(receivedNotification.payload),
                //   ),
                // );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }
}

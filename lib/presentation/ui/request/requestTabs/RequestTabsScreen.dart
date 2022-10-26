import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/auth/CarRegistrationScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/RequestDetailsScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/request_cubit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestTabsScreen extends StatefulWidget {
  const RequestTabsScreen({Key? key, this.screenNotify}) : super(key: key);
  final String? screenNotify;

  @override
  State<RequestTabsScreen> createState() => _RequestTabsScreenState();
}

class _RequestTabsScreenState extends State<RequestTabsScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late ScrollController _controllerUpcoming;
  late ScrollController _controllerPast;
  late ScrollController _controllerPending;
  bool loadingUpComing = false;
  bool firstClickTabController = false;
  double _userRating = 3.0;
  var formKeyRequest = GlobalKey<FormState>();
  var commentController = TextEditingController();
  String typeEditPending = "";
  int? indexPending;

  @override
  void initState() {
    super.initState();

    getIt<SharedPreferences>().setString('typeScreen', "request");

    _controllerUpcoming = ScrollController();
    _controllerPast = ScrollController();
    _controllerPending = ScrollController();

    RequestCubit.get(context).tabController =
        TabController(length: 4, vsync: this);

    if (widget.screenNotify != null &&
        widget.screenNotify == "RequestPending") {
      _currentIndex = 3;
      RequestCubit.get(context).tabController!.index = 3;
    }

    // first load
    RequestCubit.get(context).getRequestCurrent(1);

    RequestCubit.get(context).tabController!.addListener(() {
      setState(() {
        // print("_currentIndex*********** ${RequestCubit.get(context).tabController!.index}");

        _currentIndex = RequestCubit.get(context).tabController!.index;
        // if(_tabController!.indexIsChanging) {
        if (_currentIndex == 0) {
          RequestCubit.get(context).getRequestCurrent(1);
          RequestCubit.get(context).typeRequest = "current";
          // getIt<SharedPreferences>()
          //     .setString('typeScreen', "RequestCurrent");
        } else if (_currentIndex == 1) {
          RequestCubit.get(context).indexUpComing = 1;
          RequestCubit.get(context).getRequestUpComing(1);
          RequestCubit.get(context).typeRequest = "upComing";
          // getIt<SharedPreferences>()
          //     .setString('typeScreen', "RequestUpComing");
        } else if (_currentIndex == 2) {
          RequestCubit.get(context).indexPast = 1;
          RequestCubit.get(context).getRequestPast(1);
          RequestCubit.get(context).typeRequest = "past";
          // getIt<SharedPreferences>()
          //     .setString('typeScreen', "RequestPast");
        } else if (_currentIndex == 3) {
          RequestCubit.get(context).indexPending = 1;
          RequestCubit.get(context).getRequestPending(1);
          RequestCubit.get(context).typeRequest = "pending";
          // getIt<SharedPreferences>()
          //     .setString('typeScreen', "RequestPending");
        }
        // }
      });
    });
  }

  @override
  void dispose() {
    // RequestCubit.get(context).tabController!.dispose();
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
        if (typeEditPending == "accept") {
          RequestCubit.get(context).indexPending = 1;
          RequestCubit.get(context).getRequestPending(1);
        } else if (typeEditPending == "reject") {
          Navigator.pop(context);
          RequestCubit.get(context).indexPast = 1;
          RequestCubit.get(context).getRequestPast(1);
          RequestCubit.get(context).typeRequest = "past";
          RequestCubit.get(context).tabController?.animateTo(2);
          _currentIndex = 2;
        }
      } else if (state is RequestEditErrorState) {
        Navigator.pop(context);
        showToastt(
            text: state.message, state: ToastStates.error, context: context);
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              navigateTo(context, const CarRegistrationScreen());
            },
            child: Text(
              'Requests',
              style: TextStyle(color: primaryColor, fontSize: 20.sp),
            ),
          ),
          centerTitle: true,
          elevation: 1.0,
        ),
        body: TabBarView(
          controller: RequestCubit.get(context).tabController,
          children: [
            state is RequestCurrentInitial
                ? const Center(
                    child: CircularProgressIndicator(
                      color: black,
                    ),
                  )
                : state is RequestCurrentErrorState
                    ? Center(
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
                                    state.message.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.sm,
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 35.h,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      RequestCubit.get(context)
                                          .getRequestCurrent(1);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: white,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.r, vertical: 10.r),
                                          child: Text(
                                            "Refresh",
                                            style: TextStyle(
                                                color: accentColor,
                                                fontSize: 20.sm),
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
                      )
                    : ListView.builder(
                        // key: const PageStorageKey<String>('tab1'),
                        scrollDirection: Axis.vertical,
                        itemCount:
                            RequestCubit.get(context).requestCurrent.length,
                        itemBuilder: (context, i) {
                          var current =
                              RequestCubit.get(context).requestCurrent[i];
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
                                                url:
                                                    current.client2!.image!.src,
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
                                                          current
                                                              .client2!.name!,
                                                          style: TextStyle(
                                                              fontSize: 17.sp,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    '${current.client2!.country?.title!.en!}, ${current.client2!.city?.title!.en!}, ${current.client2!.area?.title!.en!}',
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: grey2),
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  /*RatingBar.builder(
                                                    minRating: _userRating,
                                                    itemBuilder:
                                                        (context, index) =>
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
                                                    unratedColor: Colors.amber
                                                        .withAlpha(50),
                                                    direction: Axis.horizontal,
                                                  ),*/
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
                                            CrossAxisAlignment.start,
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 5.h),
                                                Text(
                                                  current.from!.placeTitle!,
                                                  style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 16.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    DateFormat.yMEd().format(
                                                        DateTime.parse(current
                                                            .from!.date!)),
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 14.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    DateFormat.jm().format(
                                                        DateTime.parse(current
                                                            .from!.date!)),
                                                    style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    DateFormat.yMEd().format(
                                                        DateTime.parse(
                                                            current.to!)),
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 14.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    DateFormat.jm().format(
                                                        DateTime.parse(
                                                            current.to!)),
                                                    style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
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
                                                          MainAxisAlignment
                                                              .center,
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
                                                                  FontWeight
                                                                      .bold),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Used Points',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: grey2,
                                                              fontSize: 12.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Text(
                                                          current
                                                              .totalConsumptionPoints
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: black,
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Total Distance',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: grey2,
                                                              fontSize: 12.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Text(
                                                          current.consumptionKM
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: black,
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Total Price',
                                                          textAlign:
                                                              TextAlign.center,
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
                                                                  FontWeight
                                                                      .bold),
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
                            onTap: () async {
                              await navigateToWithRefreshPagePrevious(
                                  context,
                                  RequestDetailsScreen(
                                    idRequest: current.id,
                                  ));
                              setState(() {
                                RequestCubit.get(context).getRequestCurrent(1);
                              });
                            },
                          );
                        },
                      ),
            state is RequestUpComingInitial
                ? const Center(
                    child: CircularProgressIndicator(
                      color: black,
                    ),
                  )
                : state is RequestUpComingErrorState
                    ? Center(
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
                                    state.message.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.sm,
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 35.h,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      RequestCubit.get(context)
                                          .getRequestUpComing(1);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: white,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.r, vertical: 10.r),
                                          child: Text(
                                            "Refresh",
                                            style: TextStyle(
                                                color: accentColor,
                                                fontSize: 20.sm),
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
                      )
                    : ListView.builder(
                        controller: _controllerUpcoming
                          ..addListener(() async {
                            if (_controllerUpcoming.position.extentAfter == 0) {
                              if (RequestCubit.get(context).loadingUpComing &&
                                  RequestCubit.get(context).typeRequest ==
                                      "upComing") {
                                print("_controllerUpcoming*********** ");
                                _loadMoreUpComing();
                              }
                            }
                          }),
                        // key: const PageStorageKey<String>('tab2'),
                        scrollDirection: Axis.vertical,
                        itemCount:
                            RequestCubit.get(context).requestUpComing.length,
                        itemBuilder: (context, i) {
                          var upComing =
                              RequestCubit.get(context).requestUpComing[i];
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
                                                url: upComing
                                                    .client2!.image!.src,
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
                                                          upComing
                                                              .client2!.name!,
                                                          style: TextStyle(
                                                              fontSize: 17.sp,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    '${upComing.client2!.country?.title!.en!}, ${upComing.client2!.city?.title!.en!}, ${upComing.client2!.area?.title!.en!}',
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: grey2),
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                 /* RatingBar.builder(
                                                    minRating: _userRating,
                                                    itemBuilder:
                                                        (context, index) =>
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
                                                    unratedColor: Colors.amber
                                                        .withAlpha(50),
                                                    direction: Axis.horizontal,
                                                  ),*/
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
                                            CrossAxisAlignment.start,
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 5.h),
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
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    DateFormat.yMEd().format(
                                                        DateTime.parse(upComing
                                                            .from!.date!)),
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 14.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    DateFormat.jm().format(
                                                        DateTime.parse(upComing
                                                            .from!.date!)),
                                                    style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    DateFormat.yMEd().format(
                                                        DateTime.parse(
                                                            upComing.to!)),
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 14.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    DateFormat.jm().format(
                                                        DateTime.parse(
                                                            upComing.to!)),
                                                    style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
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
                                                          MainAxisAlignment
                                                              .center,
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
                                                                  FontWeight
                                                                      .bold),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Used Points',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: grey2,
                                                              fontSize: 12.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Text(
                                                          upComing
                                                              .totalConsumptionPoints
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: black,
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Total Distance',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: grey2,
                                                              fontSize: 13.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Text(
                                                          upComing.consumptionKM
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: black,
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Total Price',
                                                          textAlign:
                                                              TextAlign.center,
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
                                                                  FontWeight
                                                                      .bold),
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
                            onTap: () async {
                              await navigateToWithRefreshPagePrevious(
                                  context,
                                  RequestDetailsScreen(
                                    idRequest: upComing.id,
                                  ));
                              setState(() {
                                RequestCubit.get(context).getRequestUpComing(1);
                              });
                            },
                          );
                        },
                      ),
            state is RequestPastInitial
                ? const Center(
                    child: CircularProgressIndicator(
                    color: black,
                  ))
                : state is RequestPastErrorState
                    ? Center(
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
                                    state.message.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.sm,
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 35.h,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      RequestCubit.get(context)
                                          .getRequestPast(1);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: white,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.r, vertical: 10.r),
                                          child: Text(
                                            "Refresh",
                                            style: TextStyle(
                                                color: accentColor,
                                                fontSize: 20.sm),
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
                      )
                    : ListView.builder(
                        controller: _controllerPast
                          ..addListener(() async {
                            if (_controllerPast.position.extentAfter == 0) {
                              print(
                                  '_controllerPast00*******${RequestCubit.get(context).loadingPast}');
                              if (RequestCubit.get(context).loadingPast &&
                                  RequestCubit.get(context).typeRequest ==
                                      "past") {
                                _loadMorePast();
                              }
                            }
                          }),
                        // key: const PageStorageKey<String>('tab2'),
                        scrollDirection: Axis.vertical,
                        itemCount: RequestCubit.get(context).requestPast.length,
                        itemBuilder: (context, i) {
                          var past = RequestCubit.get(context).requestPast[i];

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
                                                url: past.client2!.image!.src,
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
                                                          past.client2!.name!,
                                                          style: TextStyle(
                                                              fontSize: 17.sp,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    '${past.client2!.country?.title!.en!}, ${past.client2!.city?.title!.en!}, ${past.client2!.area?.title!.en!}',
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: grey2),
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  /*RatingBar.builder(
                                                    minRating: _userRating,
                                                    itemBuilder:
                                                        (context, index) =>
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
                                                    unratedColor: Colors.amber
                                                        .withAlpha(50),
                                                    direction: Axis.horizontal,
                                                  ),*/
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
                                            CrossAxisAlignment.start,
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 5.h),
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
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    DateFormat.yMEd().format(
                                                        DateTime.parse(
                                                            past.from!.date!)),
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 14.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    DateFormat.jm().format(
                                                        DateTime.parse(
                                                            past.from!.date!)),
                                                    style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    DateFormat.yMEd().format(
                                                        DateTime.parse(
                                                            past.to!)),
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 14.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    DateFormat.jm().format(
                                                        DateTime.parse(
                                                            past.to!)),
                                                    style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
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
                                                          MainAxisAlignment
                                                              .center,
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
                                                                  FontWeight
                                                                      .bold),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Used Points',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: grey2,
                                                              fontSize: 12.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Text(
                                                          past.totalConsumptionPoints
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: black,
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Total Distance',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: grey2,
                                                              fontSize: 12.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Text(
                                                          past.consumptionKM
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: black,
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Total Price',
                                                          textAlign:
                                                              TextAlign.center,
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
                                                                  FontWeight
                                                                      .bold),
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
                            onTap: () async {
                              await navigateToWithRefreshPagePrevious(
                                  context,
                                  RequestDetailsScreen(
                                    idRequest: past.id,
                                    typeScreen: "past",
                                  ));
                              setState(() {
                                RequestCubit.get(context).getRequestPast(1);
                              });
                            },
                          );
                        },
                      ),
            state is RequestPendingInitial
                ? const Center(
                    child: CircularProgressIndicator(
                    color: black,
                  ))
                : state is RequestPendingErrorState
                    ? Center(
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
                                    state.message.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.sm,
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 35.h,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      RequestCubit.get(context)
                                          .getRequestPending(1);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: white,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.r, vertical: 10.r),
                                          child: Text(
                                            "Refresh",
                                            style: TextStyle(
                                                color: accentColor,
                                                fontSize: 20.sm),
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
                      )
                    : ListView.builder(
                        controller: _controllerPending
                          ..addListener(() async {
                            if (_controllerPending.position.extentAfter == 0) {

                              if (RequestCubit.get(context).loadingPending &&
                                  RequestCubit.get(context).typeRequest ==
                                      "pending") {
                                if (kDebugMode) {
                                  print(
                                      '_controllerPending00*******${RequestCubit.get(context).loadingPending}');
                                }
                                _loadMorePending();
                              }
                            }
                          }),
                        // key: const PageStorageKey<String>('tab2'),
                        scrollDirection: Axis.vertical,
                        itemCount:
                            RequestCubit.get(context).requestPending.length,
                        itemBuilder: (context, i) {
                          var pending =
                              RequestCubit.get(context).requestPending[i];
                          final loadAcceptVisible = i == indexPending;

                          return Container(
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
                                                                FontWeight
                                                                    .bold),
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
                                                /*RatingBar.builder(
                                                  minRating: _userRating,
                                                  itemBuilder:
                                                      (context, index) =>
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
                                                  unratedColor: Colors.amber
                                                      .withAlpha(50),
                                                  direction: Axis.horizontal,
                                                ),*/
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
                                          CrossAxisAlignment.start,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                pending.from!.placeTitle!,
                                                // upComing.from!.placeTitle!,
                                                style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 16.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  DateFormat.yMEd().format(
                                                      DateTime.parse(
                                                          pending.from!.date!)),
                                                  style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp),
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  DateFormat.jm().format(
                                                      DateTime.parse(
                                                          pending.from!.date!)),
                                                  style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  DateFormat.yMEd().format(
                                                      DateTime.parse(
                                                          pending.to!)),
                                                  style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp),
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  DateFormat.jm().format(
                                                      DateTime.parse(
                                                          pending.to!)),
                                                  style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ],
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
                                                        MainAxisAlignment
                                                            .center,
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
                                                                FontWeight
                                                                    .bold),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Used Points',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: grey2,
                                                            fontSize: 12.sp),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        pending
                                                            .totalConsumptionPoints
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize: 13.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Total Distance',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: grey2,
                                                            fontSize: 12.sp),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        pending.consumptionKM
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize: 13.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Total Price',
                                                        textAlign:
                                                            TextAlign.center,
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
                                                                FontWeight
                                                                    .bold),
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
                                    pending.status == "pending"
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              loadAcceptVisible
                                                  ? state is! RequestEditInitial
                                                      ? defaultButton2(
                                                          press: () {
                                                            typeEditPending =
                                                                "accept";
                                                            RequestCubit.get(
                                                                    context)
                                                                .editRequest(
                                                                    pending.id!,
                                                                    "accept",
                                                                    "");
                                                            setState(() {
                                                              indexPending = i;
                                                            });
                                                          },
                                                          text: "Accept",
                                                          backColor: greenColor,
                                                          textColor: white)
                                                      : const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: accentColor,
                                                          ),
                                                        )
                                                  : defaultButton2(
                                                      press: () {
                                                        typeEditPending =
                                                            "accept";
                                                        RequestCubit.get(
                                                                context)
                                                            .editRequest(
                                                                pending.id!,
                                                                "accept",
                                                                "");
                                                        setState(() {
                                                          indexPending = i;
                                                        });
                                                      },
                                                      text: "Accept",
                                                      backColor: greenColor,
                                                      textColor: white),
                                              defaultButton2(
                                                press: () {
                                                  typeEditPending = "reject";
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    // outside to dismiss
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomDialog(
                                                        title:
                                                            'Do you want to reject?',
                                                        description:
                                                            'If you want to be rejected, you must first enter the reason for rejection and press OK..',
                                                        backgroundColor: white,
                                                        btnOkColor: accentColor,
                                                        btnCancelColor: grey,
                                                        id: pending.id,
                                                        titleColor: accentColor,
                                                        descColor: black,
                                                      );
                                                    },
                                                  );
                                                },
                                                colorBorder: true,
                                                text: "Reject",
                                                backColor: white,
                                                textColor: grey2,
                                              ),
                                            ],
                                          )
                                        : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            defaultButton2(
                                              press: () {
                                                typeEditPending = "reject";
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  // outside to dismiss
                                                  builder:
                                                      (BuildContext context) {
                                                    return CustomDialog(
                                                      title:
                                                          'Do you want to reject?',
                                                      description:
                                                          'If you want to be rejected, you must first enter the reason for rejection and press OK..',
                                                      backgroundColor: white,
                                                      btnOkColor: accentColor,
                                                      btnCancelColor: grey,
                                                      id: pending.id,
                                                      titleColor: accentColor,
                                                      descColor: black,
                                                    );
                                                  },
                                                );
                                              },
                                              colorBorder: true,
                                              text: "Reject",
                                              backColor: white,
                                              textColor: grey2,
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                              Text(
                                                '${pending.client2?.name} not paid yet..',
                                                style: TextStyle(
                                                    color: accentColor,
                                                    fontSize: 18.sp),
                                              )
                                            ],
                                        ),
                                    SizedBox(
                                      height: 5.h,
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
        drawer: const DrawerMenu(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              RequestCubit.get(context).tabController!.animateTo(_currentIndex);
              // _tabController!.index = _currentIndex;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: primaryColor,
          selectedItemColor: accentColor,
          unselectedItemColor: grey,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "current"),
            BottomNavigationBarItem(
                icon: Icon(Icons.upcoming), label: "upcoming"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_outlined), label: "past"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_outlined), label: "pending"),
          ],
        ),
      );
    });
  }
}

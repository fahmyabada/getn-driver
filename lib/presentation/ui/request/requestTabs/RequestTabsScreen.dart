import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/main_cubit.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/RequestDetailsScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/request_cubit.dart';
import 'package:intl/intl.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
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
  bool firstClickTabController = false;
  bool loadingMorePast = false;
  bool loadingMoreUpComing = false;
  bool loadingMorePending = false;
  String typeEditPending = "";
  int? indexPending;

  var btnStatus3 = {
    'pending': 'Pending',
    'accept': 'Accept',
    'on_my_way': 'On My Way',
    'arrive': 'Arrive',
    'coming': 'Coming',
    'start': 'Start',
    'end': 'End',
    'mid_pause': 'Mid Pause',
    'reject': 'Reject',
    'cancel': 'Cancel',
    'need_confirm': 'Need Confirm',
    'paid': 'Paid'
  };

  @override
  void initState() {
    super.initState();

    RequestCubit.get(context).editFcmToken();
    getIt<SharedPreferences>().setString('typeScreen', "request");

    MainCubit.get(context).tabController =
        TabController(length: 4, vsync: this);

    if (widget.screenNotify != null &&
        widget.screenNotify == "RequestPending") {
      _currentIndex = 3;
      MainCubit.get(context).tabController!.index = 2;
    }

    // first load
    RequestCubit.get(context).getRequestCurrent(1);

    MainCubit.get(context).tabController!.addListener(() {
      setState(() {
        print("_currentIndex*********** ");

        _currentIndex = MainCubit.get(context).tabController!.index;
        if (MainCubit.get(context).tabController!.indexIsChanging && MainCubit.get(context).tabControllerChanged) {
          print("_currentIndex***********0 ");
          if (_currentIndex == 0) {
            RequestCubit.get(context).getRequestCurrent(1);
            MainCubit.get(context).typeRequest = "current";
          } else if (_currentIndex == 1) {
            RequestCubit.get(context).indexUpComing = 1;
            RequestCubit.get(context).getRequestUpComing(1);
            MainCubit.get(context).typeRequest = "upComing";
          } else if (_currentIndex == 2) {
            RequestCubit.get(context).indexPast = 1;
            RequestCubit.get(context).getRequestPast(1);
            MainCubit.get(context).typeRequest = "past";
          } else if (_currentIndex == 3) {
            RequestCubit.get(context).indexPending = 1;
            RequestCubit.get(context).getRequestPending(1);
            MainCubit.get(context).typeRequest = "pending";
          }
        }else if (!MainCubit.get(context).tabController!.indexIsChanging && !MainCubit.get(context).tabControllerChanged){
          print("_currentIndex***********1 ");
          if (_currentIndex == 0) {
            RequestCubit.get(context).getRequestCurrent(1);
            MainCubit.get(context).typeRequest = "current";
          } else if (_currentIndex == 1) {
            RequestCubit.get(context).indexUpComing = 1;
            RequestCubit.get(context).getRequestUpComing(1);
            MainCubit.get(context).typeRequest = "upComing";
          } else if (_currentIndex == 2) {
            RequestCubit.get(context).indexPast = 1;
            RequestCubit.get(context).getRequestPast(1);
            MainCubit.get(context).typeRequest = "past";
          } else if (_currentIndex == 3) {
            RequestCubit.get(context).indexPending = 1;
            RequestCubit.get(context).getRequestPending(1);
            MainCubit.get(context).typeRequest = "pending";
          }
        }
        // else if (MainCubit.get(context).tabController!.index )
      });
    });
  }

  void _loadMoreUpComing() {
    RequestCubit.get(context)
        .getRequestUpComing(RequestCubit.get(context).indexUpComing);
  }

  void _loadMorePast() {
    RequestCubit.get(context)
        .getRequestPast(RequestCubit.get(context).indexPast);
  }

  void _loadMorePending() {
    RequestCubit.get(context)
        .getRequestPending(RequestCubit.get(context).indexPending);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestCubit, RequestState>(listener: (context, state) {
      if (state is RequestEditSuccessState) {
        if (state.data!.status! == "accept") {
          MainCubit.get(context).tabControllerChanged = false;
          MainCubit.get(context).tabController!.index = 3;
          MainCubit.get(context)
              .tabController!
              .notifyListeners();
        }
      } else if (state is RequestEditErrorState) {
        MainCubit.get(context).tabControllerChanged = false;
        MainCubit.get(context).tabController!.index = 3;
        MainCubit.get(context)
            .tabController!
            .notifyListeners();
        showToastt(
            text: state.message, state: ToastStates.error, context: context);
      } else if (state is RequestPastSuccessState) {
        setState(() {
          loadingMorePast = false;
        });
      } else if (state is RequestPastErrorState) {
        setState(() {
          loadingMorePast = false;
        });
      } else if (state is RequestUpComingSuccessState) {
        setState(() {
          loadingMoreUpComing = false;
        });
      } else if (state is RequestUpComingErrorState) {
        setState(() {
          loadingMoreUpComing = false;
        });
      } else if (state is RequestPendingSuccessState) {
        setState(() {
          loadingMorePending = false;
        });
      } else if (state is RequestPendingErrorState) {
        setState(() {
          loadingMorePending = false;
        });
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
          controller: MainCubit.get(context).tabController,
          children: [
            RequestCubit.get(context).loadingCurrent
                ? loading()
                : state is RequestCurrentSuccessState
                    ? RequestCubit.get(context).requestCurrent.isEmpty
                        ? errorMessage(
                            message: "Not Found Data",
                            press: () {
                              RequestCubit.get(context).getRequestCurrent(1);
                            })
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
                                                    url: current
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              current.client2!
                                                                  .name!,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      17.sp,
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
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.r),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'refId: ${current.referenceId}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: black,
                                                      fontSize: 18.sp,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'status: ${btnStatus3[current.status]}',
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                      color: black,
                                                      fontSize: 18.sp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
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
                                                        DateFormat.yMEd()
                                                            .format(DateTime
                                                                .parse(current
                                                                    .from!
                                                                    .date!)),
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
                                                                current.from!
                                                                    .date!)),
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
                                                        DateFormat.yMEd()
                                                            .format(
                                                                DateTime.parse(
                                                                    current
                                                                        .to!)),
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
                                                      padding:
                                                          EdgeInsets.all(15.r),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Days',
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                            Text(
                                                              '${current.days!.length} Days',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: black,
                                                                  fontSize:
                                                                      13.sp,
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
                                                      padding:
                                                          EdgeInsets.all(15.r),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Used Points',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      12.sp),
                                                            ),
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                            Text(
                                                              current
                                                                  .totalConsumptionPoints
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: black,
                                                                  fontSize:
                                                                      13.sp,
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
                                                      padding:
                                                          EdgeInsets.all(15.r),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Total Distance',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      12.sp),
                                                            ),
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                            Text(
                                                              current
                                                                  .consumptionKM
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: black,
                                                                  fontSize:
                                                                      13.sp,
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 15.r),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Total Price',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                            Text(
                                                              current.totalPrice
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: black,
                                                                  fontSize:
                                                                      13.sp,
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
                                    RequestCubit.get(context)
                                        .getRequestCurrent(1);
                                  });
                                },
                              );
                            },
                          )
                    : state is RequestCurrentErrorState
                        ? errorMessage(
                            message: state.message,
                            press: () {
                              RequestCubit.get(context).getRequestCurrent(1);
                            })
                        : Container(),
            RequestCubit.get(context).loadingUpComing
                ? loading()
                : state is RequestUpComingSuccessState
                    ? RequestCubit.get(context).requestUpComing.isEmpty
                        ? errorMessage(
                            message: "Not Found Data",
                            press: () {
                              RequestCubit.get(context).getRequestUpComing(1);
                            })
                        : ScrollEdgeListener(
                            edge: ScrollEdge.end,
                            // edgeOffset: 400,
                            // continuous: false,
                            // debounce: const Duration(milliseconds: 500),
                            // dispatch: true,
                            listener: () {
                              if (MainCubit.get(context).typeRequest ==
                                  "upComing") {
                                print("_controllerUpcoming*********** ");
                                setState(() {
                                  loadingMoreUpComing = true;
                                });
                                _loadMoreUpComing();
                              }
                            },
                            child: ListView.builder(
                              // key: const PageStorageKey<String>('tab2'),
                              scrollDirection: Axis.vertical,
                              itemCount: RequestCubit.get(context)
                                  .requestUpComing
                                  .length,
                              itemBuilder: (context, i) {
                                var upComing = RequestCubit.get(context)
                                    .requestUpComing[i];
                                return Column(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.r, vertical: 10.r),
                                        child: Card(
                                          elevation: 5.r,
                                          clipBehavior: Clip.antiAlias,
                                          child: Container(
                                            color: white,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.r,
                                                horizontal: 7.r),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Row(
                                                  children: [
                                                    ClipOval(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: ImageTools.image(
                                                          fit: BoxFit.fill,
                                                          url: upComing.client2!
                                                              .image!.src,
                                                          height: 70.w,
                                                          width: 70.w),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.r),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    upComing
                                                                        .client2!
                                                                        .name!,
                                                                    style: TextStyle(
                                                                        fontSize: 17
                                                                            .sp,
                                                                        color:
                                                                            black,
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
                                                              '${upComing.client2!.country?.title!.en!}, ${upComing.client2!.city?.title!.en!}, ${upComing.client2!.area?.title!.en!}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      15.sp,
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
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.r),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'refId: ${upComing.referenceId}',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: black,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'status: ${btnStatus3[upComing.status]}',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            color: black,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Picked Point',
                                                            style: TextStyle(
                                                                color: black,
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(height: 5.h),
                                                          Text(
                                                            upComing.from!
                                                                .placeTitle!,
                                                            // upComing.from!.placeTitle!,
                                                            style: TextStyle(
                                                                color: grey2,
                                                                fontSize:
                                                                    16.sp),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              DateFormat.yMEd()
                                                                  .format(DateTime
                                                                      .parse(upComing
                                                                          .from!
                                                                          .date!)),
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      14.sp),
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            Text(
                                                              DateFormat.jm().format(
                                                                  DateTime.parse(
                                                                      upComing
                                                                          .from!
                                                                          .date!)),
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
                                                              DateFormat.yMEd()
                                                                  .format(DateTime
                                                                      .parse(upComing
                                                                          .to!)),
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      14.sp),
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            Text(
                                                              DateFormat.jm().format(
                                                                  DateTime.parse(
                                                                      upComing
                                                                          .to!)),
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Card(
                                                          color:
                                                              yellowLightColor,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15.r),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Days',
                                                                    style: TextStyle(
                                                                        color:
                                                                            grey2,
                                                                        fontSize:
                                                                            13.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Text(
                                                                    '${upComing.days!.length} Days',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize: 13
                                                                            .sp,
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
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15.r),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Used Points',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            grey2,
                                                                        fontSize:
                                                                            12.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Text(
                                                                    upComing
                                                                        .totalConsumptionPoints
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize: 13
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Card(
                                                          color:
                                                              greenLightColor,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15.r),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Total Distance',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            grey2,
                                                                        fontSize:
                                                                            13.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Text(
                                                                    upComing
                                                                        .consumptionKM
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize: 13
                                                                            .sp,
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
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        15.r),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Total Price',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            grey2,
                                                                        fontSize:
                                                                            13.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Text(
                                                                    upComing
                                                                        .totalPrice
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize: 13
                                                                            .sp,
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
                                      onTap: () async {
                                        await navigateToWithRefreshPagePrevious(
                                            context,
                                            RequestDetailsScreen(
                                              idRequest: upComing.id,
                                            ));
                                        setState(() {
                                          RequestCubit.get(context)
                                              .getRequestUpComing(1);
                                        });
                                      },
                                    ),
                                    i ==
                                                RequestCubit.get(context)
                                                        .requestUpComing
                                                        .length -
                                                    1 &&
                                            loadingMoreUpComing
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              loading(),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                          )
                    : state is RequestUpComingErrorState
                        ? errorMessage(
                            message: state.message,
                            press: () {
                              RequestCubit.get(context).getRequestUpComing(1);
                            })
                        : Container(),
            RequestCubit.get(context).loadingPast
                ? loading()
                : state is RequestPastSuccessState
                    ? RequestCubit.get(context).requestPast.isEmpty
                        ? errorMessage(
                            message: "Not Found Data",
                            press: () {
                              RequestCubit.get(context).getRequestPast(1);
                            })
                        : ScrollEdgeListener(
                            edge: ScrollEdge.end,
                            // edgeOffset: 400,
                            // continuous: false,
                            // debounce: const Duration(milliseconds: 500),
                            // dispatch: true,
                            listener: () {
                              if (MainCubit.get(context).typeRequest ==
                                  "past") {
                                setState(() {
                                  print("_controllerPast*********** ");
                                  loadingMorePast = true;
                                });
                                _loadMorePast();
                              }
                            },
                            child: ListView.builder(
                              // key: const PageStorageKey<String>('tab2'),
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  RequestCubit.get(context).requestPast.length,
                              itemBuilder: (context, i) {
                                var past =
                                    RequestCubit.get(context).requestPast[i];

                                return Column(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.r, vertical: 10.r),
                                        child: Card(
                                          elevation: 5.r,
                                          clipBehavior: Clip.antiAlias,
                                          child: Container(
                                            color: white,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.r,
                                                horizontal: 7.r),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Row(
                                                  children: [
                                                    ClipOval(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: ImageTools.image(
                                                          fit: BoxFit.fill,
                                                          url: past.client2!
                                                              .image!.src,
                                                          height: 70.w,
                                                          width: 70.w),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.r),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    past.client2!
                                                                        .name!,
                                                                    style: TextStyle(
                                                                        fontSize: 17
                                                                            .sp,
                                                                        color:
                                                                            black,
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
                                                              '${past.client2!.country?.title!.en!}, ${past.client2!.city?.title!.en!}, ${past.client2!.area?.title!.en!}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      15.sp,
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
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.r),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'refId: ${past.referenceId}',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: black,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'status: ${btnStatus3[past.status]}',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            color: black,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Picked Point',
                                                            style: TextStyle(
                                                                color: black,
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(height: 5.h),
                                                          Text(
                                                            past.from!
                                                                .placeTitle!,
                                                            // past.from!.placeTitle!,
                                                            style: TextStyle(
                                                                color: grey2,
                                                                fontSize:
                                                                    16.sp),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              DateFormat.yMEd()
                                                                  .format(DateTime
                                                                      .parse(past
                                                                          .from!
                                                                          .date!)),
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      14.sp),
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            Text(
                                                              DateFormat.jm()
                                                                  .format(DateTime
                                                                      .parse(past
                                                                          .from!
                                                                          .date!)),
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
                                                              DateFormat.yMEd()
                                                                  .format(DateTime
                                                                      .parse(past
                                                                          .to!)),
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      14.sp),
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            Text(
                                                              DateFormat.jm()
                                                                  .format(DateTime
                                                                      .parse(past
                                                                          .to!)),
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Card(
                                                          color:
                                                              yellowLightColor,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15.r),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Days',
                                                                    style: TextStyle(
                                                                        color:
                                                                            grey2,
                                                                        fontSize:
                                                                            13.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Text(
                                                                    '${past.days!.length} Days',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize: 13
                                                                            .sp,
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
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15.r),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Used Points',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            grey2,
                                                                        fontSize:
                                                                            12.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Text(
                                                                    past.totalConsumptionPoints
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize: 13
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Card(
                                                          color:
                                                              greenLightColor,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15.r),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Total Distance',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            grey2,
                                                                        fontSize:
                                                                            12.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Text(
                                                                    past.consumptionKM
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize: 13
                                                                            .sp,
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
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        15.r),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Total Price',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            grey2,
                                                                        fontSize:
                                                                            13.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Text(
                                                                    past.totalPrice
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize: 13
                                                                            .sp,
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
                                      onTap: () async {
                                        await navigateToWithRefreshPagePrevious(
                                            context,
                                            RequestDetailsScreen(
                                              idRequest: past.id,
                                              typeScreen: "past",
                                            ));
                                        setState(() {
                                          RequestCubit.get(context)
                                              .getRequestPast(1);
                                        });
                                      },
                                    ),
                                    i ==
                                                RequestCubit.get(context)
                                                        .requestPast
                                                        .length -
                                                    1 &&
                                            loadingMorePast
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              loading(),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                          )
                    : state is RequestPastErrorState
                        ? errorMessage(
                            message: state.message,
                            press: () {
                              RequestCubit.get(context).getRequestPast(1);
                            })
                        : Container(),
            RequestCubit.get(context).loadingPending
                ? loading()
                : state is RequestPendingSuccessState
                    ? RequestCubit.get(context).requestPending.isEmpty
                        ? errorMessage(
                            message: "Not Found Data",
                            press: () {
                              RequestCubit.get(context).getRequestPending(1);
                            })
                        : ScrollEdgeListener(
                            edge: ScrollEdge.end,
                            // edgeOffset: 400,
                            // continuous: false,
                            // debounce: const Duration(milliseconds: 500),
                            // dispatch: true,
                            listener: () {
                              if (MainCubit.get(context).typeRequest ==
                                  "pending") {
                                if (kDebugMode) {
                                  print('_controllerPending*******');
                                }
                                setState(() {
                                  loadingMorePending = true;
                                });
                                _loadMorePending();
                              }
                            },
                            child: ListView.builder(
                              // key: const PageStorageKey<String>('tab2'),
                              scrollDirection: Axis.vertical,
                              itemCount: RequestCubit.get(context)
                                  .requestPending
                                  .length,
                              itemBuilder: (context, i) {
                                var pending =
                                    RequestCubit.get(context).requestPending[i];
                                final loadAcceptVisible = i == indexPending;

                                return Column(
                                  children: [
                                    Container(
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
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: ImageTools.image(
                                                        fit: BoxFit.fill,
                                                        url: pending.client2!
                                                            .image!.src,
                                                        height: 70.w,
                                                        width: 70.w),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.r),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  pending
                                                                      .client2!
                                                                      .name!,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17.sp,
                                                                      color:
                                                                          black,
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Picked Point',
                                                          style: TextStyle(
                                                              color: black,
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(height: 5.h),
                                                        Text(
                                                          pending.from!
                                                              .placeTitle!,
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            DateFormat.yMEd()
                                                                .format(DateTime
                                                                    .parse(pending
                                                                        .from!
                                                                        .date!)),
                                                            style: TextStyle(
                                                                color: grey2,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Text(
                                                            DateFormat.jm()
                                                                .format(DateTime
                                                                    .parse(pending
                                                                        .from!
                                                                        .date!)),
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
                                                            DateFormat.yMEd()
                                                                .format(DateTime
                                                                    .parse(pending
                                                                        .to!)),
                                                            style: TextStyle(
                                                                color: grey2,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Text(
                                                            DateFormat.jm()
                                                                .format(DateTime
                                                                    .parse(pending
                                                                        .to!)),
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
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15.r),
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Days',
                                                                  style: TextStyle(
                                                                      color:
                                                                          grey2,
                                                                      fontSize:
                                                                          13.sp),
                                                                ),
                                                                SizedBox(
                                                                  height: 5.h,
                                                                ),
                                                                Text(
                                                                  '${pending.days!.length} Days',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          black,
                                                                      fontSize:
                                                                          13.sp,
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
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15.r),
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Used Points',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          grey2,
                                                                      fontSize:
                                                                          12.sp),
                                                                ),
                                                                SizedBox(
                                                                  height: 5.h,
                                                                ),
                                                                Text(
                                                                  pending
                                                                      .totalConsumptionPoints
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          black,
                                                                      fontSize:
                                                                          13.sp,
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
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15.r),
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Total Distance',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          grey2,
                                                                      fontSize:
                                                                          12.sp),
                                                                ),
                                                                SizedBox(
                                                                  height: 5.h,
                                                                ),
                                                                Text(
                                                                  pending
                                                                      .consumptionKM
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          black,
                                                                      fontSize:
                                                                          13.sp,
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
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      15.r),
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Total Price',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          grey2,
                                                                      fontSize:
                                                                          13.sp),
                                                                ),
                                                                SizedBox(
                                                                  height: 5.h,
                                                                ),
                                                                Text(
                                                                  pending
                                                                      .totalPrice
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          black,
                                                                      fontSize:
                                                                          13.sp,
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
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        loadAcceptVisible
                                                            ? state
                                                                    is! RequestEditInitial
                                                                ? defaultButton2(
                                                                    press: () {
                                                                      RequestCubit.get(context).editRequest(
                                                                          pending
                                                                              .id!,
                                                                          "accept",
                                                                          "");
                                                                      setState(
                                                                          () {
                                                                        indexPending =
                                                                            i;
                                                                      });
                                                                    },
                                                                    text:
                                                                        "Accept",
                                                                    backColor:
                                                                        greenColor,
                                                                    textColor:
                                                                        white)
                                                                : loading()
                                                            : defaultButton2(
                                                                press: () {
                                                                  RequestCubit.get(
                                                                          context)
                                                                      .editRequest(
                                                                          pending
                                                                              .id!,
                                                                          "accept",
                                                                          "");
                                                                  setState(() {
                                                                    indexPending =
                                                                        i;
                                                                  });
                                                                },
                                                                text: "Accept",
                                                                backColor:
                                                                    greenColor,
                                                                textColor:
                                                                    white),
                                                        defaultButton2(
                                                          press: () {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              // outside to dismiss
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return BlocProvider(
                                                                  create: (context) =>
                                                                      RequestCubit(),
                                                                  child:
                                                                      CustomDialogRequestTabs(
                                                                    title:
                                                                        'Do you want to reject?',
                                                                    description:
                                                                        'If you want to be rejected, you must first enter the reason for rejection and press OK..',
                                                                    backgroundColor:
                                                                        white,
                                                                    btnOkColor:
                                                                        accentColor,
                                                                    btnCancelColor:
                                                                        grey,
                                                                    id: pending
                                                                        .id,
                                                                    titleColor:
                                                                        accentColor,
                                                                    descColor:
                                                                        black,
                                                                  ),
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
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        defaultButton2(
                                                          press: () {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              // outside to dismiss
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return BlocProvider(
                                                                  create: (context) =>
                                                                      RequestCubit(),
                                                                  child:
                                                                      CustomDialogRequestTabs(
                                                                    title:
                                                                        'Do you want to reject?',
                                                                    description:
                                                                        'If you want to be rejected, you must first enter the reason for rejection and press OK..',
                                                                    backgroundColor:
                                                                        white,
                                                                    btnOkColor:
                                                                        accentColor,
                                                                    btnCancelColor:
                                                                        grey,
                                                                    id: pending
                                                                        .id,
                                                                    titleColor:
                                                                        accentColor,
                                                                    descColor:
                                                                        black,
                                                                  ),
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
                                                              color:
                                                                  accentColor,
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
                                    ),
                                    i ==
                                                RequestCubit.get(context)
                                                        .requestPending
                                                        .length -
                                                    1 &&
                                            loadingMorePending
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              loading(),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                          )
                    : state is RequestPendingErrorState
                        ? errorMessage(
                            message: state.message,
                            press: () {
                              RequestCubit.get(context).getRequestPending(1);
                            })
                        : Container(),
          ],
        ),
        drawer: const DrawerMenu(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              // _currentIndex = index;
              if(MainCubit.get(context).tabController!.index != index){
                MainCubit.get(context).tabControllerChanged = true;
                MainCubit.get(context).tabController!.animateTo(index);
              }else{
                MainCubit.get(context).tabControllerChanged = false;
                MainCubit.get(context).tabController!.index = index;
                MainCubit.get(context)
                    .tabController!
                    .notifyListeners();
              }

              // print("_currentIndexxxxx2*********** ${MainCubit.get(context).tabController!.previousIndex}");
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

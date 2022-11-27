import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/auth/SignInScreen.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/notifications/NotificationScreen.dart';
import 'package:getn_driver/presentation/ui/notifications/notification_cubit.dart';
import 'package:getn_driver/presentation/ui/policies/PoliciesScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/RequestDetailsScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/request_details_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/request_cubit.dart';
import 'package:getn_driver/presentation/ui/setting/SettingScreen.dart';
import 'package:getn_driver/presentation/ui/wallet/WalletScreen.dart';
import 'package:getn_driver/presentation/ui/wallet/wallet_cubit.dart';
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
    'en': {
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
    },
    'ar': {
      'pending': 'قيد الإنتظار',
      'accept': 'مقبول',
      'on_my_way': 'في الطريق',
      'arrive': 'تم الوصول',
      'coming': 'في الطريق',
      'start': 'بدأت',
      'end': 'إنتهت',
      'mid_pause': 'الغيت',
      'reject': 'مرفوض',
      'cancel': 'الغيت',
      'need_confirm': 'تحتاج للموافقة',
      'paid': 'مدفوعة'
    }
  };

  @override
  void initState() {
    super.initState();

    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }

    RequestCubit.get(context).editProfile();

    RequestCubit.get(context).tabController =
        TabController(length: 4, vsync: this);

    if (widget.screenNotify != null &&
        widget.screenNotify == "RequestPending") {
      _currentIndex = 3;
      RequestCubit.get(context).tabController!.index = 2;
    }

    // first load
    RequestCubit.get(context).getRequestCurrent(1);

    RequestCubit.get(context).tabController!.addListener(() {
      setState(() {
        print("_currentIndex*********** ");

        _currentIndex = RequestCubit.get(context).tabController!.index;
        if (RequestCubit.get(context).tabController!.indexIsChanging &&
            RequestCubit.get(context).tabControllerChanged) {
          print("_currentIndex***********0 ");
          if (_currentIndex == 0) {
            RequestCubit.get(context).getRequestCurrent(1);
            RequestCubit.get(context).typeRequest = "current";
          } else if (_currentIndex == 1) {
            RequestCubit.get(context).indexUpComing = 1;
            RequestCubit.get(context).getRequestUpComing(1);
            RequestCubit.get(context).typeRequest = "upComing";
          } else if (_currentIndex == 2) {
            RequestCubit.get(context).indexPast = 1;
            RequestCubit.get(context).getRequestPast(1);
            RequestCubit.get(context).typeRequest = "past";
          } else if (_currentIndex == 3) {
            RequestCubit.get(context).indexPending = 1;
            RequestCubit.get(context).getRequestPending(1);
            RequestCubit.get(context).typeRequest = "pending";
          }
        } else if (!RequestCubit.get(context).tabController!.indexIsChanging &&
            !RequestCubit.get(context).tabControllerChanged) {
          print("_currentIndex***********1 ");
          if (_currentIndex == 0) {
            RequestCubit.get(context).getRequestCurrent(1);
            RequestCubit.get(context).typeRequest = "current";
          } else if (_currentIndex == 1) {
            RequestCubit.get(context).indexUpComing = 1;
            RequestCubit.get(context).getRequestUpComing(1);
            RequestCubit.get(context).typeRequest = "upComing";
          } else if (_currentIndex == 2) {
            RequestCubit.get(context).indexPast = 1;
            RequestCubit.get(context).getRequestPast(1);
            RequestCubit.get(context).typeRequest = "past";
          } else if (_currentIndex == 3) {
            RequestCubit.get(context).indexPending = 1;
            RequestCubit.get(context).getRequestPending(1);
            RequestCubit.get(context).typeRequest = "pending";
          }
        }
        // else if (MainCubit.get(context).tabController!.index )
      });
    });
  }

  void viewWillAppear() {
    print("onResume / viewWillAppear / onFocusGained    requestTabs");
    getIt<SharedPreferences>().setString('typeScreen', "request");
    getIt<SharedPreferences>().setString('requestDetailsId', "");
    getIt<SharedPreferences>().setString('tripDetailsId', "");
  }

  void viewWillDisappear() {
    print("onPause / viewWillDisappear / onFocusLost  requestTabs");
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
    return FocusDetector(
      onFocusGained: viewWillAppear,
      onFocusLost: viewWillDisappear,
      child:
          BlocConsumer<RequestCubit, RequestState>(listener: (context, state) {
        if (state is RequestEditSuccessState) {
          if (state.data!.status! == "accept") {
            RequestCubit.get(context).tabControllerChanged = false;
            RequestCubit.get(context).tabController!.index = 3;
            RequestCubit.get(context).tabController!.notifyListeners();
          } else if (state.data!.status! == "reject") {
            Navigator.pop(context);
            RequestCubit.get(context).tabController!.animateTo(2);
          }
        } else if (state is RequestEditErrorState) {
          if (state.type == "reject") {
            Navigator.pop(context);
          }
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
        return Directionality(
          textDirection: LanguageCubit.get(context).isEn
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                LanguageCubit.get(context).getTexts('Requests').toString(),
                style: TextStyle(color: primaryColor, fontSize: 20.sp),
              ),
              centerTitle: true,
              elevation: 1.0,
            ),
            body: TabBarView(
              controller: RequestCubit.get(context).tabController,
              children: [
                RequestCubit.get(context).loadingCurrent
                    ? loading()
                    : state is RequestCurrentSuccessState
                        ? RequestCubit.get(context).requestCurrent.isEmpty
                            ? errorMessage(
                                message: LanguageCubit.get(context)
                                    .getTexts('NotFoundData')
                                    .toString(),
                                press: () {
                                  RequestCubit.get(context)
                                      .getRequestCurrent(1);
                                },
                                context: context)
                            : current()
                        : state is RequestCurrentErrorState
                            ? errorMessage(
                                message: state.message,
                                press: () {
                                  RequestCubit.get(context)
                                      .getRequestCurrent(1);
                                },
                                context: context)
                            : Container(),
                RequestCubit.get(context).loadingUpComing
                    ? loading()
                    : state is RequestUpComingSuccessState
                        ? RequestCubit.get(context).requestUpComing.isEmpty
                            ? errorMessage(
                                message: LanguageCubit.get(context)
                                    .getTexts('NotFoundData')
                                    .toString(),
                                press: () {
                                  RequestCubit.get(context)
                                      .getRequestUpComing(1);
                                },
                                context: context)
                            : upComing()
                        : state is RequestUpComingErrorState
                            ? errorMessage(
                                message: state.message,
                                press: () {
                                  RequestCubit.get(context)
                                      .getRequestUpComing(1);
                                },
                                context: context)
                            : Container(),
                RequestCubit.get(context).loadingPast
                    ? loading()
                    : state is RequestPastSuccessState
                        ? RequestCubit.get(context).requestPast.isEmpty
                            ? errorMessage(
                                message: LanguageCubit.get(context)
                                    .getTexts('NotFoundData')
                                    .toString(),
                                press: () {
                                  RequestCubit.get(context).getRequestPast(1);
                                },
                                context: context)
                            : past()
                        : state is RequestPastErrorState
                            ? errorMessage(
                                message: state.message,
                                press: () {
                                  RequestCubit.get(context).getRequestPast(1);
                                },
                                context: context)
                            : Container(),
                RequestCubit.get(context).loadingPending
                    ? loading()
                    : state is RequestPendingSuccessState
                        ? RequestCubit.get(context).requestPending.isEmpty
                            ? errorMessage(
                                message: LanguageCubit.get(context)
                                    .getTexts('NotFoundData')
                                    .toString(),
                                press: () {
                                  RequestCubit.get(context)
                                      .getRequestPending(1);
                                },
                                context: context)
                            : pending()
                        : state is RequestPendingErrorState
                            ? errorMessage(
                                message: state.message,
                                press: () {
                                  RequestCubit.get(context)
                                      .getRequestPending(1);
                                },
                                context: context)
                            : Container(),
              ],
            ),
            drawer: sideBar(),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  // _currentIndex = index;
                  if (RequestCubit.get(context).tabController!.index != index) {
                    RequestCubit.get(context).tabControllerChanged = true;
                    RequestCubit.get(context).tabController!.animateTo(index);
                  } else {
                    RequestCubit.get(context).tabControllerChanged = false;
                    RequestCubit.get(context).tabController!.index = index;
                    RequestCubit.get(context).tabController!.notifyListeners();
                  }

                  // print("_currentIndexxxxx2*********** ${MainCubit.get(context).tabController!.previousIndex}");
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: primaryColor,
              selectedItemColor: accentColor,
              unselectedItemColor: grey,
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.settings),
                    label: LanguageCubit.get(context)
                        .getTexts('current')
                        .toString()),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.upcoming),
                    label: LanguageCubit.get(context)
                        .getTexts('upcoming')
                        .toString()),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.person_pin_outlined),
                    label:
                        LanguageCubit.get(context).getTexts('past').toString()),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.person_pin_outlined),
                    label: LanguageCubit.get(context)
                        .getTexts('pending')
                        .toString()),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget current() => ListView.builder(
        // key: const PageStorageKey<String>('tab1'),
        scrollDirection: Axis.vertical,
        itemCount: RequestCubit.get(context).requestCurrent.length,
        itemBuilder: (context, i) {
          var current = RequestCubit.get(context).requestCurrent[i];
          return InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
              child: Card(
                elevation: 5.r,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  color: white,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.r, horizontal: 7.r),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      clientCurrent(current),
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
                      // status
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.r),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${LanguageCubit.get(context).getTexts('refId').toString()} ${current.referenceId}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: black,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Text(
                                '${LanguageCubit.get(context).getTexts('Status').toString()} ${LanguageCubit.get(context).isEn ? btnStatus3['en']![current.status] : btnStatus3['ar']![current.status]}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: black,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      // picked point
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LanguageCubit.get(context)
                                      .getTexts('PickedPoint')
                                      .toString(),
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  current.from!.placeTitle!,
                                  style:
                                      TextStyle(color: grey2, fontSize: 16.sp),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    LanguageCubit.get(context).isEn
                                        ? DateFormat.yMEd().format(
                                            DateTime.parse(current.from!.date!))
                                        : DateFormat.yMEd("ar").format(
                                            DateTime.parse(
                                                current.from!.date!)),
                                    style: TextStyle(
                                        color: grey2, fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    LanguageCubit.get(context).isEn
                                        ? DateFormat.jm().format(
                                            DateTime.parse(current.from!.date!))
                                        : DateFormat.jm("ar").format(
                                            DateTime.parse(
                                                current.from!.date!)),
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
                                    LanguageCubit.get(context).isEn
                                        ? DateFormat.yMEd()
                                            .format(DateTime.parse(current.to!))
                                        : DateFormat.yMEd("ar").format(
                                            DateTime.parse(current.to!)),
                                    style: TextStyle(
                                        color: grey2, fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    LanguageCubit.get(context).isEn
                                        ? DateFormat.jm()
                                            .format(DateTime.parse(current.to!))
                                        : DateFormat.jm("ar").format(
                                            DateTime.parse(current.to!)),
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
                      distanceCurrent(current),
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
                      ))
                  .then((value) =>
                      RequestCubit.get(context).getRequestCurrent(1));
            },
          );
        },
      );

  Widget clientCurrent(DataRequest current) => Row(
        children: [
          ClipOval(
            clipBehavior: Clip.antiAlias,
            child: ImageTools.image(
                fit: BoxFit.fill,
                url: current.client2 != null
                    ? current.client2!.image!.src
                    : null,
                height: 70.w,
                width: 70.w),
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
                          current.client2 != null ? current.client2!.name! : '',
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    LanguageCubit.get(context).isEn
                        ? '${current.client2 != null ? current.client2!.country?.title!.en : ""}, ${current.client2 != null ? current.client2!.city?.title!.en : ""}, ${current.client2 != null ? current.client2!.area?.title!.en : ""}'
                        : '${current.client2 != null ? current.client2!.country?.title!.ar : ""}, ${current.client2 != null ? current.client2!.city?.title!.ar : ""}, ${current.client2 != null ? current.client2!.area?.title!.ar : ""}',
                    style: TextStyle(fontSize: 15.sp, color: grey2),
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
      );

  Widget distanceCurrent(DataRequest current) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                color: yellowLightColor,
                child: Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('Days')
                              .toString(),
                          style: TextStyle(color: grey2, fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '${current.days!.length} ${LanguageCubit.get(context).getTexts('Days').toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('UsedPoints')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          current.totalConsumptionPoints!.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('TotalDistance')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          current.consumptionKM!.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: blueLight,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.r),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('TotalPrice')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '${current.totalPrice!.toStringAsFixed(2)}\$',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      );

  Widget upComing() => ScrollEdgeListener(
        edge: ScrollEdge.end,
        // edgeOffset: 400,
        // continuous: false,
        // debounce: const Duration(milliseconds: 500),
        // dispatch: true,
        listener: () {
          if (RequestCubit.get(context).typeRequest == "upComing") {
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
          itemCount: RequestCubit.get(context).requestUpComing.length,
          itemBuilder: (context, i) {
            var upComing = RequestCubit.get(context).requestUpComing[i];
            return Column(
              children: [
                InkWell(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
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
                            clientUpComing(upComing),
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
                            // status
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.r),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'refId: ${upComing.referenceId}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${LanguageCubit.get(context).getTexts('Status').toString()} ${LanguageCubit.get(context).isEn ? btnStatus3['en']![upComing.status] : btnStatus3['ar']![upComing.status]}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            // picked point
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        LanguageCubit.get(context)
                                            .getTexts('PickedPoint')
                                            .toString(),
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        upComing.from!.placeTitle!,
                                        // upComing.from!.placeTitle!,
                                        style: TextStyle(
                                            color: grey2, fontSize: 16.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          LanguageCubit.get(context).isEn
                                              ? DateFormat.yMEd().format(
                                                  DateTime.parse(
                                                      upComing.from!.date!))
                                              : DateFormat.yMEd("ar").format(
                                                  DateTime.parse(
                                                      upComing.from!.date!)),
                                          style: TextStyle(
                                              color: grey2, fontSize: 14.sp),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          LanguageCubit.get(context).isEn
                                              ? DateFormat.jm().format(
                                                  DateTime.parse(
                                                      upComing.from!.date!))
                                              : DateFormat.jm("ar").format(
                                                  DateTime.parse(
                                                      upComing.from!.date!)),
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
                                          LanguageCubit.get(context).isEn
                                              ? DateFormat.yMEd().format(
                                                  DateTime.parse(upComing.to!))
                                              : DateFormat.yMEd("ar").format(
                                                  DateTime.parse(upComing.to!)),
                                          style: TextStyle(
                                              color: grey2, fontSize: 14.sp),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          LanguageCubit.get(context).isEn
                                              ? DateFormat.jm().format(
                                                  DateTime.parse(upComing.to!))
                                              : DateFormat.jm("ar").format(
                                                  DateTime.parse(upComing.to!)),
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
                            distanceUpComing(upComing),
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
                            ))
                        .then((value) =>
                            RequestCubit.get(context).getRequestUpComing(1));
                  },
                ),
                i == RequestCubit.get(context).requestUpComing.length - 1 &&
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
      );

  Widget clientUpComing(DataRequest upComing) => Row(
        children: [
          ClipOval(
            clipBehavior: Clip.antiAlias,
            child: ImageTools.image(
                fit: BoxFit.fill,
                url: upComing.client2 != null
                    ? upComing.client2!.image!.src
                    : null,
                height: 70.w,
                width: 70.w),
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
                          upComing.client2 != null
                              ? upComing.client2!.name!
                              : '',
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    LanguageCubit.get(context).isEn
                        ? '${upComing.client2 != null ? upComing.client2!.country?.title!.en : ""}, ${upComing.client2 != null ? upComing.client2!.city?.title!.en : ""}, ${upComing.client2 != null ? upComing.client2!.area?.title!.en : ""}'
                        : '${upComing.client2 != null ? upComing.client2!.country?.title!.ar : ""}, ${upComing.client2 != null ? upComing.client2!.city?.title!.ar : ""}, ${upComing.client2 != null ? upComing.client2!.area?.title!.ar : ""}',
                    style: TextStyle(fontSize: 15.sp, color: grey2),
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
      );

  Widget distanceUpComing(DataRequest upComing) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                color: yellowLightColor,
                child: Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('Days')
                              .toString(),
                          style: TextStyle(color: grey2, fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '${upComing.days!.length} Days',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('UsedPoints')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          upComing.totalConsumptionPoints!.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('TotalDistance')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          upComing.consumptionKM!.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: blueLight,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.r),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('TotalPrice')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '${upComing.totalPrice!.toStringAsFixed(2)}\$',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      );

  Widget past() => ScrollEdgeListener(
        edge: ScrollEdge.end,
        // edgeOffset: 400,
        // continuous: false,
        // debounce: const Duration(milliseconds: 500),
        // dispatch: true,
        listener: () {
          if (RequestCubit.get(context).typeRequest == "past") {
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
          itemCount: RequestCubit.get(context).requestPast.length,
          itemBuilder: (context, i) {
            var past = RequestCubit.get(context).requestPast[i];

            return Column(
              children: [
                InkWell(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
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
                            clientPast(past),
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
                            // status
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.r),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'refId: ${past.referenceId}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${LanguageCubit.get(context).getTexts('Status').toString()} ${LanguageCubit.get(context).isEn ? btnStatus3['en']![past.status] : btnStatus3['ar']![past.status]}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            // picked point
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        LanguageCubit.get(context)
                                            .getTexts('PickedPoint')
                                            .toString(),
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        past.from!.placeTitle!,
                                        // past.from!.placeTitle!,
                                        style: TextStyle(
                                            color: grey2, fontSize: 16.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          LanguageCubit.get(context).isEn
                                              ? DateFormat.yMEd().format(
                                                  DateTime.parse(
                                                      past.from!.date!))
                                              : DateFormat.yMEd("ar").format(
                                                  DateTime.parse(
                                                      past.from!.date!)),
                                          style: TextStyle(
                                              color: grey2, fontSize: 14.sp),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          LanguageCubit.get(context).isEn
                                              ? DateFormat.jm().format(
                                                  DateTime.parse(
                                                      past.from!.date!))
                                              : DateFormat.jm("ar").format(
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
                                          LanguageCubit.get(context).isEn
                                              ? DateFormat.yMEd().format(
                                                  DateTime.parse(past.to!))
                                              : DateFormat.yMEd("ar").format(
                                                  DateTime.parse(past.to!)),
                                          style: TextStyle(
                                              color: grey2, fontSize: 14.sp),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          LanguageCubit.get(context).isEn
                                              ? DateFormat.jm().format(
                                                  DateTime.parse(past.to!))
                                              : DateFormat.jm("ar").format(
                                                  DateTime.parse(past.to!)),
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
                            distancePast(past),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    RequestDetailsCubit.get(context).typeScreen = "past";

                    await navigateToWithRefreshPagePrevious(
                            context,
                            RequestDetailsScreen(
                              idRequest: past.id,
                            ))
                        .then((value) =>
                            RequestCubit.get(context).getRequestPast(1));
                  },
                ),
                i == RequestCubit.get(context).requestPast.length - 1 &&
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
      );

  Widget clientPast(DataRequest past) => Row(
        children: [
          ClipOval(
            clipBehavior: Clip.antiAlias,
            child: ImageTools.image(
                fit: BoxFit.fill,
                url: past.client2 != null ? past.client2!.image!.src : null,
                height: 70.w,
                width: 70.w),
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
                          past.client2 != null ? past.client2!.name! : '',
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    LanguageCubit.get(context).isEn
                        ? '${past.client2 != null ? past.client2!.country!.title!.en : ""}, ${past.client2 != null ? past.client2!.city?.title!.en : ""}, ${past.client2 != null ? past.client2!.area?.title!.en : ""}'
                        : '${past.client2 != null ? past.client2!.country?.title!.ar : ""}, ${past.client2 != null ? past.client2!.city?.title!.ar : ""}, ${past.client2 != null ? past.client2!.area?.title!.ar : ""}',
                    style: TextStyle(fontSize: 15.sp, color: grey2),
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
      );

  Widget distancePast(DataRequest past) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                color: yellowLightColor,
                child: Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('Days')
                              .toString(),
                          style: TextStyle(color: grey2, fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '${past.days!.length} Days',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('UsedPoints')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          past.totalConsumptionPoints!.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('TotalDistance')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          past.consumptionKM!.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: blueLight,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.r),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('TotalPrice')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '${past.totalPrice!.toStringAsFixed(2)}\$',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      );

  Widget pending() => ScrollEdgeListener(
        edge: ScrollEdge.end,
        // edgeOffset: 400,
        // continuous: false,
        // debounce: const Duration(milliseconds: 500),
        // dispatch: true,
        listener: () {
          if (RequestCubit.get(context).typeRequest == "pending") {
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
          itemCount: RequestCubit.get(context).requestPending.length,
          itemBuilder: (context, i) {
            var pending = RequestCubit.get(context).requestPending[i];
            final loadAcceptVisible = i == indexPending;
            print("loadAcceptVisible***********$loadAcceptVisible");
            return Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
                  child: Card(
                    elevation: 5.r,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      color: white,
                      padding:
                          EdgeInsets.symmetric(vertical: 10.r, horizontal: 7.r),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          clientPending(pending),
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
                          // picked point
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LanguageCubit.get(context)
                                          .getTexts('PickedPoint')
                                          .toString(),
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      pending.from!.placeTitle!,
                                      // upComing.from!.placeTitle!,
                                      style: TextStyle(
                                          color: grey2, fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        LanguageCubit.get(context).isEn
                                            ? DateFormat.yMEd().format(
                                                DateTime.parse(
                                                    pending.from!.date!))
                                            : DateFormat.yMEd("ar").format(
                                                DateTime.parse(
                                                    pending.from!.date!)),
                                        style: TextStyle(
                                            color: grey2, fontSize: 14.sp),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        LanguageCubit.get(context).isEn
                                            ? DateFormat.jm().format(
                                                DateTime.parse(
                                                    pending.from!.date!))
                                            : DateFormat.jm("ar").format(
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
                                        LanguageCubit.get(context).isEn
                                            ? DateFormat.yMEd().format(
                                                DateTime.parse(pending.to!))
                                            : DateFormat.yMEd("ar").format(
                                                DateTime.parse(pending.to!)),
                                        style: TextStyle(
                                            color: grey2, fontSize: 14.sp),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        LanguageCubit.get(context).isEn
                                            ? DateFormat.jm().format(
                                                DateTime.parse(pending.to!))
                                            : DateFormat.jm("ar").format(
                                                DateTime.parse(pending.to!)),
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
                          distancePending(pending),
                          SizedBox(
                            height: 15.h,
                          ),
                          btnStatusPending(pending, loadAcceptVisible, i),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                i == RequestCubit.get(context).requestPending.length - 1 &&
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
      );

  Widget clientPending(DataRequest pending) => Row(
        children: [
          ClipOval(
            clipBehavior: Clip.antiAlias,
            child: ImageTools.image(
                fit: BoxFit.fill,
                url: pending.client2 != null
                    ? pending.client2!.image!.src
                    : null,
                height: 70.w,
                width: 70.w),
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
                          pending.client2 != null ? pending.client2!.name! : '',
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    LanguageCubit.get(context).isEn
                        ? '${pending.client2 != null ? pending.client2!.country?.title!.en : ""}, ${pending.client2 != null ? pending.client2!.city?.title!.en : ""}, ${pending.client2 != null ? pending.client2!.area?.title!.en : ""}'
                        : '${pending.client2 != null ? pending.client2!.country?.title!.ar : ""}, ${pending.client2 != null ? pending.client2!.city?.title!.ar : ""}, ${pending.client2 != null ? pending.client2!.area?.title!.ar : ""}',
                    style: TextStyle(fontSize: 15.sp, color: grey2),
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
      );

  Widget distancePending(DataRequest pending) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                color: yellowLightColor,
                child: Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('Days')
                              .toString(),
                          style: TextStyle(color: grey2, fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '${pending.days!.length} Days',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('UsedPoints')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          pending.totalConsumptionPoints!.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('TotalDistance')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          pending.consumptionKM!.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: blueLight,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.r),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageCubit.get(context)
                              .getTexts('TotalPrice')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grey2, fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '${pending.totalPrice!.toStringAsFixed(2)}\$',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      );

  Widget btnStatusPending(DataRequest pending, bool loadAcceptVisible, int i) =>
      pending.status == "pending"
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                loadAcceptVisible
                    ? RequestCubit.get(context).loadingEditPending
                        ? loading()
                        : defaultButton2(
                            press: () {
                              RequestCubit.get(context)
                                  .editRequest(pending.id!, "accept", "");

                              setState(() {
                                indexPending = i;
                              });
                            },
                            text: LanguageCubit.get(context)
                                .getTexts('Accept')
                                .toString(),
                            backColor: greenColor,
                            textColor: white)
                    : defaultButton2(
                        press: () {
                          RequestCubit.get(context)
                              .editRequest(pending.id!, "accept", "");
                          setState(() {
                            indexPending = i;
                          });
                        },
                        text: LanguageCubit.get(context)
                            .getTexts('Accept')
                            .toString(),
                        backColor: greenColor,
                        textColor: white),
                defaultButton2(
                  press: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      // outside to dismiss
                      builder: (BuildContext context) {
                        return CustomDialogRequestTabs(
                          title: LanguageCubit.get(context)
                              .getTexts('DoReject')
                              .toString(),
                          description: LanguageCubit.get(context)
                              .getTexts('IfRejected')
                              .toString(),
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
                  text:
                      LanguageCubit.get(context).getTexts('Reject').toString(),
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
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      // outside to dismiss
                      builder: (BuildContext context) {
                        return CustomDialogRequestTabs(
                          title: LanguageCubit.get(context)
                              .getTexts('DoReject')
                              .toString(),
                          description: LanguageCubit.get(context)
                              .getTexts('IfRejected')
                              .toString(),
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
                  text:
                      LanguageCubit.get(context).getTexts('Reject').toString(),
                  backColor: white,
                  textColor: grey2,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  '${pending.client2?.name} ${LanguageCubit.get(context).getTexts('notPaidYet')}',
                  style: TextStyle(color: accentColor, fontSize: 18.sp),
                )
              ],
            );

  Widget sideBar() => Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: blueColor),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: grey3,
                    backgroundImage: NetworkImage(getIt<SharedPreferences>()
                            .getString('userImage') ??
                        "https://www.pphfoundation.ca/wp-content/uploads/2018/05/default-avatar.png"), // for Network image
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getIt<SharedPreferences>().getString("name") ?? "",
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "+20${getIt<SharedPreferences>().getString("phone")}",
                          style: TextStyle(
                            color: white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                LanguageCubit.get(context).getTexts('Home').toString(),
                style: TextStyle(
                  color: grey2,
                  fontSize: 20.sp,
                ),
              ),
              leading: const Icon(Icons.home, color: grey2),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                LanguageCubit.get(context).getTexts('Wallet').toString(),
                style: TextStyle(
                  color: grey2,
                  fontSize: 20.sp,
                ),
              ),
              leading: const Icon(
                Icons.account_balance_wallet,
                color: grey2,
              ),
              onTap: () {
                navigateTo(
                    context,
                    BlocProvider(
                        create: (context) => WalletCubit(),
                        child: const WalletScreen()));
              },
            ),
            ListTile(
              title: Text(
                LanguageCubit.get(context).getTexts('Notifications').toString(),
                style: TextStyle(
                  color: grey2,
                  fontSize: 20.sp,
                ),
              ),
              leading: const Icon(Icons.notifications, color: grey2),
              onTap: () {
                navigateTo(
                    context,
                    BlocProvider(
                        create: (context) => NotificationCubit(),
                        child: const NotificationScreen()));
              },
            ),
            ListTile(
              title: Text(
                LanguageCubit.get(context).getTexts('Setting').toString(),
                style: TextStyle(
                  color: grey2,
                  fontSize: 20.sp,
                ),
              ),
              leading: const Icon(Icons.settings, color: grey2),
              onTap: () async {
                await navigateToWithRefreshPagePrevious(
                    context, const SettingScreen());
                setState(() {});
              },
            ),
            ListTile(
              title: Text(
                LanguageCubit.get(context).getTexts('Policies').toString(),
                style: TextStyle(
                  color: grey2,
                  fontSize: 20.sp,
                ),
              ),
              leading: const Icon(
                Icons.policy,
                color: grey2,
              ),
              onTap: () {
                navigateTo(context, const PoliciesScreen());
              },
            ),
            ListTile(
              title: Text(
                LanguageCubit.get(context).getTexts('SignOut').toString(),
                style: TextStyle(
                  color: grey2,
                  fontSize: 20.sp,
                ),
              ),
              leading: const Icon(Icons.exit_to_app, color: grey2),
              onTap: () {
                FirebaseMessaging messaging = FirebaseMessaging.instance;
                FirebaseAuth.instance.signOut().then((value) => messaging
                    .deleteToken()
                    .then((value) =>
                        getIt<SharedPreferences>().clear().then((value) {
                          getIt<SharedPreferences>()
                              .setBool("isEn", LanguageCubit.get(context).isEn);
                          navigateAndFinish(context, const SignInScreen());
                        })));
              },
            ),
          ],
        ),
      );
}

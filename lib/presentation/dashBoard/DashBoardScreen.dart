import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/dashBoard/dash_board_cubit.dart';
import 'package:getn_driver/presentation/requestDetails/RequestDetailsScreen.dart';
import 'package:intl/intl.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  TabController? _tabController;
  late ScrollController _controllerUpcoming;
  late ScrollController _controllerPast;
  String typeRequest = "current";
  bool loadingUpComing = false;
  bool firstClickTabController = false;
  @override
  void initState() {
    super.initState();
    // first load
    DashBoardCubit.get(context).getRequestCurrent(1);
    DashBoardCubit.get(context).getRequestUpComing(1);
    DashBoardCubit.get(context).getRequestPast(1);

    _controllerUpcoming = ScrollController();
    _controllerPast = ScrollController();

    _tabController = TabController(length: 3, vsync: this);

    _tabController!.addListener(() {
      setState(() {
        print("_currentIndex*********** ${_tabController!.index}");
        _currentIndex = _tabController!.index;
        if(_tabController!.indexIsChanging) {
          if (_currentIndex == 0) {
            DashBoardCubit.get(context).getRequestCurrent(1);
            typeRequest = "current";
          } else if (_currentIndex == 1) {
            DashBoardCubit
                .get(context)
                .indexUpComing = 1;
            DashBoardCubit.get(context).getRequestUpComing(1);
            typeRequest = "upComing";
          } else if (_currentIndex == 2) {
            DashBoardCubit
                .get(context)
                .indexPast = 1;
            DashBoardCubit.get(context).getRequestPast(1);
            typeRequest = "past";
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
    _controllerUpcoming.removeListener(_loadMoreUpComing);
    _controllerPast.removeListener(_loadMorePast);
  }

  void _loadMoreUpComing() {
    DashBoardCubit.get(context).loadingUpComing = false;

    DashBoardCubit.get(context).getRequestUpComing(
        DashBoardCubit.get(context).indexUpComing);
  }
  void _loadMorePast() {
    DashBoardCubit.get(context).loadingPast = false;

    DashBoardCubit.get(context).getRequestPast(
        DashBoardCubit.get(context).indexPast);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashBoardCubit, DashBoardState>(
        listener: (context, state) {
      if (state is RequestCurrentInitial) {
        if (kDebugMode) {
          print('*******RequestInitial');
        }
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
                    itemCount:
                        DashBoardCubit.get(context).requestCurrent.length,
                    itemBuilder: (context, i) {
                      var current = DashBoardCubit.get(context).requestCurrent[i];
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
                                  vertical: 10.r, horizontal: 15.r),
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
                                              current.referenceId!.toString(),
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
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '12:00 am',
                                            style: TextStyle(
                                              color: grey2,
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                          Text(
                                            '11/12/2022',
                                            style: TextStyle(
                                                color: grey2, fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.r,
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
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                Text(
                                                  'Days',
                                                  style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp),
                                                ),
                                                SizedBox(
                                                  height: 5.r,
                                                ),
                                                Text(
                                                  '${current.days!.length} Days',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: 14.sp,
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
                                                  'Start Date',
                                                  style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp),
                                                ),
                                                SizedBox(
                                                  height: 5.r,
                                                ),
                                                Text(
                                                  DateFormat.yMMMd().format(startDate),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: 14.sp,
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
                                                  'End Date',
                                                  style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp),
                                                ),
                                                SizedBox(
                                                  height: 5.r,
                                                ),
                                                Text(
                                                  DateFormat.yMMMd().format(endDate),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: 14.sp,
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
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.r),
                                              child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                Text(
                                                  'Cost',
                                                  style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp),
                                                ),
                                                SizedBox(
                                                  height: 5.r,
                                                ),
                                                Text(
                                                  current.totalPrice.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: 14.sp,
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
                          navigateTo(context, RequestDetailsScreen());
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
                          if (DashBoardCubit.get(context).loadingUpComing &&
                              typeRequest == "upComing") {
                            _loadMoreUpComing();
                          }
                        }
                      }),
                    // key: const PageStorageKey<String>('tab2'),
                    scrollDirection: Axis.vertical,
                    itemCount:
                        DashBoardCubit.get(context).requestUpComing.length,
                    itemBuilder: (context, i) {
                      var upComing = DashBoardCubit.get(context).requestUpComing[i];
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
                                  vertical: 10.r, horizontal: 15.r),
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
                                              upComing.referenceId!.toString(),
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
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '12:00 am',
                                            style: TextStyle(
                                              color: grey2,
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                          Text(
                                            '11/12/2022',
                                            style: TextStyle(
                                                color: grey2, fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.r,
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
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Days',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.r,
                                                    ),
                                                    Text(
                                                      '${upComing.days!.length} Days',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 14.sp,
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
                                                      'Start Date',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.r,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd().format(startDate),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 14.sp,
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
                                                      'End Date',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.r,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd().format(endDate),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 14.sp,
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
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.r),
                                              child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Cost',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.r,
                                                    ),
                                                    Text(
                                                      upComing.totalPrice.toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 14.sp,
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
                          navigateTo(context, RequestDetailsScreen());
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
                    print('_controllerPast00*******${DashBoardCubit.get(context).loadingPast}');
                    if (DashBoardCubit.get(context).loadingPast &&
                        typeRequest == "past") {
                      _loadMorePast();
                    }
                  }
                }),
              // key: const PageStorageKey<String>('tab2'),
              scrollDirection: Axis.vertical,
              itemCount:
              DashBoardCubit.get(context).requestPast.length,
              itemBuilder: (context, i) {
                var past = DashBoardCubit.get(context).requestPast[i];
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
                            vertical: 10.r, horizontal: 15.r),
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
                                        past.referenceId!.toString(),
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
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '12:00 am',
                                      style: TextStyle(
                                        color: grey2,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    Text(
                                      '11/12/2022',
                                      style: TextStyle(
                                          color: grey2, fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.r,
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
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Days',
                                                style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 14.sp),
                                              ),
                                              SizedBox(
                                                height: 5.r,
                                              ),
                                              Text(
                                                '${past.days!.length} Days',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: 14.sp,
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
                                                'Start Date',
                                                style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 14.sp),
                                              ),
                                              SizedBox(
                                                height: 5.r,
                                              ),
                                              Text(
                                                DateFormat.yMMMd().format(startDate),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: 14.sp,
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
                                                'End Date',
                                                style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 14.sp),
                                              ),
                                              SizedBox(
                                                height: 5.r,
                                              ),
                                              Text(
                                                DateFormat.yMMMd().format(endDate),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: 14.sp,
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
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.r),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Cost',
                                                style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 14.sp),
                                              ),
                                              SizedBox(
                                                height: 5.r,
                                              ),
                                              Text(
                                                past.totalPrice.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: 14.sp,
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
                    navigateTo(context, RequestDetailsScreen());
                  },
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
            });
          },

          type: BottomNavigationBarType.fixed,
          backgroundColor: primaryColor,
          selectedItemColor: accentColor,
          unselectedItemColor: grey,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "current "),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "upcoming "),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_outlined), label: "past "),
          ],
        ),
      );
    });
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/dashBoard/dash_board_cubit.dart';
import 'package:getn_driver/presentation/requestDetails/RequestDetailsScreen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  TabController? _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
        length: DashBoardCubit().request.isEmpty
            ? 3
            : DashBoardCubit().request.length,
        vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _currentIndex = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashBoardCubit()..getRequest(),
      child: BlocConsumer<DashBoardCubit, DashBoardState>(
          listener: (context, state) {
        if (state is RequestInitial) {
          if (kDebugMode) {
            print('SignInScreen*******CountriesLoading');
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
              state is RequestInitial
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: black,
                    ))
                  : ListView.builder(
                      key: const PageStorageKey<String>('tab1'),
                      scrollDirection: Axis.vertical,
                      itemCount: DashBoardCubit.get(context).request.length,
                      itemBuilder: (context, i) {
                        var list = DashBoardCubit.get(context).request;
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
                                                'Nasr City,Cairo,Egypt',
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
                                      height: 15.r,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Card(
                                          color: yellowLightColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(15.r),
                                            child: Column(children: [
                                              Text(
                                                'Days',
                                                style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 15.sp),
                                              ),
                                              SizedBox(
                                                height: 5.r,
                                              ),
                                              Text(
                                                '4 Days',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ]),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.redAccent.withOpacity(.3),
                                          child: Padding(
                                            padding: EdgeInsets.all(15.r),
                                            child: Column(children: [
                                              Text(
                                                'Start Date',
                                                style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 15.sp),
                                              ),
                                              SizedBox(
                                                height: 5.r,
                                              ),
                                              Text(
                                                '15 feb 2022',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ]),
                                          ),
                                        ),
                                        Card(
                                          color: greenLightColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(15.r),
                                            child: Column(children: [
                                              Text(
                                                'End Date',
                                                style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 15.sp),
                                              ),
                                              SizedBox(
                                                height: 5.r,
                                              ),
                                              Text(
                                                '15 feb 2022',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ]),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: blueColor,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.r),
                                              child: Column(children: [
                                                Text(
                                                  'Cost',
                                                  style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 15.sp),
                                                ),
                                                SizedBox(
                                                  height: 5.r,
                                                ),
                                                Text(
                                                  '202E',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                          ),
                          onTap: (){
                            navigateTo(context, RequestDetailsScreen());
                          },
                        );
                      },
                    ),
              state is RequestInitial
                  ? const Center(
                  child: CircularProgressIndicator(
                    color: black,
                  ))
                  : ListView.builder(
                key: const PageStorageKey<String>('tab2'),
                scrollDirection: Axis.vertical,
                itemCount: DashBoardCubit.get(context).request.length,
                itemBuilder: (context, i) {
                  var list = DashBoardCubit.get(context).request;
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
                                        'Nasr City,Cairo,Egypt',
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
                              height: 15.r,
                            ),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Card(
                                  color: yellowLightColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(15.r),
                                    child: Column(children: [
                                      Text(
                                        'Days',
                                        style: TextStyle(
                                            color: grey2,
                                            fontSize: 15.sp),
                                      ),
                                      SizedBox(
                                        height: 5.r,
                                      ),
                                      Text(
                                        '4 Days',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                  ),
                                ),
                                Card(
                                  color: Colors.redAccent.withOpacity(.3),
                                  child: Padding(
                                    padding: EdgeInsets.all(15.r),
                                    child: Column(children: [
                                      Text(
                                        'Start Date',
                                        style: TextStyle(
                                            color: grey2,
                                            fontSize: 15.sp),
                                      ),
                                      SizedBox(
                                        height: 5.r,
                                      ),
                                      Text(
                                        '15 feb 2022',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                  ),
                                ),
                                Card(
                                  color: greenLightColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(15.r),
                                    child: Column(children: [
                                      Text(
                                        'End Date',
                                        style: TextStyle(
                                            color: grey2,
                                            fontSize: 15.sp),
                                      ),
                                      SizedBox(
                                        height: 5.r,
                                      ),
                                      Text(
                                        '15 feb 2022',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    color: blueColor,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.r),
                                      child: Column(children: [
                                        Text(
                                          'Cost',
                                          style: TextStyle(
                                              color: grey2,
                                              fontSize: 15.sp),
                                        ),
                                        SizedBox(
                                          height: 5.r,
                                        ),
                                        Text(
                                          '202E',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 15.sp,
                                              fontWeight:
                                              FontWeight.bold),
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
              ListView.builder(
                key: const PageStorageKey<String>('tab3'),
                scrollDirection: Axis.vertical,
                itemCount: DashBoardCubit.get(context).request.length,
                itemBuilder: (context, i) {
                  var list = DashBoardCubit.get(context).request;
                  return ListTile(
                    title: Container(
                      height: 1.sh,
                      margin:
                          EdgeInsets.symmetric(vertical: 5.r, horizontal: 15.r),
                      child: Container(
                        color: primaryColor,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.r, horizontal: 15.r),
                        child: Center(
                          child: Text(
                            list[i].title!,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold),
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
                  icon: Icon(Icons.home), label: "upcoming "),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_pin_outlined), label: "past "),
            ],
          ),
        );
      }),
    );
  }
}

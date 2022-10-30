import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/notifications/notification_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/RequestDetailsScreen.dart';
import 'package:getn_driver/presentation/ui/trip/tripDetails/TripDetailsScreen.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ScrollController _controllerNotification;
  bool loadingNotification = false;

  @override
  void initState() {
    super.initState();
    _controllerNotification = ScrollController();
    NotificationCubit.get(context).getNotification(1);
  }

  @override
  void dispose() {
    super.dispose();
    _controllerNotification.removeListener(_loadMoreWallet);
  }

  void _loadMoreWallet() {
    NotificationCubit.get(context)
        .getNotification(NotificationCubit.get(context).indexNotification);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state is NotificationSuccessState) {
          setState(() {
            loadingNotification = false;
          });
        } else if (state is NotificationErrorState) {
          setState(() {
            loadingNotification = false;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            controller: _controllerNotification
              ..addListener(() async {
                if (_controllerNotification.position.extentAfter == 0 &&
                    !loadingNotification) {
                  setState(() {
                    print("_controllerNotification*********** ");
                    loadingNotification = true;
                  });
                  _loadMoreWallet();
                }
              }),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 15.r),
              child: state is NotificationLoading
                  ? loading()
                  : state is NotificationSuccessState
                      ? NotificationCubit.get(context).notification.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: NotificationCubit.get(context)
                                  .notification
                                  .length,
                              itemBuilder: (context, index) {
                                var notification =
                                    NotificationCubit.get(context)
                                        .notification[index];
                                return Column(
                                  children: [
                                    InkWell(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                notification.title!.en!,
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: black,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    DateFormat.yMEd().format(
                                                        DateTime.parse(
                                                            notification
                                                                .createdAt!)),
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
                                                            notification
                                                                .createdAt!)),
                                                    style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            notification.content!.en!,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: greyColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          const Divider(),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        if (notification.type == "request") {
                                          navigateTo(
                                              context,
                                              RequestDetailsScreen(
                                                idRequest: notification.id,
                                              ));
                                        } else if (notification.type ==
                                            "trip") {
                                          navigateTo(
                                              context,
                                              TripDetailsScreen(
                                                idTrip: notification.id,
                                              ));
                                        }
                                      },
                                    ),
                                    index ==
                                                NotificationCubit.get(context)
                                                        .notification
                                                        .length -
                                                    1 &&
                                            loadingNotification
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
                            )
                          : errorMessage2(
                              message: 'Not Found Data',
                              press: () {
                                NotificationCubit.get(context)
                                    .getNotification(1);
                              })
                      : state is NotificationErrorState
                          ? errorMessage2(
                              message: state.message,
                              press: () {
                                NotificationCubit.get(context)
                                    .getNotification(1);
                              })
                          : Container(),
            ),
          ),
        );
      },
    );
  }
}

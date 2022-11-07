import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/notifications/notification_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/RequestDetailsScreen.dart';
import 'package:getn_driver/presentation/ui/trip/tripDetails/TripDetailsScreen.dart';
import 'package:getn_driver/presentation/ui/wallet/WalletScreen.dart';
import 'package:intl/intl.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool loadingNotification = false;

  @override
  void initState() {
    super.initState();
    NotificationCubit.get(context).getNotification(1);

    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }
  }

  void _loadMoreNotification() {
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
        return Directionality(
          textDirection: LanguageCubit.get(context).isEn
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                LanguageCubit.get(context)
                    .getTexts('Notifications')
                    .toString(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              centerTitle: true,
            ),
            body: ScrollEdgeListener(
              edge: ScrollEdge.end,
              // edgeOffset: 400,
              // continuous: false,
              // debounce: const Duration(milliseconds: 500),
              // dispatch: true,
              listener: () {
                setState(() {
                  print("_controllerNotification*********** ");
                  loadingNotification = true;
                });
                _loadMoreNotification();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.r, horizontal: 15.r),
                  child: state is NotificationLoading
                      ? loading()
                      : state is NotificationSuccessState
                          ? NotificationCubit.get(context)
                                  .notification
                                  .isNotEmpty
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    LanguageCubit.get(
                                                                context)
                                                            .isEn
                                                        ? notification
                                                                .title!.en! ??
                                                            ""
                                                        : notification
                                                                .title!.ar! ??
                                                            "",
                                                    style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: black,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        LanguageCubit.get(
                                                                    context)
                                                                .isEn
                                                            ? DateFormat.yMEd().format(
                                                                DateTime.parse(
                                                                    notification
                                                                        .createdAt!))
                                                            : DateFormat.yMEd(
                                                                    "ar")
                                                                .format(DateTime.parse(
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
                                                        LanguageCubit.get(
                                                                    context)
                                                                .isEn
                                                            ? DateFormat.jm().format(
                                                                DateTime.parse(
                                                                    notification
                                                                        .createdAt!))
                                                            : DateFormat.jm(
                                                                    "ar")
                                                                .format(DateTime.parse(
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
                                                LanguageCubit.get(context).isEn
                                                    ? notification
                                                            .content!.en! ??
                                                        ""
                                                    : notification
                                                            .content!.ar! ??
                                                        "",
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
                                            if (notification.type ==
                                                    "request" ||
                                                notification.type ==
                                                    "payment") {
                                              navigateTo(
                                                  context,
                                                  RequestDetailsScreen(
                                                    idRequest:
                                                        notification.typeId,
                                                  ));
                                            } else if (notification.type ==
                                                "trip") {
                                              navigateTo(
                                                  context,
                                                  TripDetailsScreen(
                                                    idTrip: notification.typeId,
                                                  ));
                                            } else if (notification.type ==
                                                    "walletTransaction" ||
                                                notification.type ==
                                                    "requestTransaction") {
                                              navigateTo(context,
                                                  const WalletScreen());
                                            }
                                          },
                                        ),
                                        index ==
                                                    NotificationCubit.get(
                                                                context)
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
                                  message: LanguageCubit.get(context)
                                      .getTexts('NotFoundData')
                                      .toString(),
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
            ),
          ),
        );
      },
    );
  }
}

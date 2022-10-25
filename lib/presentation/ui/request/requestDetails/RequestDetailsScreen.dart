import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/request_details_cubit.dart';
import 'package:getn_driver/presentation/ui/trip/tripCreate/TripCreateScreen.dart';
import 'package:getn_driver/presentation/ui/trip/tripDetails/TripDetailsScreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetailsScreen extends StatefulWidget {
  const RequestDetailsScreen({Key? key, this.idRequest}) : super(key: key);

  final String? idRequest;

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  // double _userRating = 3.0;
  var btnStatus = {
    'pending': ['accept', 'reject'],
    'accept': ['on_my_way', 'reject'],
    'on_my_way': ['arrive', 'reject'],
    'arrive': ['start', 'reject'],
    'coming': ['start', 'reject'],
    'start': ['end', 'mid_pause'],
    'end': [],
    'mid_pause': [],
    'reject': [],
    'cancel': []
  };

  var btnStatus2 = {
    'pending': ['Accept', 'Reject'],
    'accept': ['On My Way', 'Cancel'],
    'on_my_way': ['Arrive', 'Cancel'],
    'arrive': ['Start', 'Cancel'],
    'coming': ['Start', 'Cancel'],
    'start': ['End', 'Cancel'],
    'end': [],
    'mid_pause': [],
    'reject': [],
    'cancel': []
  };

  int? indexStatus;
  late ScrollController _controllerLoadingTrips;

  void _loadMoreTrips() {
    RequestDetailsCubit
        .get(context)
        .loadingMoreTrips = false;
    RequestDetailsCubit.get(context).getTripsRequestDetails(
        RequestDetailsCubit
            .get(context)
            .indexTrips, widget.idRequest!);
  }

  @override
  void initState() {
    super.initState();

    _controllerLoadingTrips = ScrollController();
    getIt<SharedPreferences>().setString('typeScreen', "requestDetails");
    RequestDetailsCubit
        .get(context)
        .indexTrips = 1;
    RequestDetailsCubit
        .get(context)
        .trips = [];
    RequestDetailsCubit
        .get(context)
        .loadingMoreTrips = false;
    RequestDetailsCubit
        .get(context)
        .loadingTrips = false;
    RequestDetailsCubit
        .get(context)
        .loadingRequest = false;
    RequestDetailsCubit
        .get(context)
        .failureRequest = "";
    RequestDetailsCubit
        .get(context)
        .failureTrip = "";
    RequestDetailsCubit.get(context).getRequestDetails(widget.idRequest!);
    RequestDetailsCubit.get(context)
        .getTripsRequestDetails(1, widget.idRequest!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerLoadingTrips.removeListener(_loadMoreTrips);

    getIt<SharedPreferences>().setString('typeScreen', "");
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestDetailsCubit, RequestDetailsState>(
      listener: (context, state) async {
        if (state is RequestDetailsEditSuccessState) {
          RequestDetailsCubit.get(context).getRequestDetails(widget.idRequest!);
          RequestDetailsCubit.get(context)
              .getTripsRequestDetails(1, widget.idRequest!);
        } else if (state is RequestDetailsEditErrorState) {
          // Navigator.pop(context);
          showToastt(
              text: state.message, state: ToastStates.error, context: context);
        } else if (state is CurrentLocationSuccessState) {
          print('CurrentLocationSuccessState********* ');
          String id = await navigateToWithRefreshPagePrevious(
            context,
            TripCreateScreen(
              requestId: widget.idRequest!,
              fromLatitude: state.position.latitude,
              fromLongitude: state.position.longitude,
            ),
          );
          setState(() {
            print("CurrentLocationSuccessState************ ${id}");
            if (id.isNotEmpty) {
              getIt<SharedPreferences>()
                  .setString('typeScreen', "requestDetails");
              RequestDetailsCubit
                  .get(context)
                  .indexTrips = 1;
              RequestDetailsCubit
                  .get(context)
                  .trips = [];
              RequestDetailsCubit
                  .get(context)
                  .loadingMoreTrips = false;
              RequestDetailsCubit
                  .get(context)
                  .loadingTrips = false;
              RequestDetailsCubit
                  .get(context)
                  .loadingRequest = false;
              RequestDetailsCubit
                  .get(context)
                  .failureRequest = "";
              RequestDetailsCubit
                  .get(context)
                  .failureTrip = "";
              RequestDetailsCubit.get(context).getRequestDetails(id);
              RequestDetailsCubit.get(context).getTripsRequestDetails(1, id);
            }
          });
        } else if (state is CurrentLocationErrorState) {
          if (kDebugMode) {
            print('CurrentLocationErrorState********* ${state.error}');
          }
          if (state.error == "denied") {
            showDialog(
              context: context,
              barrierDismissible: false,
              // outside to dismiss
              builder: (BuildContext context) {
                return CustomDialog(
                  title: "Location",
                  description: 'Location permissions are denied',
                  press: () {
                    Navigator.pop(context);
                  },
                  type: "checkLocationDenied",
                );
              },
            );
          } else if (state.error == "deniedForever") {
            showDialog(
              context: context,
              barrierDismissible: false,
              // outside to dismiss
              builder: (BuildContext mContext) {
                return CustomDialog(
                  title: "Location",
                  description:
                  'Location permissions are permanently denied\n You must enable the access location so that we can determine your location and save the visit\n choose setting and enable location then try back',
                  press: () {
                    Navigator.pop(context);
                  },
                  type: "checkLocationDeniedForever",
                );
              },
            );
          }
        }
      },
      builder: (context, state) {
        final currentDate = DateTime.now();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Requests',
              style: TextStyle(color: primaryColor, fontSize: 20.sp),
            ),
            centerTitle: true,
            elevation: 1.0,
          ),
          body: RequestDetailsCubit
              .get(context)
              .loadingRequest
              ? const Center(
              child: CircularProgressIndicator(
                color: black,
              ))
              : RequestDetailsCubit
              .get(context)
              .requestDetails!
              .id != null
              ? Container(
            margin: EdgeInsets.symmetric(
                horizontal: 15.r, vertical: 20.r),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: _controllerLoadingTrips
                ..addListener(() async {
                  if (_controllerLoadingTrips.position.extentAfter ==
                      0) {
                    if (RequestDetailsCubit
                        .get(context)
                        .loadingMoreTrips) {
                      _loadMoreTrips();
                    }
                  }
                }),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: ImageTools.image(
                            fit: BoxFit.fill,
                            url: RequestDetailsCubit
                                .get(context)
                                .requestDetails!
                                .client2!
                                .image!
                                .src,
                            height: 70.w,
                            width: 70.w),
                      ),
                      Expanded(
                        child: Container(
                          margin:
                          EdgeInsets.symmetric(horizontal: 20.r),
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
                                      RequestDetailsCubit
                                          .get(context)
                                          .requestDetails!
                                          .client2!
                                          .name!,
                                      style: TextStyle(
                                          fontSize: 20.sp,
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
                                '${RequestDetailsCubit
                                    .get(context)
                                    .requestDetails!
                                    .client2!
                                    .country!
                                    .title!
                                    .en!}, ${RequestDetailsCubit
                                    .get(context)
                                    .requestDetails!
                                    .client2!
                                    .city
                                    ?.title!
                                    .en!}, ${RequestDetailsCubit
                                    .get(context)
                                    .requestDetails!
                                    .client2!
                                    .area
                                    ?.title!
                                    .en!}',
                                style: TextStyle(
                                    fontSize: 18.sp, color: grey2),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: defaultButtonWithIcon(
                                        press: () {
                                          if (RequestDetailsCubit
                                              .get(
                                              context)
                                              .requestDetails
                                              ?.client2
                                              ?.phone !=
                                              null) {
                                            print(
                                                'phone*************** ${RequestDetailsCubit
                                                    .get(context)
                                                    .requestDetails
                                                    ?.client2
                                                    ?.country
                                                    ?.code}${RequestDetailsCubit
                                                    .get(context)
                                                    .requestDetails
                                                    ?.client2
                                                    ?.phone}');
                                            _makePhoneCall(
                                                '${RequestDetailsCubit
                                                    .get(context)
                                                    .requestDetails
                                                    ?.client2
                                                    ?.country
                                                    ?.code}${RequestDetailsCubit
                                                    .get(context)
                                                    .requestDetails
                                                    ?.client2
                                                    ?.phone}');
                                          } else {
                                            showToastt(
                                                text: "this client not have phone...",
                                                state: ToastStates.error,
                                                context: context);
                                          }
                                        },
                                        fontSize: 18,
                                        paddingVertical: 1,
                                        paddingHorizontal: 5,
                                        borderRadius: 10,
                                        text: 'Call Client',
                                        backColor: greenColor,
                                        textColor: white,
                                        icon: Icons.phone),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                    child: defaultButtonWithIcon(
                                        press: () {
                                          openWhatsapp('${RequestDetailsCubit
                                              .get(context)
                                              .requestDetails
                                              ?.client2
                                              ?.country
                                              ?.code}${RequestDetailsCubit
                                              .get(context)
                                              .requestDetails
                                              ?.client2
                                              ?.phone}');
                                        },
                                        fontSize: 18,
                                        paddingVertical: 1,
                                        paddingHorizontal: 5,
                                        borderRadius: 10,
                                        text: 'WhatsApp',
                                        backColor: greenColor,
                                        textColor: white,
                                        icon: Icons.whatsapp),
                                  ),
                                ],
                              )
                              /* RatingBar.builder(
                                          minRating: _userRating,
                                          itemBuilder: (context, index) =>
                                              const Icon(
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
                                          unratedColor:
                                              Colors.amber.withAlpha(50),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Status :',
                                style: TextStyle(
                                  color: black,
                                  fontSize: 15.sp,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                RequestDetailsCubit
                                    .get(context)
                                    .requestDetails!
                                    .status!,
                                style: TextStyle(
                                    color: grey2, fontSize: 14.sp),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Payment Status :',
                                style: TextStyle(
                                  color: black,
                                  fontSize: 15.sp,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                RequestDetailsCubit
                                    .get(context)
                                    .requestDetails!
                                    .paymentStatus!,
                                style: TextStyle(
                                    color: grey2, fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trip start and date',
                            style: TextStyle(
                              color: black,
                              fontSize: 15.sp,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat.yMEd().format(
                                    DateTime.parse(
                                        RequestDetailsCubit
                                            .get(
                                            context)
                                            .requestDetails!
                                            .from!
                                            .date!)),
                                style: TextStyle(
                                    color: grey2, fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                DateFormat.jm().format(DateTime.parse(
                                    RequestDetailsCubit
                                        .get(context)
                                        .requestDetails!
                                        .from!
                                        .date!)),
                                style: TextStyle(
                                  color: grey2,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Picked Location',
                              style: TextStyle(
                                  color: greenColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              RequestDetailsCubit
                                  .get(context)
                                  .requestDetails!
                                  .from!
                                  .placeTitle!,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: grey2,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  btnStatus['${RequestDetailsCubit
                      .get(context)
                      .requestDetails!
                      .status}']!
                      .isNotEmpty
                      ? Column(
                    children: [
                      SizedBox(
                          height: 50.h,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              state is! RequestDetailsEditInitial
                                  ? Expanded(
                                child: defaultButton2(
                                  press: () {
                                    RequestDetailsCubit
                                        .get(context)
                                        .editRequest(
                                        RequestDetailsCubit
                                            .get(
                                            context)
                                            .requestDetails!
                                            .id!,
                                        btnStatus[
                                        '${RequestDetailsCubit
                                            .get(context)
                                            .requestDetails!
                                            .status}']![0],
                                        "");
                                  },
                                  disablePress: RequestDetailsCubit
                                      .get(
                                      context)
                                      .requestDetails
                                      ?.paymentStatus! ==
                                      "paid"
                                      ? true
                                      : false,
                                  fontSize: 20,
                                  paddingVertical: 1,
                                  paddingHorizontal: 10,
                                  borderRadius: 10,
                                  text: btnStatus2[
                                  '${RequestDetailsCubit
                                      .get(context)
                                      .requestDetails!
                                      .status}']![0],
                                  backColor: greenColor,
                                  textColor: white,
                                ),
                              )
                                  : Expanded(
                                child: SizedBox(
                                  width: 20.w,
                                  child:
                                  const CircularProgressIndicator(
                                    color: accentColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                child: defaultButton2(
                                    press: () {
                                      final currentDate =
                                      DateTime.now();
                                      final dateDeadline = DateFormat(
                                          "yyyy-MM-ddTHH:mm")
                                          .parse(RequestDetailsCubit
                                          .get(context)
                                          .requestDetails!
                                          .from!
                                          .date!)
                                          .subtract(
                                        const Duration(
                                          hours: 24,
                                        ),
                                      );

                                      if (currentDate.isBefore(
                                          dateDeadline)) {
                                        showDialog(
                                          context: context,
                                          barrierDismissible:
                                          true,
                                          // outside to dismiss
                                          builder: (BuildContext
                                          context) {
                                            return CustomDialog(
                                              title: 'Warning',
                                              description:
                                              'you will charged a cancelation fee..',
                                              backgroundColor:
                                              white,
                                              btnOkColor:
                                              accentColor,
                                              btnCancelColor:
                                              grey,
                                              id: RequestDetailsCubit
                                                  .get(
                                                  context)
                                                  .requestDetails!
                                                  .id,
                                              titleColor:
                                              accentColor,
                                              descColor: black,
                                            );
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          barrierDismissible:
                                          true,
                                          // outside to dismiss
                                          builder: (BuildContext
                                          context) {
                                            return CustomDialog(
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
                                              id: RequestDetailsCubit
                                                  .get(
                                                  context)
                                                  .requestDetails!
                                                  .id,
                                              titleColor:
                                              accentColor,
                                              descColor: black,
                                            );
                                          },
                                        );
                                      }
                                    },
                                    disablePress: RequestDetailsCubit
                                        .get(
                                        context)
                                        .requestDetails
                                        ?.paymentStatus! ==
                                        "paid"
                                        ? true
                                        : false,
                                    fontSize: 20,
                                    paddingVertical: 1,
                                    paddingHorizontal: 10,
                                    borderRadius: 10,
                                    text: btnStatus2[
                                    '${RequestDetailsCubit
                                        .get(context)
                                        .requestDetails!
                                        .status}']![1],
                                    backColor: greenColor,
                                    textColor: white),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  )
                      : Container(),

                  RequestDetailsCubit
                      .get(context)
                      .requestDetails
                      ?.paymentStatus! ==
                      "paid"
                      ? Container()
                      : Text(
                    'the client you should paid first',
                    style: TextStyle(
                        color: accentColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold),
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
                  RequestDetailsCubit
                      .get(context)
                      .requestDetails!
                      .status !=
                      null &&
                      RequestDetailsCubit
                          .get(context)
                          .requestDetails!
                          .status ==
                          "start" &&
                      currentDate.isBefore(
                        DateFormat("yyyy-MM-ddTHH:mm").parse(
                            RequestDetailsCubit
                                .get(context)
                                .requestDetails!
                                .to!),
                      ) &&
                      currentDate.isAfter(
                        DateFormat("yyyy-MM-ddTHH:mm").parse(
                            RequestDetailsCubit
                                .get(context)
                                .requestDetails!
                                .from!
                                .date!),
                      )
                      ? state is CurrentLocationLoading
                      ? const Center(
                      child: CircularProgressIndicator(
                        color: black,
                      ))
                      : defaultButton2(
                      text: 'Add Trip',
                      press: () {
                        RequestDetailsCubit.get(context)
                            .getCurrentLocation();
                      },
                      textColor: white,
                      backColor: accentColor)
                      : Container(),
                  SizedBox(
                    height: 15.h,
                  ),
                  RequestDetailsCubit
                      .get(context)
                      .loadingTrips
                      ? const Center(
                      child: CircularProgressIndicator(
                        color: black,
                      ))
                      : RequestDetailsCubit
                      .get(context)
                      .trips
                      .isNotEmpty
                      ? ListView.builder(
                    physics:
                    const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                    RequestDetailsCubit
                        .get(context)
                        .trips
                        .length,
                    itemBuilder: (context, i) {
                      var trip =
                      RequestDetailsCubit
                          .get(context)
                          .trips[i];
                      return InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.r),
                          child: Card(
                            elevation: 5.r,
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              color: white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.r,
                                  horizontal: 15.r),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
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
                                        flex: 3,
                                        child: Padding(
                                          padding:
                                          EdgeInsetsDirectional
                                              .only(
                                              end: 10
                                                  .r),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                'Picked Point',
                                                style: TextStyle(
                                                    color:
                                                    black,
                                                    fontSize: 15
                                                        .sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              SizedBox(
                                                  height:
                                                  10.h),
                                              Text(
                                                trip.from!
                                                    .placeTitle!,
                                                style: TextStyle(
                                                    color:
                                                    grey2,
                                                    fontSize:
                                                    14.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .end,
                                              children: [
                                                Text(
                                                  'Status :',
                                                  style:
                                                  TextStyle(
                                                    color:
                                                    black,
                                                    fontSize:
                                                    15.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                  5.w,
                                                ),
                                                Text(
                                                  trip.status!,
                                                  style: TextStyle(
                                                      color:
                                                      grey2,
                                                      fontSize:
                                                      14.sp),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            Text(
                                              DateFormat
                                                  .jm()
                                                  .format(DateTime
                                                  .parse(
                                                  trip.startDate!)),
                                              style:
                                              TextStyle(
                                                color:
                                                grey2,
                                                fontSize:
                                                14.sp,
                                              ),
                                            ),
                                            Text(
                                              DateFormat
                                                  .yMEd()
                                                  .format(DateTime
                                                  .parse(
                                                  trip.startDate!)),
                                              style: TextStyle(
                                                  color:
                                                  grey2,
                                                  fontSize:
                                                  13.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
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
                                        flex: 3,
                                        child: Padding(
                                          padding:
                                          EdgeInsetsDirectional
                                              .only(
                                              end: 10
                                                  .r),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                'Picked Point',
                                                style: TextStyle(
                                                    color:
                                                    black,
                                                    fontSize: 15
                                                        .sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              SizedBox(
                                                  height:
                                                  5.h),
                                              Text(
                                                trip.to!
                                                    .placeTitle!,
                                                style: TextStyle(
                                                    color:
                                                    grey2,
                                                    fontSize:
                                                    14.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .end,
                                          children: [
                                            Text(
                                              '12:00 am',
                                              // DateFormat.jm().format(DateTime.parse(
                                              //     trip.to!.date!)),
                                              style:
                                              TextStyle(
                                                color:
                                                grey2,
                                                fontSize:
                                                14.sp,
                                              ),
                                            ),
                                            Text(
                                              '12/2/20200',
                                              // DateFormat.yMEd().format(
                                              //     DateTime.parse(
                                              //         trip.to!.date!)),
                                              style: TextStyle(
                                                  color:
                                                  grey2,
                                                  fontSize:
                                                  13.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
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
                                              EdgeInsets
                                                  .all(10
                                                  .r),
                                              child: Column(
                                                  children: [
                                                    Text(
                                                      'Distance',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                      5.r,
                                                    ),
                                                    Text(
                                                      trip.consumptionKM!
                                                          .toStringAsFixed(2),
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
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
                                              EdgeInsets
                                                  .all(10
                                                  .r),
                                              child: Column(
                                                  children: [
                                                    Text(
                                                      'Points',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                      5.r,
                                                    ),
                                                    Text(
                                                      trip.consumptionPoints!
                                                          .toStringAsFixed(2),
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .bold),
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
                                              EdgeInsets
                                                  .all(10
                                                  .r),
                                              child: Column(
                                                  children: [
                                                    Text(
                                                      '1 Km Points',
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                      5.r,
                                                    ),
                                                    Text(
                                                      trip.oneKMPoints
                                                          .toString(),
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
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
                          print(
                              "typeId44************ ${widget.idRequest!}");
                          String id =
                          await navigateToWithRefreshPagePrevious(
                              context,
                              TripDetailsScreen(
                                idTrip:
                                RequestDetailsCubit
                                    .get(
                                    context)
                                    .trips[i]
                                    .id,
                                idRequest:
                                widget.idRequest!,
                              ));
                          setState(() {
                            print(
                                "typeId33************ ${id}");
                            if (id.isNotEmpty) {
                              getIt<SharedPreferences>()
                                  .setString('typeScreen',
                                  "requestDetails");
                              RequestDetailsCubit
                                  .get(
                                  context)
                                  .indexTrips = 1;
                              RequestDetailsCubit
                                  .get(
                                  context)
                                  .trips = [];
                              RequestDetailsCubit
                                  .get(
                                  context)
                                  .loadingMoreTrips = false;
                              RequestDetailsCubit
                                  .get(
                                  context)
                                  .loadingTrips = false;
                              RequestDetailsCubit
                                  .get(
                                  context)
                                  .loadingRequest = false;
                              RequestDetailsCubit
                                  .get(
                                  context)
                                  .failureRequest = "";
                              RequestDetailsCubit
                                  .get(
                                  context)
                                  .failureTrip = "";
                              RequestDetailsCubit.get(
                                  context)
                                  .getRequestDetails(id);
                              RequestDetailsCubit.get(
                                  context)
                                  .getTripsRequestDetails(
                                  1, id);
                            }
                          });
                        },
                      );
                    },
                  )
                      : Center(
                    child: Text(
                      RequestDetailsCubit
                          .get(context)
                          .failureTrip,
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: blueColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
              : Center(
            child: Text(
              RequestDetailsCubit
                  .get(context)
                  .failureRequest,
              style: TextStyle(
                  fontSize: 20.sp,
                  color: blueColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  // Future<void> openWhatsapp(String whatsapp) async {
  //   String whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
  //   String whatsappURLIos =
  //       "https://wa.me/$whatsapp}";
  //   if (Platform.isIOS) {
  //     if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
  //       await launchUrl(Uri.parse(whatsappURLIos));
  //     } else {
  //       showToastt(
  //           text: "whatsapp no installed",
  //           state: ToastStates.error,
  //           context: context);
  //     }
  //   } else {
  //     launchUrl(Uri.parse('https://wa.me/$whatsapp?text=Hi'),
  //         mode: LaunchMode.externalApplication);
  //     // if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
  //     //   await launchUrl(Uri.parse(whatsappURlAndroid));
  //     // } else {
  //     //   showToastt(
  //     //       text: "whatsapp no installed",
  //     //       state: ToastStates.error,
  //     //       context: context);
  //     // }
  //   }
  // }

  void openWhatsapp(String whatsapp) async {

    var androidUrl = "whatsapp://send?phone=$whatsapp";
    var iosUrl = "https://wa.me/$whatsapp";

    try{
      if(Platform.isIOS){
        await launchUrl(Uri.parse(iosUrl));
      }
      else{
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception{
      showToastt(
          text: "whatsapp no installed",
          state: ToastStates.error,
          context: context);
    }

  }
}
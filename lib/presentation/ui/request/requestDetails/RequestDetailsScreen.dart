import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/request_details_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/request_cubit.dart';
import 'package:getn_driver/presentation/ui/trip/tripDetails/TripDetailsScreen.dart';
import 'package:intl/intl.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    'en': {
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
    },
    'ar': {
      'pending': ['قبول', 'رفض'],
      'accept': ['في الطريق', 'إلغاء'],
      'on_my_way': ['وصلت', 'إلغاء'],
      'arrive': ['إبدأ', 'إلغاء'],
      'coming': ['إبدأ', 'إلغاء'],
      'start': ['إنهاء', 'إلغاء'],
      'end': [],
      'mid_pause': [],
      'reject': [],
      'cancel': []
    },
  };

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
    },
  };

  int? indexStatus;
  var formKeyRequest = GlobalKey<FormState>();
  var commentController = TextEditingController();
  bool loadingMoreTrips = false;
  String idRequest = '';
  
  void _loadMoreTrips(BuildContext context) {
    RequestDetailsCubit.get(context).getTripsRequestDetails(
        RequestDetailsCubit.get(context).indexTrips, idRequest);
  }

  @override
  void initState() {
    super.initState();
    
    idRequest = widget.idRequest!;
    RequestDetailsCubit.get(context)
        .getRequestDetails(idRequest);
    
    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }
  }

  void viewWillAppear() {
    print("onResume / viewWillAppear / onFocusGained     RequestDetailsScreen");
    getIt<SharedPreferences>().setString('typeScreen', "requestDetails");
    getIt<SharedPreferences>().setString('requestDetailsId', idRequest);
    getIt<SharedPreferences>().setString('tripDetailsId', "");
  }

  void viewWillDisappear() {
    print("onPause / viewWillDisappear / onFocusLost    RequestDetailsScreen");
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: viewWillAppear,
      onFocusLost: viewWillDisappear,
      child: BlocConsumer<RequestDetailsCubit, RequestDetailsState>(
        listener: (context, state) async {
          if (state is RequestDetailsSuccessState) {
            RequestDetailsCubit.get(context)
                .getTripsRequestDetails(1, idRequest);
          }
          else if (state is RequestDetailsEditSuccessState) {
            if (state.type == "reject" ||
                state.type == "mid_pause" ||
                state.type == "end") {
              if (RequestCubit.get(navigatorKey.currentContext).typeRequest ==
                  "past") {
                RequestCubit.get(navigatorKey.currentContext)
                    .tabControllerChanged = false;
                RequestCubit.get(navigatorKey.currentContext)
                    .tabController!
                    .index = 2;
                RequestCubit.get(navigatorKey.currentContext)
                    .tabController!
                    .notifyListeners();
              } else {
                RequestCubit.get(navigatorKey.currentContext)
                    .tabControllerChanged = true;
                RequestCubit.get(navigatorKey.currentContext)
                    .tabController!
                    .animateTo(2);
              }
              Navigator.pop(context);
            }

            if (state.type == "on_my_way") {
              if (RequestCubit.get(navigatorKey.currentContext).typeRequest ==
                  "current") {
                RequestCubit.get(navigatorKey.currentContext)
                    .tabControllerChanged = false;
                RequestCubit.get(navigatorKey.currentContext)
                    .tabController!
                    .index = 0;
                RequestCubit.get(navigatorKey.currentContext)
                    .tabController!
                    .notifyListeners();
              } else {
                RequestCubit.get(navigatorKey.currentContext)
                    .tabControllerChanged = true;
                RequestCubit.get(navigatorKey.currentContext)
                    .tabController!
                    .animateTo(0);
              }
            }

            RequestDetailsCubit.get(context)
                .getRequestDetails(idRequest);
          }
          else if (state is RequestDetailsEditErrorState) {
            if (state.type == "reject" ||
                state.type == "mid_pause" ||
                state.type == "end") {
              Navigator.pop(context);
            }
            if (state.message == "you can't start request now") {
              showToastt(
                  text: LanguageCubit.get(context)
                      .getTexts('journeyStartedYet')
                      .toString(),
                  state: ToastStates.error,
                  context: context);
            } else if (state.message == 'network not available') {
              showDialog(
                context: context,
                barrierDismissible: true,
                // outside to dismiss
                builder: (_) {
                  return CustomNotHaveNetwork(
                    idRequest:
                    RequestDetailsCubit.get(context).requestDetails!.id!,
                  );
                },
              );
            } else {
              showToastt(
                  text: state.message,
                  state: ToastStates.error,
                  context: context);
            }
          }
          else if (state is CurrentLocationSuccessState) {
            print('CurrentLocationSuccessState********* ');
            // this belong add trip
            /*String id = await navigateToWithRefreshPagePrevious(
              context,
              TripCreateScreen(
                requestId: idRequestTrip,
                fromLatitude: state.position.latitude,
                fromLongitude: state.position.longitude,
              ),
            );
            setState(() {
              print("CurrentLocationSuccessState************ ${id}");
              if (id.isNotEmpty) {
                getIt<SharedPreferences>()
                    .setString('typeScreen', "requestDetails");
                RequestDetailsCubit.get(context).indexTrips = 1;
                RequestDetailsCubit.get(context).trips = [];
                loadingMoreTrips = false;
                RequestDetailsCubit.get(context).loadingTrips = false;
                RequestDetailsCubit.get(context).loadingRequest = false;
                RequestDetailsCubit.get(context).failureRequest = "";
                RequestDetailsCubit.get(context).failureTrip = "";
                RequestDetailsCubit.get(context).getRequestDetails(id);
                RequestDetailsCubit.get(context).getTripsRequestDetails(1, id);
              }
            });*/

            String sLat = state.position.latitude.toString();
            String sLon = state.position.longitude.toString();

            launchInMap(sLat, sLon, RequestDetailsCubit.get(context).requestDetails!.from!.placeLatitude!,
                RequestDetailsCubit.get(context).requestDetails!.from!.placeLongitude!, context);
          } 
          else if (state is CurrentLocationErrorState) {
            if (kDebugMode) {
              print('CurrentLocationErrorState********* ${state.error}');
            }
            if (state.error == "denied") {
              showDialog(
                context: context,
                barrierDismissible: false,
                // outside to dismiss
                builder: (BuildContext context) {
                  return CustomDialogLocation(
                    title: LanguageCubit.get(context)
                        .getTexts('Location')
                        .toString(),
                    description: LanguageCubit.get(context)
                        .getTexts('LocationPermissions')
                        .toString(),
                    type: "checkLocationDenied",
                    backgroundColor: white,
                    btnOkColor: accentColor,
                    btnCancelColor: grey,
                    titleColor: accentColor,
                    descColor: black,
                  );
                },
              ).then((value) => Navigator.pop(context));
            } else if (state.error == "deniedForever") {
              showDialog(
                context: context,
                barrierDismissible: false,
                // outside to dismiss
                builder: (BuildContext mContext) {
                  return CustomDialogLocation(
                    title: LanguageCubit.get(context)
                        .getTexts('Location')
                        .toString(),
                    description: LanguageCubit.get(context)
                        .getTexts('LocationPermissionsPermanently')
                        .toString(),
                    type: "checkLocationDeniedForever",
                    backgroundColor: white,
                    btnOkColor: accentColor,
                    btnCancelColor: grey,
                    titleColor: accentColor,
                    descColor: black,
                  );
                },
              ).then((value) => Navigator.pop(context));
            }
          }
          else if (state is TripsSuccessState) {
            setState(() {
              loadingMoreTrips = false;
            });
          }
          else if (state is TripsErrorState) {
            setState(() {
              loadingMoreTrips = false;
            });
            if (state.message == 'network not available') {
              showDialog(
                context: context,
                barrierDismissible: true,
                // outside to dismiss
                builder: (_) {
                  return CustomNotHaveNetwork(
                    idRequest:
                    RequestDetailsCubit.get(context).requestDetails!.id!,
                  );
                },
              );
            }
          }
          else if (state is RequestDetailsLastTripSuccessState) {
            if(state.data!.data!.isNotEmpty){
              showDialog(
                context: context,
                barrierDismissible: true,
                // outside to dismiss
                builder: (_) {
                  return CustomDialogLastTrip(
                    idRequest:
                        RequestDetailsCubit.get(context).requestDetails!.id!,
                    idTrip: state.data!.data![0].id,
                    title: LanguageCubit.get(context)
                        .getTexts('Warning')
                        .toString(),
                    description: LanguageCubit.get(context)
                        .getTexts('lastTripDescription')
                        .toString(),
                  );
                },
              );
            }
            else if(state.data!.data!.isEmpty && state.type == 'end'){
              showDialog(
                context: context,
                barrierDismissible: true,
                // outside to dismiss
                builder: (_) {
                  print(
                      "CustomDialogRejectRequestDetails1************* ${btnStatus['${RequestDetailsCubit.get(context).requestDetails!.status}']![0]}");
                  return CustomDialogEndRequestDetails(
                    id: RequestDetailsCubit.get(context)
                        .requestDetails!
                        .id!,
                    title: LanguageCubit.get(context)
                        .getTexts('Requests')
                        .toString(),
                    description: LanguageCubit.get(context)
                        .getTexts('EndRequest')
                        .toString(),
                    status: btnStatus[
                    '${RequestDetailsCubit.get(context).requestDetails!.status}']![0],
                  );
                },
              );
            }
            else if(state.data!.data!.isEmpty && state.type == 'mid_pause'){

              final currentDate = DateTime.now();
              final dateFrom = DateFormat("yyyy-MM-ddTHH:mm")
                  .parse(RequestDetailsCubit.get(context)
                  .requestDetails!
                  .from!
                  .date!)
                  .difference(currentDate)
                  .inHours;

              final dateTo = DateFormat("yyyy-MM-ddTHH:mm")
                  .parse(RequestDetailsCubit.get(context)
                  .requestDetails!
                  .from!
                  .date!)
                  .difference(DateFormat("yyyy-MM-ddTHH:mm").parse(
                  RequestDetailsCubit.get(context)
                      .requestDetails!
                      .createdAt!))
                  .inHours;
              // print("dateFrom********$dateFrom");
              // print("dateTo********$dateTo");
              // from.date subtract  current now   / 1000 / 60 / 60
              // if result less than 24 or equal
              // from.date  subtract created at    /1000 / 60 / 60
              // if result grater than or equal      48
              // this condition on all reject
              if (dateFrom <= 24 && dateTo >= 48) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  // outside to dismiss
                  builder: (_) {
                    return CustomDialogRejectRequestDetails(
                        id: RequestDetailsCubit.get(context)
                            .requestDetails!
                            .id!,
                        title: LanguageCubit.get(context)
                            .getTexts('Warning')
                            .toString(),
                        description: LanguageCubit.get(context)
                            .getTexts('CancelationFee')
                            .toString(),
                        type: btnStatus[
                        '${RequestDetailsCubit.get(context).requestDetails!.status}']![1]);
                  },
                );
              }
              else {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  // outside to dismiss
                  builder: (_) {
                    return CustomDialogRejectRequestDetails(
                        id: RequestDetailsCubit.get(context)
                            .requestDetails!
                            .id!,
                        title: LanguageCubit.get(context)
                            .getTexts('DoReject')
                            .toString(),
                        description: LanguageCubit.get(context)
                            .getTexts('IfRejected')
                            .toString(),
                        type: btnStatus[
                        '${RequestDetailsCubit.get(context).requestDetails!.status}']![1]);
                  },
                );
              }
            }
          }
          else if (state is RequestDetailsLastTripErrorState) {
            print(
                "RequestDetailsLastTripErrorState************ ");
            if (state.message == 'network not available') {
              showDialog(
                context: context,
                barrierDismissible: true,
                // outside to dismiss
                builder: (_) {
                  return CustomNotHaveNetwork(
                    idRequest:
                        RequestDetailsCubit.get(context).requestDetails!.id!,
                  );
                },
              );
            }
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
                      .getTexts('RequestDetails')
                      .toString(),
                  style: TextStyle(color: primaryColor, fontSize: 20.sp),
                ),
                centerTitle: true,
                elevation: 1.0,
              ),
              body: RequestDetailsCubit.get(context).loadingRequest
                  ? loading()
                  : RequestDetailsCubit.get(context).failureRequest.isNotEmpty
                      ? errorMessage2(
                          message:
                              RequestDetailsCubit.get(context).failureRequest,
                          press: () {
                            RequestDetailsCubit.get(context).failureRequest =
                                "";
                            RequestDetailsCubit.get(context)
                                .getRequestDetails(idRequest);
                          },
                          context: context)
                      : RequestDetailsCubit.get(context).requestDetails!.id !=
                              null
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15.r, vertical: 20.r),
                              child: ScrollEdgeListener(
                                edge: ScrollEdge.end,
                                // edgeOffset: 400,
                                // continuous: false,
                                // debounce: const Duration(milliseconds: 500),
                                // dispatch: true,
                                listener: () {
                                  setState(() {
                                    print(
                                        "_controllerLoadingTrips*********** ${RequestDetailsCubit.get(context).indexTrips}");
                                    loadingMoreTrips = true;
                                  });
                                  _loadMoreTrips(context);
                                },
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      client(context),
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

                                      requestInfo(context),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      buttonStatus(context, state),

                                      RequestDetailsCubit.get(context)
                                                  .typeScreen
                                                  .isNotEmpty &&
                                              RequestDetailsCubit.get(context)
                                                      .typeScreen ==
                                                  "past"
                                          ? Container()
                                          : RequestDetailsCubit.get(context)
                                                      .requestDetails
                                                      ?.paymentStatus! ==
                                                  "paid"
                                              ? Container()
                                              : RequestDetailsCubit.get(context)
                                                          .requestDetails
                                                          ?.status ==
                                                      "reject"
                                                  ? Container()
                                                  : Text(
                                                      LanguageCubit.get(context)
                                                          .getTexts(
                                                              'clientNotPaidYet')
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: accentColor,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                      // add trip
                                      /*  SizedBox(
                                        height: 15.h,
                                      ),
                                      RequestDetailsCubit.get(context)
                                                      .requestDetails!
                                                      .status !=
                                                  null &&
                                              RequestDetailsCubit.get(context)
                                                      .requestDetails!
                                                      .status ==
                                                  "start" &&
                                              currentDate.isBefore(
                                                DateFormat("yyyy-MM-ddTHH:mm")
                                                    .parse(RequestDetailsCubit.get(
                                                            context)
                                                        .requestDetails!
                                                        .to!),
                                              ) &&
                                              currentDate.isAfter(
                                                DateFormat("yyyy-MM-ddTHH:mm")
                                                    .parse(RequestDetailsCubit.get(
                                                            context)
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
                                          : Container(),*/
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      trips(context, state),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                RequestDetailsCubit.get(context).failureRequest,
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: blueColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
            ),
          );
        },
      ),
    );
  }

  Widget client(BuildContext context) {
    DataRequest data = RequestDetailsCubit.get(context).requestDetails!;
    return Row(
      children: [
        ClipOval(
          clipBehavior: Clip.antiAlias,
          child: ImageTools.image(
              fit: BoxFit.fill,
              url: data.client2 != null ? data.client2!.image!.src : null,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.client2 != null ? data.client2!.name! : '',
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            LanguageCubit.get(context).isEn
                                ? '${data.client2 != null ? data.client2!.country!.title!.en : ""}, ${data.client2 != null ? data.client2!.city?.title!.en : ""}, ${data.client2 != null ? data.client2!.area?.title!.en : ""}'
                                : '${data.client2 != null ? data.client2!.country!.title!.ar : ""}, ${data.client2 != null ? data.client2!.city?.title!.ar : ""}, ${data.client2 != null ? data.client2!.area?.title!.ar : ""}',
                            style: TextStyle(fontSize: 18.sp, color: grey2),
                          ),
                        ],
                      ),
                    ),
                    RequestDetailsCubit.get(context).typeScreen.isNotEmpty &&
                                RequestDetailsCubit.get(context).typeScreen ==
                                    "past" ||
                            data.status == "end" ||
                            data.status == "mid_pause" ||
                            data.status == "reject" ||
                            data.status == "cancel" ||
                            data.paymentStatus! != "paid"
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              RequestDetailsCubit.get(context).getCurrentLocation();
                            },
                            icon: Icon(
                              Icons.wrong_location_sharp,
                              size: 25.w,
                            ))
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                RequestDetailsCubit.get(context).typeScreen.isNotEmpty &&
                            RequestDetailsCubit.get(context).typeScreen ==
                                "past" ||
                        data.status == "pending" ||
                        data.status == "end" ||
                        data.status == "reject" ||
                        data.status == "mid_pause" ||
                        data.status == "cancel" ||
                        data.paymentStatus! != "paid"
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: defaultButtonWithIcon(
                                press: () {
                                  if (data.client2 != null &&
                                      data.client2!.phone != null) {
                                    // print(
                                    //     'phone*************** ${data.client2?.country?.code}${data.client2?.phone}');
                                    makePhoneCall(
                                        '${data.client2?.country?.code}${data.client2?.phone}');
                                  } else {
                                    showToastt(
                                        text: LanguageCubit.get(context)
                                            .getTexts('ClientNotHavePhone')
                                            .toString(),
                                        state: ToastStates.error,
                                        context: context);
                                  }
                                },
                                fontSize: 18,
                                paddingVertical: 1,
                                paddingHorizontal: 5,
                                borderRadius: 10,
                                text: LanguageCubit.get(context)
                                    .getTexts('CallClient')
                                    .toString(),
                                backColor: accentColor,
                                textColor: white,
                                icon: Icons.phone),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Expanded(
                            child: defaultButtonWithIcon(
                                press: () {
                                  if (data.client2 != null &&
                                      data.client2!.whatsApp != null) {
                                    openWhatsapp(
                                        '${data.client2?.country?.code}${data.client2?.whatsApp}',
                                        context);
                                  } else {
                                    openWhatsapp(
                                        '${data.client2?.country?.code}${data.client2?.phone}',
                                        context);
                                  }
                                },
                                fontSize: 18,
                                paddingVertical: 1,
                                paddingHorizontal: 5,
                                borderRadius: 10,
                                text: LanguageCubit.get(context)
                                    .getTexts('WhatsApp')
                                    .toString(),
                                backColor: accentColor,
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
    );
  }

  Widget requestInfo(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    LanguageCubit.get(context).getTexts('Status').toString(),
                    style: TextStyle(
                      color: black,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    LanguageCubit.get(context).isEn
                        ? btnStatus3["en"]![RequestDetailsCubit.get(context)
                                .requestDetails!
                                .status!]
                            .toString()
                        : btnStatus3["ar"]![RequestDetailsCubit.get(context)
                                .requestDetails!
                                .status!]
                            .toString(),
                    style: TextStyle(color: grey2, fontSize: 14.sp),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    LanguageCubit.get(context)
                        .getTexts('PaymentStatus')
                        .toString(),
                    style: TextStyle(
                      color: black,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    LanguageCubit.get(context).isEn
                        ? btnStatus3["en"]![RequestDetailsCubit.get(context)
                                .requestDetails!
                                .paymentStatus!]
                            .toString()
                        : btnStatus3["ar"]![RequestDetailsCubit.get(context)
                                .requestDetails!
                                .paymentStatus!]
                            .toString(),
                    style: TextStyle(color: grey2, fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LanguageCubit.get(context)
                    .getTexts('RequestStartDate')
                    .toString(),
                style: TextStyle(
                  color: black,
                  fontSize: 15.sp,
                ),
              ),
              Row(
                children: [
                  Text(
                    LanguageCubit.get(context).isEn
                        ? DateFormat.yMEd().format(DateTime.parse(
                            RequestDetailsCubit.get(context)
                                .requestDetails!
                                .from!
                                .date!))
                        : DateFormat.yMEd("ar").format(DateTime.parse(
                            RequestDetailsCubit.get(context)
                                .requestDetails!
                                .from!
                                .date!)),
                    style: TextStyle(color: grey2, fontSize: 14.sp),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    LanguageCubit.get(context).isEn
                        ? DateFormat.jm().format(DateTime.parse(
                            RequestDetailsCubit.get(context)
                                .requestDetails!
                                .from!
                                .date!))
                        : DateFormat.jm("ar").format(DateTime.parse(
                            RequestDetailsCubit.get(context)
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LanguageCubit.get(context)
                    .getTexts('RequestEndDate')
                    .toString(),
                style: TextStyle(
                  color: black,
                  fontSize: 15.sp,
                ),
              ),
              Row(
                children: [
                  Text(
                    LanguageCubit.get(context).isEn
                        ? DateFormat.yMEd().format(DateTime.parse(
                            RequestDetailsCubit.get(context)
                                .requestDetails!
                                .to!))
                        : DateFormat.yMEd("ar").format(DateTime.parse(
                            RequestDetailsCubit.get(context)
                                .requestDetails!
                                .to!)),
                    style: TextStyle(color: grey2, fontSize: 14.sp),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    LanguageCubit.get(context).isEn
                        ? DateFormat.jm().format(DateTime.parse(
                            RequestDetailsCubit.get(context)
                                .requestDetails!
                                .to!))
                        : DateFormat.jm("ar").format(DateTime.parse(
                            RequestDetailsCubit.get(context)
                                .requestDetails!
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
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  LanguageCubit.get(context)
                      .getTexts('PickedLocation')
                      .toString(),
                  style: TextStyle(
                      color: accentColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  RequestDetailsCubit.get(context)
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
      );

  Widget buttonStatus(BuildContext context, RequestDetailsState state) {
    final currentDate = DateTime.now();
    return btnStatus[
                '${RequestDetailsCubit.get(context).requestDetails!.status}']!
            .isNotEmpty
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  state is! RequestDetailsEditInitial
                      ? Expanded(
                          child: defaultButton2(
                            press: () {
                              if (btnStatus2["en"]![
                                          '${RequestDetailsCubit.get(context).requestDetails!.status}']![
                                      0] ==
                                  "End") {
                                RequestDetailsCubit.get(context).getLastTrip(
                                    RequestDetailsCubit.get(context)
                                        .requestDetails!
                                        .id!,
                                    btnStatus[
                                        '${RequestDetailsCubit.get(context).requestDetails!.status}']![0]);
                              } else {
                                RequestDetailsCubit.get(context).editRequest(
                                    RequestDetailsCubit.get(context)
                                        .requestDetails!
                                        .id!,
                                    btnStatus[
                                        '${RequestDetailsCubit.get(context).requestDetails!.status}']![0],
                                    "");
                              }
                            },
                            disablePress: RequestDetailsCubit.get(context)
                                        .requestDetails!
                                        .status ==
                                    "pending"
                                ? true
                                : RequestDetailsCubit.get(context)
                                            .requestDetails
                                            ?.paymentStatus! ==
                                        "paid"
                                    ? btnStatus2[
                                                        "en"]![
                                                    '${RequestDetailsCubit.get(context).requestDetails!.status}']![
                                                0] ==
                                            "start"
                                        ? DateFormat("yyyy-MM-ddTHH:mm")
                                                .parse(RequestDetailsCubit.get(
                                                        context)
                                                    .requestDetails!
                                                    .from!
                                                    .date!)
                                                .isAfter(currentDate)
                                            ? true
                                            : false
                                        : RequestDetailsCubit.get(context)
                                                    .requestDetails!
                                                    .status ==
                                                "arrive"
                                            ? false
                                            : true
                                    : false,
                            fontSize: 20,
                            paddingVertical: 1,
                            paddingHorizontal: 10,
                            borderRadius: 10,
                            text: LanguageCubit.get(context).isEn
                                ? btnStatus2["en"]![
                                        '${RequestDetailsCubit.get(context).requestDetails!.status}']![
                                    0]
                                : btnStatus2["ar"]![
                                    '${RequestDetailsCubit.get(context).requestDetails!.status}']![0],
                            backColor: accentColor,
                            textColor: white,
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: SizedBox(
                              width: 40.w,
                              child: loading(),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 20.w,
                  ),
                  state is! RequestDetailsEditCancelInitial
                      ? Expanded(
                          child: defaultButton2(
                              press: () {
                                RequestDetailsCubit.get(context).getLastTrip(
                                    RequestDetailsCubit.get(context)
                                        .requestDetails!
                                        .id!,
                                    btnStatus[
                                        '${RequestDetailsCubit.get(context).requestDetails!.status}']![1]);
                              },
                              disablePress: RequestDetailsCubit.get(context)
                                          .requestDetails!
                                          .status ==
                                      "pending"
                                  ? true
                                  : RequestDetailsCubit.get(context)
                                              .requestDetails
                                              ?.paymentStatus! ==
                                          "need_confirm"
                                      ? true
                                      : RequestDetailsCubit.get(context)
                                                  .requestDetails
                                                  ?.paymentStatus! ==
                                              "paid"
                                          ? RequestDetailsCubit.get(context)
                                                      .requestDetails!
                                                      .status ==
                                                  "arrive"
                                              ? false
                                              : true
                                          : false,
                              fontSize: 20,
                              paddingVertical: 1,
                              paddingHorizontal: 10,
                              borderRadius: 10,
                              text: LanguageCubit.get(context).isEn
                                  ? btnStatus2["en"]![
                                          '${RequestDetailsCubit.get(context).requestDetails!.status}']![
                                      1]
                                  : btnStatus2["ar"]![
                                      '${RequestDetailsCubit.get(context).requestDetails!.status}']![1],
                              backColor: redColor,
                              textColor: white),
                        )
                      : Expanded(
                          child: Center(
                            child: SizedBox(
                              width: 40.w,
                              child: loading(),
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          )
        : Container();
  }

  Widget trips(BuildContext context, RequestDetailsState state) {
    return RequestDetailsCubit.get(context).loadingTrips
        ? loading()
        : RequestDetailsCubit.get(context).tripsSuccess != null &&
                RequestDetailsCubit.get(context).tripsSuccess == true
            ? RequestDetailsCubit.get(context).trips.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: RequestDetailsCubit.get(context).trips.length,
                    itemBuilder: (context, i) {
                      var trip = RequestDetailsCubit.get(context).trips[i];
                      return Column(
                        children: [
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10.r),
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
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: accentColor,
                                            size: 20.w,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      end: 10.r),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    LanguageCubit.get(context)
                                                        .getTexts('StartPoint')
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: black,
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Text(
                                                    trip.from!.placeTitle!,
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 14.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      LanguageCubit.get(context)
                                                          .getTexts('Status')
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: black,
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text(
                                                      LanguageCubit.get(context)
                                                              .isEn
                                                          ? btnStatus3["en"]![
                                                                  trip.status!]
                                                              .toString()
                                                          : btnStatus3["ar"]![
                                                                  trip.status!]
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                Text(
                                                  LanguageCubit.get(context)
                                                          .isEn
                                                      ? DateFormat.jm().format(
                                                          DateTime.parse(
                                                              trip.startDate!))
                                                      : DateFormat.jm("ar")
                                                          .format(DateTime
                                                              .parse(trip
                                                                  .startDate!)),
                                                  style: TextStyle(
                                                    color: grey2,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                                Text(
                                                  LanguageCubit.get(context)
                                                          .isEn
                                                      ? DateFormat.yMEd()
                                                          .format(DateTime
                                                              .parse(trip
                                                                  .startDate!))
                                                      : DateFormat.yMEd("ar")
                                                          .format(DateTime
                                                              .parse(trip
                                                                  .startDate!)),
                                                  style: TextStyle(
                                                      color: grey2,
                                                      fontSize: 13.sp),
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
                                            CrossAxisAlignment.start,
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
                                                  EdgeInsetsDirectional.only(
                                                      end: 10.r),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    LanguageCubit.get(context)
                                                        .getTexts('EndPoint')
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: black,
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Text(
                                                    trip.to!.placeTitle!,
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 14.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          trip.endDate!.isNotEmpty
                                              ? Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        LanguageCubit.get(
                                                                    context)
                                                                .isEn
                                                            ? DateFormat.jm()
                                                                .format(DateTime
                                                                    .parse(trip
                                                                        .endDate!))
                                                            : DateFormat.jm(
                                                                    "ar")
                                                                .format(DateTime
                                                                    .parse(trip
                                                                        .endDate!)),
                                                        style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        LanguageCubit.get(
                                                                    context)
                                                                .isEn
                                                            ? DateFormat.yMEd()
                                                                .format(DateTime
                                                                    .parse(trip
                                                                        .endDate!))
                                                            : DateFormat.yMEd(
                                                                    "ar")
                                                                .format(DateTime
                                                                    .parse(trip
                                                                        .endDate!)),
                                                        style: TextStyle(
                                                            color: grey2,
                                                            fontSize: 13.sp),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            launchInMap(
                                                trip.from!.placeLatitude!
                                                    .toString(),
                                                trip.from!.placeLongitude!
                                                    .toString(),
                                                trip.to!.placeLatitude!
                                                    .toString(),
                                                trip.to!.placeLongitude!
                                                    .toString(),
                                                context);
                                          },
                                          icon: Icon(
                                            Icons.wrong_location_sharp,
                                            size: 45.w,
                                          )),
                                      SizedBox(
                                        height: 15.h,
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
                                                  padding: EdgeInsets.all(10.r),
                                                  child: Column(children: [
                                                    Text(
                                                      LanguageCubit.get(context)
                                                          .getTexts('Distance')
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.r,
                                                    ),
                                                    Text(
                                                      '${trip.consumptionKM!.toStringAsFixed(2)} ${LanguageCubit.get(context).getTexts('KM')}',
                                                      textAlign:
                                                          TextAlign.center,
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
                                            Expanded(
                                              child: Card(
                                                color: rough,
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.r),
                                                  child: Column(children: [
                                                    Text(
                                                      LanguageCubit.get(context)
                                                          .getTexts('Points')
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.r,
                                                    ),
                                                    Text(
                                                      trip.consumptionPoints!
                                                          .toStringAsFixed(2),
                                                      textAlign:
                                                          TextAlign.center,
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
                                            Expanded(
                                              child: Card(
                                                color: greenLightColor,
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.r),
                                                  child: Column(children: [
                                                    Text(
                                                      LanguageCubit.get(context)
                                                          .getTexts('1KmPoints')
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.r,
                                                    ),
                                                    Text(
                                                      trip.oneKMPoints
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
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
                            onTap: () async {
                              print(
                                  "typeId44************ ${idRequest}");
                              await navigateToWithRefreshPagePrevious(
                                  context,
                                  TripDetailsScreen(
                                    idTrip: RequestDetailsCubit.get(context)
                                        .trips[i]
                                        .id,
                                    idRequest: idRequest,
                                  )).then((id) {
                                print(
                                    "typeId33************ ${id}");
                                setState(() {
                                  loadingMoreTrips = false;
                                  getIt<SharedPreferences>().setString(
                                      'typeScreen', "requestDetails");
                                  RequestDetailsCubit.get(context).indexTrips =
                                      1;
                                  RequestDetailsCubit.get(context)
                                      .loadingRequest = false;
                                  RequestDetailsCubit.get(context)
                                      .failureRequest = "";
                                  RequestDetailsCubit.get(context).failureTrip =
                                      "";
                                  idRequest = id;
                                  RequestDetailsCubit.get(context)
                                      .getRequestDetails(id);
                                });
                              });
                            },
                          ),
                          i ==
                                      RequestDetailsCubit.get(context)
                                              .trips
                                              .length -
                                          1 &&
                                  loadingMoreTrips
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
                        .getTexts('NotFoundTrip')
                        .toString(),
                    press: () {
                      RequestDetailsCubit.get(context).indexTrips = 1;
                      RequestDetailsCubit.get(context)
                          .getTripsRequestDetails(1, idRequest);
                    },
                    context: context)
            : RequestDetailsCubit.get(context).tripsSuccess != null &&
                    RequestDetailsCubit.get(context).tripsSuccess == false
                ? RequestDetailsCubit.get(context).failureTrip.isNotEmpty
                    ? errorMessage2(
                        message: RequestDetailsCubit.get(context).failureTrip,
                        press: () {
                          print(
                              "getTripsRequestDetails**********${idRequest}");
                          RequestDetailsCubit.get(context).failureTrip = "";
                          RequestDetailsCubit.get(context).indexTrips = 1;
                          RequestDetailsCubit.get(context)
                              .getTripsRequestDetails(1, idRequest);
                        },
                        context: context)
                    : Container()
                : Container();
  }
}

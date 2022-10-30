import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/main_cubit.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/trip/tripDetails/trip_details_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({Key? key, this.idTrip, this.idRequest})
      : super(key: key);

  final String? idTrip, idRequest;

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  var btnStatus = {
    'pending': ['accept', 'reject'],
    'accept': ['on_my_way'],
    'on_my_way': ['arrive'],
    'arrive': ['start'],
    'coming': ['start'],
    'start': ['end'],
    'end': [],
    'reject': [],
    'cancel': []
  };

  var btnStatus2 = {
    'pending': ['Accept', 'Reject'],
    'accept': ['On My Way'],
    'on_my_way': ['Arrive'],
    'arrive': ['Start'],
    'coming': ['Start'],
    'start': ['End'],
    'end': [],
    'reject': [],
    'cancel': []
  };

  var txtStatusRunning = {
    'pending': 'Pending',
    'accept': 'Accept',
    'on_my_way': 'On My Way',
    'arrive': 'Arrive',
    'coming': 'Coming',
    'start': 'Start',
    'end': 'End',
    'reject': 'Reject',
    'cancel': 'Cancel'
  };

  int? indexStatus;

  // custom marker
  final Set<Marker> _markers = <Marker>{};
  final LatLng destinationLatLng = const LatLng(30.149350, 31.738539);
  final LatLng initialLatLng = const LatLng(30.1541371, 31.7397189);
  final Completer<GoogleMapController> _controller = Completer();
  var formKeyRequest = GlobalKey<FormState>();
  var commentController = TextEditingController();

  _setMapPins(List<LatLng> markersLocation) {
    _markers.clear();
    setState(() {
      // for (var markerLocation in markersLocation) {
      //   _markers.add(Marker(
      //     markerId: MarkerId(markerLocation.toString()),
      //     position: markerLocation,
      //     icon: customIcon,
      //   ));
      // }
      _markers.add(Marker(
        markerId: MarkerId(destinationLatLng.toString()),
        position: destinationLatLng,
      ));
    });
  }

  @override
  void dispose() {
    super.dispose();
    getIt<SharedPreferences>().setString('tripDetailsId', "");
    getIt<SharedPreferences>().setString('typeScreen', "");
  }

  @override
  void initState() {
    super.initState();

    getIt<SharedPreferences>().setString('typeScreen', "tripDetails");
    getIt<SharedPreferences>().setString('tripDetailsId', widget.idTrip!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripDetailsCubit()..getTripDetails(widget.idTrip!),
      child: BlocConsumer<TripDetailsCubit, TripDetailsState>(
        listener: (context, state) {
          if (state is TripDetailsEditSuccessState) {
            if (state.type == "reject") {
              Navigator.pop(context);
            }
            TripDetailsCubit.get(context).getTripDetails(widget.idTrip!);
          } else if (state is TripDetailsEditErrorState) {
            // if(state.type == "reject"){
            //   Navigator.pop(context);
            // }
            // Navigator.of(context).pop(widget.idRequest);
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop(widget.idRequest);
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Trip Details',
                  style: TextStyle(color: primaryColor, fontSize: 20.sp),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: black,
                    size: 27.sp,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(widget.idRequest);
                  },
                ),
                centerTitle: true,
                elevation: 1.0,
              ),
              body: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 360.h),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      rotateGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      trafficEnabled: false,
                      tiltGesturesEnabled: false,
                      scrollGesturesEnabled: true,
                      compassEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      mapToolbarEnabled: false,
                      markers: _markers,
                      initialCameraPosition:
                          CameraPosition(target: initialLatLng, zoom: 13),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        _setMapPins([const LatLng(30.1541371, 31.7397189)]);
                      },
                    ),
                  ),
                  Positioned(
                    right: 1,
                    left: 1,
                    bottom: 1,
                    child: Stack(
                      children: [
                        state is TripDetailsErrorState
                            ? Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                    height: 300.h,
                                    child: errorMessage2(
                                        message: state.message,
                                        press: () {
                                          TripDetailsCubit.get(context)
                                              .getTripDetails(widget.idTrip!);
                                        })),
                              )
                            : Container(
                                color: white,
                                padding: EdgeInsets.only(
                                    top: 30.r, left: 16.r, right: 16.r),
                                margin: EdgeInsets.only(top: 70.r),
                                child: state is TripDetailsLoading
                                    ? SizedBox(
                                        height: 120.h,
                                        child: loading(),
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              ClipOval(
                                                clipBehavior: Clip.antiAlias,
                                                child: ImageTools.image(
                                                    fit: BoxFit.fill,
                                                    url: TripDetailsCubit.get(
                                                            context)
                                                        .tripDetails!
                                                        .client2!
                                                        .image!
                                                        .src,
                                                    height: 50.w,
                                                    width: 50.w),
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
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              TripDetailsCubit
                                                                      .get(
                                                                          context)
                                                                  .tripDetails!
                                                                  .client2!
                                                                  .name!,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        TripDetailsCubit.get(
                                                                context)
                                                            .tripDetails!
                                                            .client2!
                                                            .name!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: grey2),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                defaultButtonWithIcon(
                                                                    press: () {
                                                                      if (TripDetailsCubit.get(context)
                                                                              .tripDetails
                                                                              ?.client2
                                                                              ?.phone !=
                                                                          null) {
                                                                        makePhoneCall(
                                                                            '${TripDetailsCubit.get(context).tripDetails?.client2?.country?.code}${TripDetailsCubit.get(context).tripDetails?.client2?.phone}');
                                                                      } else {
                                                                        showToastt(
                                                                            text:
                                                                                "this client not have phone...",
                                                                            state:
                                                                                ToastStates.error,
                                                                            context: context);
                                                                      }
                                                                    },
                                                                    fontSize:
                                                                        18,
                                                                    paddingVertical:
                                                                        1,
                                                                    paddingHorizontal:
                                                                        5,
                                                                    borderRadius:
                                                                        10,
                                                                    text:
                                                                        'Call Client',
                                                                    backColor:
                                                                        greenColor,
                                                                    textColor:
                                                                        white,
                                                                    icon: Icons
                                                                        .phone),
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Expanded(
                                                            child:
                                                                defaultButtonWithIcon(
                                                                    press: () {
                                                                      if (TripDetailsCubit.get(context)
                                                                              .tripDetails
                                                                              ?.client2
                                                                              ?.whatsApp !=
                                                                          null) {
                                                                        openWhatsapp(
                                                                            '${TripDetailsCubit.get(context).tripDetails?.client2?.country?.code}${TripDetailsCubit.get(context).tripDetails?.client2?.whatsApp}',
                                                                            context);
                                                                      } else {
                                                                        openWhatsapp(
                                                                            '${TripDetailsCubit.get(context).tripDetails?.client2?.country?.code}${TripDetailsCubit.get(context).tripDetails?.client2?.phone}',
                                                                            context);
                                                                      }
                                                                    },
                                                                    fontSize:
                                                                        18,
                                                                    paddingVertical:
                                                                        1,
                                                                    paddingHorizontal:
                                                                        5,
                                                                    borderRadius:
                                                                        10,
                                                                    text:
                                                                        'WhatsApp',
                                                                    backColor:
                                                                        greenColor,
                                                                    textColor:
                                                                        white,
                                                                    icon: Icons
                                                                        .whatsapp),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          // divider
                                          Container(
                                            width: 1.sw,
                                            height: 1.h,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Container(
                                            color: white,
                                            child: Column(
                                              children: [
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
                                                      flex: 3,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                    end: 10.r),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Picked Point',
                                                              style: TextStyle(
                                                                  color: black,
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 5.h),
                                                            Text(
                                                              TripDetailsCubit
                                                                      .get(
                                                                          context)
                                                                  .tripDetails!
                                                                  .from!
                                                                  .placeTitle!,
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      13.sp),
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
                                                            // '12:00 am',
                                                            DateFormat.jm().format(DateTime.parse(
                                                                TripDetailsCubit
                                                                        .get(
                                                                            context)
                                                                    .tripDetails!
                                                                    .startDate!)),
                                                            style: TextStyle(
                                                              color: grey2,
                                                              fontSize: 14.sp,
                                                            ),
                                                          ),
                                                          Text(
                                                            // '12/2/20200',
                                                            DateFormat.yMEd().format(DateTime.parse(
                                                                TripDetailsCubit
                                                                        .get(
                                                                            context)
                                                                    .tripDetails!
                                                                    .startDate!)),
                                                            style: TextStyle(
                                                                color: grey2,
                                                                fontSize:
                                                                    13.sp),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
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
                                                                    end: 10.r),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Picked Point',
                                                              style: TextStyle(
                                                                  color: black,
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 5.h),
                                                            Text(
                                                              TripDetailsCubit
                                                                      .get(
                                                                          context)
                                                                  .tripDetails!
                                                                  .to!
                                                                  .placeTitle!,
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    TripDetailsCubit.get(
                                                                context)
                                                            .tripDetails!
                                                            .endDate!
                                                            .isNotEmpty
                                                        ? Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  // '12:00 am',
                                                                  DateFormat.jm().format(DateTime.parse(TripDetailsCubit
                                                                          .get(
                                                                              context)
                                                                      .tripDetails!
                                                                      .endDate!)),
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        grey2,
                                                                    fontSize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  // '12/2/20200',
                                                                  DateFormat.yMEd().format(DateTime.parse(TripDetailsCubit
                                                                          .get(
                                                                              context)
                                                                      .tripDetails!
                                                                      .endDate!)),
                                                                  style: TextStyle(
                                                                      color:
                                                                          grey2,
                                                                      fontSize:
                                                                          13.sp),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Card(
                                                        color: yellowLightColor,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.r),
                                                          child:
                                                              Column(children: [
                                                            Text(
                                                              'Distance',
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                            SizedBox(
                                                              height: 5.r,
                                                            ),
                                                            Text(
                                                              // '20',
                                                              TripDetailsCubit
                                                                      .get(
                                                                          context)
                                                                  .tripDetails!
                                                                  .consumptionKM!
                                                                  .toStringAsFixed(
                                                                      2),
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
                                                              EdgeInsets.all(
                                                                  10.r),
                                                          child:
                                                              Column(children: [
                                                            Text(
                                                              'Points',
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                            SizedBox(
                                                              height: 5.r,
                                                            ),
                                                            Text(
                                                              // '20',
                                                              TripDetailsCubit
                                                                      .get(
                                                                          context)
                                                                  .tripDetails!
                                                                  .consumptionPoints!
                                                                  .toStringAsFixed(
                                                                      2),
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
                                                              EdgeInsets.all(
                                                                  10.r),
                                                          child:
                                                              Column(children: [
                                                            Text(
                                                              '1 Km Points',
                                                              style: TextStyle(
                                                                  color: grey2,
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                            SizedBox(
                                                              height: 5.r,
                                                            ),
                                                            Text(
                                                              // '20',
                                                              TripDetailsCubit
                                                                      .get(
                                                                          context)
                                                                  .tripDetails!
                                                                  .oneKMPoints
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
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                SizedBox(
                                                    height: 50.h,
                                                    child: TripDetailsCubit.get(
                                                                    context)
                                                                .tripDetails!
                                                                .status ==
                                                            "pending"
                                                        ? Row(
                                                            children: [
                                                              state is! TripDetailsEditInitial
                                                                  ? Expanded(
                                                                      child: defaultButton2(
                                                                          press: () {
                                                                            TripDetailsCubit.get(context).editTrip(
                                                                                TripDetailsCubit.get(context).tripDetails!.id!,
                                                                                btnStatus['${TripDetailsCubit.get(context).tripDetails!.status}']![0],
                                                                                "");
                                                                          },
                                                                          fontSize: 20,
                                                                          paddingVertical: 1,
                                                                          paddingHorizontal: 10,
                                                                          borderRadius: 10,
                                                                          text: btnStatus2['${TripDetailsCubit.get(context).tripDetails!.status}']![0],
                                                                          backColor: greenColor,
                                                                          textColor: white),
                                                                    )
                                                                  : Expanded(
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              40.w,
                                                                          child:
                                                                              loading(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                              SizedBox(
                                                                width: 15.w,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    defaultButton2(
                                                                        press:
                                                                            () {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            barrierDismissible:
                                                                                true,
                                                                            // outside to dismiss
                                                                            builder:
                                                                                (_) {
                                                                              return CustomDialogTripDetails(
                                                                                id: TripDetailsCubit.get(context).tripDetails!.id!,
                                                                                title: 'Do you want to reject?',
                                                                                description: 'If you want to be rejected, you must first enter the reason for rejection and press OK..',
                                                                              );
                                                                            },
                                                                          ).then(
                                                                              (value) {
                                                                            print("showDialog************** ${MainCubit.get(context).refresh}");
                                                                            if (MainCubit.get(context).refresh) {
                                                                              TripDetailsCubit.get(context).getTripDetails(widget.idTrip!);
                                                                              MainCubit.get(context).refresh = false;
                                                                            }
                                                                          });
                                                                        },
                                                                        fontSize:
                                                                            20,
                                                                        paddingVertical:
                                                                            1,
                                                                        paddingHorizontal:
                                                                            10,
                                                                        borderRadius:
                                                                            10,
                                                                        text: btnStatus2['${TripDetailsCubit.get(context).tripDetails!.status}']![
                                                                            1],
                                                                        backColor:
                                                                            greenColor,
                                                                        textColor:
                                                                            white),
                                                              ),
                                                            ],
                                                          )
                                                        : Center(
                                                            child: state
                                                                    is! TripDetailsEditInitial
                                                                ? TripDetailsCubit.get(context).tripDetails!.status !=
                                                                            null &&
                                                                        btnStatus['${TripDetailsCubit.get(context).tripDetails!.status}']!
                                                                            .isNotEmpty
                                                                    ? defaultButton2(
                                                                        press:
                                                                            () {
                                                                          TripDetailsCubit.get(context).editTrip(
                                                                              TripDetailsCubit.get(context).tripDetails!.id!,
                                                                              btnStatus['${TripDetailsCubit.get(context).tripDetails!.status}']![0],
                                                                              "");
                                                                        },
                                                                        fontSize:
                                                                            22,
                                                                        paddingVertical:
                                                                            1,
                                                                        paddingHorizontal:
                                                                            50,
                                                                        borderRadius:
                                                                            10,
                                                                        text: btnStatus2['${TripDetailsCubit.get(context).tripDetails!.status}']![
                                                                            0],
                                                                        backColor: btnStatus2['${TripDetailsCubit.get(context).tripDetails!.status}']![0] == "End" || btnStatus2['${TripDetailsCubit.get(context).tripDetails!.status}']![0] == "Cancel"
                                                                            ? redColor
                                                                            : greenColor,
                                                                        textColor:
                                                                            white)
                                                                    : Container()
                                                                : loading(),
                                                          )),

                                                // SizedBox(
                                                //   height: 10.h,
                                                // ),
                                                // defaultButton3(
                                                //     press: () {},
                                                //     text: "Complete",
                                                //     backColor: accentColor,
                                                //     textColor: white),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                        state is TripDetailsSuccessState
                            ? Positioned(
                                left: 1,
                                right: 1,
                                top: 1,
                                child: Container(
                                  padding: EdgeInsets.all(25.r),
                                  decoration: BoxDecoration(
                                    color: white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: greenColor, width: 2.w),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Trip is',
                                        style: TextStyle(
                                            color: black, fontSize: 15.sp),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        TripDetailsCubit.get(context)
                                                    .tripDetails !=
                                                null
                                            ? txtStatusRunning[
                                                TripDetailsCubit.get(context)
                                                    .tripDetails!
                                                    .status!]!
                                            : 'Running',
                                        style: TextStyle(
                                            color: greenColor,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

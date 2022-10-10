import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/tripDetails/trip_details_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  var btnStatus = {
    'accept': ['on_my_way', 'arrive', 'start'],
    'arrive': ['start'],
    'coming': ['start'],
    'on_my_way': ['arrive'],
    'start': ['end'],
    'end': [],
    'reject': [],
    'cancel': [],
    'pending': ['accept']
  };
  int? indexStatus;

  // custom marker
  final Set<Marker> _markers = <Marker>{};
  final LatLng destinationLatLng = const LatLng(30.149350, 31.738539);
  final LatLng initialLatLng = const LatLng(30.1541371, 31.7397189);
  final Completer<GoogleMapController> _controller = Completer();

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
    // TODO: implement dispose
    super.dispose();
    getIt<SharedPreferences>().setString('typeScreen', "");
  }
  @override
  void initState() {
    super.initState();

    getIt<SharedPreferences>().setString('typeScreen', "tripDetails");
    TripDetailsCubit.get(context).getTripDetails(widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripDetailsCubit, TripDetailsState>(
      listener: (context, state) {
        if (state is TripDetailsEditSuccessState) {
          TripDetailsCubit.get(context).getTripDetails(widget.id!);
        } else if (state is TripDetailsEditErrorState) {
          Navigator.pop(context);
          showToastt(
              text: state.message, state: ToastStates.error, context: context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Trip Details',
              style: TextStyle(color: primaryColor, fontSize: 20.sp),
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
                    Container(
                      color: white,
                      padding:
                          EdgeInsets.only(top: 30.r, left: 16.r, right: 16.r),
                      margin: EdgeInsets.only(top: 60.r),
                      child: state is TripDetailsLoading
                          ? SizedBox(
                              height: 120.h,
                              child: const Center(
                                  child: CircularProgressIndicator(
                                color: black,
                              )),
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
                                          url: TripDetailsCubit.get(context)
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
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    TripDetailsCubit.get(
                                                            context)
                                                        .tripDetails!
                                                        .client2!
                                                        .name!,
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              TripDetailsCubit.get(context)
                                                  .tripDetails!
                                                  .client2!
                                                  .name!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: grey2),
                                            ),
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
                                                    'Picked Point',
                                                    style: TextStyle(
                                                        color: black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Text(
                                                    TripDetailsCubit.get(
                                                            context)
                                                        .tripDetails!
                                                        .from!
                                                        .placeTitle!,
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 13.sp),
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
                                                Text(
                                                  // '12:00 am',
                                                  DateFormat.jm().format(
                                                      DateTime.parse(
                                                          TripDetailsCubit.get(
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
                                                  DateFormat.yMEd().format(
                                                      DateTime.parse(
                                                          TripDetailsCubit.get(
                                                                  context)
                                                              .tripDetails!
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
                                        height: 10.h,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                    'Picked Point',
                                                    style: TextStyle(
                                                        color: black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Text(
                                                    TripDetailsCubit.get(
                                                            context)
                                                        .tripDetails!
                                                        .to!
                                                        .placeTitle!,
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 13.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TripDetailsCubit.get(context)
                                                  .tripDetails!
                                                  .endDate!
                                                  .isNotEmpty
                                              ? Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        // '12:00 am',
                                                        DateFormat.jm().format(
                                                            DateTime.parse(
                                                                TripDetailsCubit
                                                                        .get(
                                                                            context)
                                                                    .tripDetails!
                                                                    .endDate!)),
                                                        style: TextStyle(
                                                          color: grey2,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        // '12/2/20200',
                                                        DateFormat.yMEd().format(
                                                            DateTime.parse(
                                                                TripDetailsCubit
                                                                        .get(
                                                                            context)
                                                                    .tripDetails!
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
                                                padding: EdgeInsets.all(10.r),
                                                child: Column(children: [
                                                  Text(
                                                    'Distance',
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 13.sp),
                                                  ),
                                                  SizedBox(
                                                    height: 5.r,
                                                  ),
                                                  Text(
                                                    // '20',
                                                    TripDetailsCubit.get(
                                                            context)
                                                        .tripDetails!
                                                        .consumptionKM!
                                                        .toStringAsFixed(2),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: black,
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Card(
                                              color: Colors.redAccent
                                                  .withOpacity(.3),
                                              child: Padding(
                                                padding: EdgeInsets.all(10.r),
                                                child: Column(children: [
                                                  Text(
                                                    'Points',
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 13.sp),
                                                  ),
                                                  SizedBox(
                                                    height: 5.r,
                                                  ),
                                                  Text(
                                                    // '20',
                                                    TripDetailsCubit.get(
                                                            context)
                                                        .tripDetails!
                                                        .consumptionPoints!
                                                        .toStringAsFixed(2),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: black,
                                                        fontSize: 13.sp,
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
                                                    '1 Km Points',
                                                    style: TextStyle(
                                                        color: grey2,
                                                        fontSize: 13.sp),
                                                  ),
                                                  SizedBox(
                                                    height: 5.r,
                                                  ),
                                                  Text(
                                                    // '20',
                                                    TripDetailsCubit.get(
                                                            context)
                                                        .tripDetails!
                                                        .oneKMPoints
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: black,
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                      // divider
                                      SizedBox(
                                        height: 50.h,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: btnStatus[
                                                  '${TripDetailsCubit.get(context).tripDetails!.status}']!
                                              .length,
                                          itemBuilder: (context, i) {
                                            final loadStatus = i == indexStatus;
                                            return loadStatus
                                                ? state is! TripDetailsEditInitial
                                                    ? Container(
                                                        margin:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                    end: 10.w),
                                                        child: defaultButton2(
                                                            press: () {
                                                              setState(() {
                                                                indexStatus = i;
                                                              });
                                                              TripDetailsCubit
                                                                      .get(
                                                                          context)
                                                                  .editTrip(
                                                                      TripDetailsCubit.get(
                                                                              context)
                                                                          .tripDetails!
                                                                          .id!,
                                                                      btnStatus[
                                                                          '${TripDetailsCubit.get(context).tripDetails!.status}']![i]);
                                                            },
                                                            text: btnStatus[
                                                                    '${TripDetailsCubit.get(context).tripDetails!.status}']![
                                                                i],
                                                            fontSize: 18,
                                                            borderRadius: 10,
                                                            paddingHorizontal:
                                                                10,
                                                            paddingVertical: 5,
                                                            backColor:
                                                                greenColor,
                                                            textColor: white),
                                                      )
                                                    : Container(
                                                        margin:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                    end: 10.w),
                                                        child:
                                                            const CircularProgressIndicator(
                                                          color: accentColor,
                                                        ),
                                                      )
                                                : Container(
                                                    margin:
                                                        EdgeInsetsDirectional
                                                            .only(end: 10.w),
                                                    child: defaultButton2(
                                                        press: () {
                                                          setState(() {
                                                            indexStatus = i;
                                                          });
                                                          TripDetailsCubit.get(
                                                                  context)
                                                              .editTrip(
                                                                  TripDetailsCubit
                                                                          .get(
                                                                              context)
                                                                      .tripDetails!
                                                                      .id!,
                                                                  btnStatus[
                                                                      '${TripDetailsCubit.get(context).tripDetails!.status}']![i]);
                                                        },
                                                        fontSize: 18,
                                                        borderRadius: 10,
                                                        paddingHorizontal: 10,
                                                        paddingVertical: 5,
                                                        text: btnStatus[
                                                            '${TripDetailsCubit.get(context).tripDetails!.status}']![i],
                                                        backColor: greenColor,
                                                        textColor: white),
                                                  );
                                          },
                                        ),
                                      ),
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
                    Positioned(
                      left: 1,
                      right: 1,
                      top: 1,
                      child: Container(
                        padding: EdgeInsets.all(25.r),
                        decoration: BoxDecoration(
                          color: white,
                          shape: BoxShape.circle,
                          border: Border.all(color: greenColor, width: 2.w),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Trip is',
                              style: TextStyle(color: black, fontSize: 15.sp),
                            ),
                            Text(
                              'Running',
                              style: TextStyle(
                                  color: greenColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

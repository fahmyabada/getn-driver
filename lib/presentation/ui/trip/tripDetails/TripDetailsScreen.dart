import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:getn_driver/data/utils/MapUtils.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
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
    'en': {
      'pending': ['Accept', 'Reject'],
      'accept': ['On My Way'],
      'on_my_way': ['Arrive'],
      'arrive': ['Start'],
      'coming': ['Start'],
      'start': ['End'],
      'end': [],
      'reject': [],
      'cancel': []
    },
    'ar': {
      'pending': ['ٌقبول', 'رفض'],
      'accept': ['في الطريق'],
      'on_my_way': ['وصلت'],
      'arrive': ['إبدأ'],
      'coming': ['إبدأ'],
      'start': ['إنهاء'],
      'end': [],
      'reject': [],
      'cancel': []
    },
  };

  var txtStatusRunning = {
    'en': {
      'pending': 'Pending',
      'accept': 'Accept',
      'on_my_way': 'On My Way',
      'arrive': 'Arrive',
      'coming': 'Coming',
      'start': 'Start',
      'end': 'End',
      'reject': 'Reject',
      'cancel': 'Cancel'
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
    },
  };

  int? indexStatus;
  bool btnStatusFound = false;
  var formKeyRequest = GlobalKey<FormState>();
  var commentController = TextEditingController();

  // custom marker
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};
  late BitmapDescriptor customIcon;
  final LatLng initialLatLng = const LatLng(30.0551913, 31.2258522);

  _setMapPins(LatLng initialLatLng, LatLng destinationLatLng) {
    _markers.clear();
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(initialLatLng.toString()),
        position: initialLatLng,
        icon: customIcon,
      ));

      _markers.add(Marker(
        markerId: MarkerId(destinationLatLng.toString()),
        position: destinationLatLng,
      ));
    });
  }

  //Adding route to the map
  final Set<Polyline> _polyline = {};
  List<LatLng> polylineCoordinates = [];

  _addPolyLines(BuildContext context, String sLat, String sLon, String dLat,
      String dLon) {
    final lat = (double.parse(sLat) + double.parse(dLat)) / 2;
    final lng = (double.parse(sLon) + double.parse(dLon)) / 2;

    _moveCamera(13.0, lat, lng);

    _setMapPins(LatLng(double.parse(sLat), double.parse(sLon)),
        LatLng(double.parse(dLat), double.parse(dLon)));
    _setPolyLine(context, LatLng(double.parse(sLat), double.parse(sLon)),
        LatLng(double.parse(dLat), double.parse(dLon)));
  }

  _moveCamera(double? zoom, double lat, double lng) async {
    final CameraPosition myPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: zoom ?? 14.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(myPosition));
  }

  _setPolyLine(BuildContext context, LatLng initialLatLng,
      LatLng destinationLatLng) async {
    final result = await TripDetailsCubit()
        .getRouteCoordinates(initialLatLng, destinationLatLng);
    if (result.success) {
      final route = result.data["routes"][0]["overview_polyline"]["points"];
      setState(() {
        _polyline.add(Polyline(
            polylineId: const PolylineId("tripRoute"),
            //pass any string here
            width: 3,
            geodesic: true,
            points: MapUtils.convertToLatLng(MapUtils.decodePoly(route)),
            color: Theme.of(context).primaryColor));
      });
    } else {
      showToastt(
          text: result.message, state: ToastStates.error, context: context);
    }
  }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(50, 50)),
            'assets/marker_car.png')
        .then((icon) {
      customIcon = icon;
    });
    super.initState();

    TripDetailsCubit.get(context).getTripDetails(widget.idTrip!);

    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }
  }

  void viewWillAppear() {
    print("onResume / viewWillAppear / onFocusGained   TripDetailsScreen");
    getIt<SharedPreferences>().setString('typeScreen', "tripDetails");
    getIt<SharedPreferences>().setString('tripDetailsId', widget.idTrip!);
  }

  void viewWillDisappear() {
    print("onPause / viewWillDisappear / onFocusLost   TripDetailsScreen");
    getIt<SharedPreferences>().setString('tripDetailsId', "");
    getIt<SharedPreferences>().setString('typeScreen', "");
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: viewWillAppear,
      onFocusLost: viewWillDisappear,
      child: BlocConsumer<TripDetailsCubit, TripDetailsState>(
        listener: (context, state) {
          if (state is TripDetailsEditSuccessState) {
            if (state.type == "reject" || state.type == "end") {
              Navigator.pop(context);
            }
            TripDetailsCubit.get(context).getTripDetails(widget.idTrip!);
          } else if (state is TripDetailsEditErrorState) {
            if (state.type == "reject" || state.type == "end") {
              Navigator.pop(context);
            }
            // Navigator.of(context).pop(widget.idRequest);
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          } else if (state is TripDetailsSuccessState) {
            setState(() {
              if (btnStatus[state.data!.status!]!.isNotEmpty) {
                btnStatusFound = true;
              } else {
                btnStatusFound = false;
              }
            });

            _addPolyLines(
                context,
                state.data!.from!.placeLatitude!,
                state.data!.from!.placeLongitude!,
                state.data!.to!.placeLatitude!,
                state.data!.to!.placeLongitude!);
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: LanguageCubit.get(context).isEn
                ? ui.TextDirection.ltr
                : ui.TextDirection.rtl,
            child: WillPopScope(
              onWillPop: () async {
                Navigator.of(navigatorKey.currentState!.context)
                    .pop(widget.idRequest);
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    LanguageCubit.get(context)
                        .getTexts('TripDetails')
                        .toString(),
                    style: TextStyle(color: primaryColor, fontSize: 20.sp),
                  ),
                  // leading: IconButton(
                  //   icon: Icon(
                  //     Icons.arrow_back,
                  //     color: black,
                  //     size: 27.sp,
                  //   ),
                  //   onPressed: () {
                  //     Navigator.of(context).pop(widget.idRequest);
                  //   },
                  // ),
                  centerTitle: true,
                  elevation: 1.0,
                ),
                body: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          bottom: btnStatusFound ? 440.h : 400.h),
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
                        polylines: _polyline,
                        initialCameraPosition:
                            CameraPosition(target: initialLatLng, zoom: 13),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          // _setMapPins(LatLng(30.1541371,31.7397189),LatLng(31.1872173,29.897572));
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
                                          },
                                          context: context)),
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
                                            client(context),
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
                                                  tripInfo(context),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  buttonStatus(context, state),
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
                                          LanguageCubit.get(context)
                                              .getTexts('TripIs')
                                              .toString(),
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
                                              ? LanguageCubit.get(context).isEn
                                                  ? txtStatusRunning['en']![
                                                      TripDetailsCubit.get(
                                                              context)
                                                          .tripDetails!
                                                          .status!]!
                                                  : txtStatusRunning['ar']![
                                                      TripDetailsCubit.get(
                                                              context)
                                                          .tripDetails!
                                                          .status!]!
                                              : LanguageCubit.get(context)
                                                  .getTexts('Running')
                                                  .toString(),
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
            ),
          );
        },
      ),
    );
  }

  Widget client(BuildContext context) => Row(
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
              margin: EdgeInsets.symmetric(horizontal: 20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TripDetailsCubit.get(context)
                                  .tripDetails!
                                  .client2!
                                  .name!,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: black,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              LanguageCubit.get(context).isEn
                                  ? '${TripDetailsCubit.get(context).tripDetails!.client2!.country!.title!.en!}, ${TripDetailsCubit.get(context).tripDetails!.client2!.city?.title!.en!}, ${TripDetailsCubit.get(context).tripDetails!.client2!.area?.title!.en!}'
                                  : '${TripDetailsCubit.get(context).tripDetails!.client2!.country!.title!.ar!}, ${TripDetailsCubit.get(context).tripDetails!.client2!.city?.title!.ar!}, ${TripDetailsCubit.get(context).tripDetails!.client2!.area?.title!.ar!}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14.sp, color: grey2),
                            ),
                          ],
                        ),
                      ),
                      TripDetailsCubit.get(context).tripDetails!.status ==
                                  "pending" &&
                              TripDetailsCubit.get(context)
                                      .tripDetails!
                                      .status ==
                                  "end" &&
                              TripDetailsCubit.get(context)
                                      .tripDetails!
                                      .status ==
                                  "mid_pause" &&
                              TripDetailsCubit.get(context)
                                      .tripDetails!
                                      .status ==
                                  "reject" &&
                              TripDetailsCubit.get(context)
                                      .tripDetails!
                                      .status ==
                                  "cancel"
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                launchInMap(
                                    TripDetailsCubit.get(context)
                                        .tripDetails!
                                        .from!
                                        .placeLatitude!,
                                    TripDetailsCubit.get(context)
                                        .tripDetails!
                                        .from!
                                        .placeLongitude!,
                                    TripDetailsCubit.get(context)
                                        .tripDetails!
                                        .to!
                                        .placeLatitude!,
                                    TripDetailsCubit.get(context)
                                        .tripDetails!
                                        .to!
                                        .placeLongitude!,
                                    context);
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
                  TripDetailsCubit.get(context).tripDetails!.status! == "end" ||
                          TripDetailsCubit.get(context).tripDetails!.status! ==
                              "reject" ||
                          TripDetailsCubit.get(context).tripDetails!.status! ==
                              "cancel"
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: defaultButtonWithIcon(
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
                                  fontSize: 18,
                                  paddingVertical: 1,
                                  paddingHorizontal: 5,
                                  borderRadius: 10,
                                  text: LanguageCubit.get(context)
                                      .getTexts('WhatsApp')
                                      .toString(),
                                  backColor: greenColor,
                                  textColor: white,
                                  icon: Icons.whatsapp),
                            ),
                          ],
                        )
                ],
              ),
            ),
          )
        ],
      );

  Widget tripInfo(BuildContext context) {
    return Column(
      children: [
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
              flex: 3,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 10.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LanguageCubit.get(context)
                          .getTexts('PickedPoint')
                          .toString(),
                      style: TextStyle(
                          color: black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      TripDetailsCubit.get(context)
                          .tripDetails!
                          .from!
                          .placeTitle!,
                      style: TextStyle(color: grey2, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    // '12:00 am',
                    LanguageCubit.get(context).isEn
                        ? DateFormat.jm().format(DateTime.parse(
                            TripDetailsCubit.get(context)
                                .tripDetails!
                                .startDate!))
                        : DateFormat.jm("ar").format(DateTime.parse(
                            TripDetailsCubit.get(context)
                                .tripDetails!
                                .startDate!)),
                    style: TextStyle(
                      color: grey2,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    // '12/2/20200',
                    LanguageCubit.get(context).isEn
                        ? DateFormat.yMEd().format(DateTime.parse(
                            TripDetailsCubit.get(context)
                                .tripDetails!
                                .startDate!))
                        : DateFormat.yMEd("ar").format(DateTime.parse(
                            TripDetailsCubit.get(context)
                                .tripDetails!
                                .startDate!)),
                    style: TextStyle(color: grey2, fontSize: 13.sp),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                padding: EdgeInsetsDirectional.only(end: 10.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LanguageCubit.get(context)
                          .getTexts('PickedPoint')
                          .toString(),
                      style: TextStyle(
                          color: black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      TripDetailsCubit.get(context)
                          .tripDetails!
                          .to!
                          .placeTitle!,
                      style: TextStyle(color: grey2, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ),
            TripDetailsCubit.get(context).tripDetails!.endDate!.isNotEmpty
                ? Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          // '12:00 am',
                          LanguageCubit.get(context).isEn
                              ? DateFormat.jm().format(DateTime.parse(
                                  TripDetailsCubit.get(context)
                                      .tripDetails!
                                      .endDate!))
                              : DateFormat.jm("ar").format(DateTime.parse(
                                  TripDetailsCubit.get(context)
                                      .tripDetails!
                                      .endDate!)),
                          style: TextStyle(
                            color: grey2,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          // '12/2/20200',
                          LanguageCubit.get(context).isEn
                              ? DateFormat.yMEd().format(DateTime.parse(
                                  TripDetailsCubit.get(context)
                                      .tripDetails!
                                      .endDate!))
                              : DateFormat.yMEd("ar").format(DateTime.parse(
                                  TripDetailsCubit.get(context)
                                      .tripDetails!
                                      .endDate!)),
                          style: TextStyle(color: grey2, fontSize: 13.sp),
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      style: TextStyle(color: grey2, fontSize: 13.sp),
                    ),
                    SizedBox(
                      height: 5.r,
                    ),
                    Text(
                      // '20',
                      TripDetailsCubit.get(context)
                          .tripDetails!
                          .consumptionKM!
                          .toStringAsFixed(2),
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
                  padding: EdgeInsets.all(10.r),
                  child: Column(children: [
                    Text(
                      LanguageCubit.get(context).getTexts('Points').toString(),
                      style: TextStyle(color: grey2, fontSize: 13.sp),
                    ),
                    SizedBox(
                      height: 5.r,
                    ),
                    Text(
                      // '20',
                      TripDetailsCubit.get(context)
                          .tripDetails!
                          .consumptionPoints!
                          .toStringAsFixed(2),
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
                  padding: EdgeInsets.all(10.r),
                  child: Column(children: [
                    Text(
                      LanguageCubit.get(context)
                          .getTexts('1KmPoints')
                          .toString(),
                      style: TextStyle(color: grey2, fontSize: 13.sp),
                    ),
                    SizedBox(
                      height: 5.r,
                    ),
                    Text(
                      // '20',
                      TripDetailsCubit.get(context)
                          .tripDetails!
                          .oneKMPoints
                          .toString(),
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
      ],
    );
  }

  Widget buttonStatus(BuildContext context, TripDetailsState state) {
    return TripDetailsCubit.get(context).tripDetails!.status == "pending"
        ? Row(
            children: [
              state is! TripDetailsEditInitial
                  ? Expanded(
                      child: defaultButton2(
                          press: () {
                            TripDetailsCubit.get(context).editTrip(
                                TripDetailsCubit.get(context).tripDetails!.id!,
                                btnStatus[
                                    '${TripDetailsCubit.get(context).tripDetails!.status}']![0],
                                "");
                          },
                          fontSize: 20,
                          paddingVertical: 1,
                          paddingHorizontal: 10,
                          borderRadius: 10,
                          text: LanguageCubit.get(context).isEn
                              ? btnStatus2['en']![
                                      '${TripDetailsCubit.get(context).tripDetails!.status}']![
                                  0]
                              : btnStatus2['ar']![
                                  '${TripDetailsCubit.get(context).tripDetails!.status}']![0],
                          backColor: greenColor,
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
              SizedBox(
                width: 15.w,
              ),
              Expanded(
                child: defaultButton2(
                    press: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        // outside to dismiss
                        builder: (_) {
                          return CustomDialogRejectTripDetails(
                            id: TripDetailsCubit.get(context).tripDetails!.id!,
                            title: LanguageCubit.get(context)
                                .getTexts('DoReject')
                                .toString(),
                            description: LanguageCubit.get(context)
                                .getTexts('IfRejected')
                                .toString(),
                          );
                        },
                      );
                    },
                    fontSize: 20,
                    paddingVertical: 1,
                    paddingHorizontal: 10,
                    borderRadius: 10,
                    text: LanguageCubit.get(context).isEn
                        ? btnStatus2['en']![
                                '${TripDetailsCubit.get(context).tripDetails!.status}']![
                            1]
                        : btnStatus2['ar']![
                            '${TripDetailsCubit.get(context).tripDetails!.status}']![1],
                    backColor: greenColor,
                    textColor: white),
              ),
            ],
          )
        : Center(
            child: state is TripDetailsEditInitial
                ? loading()
                : TripDetailsCubit.get(context).tripDetails!.status != null &&
                        btnStatus['${TripDetailsCubit.get(context).tripDetails!.status}']!
                            .isEmpty
                    ? Container()
                    : defaultButton2(
                        press: () {
                          if (btnStatus2['en']![
                                      '${TripDetailsCubit.get(context).tripDetails!.status}']![
                                  0] ==
                              "End") {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              // outside to dismiss
                              builder: (_) {
                                return CustomDialogEndTripDetails(
                                  id: TripDetailsCubit.get(context)
                                      .tripDetails!
                                      .id!,
                                  title: LanguageCubit.get(context)
                                      .getTexts('Trip')
                                      .toString(),
                                  description: LanguageCubit.get(context)
                                      .getTexts('AreEndTrip')
                                      .toString(),
                                  status: btnStatus[
                                      '${TripDetailsCubit.get(context).tripDetails!.status}']![0],
                                );
                              },
                            );
                            // .then((value) {
                            // Navigator.of(context).pop(widget.idRequest);
                            // });
                          } else {
                            TripDetailsCubit.get(context).editTrip(
                                TripDetailsCubit.get(context).tripDetails!.id!,
                                btnStatus[
                                    '${TripDetailsCubit.get(context).tripDetails!.status}']![0],
                                "");
                          }
                        },
                        fontSize: 22,
                        paddingVertical: 1,
                        paddingHorizontal: 50,
                        borderRadius: 10,
                        text: LanguageCubit.get(context).isEn
                            ? btnStatus2['en']![
                                    '${TripDetailsCubit.get(context).tripDetails!.status}']![
                                0]
                            : btnStatus2['ar']![
                                    '${TripDetailsCubit.get(context).tripDetails!.status}']![
                                0],
                        backColor: btnStatus2['en']![
                                            '${TripDetailsCubit.get(context).tripDetails!.status}']![
                                        0] ==
                                    "End" ||
                                btnStatus2['en']![
                                        '${TripDetailsCubit.get(context).tripDetails!.status}']![0] ==
                                    "Cancel"
                            ? redColor
                            : greenColor,
                        textColor: white),
          );
  }
}

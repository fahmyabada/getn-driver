import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getn_driver/data/model/CreateTripModel.dart';
import 'package:getn_driver/data/model/CurrentLocation.dart';
import 'package:getn_driver/data/model/request/From.dart';
import 'package:getn_driver/data/model/trips/To.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/sharedClasses/classes.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/trip/recomendPlaces/RecomendPlacesScreen.dart';
import 'package:getn_driver/presentation/ui/trip/tripCreate/SearchMapScreen.dart';
import 'package:getn_driver/presentation/ui/trip/tripCreate/trip_create_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripCreateScreen extends StatefulWidget {
  const TripCreateScreen(
      {Key? key, this.requestId, this.fromLatitude, this.fromLongitude})
      : super(key: key);

  final String? requestId;
  final double? fromLatitude;
  final double? fromLongitude;

  @override
  State<TripCreateScreen> createState() => _TripCreateScreenState();
}

class _TripCreateScreenState extends State<TripCreateScreen> {
  late GoogleMapController _controller;
  late CameraPosition _cameraPosition;
  var setMapController = TextEditingController();
  String toAddress = "", fromAddress = "", placeId = "", branchId = "";
  double? toLongitude, toLatitude;
  bool firstTime = false;

  // custom marker
  // final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    super.initState();
    getFromAddress();
    _cameraPosition = CameraPosition(
        target: LatLng(widget.fromLatitude!, widget.fromLongitude!), zoom: 17);
    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }
  }

  Future<void> getFromAddress() async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
        widget.fromLatitude!, widget.fromLongitude!);
    Placemark place = placeMarks[0];
    fromAddress =
        '${place.street!}, ${place.administrativeArea!}, ${place.subAdministrativeArea!}, ${place.country!} ';
    print("searchLocation11*****************${widget.fromLatitude!}");
    print("searchLocation11*****************${widget.fromLongitude!}");
  }

  Future<double> getDistance(double toLatitude, double toLongitude) async {
    return Geolocator.distanceBetween(
          widget.fromLatitude!,
          widget.fromLongitude!,
          toLatitude,
          toLongitude,
        ) /
        1000;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripCreateCubit(),
      child: BlocConsumer<TripCreateCubit, TripCreateState>(
        listener: (context, state) {
          if (state is CreateTripSuccessState) {
            if (state.data!.id!.isNotEmpty) {
              Navigator.of(context).pop(widget.requestId!);
              showToastt(
                  text: LanguageCubit.get(context)
                      .getTexts('CreateSuccessfully')
                      .toString(),
                  state: ToastStates.success,
                  context: context);
            }
          } else if (state is CreateTripErrorState) {
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
          if (state is CanCreateTripSuccessState) {
            if (state.data!.activatedTrips! > 0) {
              showDialog(
                context: context,
                barrierDismissible: false,
                // outside to dismiss
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: CustomDialogCanCreateTrip(
                      title: LanguageCubit.get(context)
                          .getTexts('Warning')
                          .toString(),
                      description: LanguageCubit.get(context)
                          .getTexts('haveActivatedTrips')
                          .toString(),
                    ),
                  );
                },
              );
            }
            else {
              if (state.data!.canCreateTrip!) {
                /*getDistance(toLatitude!, toLongitude!).then((value) {
                DateTime now = DateTime.now();
                // you should use package import 'package:intl/intl.dart';  for DateFormat
                //2022-03-08 08:45:55
                String currentDate =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                print("toLatitude********* ${currentDate}");


              });*/

                TripCreateCubit.get(context).createTrip(
                  CreateTripModel(
                    from: From(
                      placeTitle: fromAddress,
                      placeLatitude: widget.fromLatitude.toString(),
                      placeLongitude: widget.fromLongitude.toString(),
                    ),
                    // startDate: currentDate,
                    to: To(
                      placeTitle: toAddress,
                      placeLatitude: toLatitude.toString(),
                      placeLongitude: toLongitude.toString(),
                    ),
                    placeId: placeId,
                    branchId: branchId,
                    request: widget.requestId,
                    // consumptionKM: double.parse(value.toStringAsFixed(2))
                  ),
                );
              }
              else {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  // outside to dismiss
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: CustomDialogCanCreateTrip(
                        title: LanguageCubit.get(context)
                            .getTexts('Warning')
                            .toString(),
                        description:
                            '${LanguageCubit.get(context).getTexts('needPoints1')}${state.data!.neededPoints!.toStringAsFixed(2)}${LanguageCubit.get(context).getTexts('needPoints2')}',
                      ),
                    );
                  },
                );
              }
            }
          } else if (state is CanCreateTripErrorState) {
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
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
                  LanguageCubit.get(context).getTexts('TripDetails').toString(),
                  style: TextStyle(color: primaryColor, fontSize: 20.sp),
                ),
                actions: [
                  IconButton(
                      onPressed: () async {
                        CurrentLocation data =
                            await navigateToWithRefreshPagePrevious(
                                    context, const SearchMapScreen())
                                as CurrentLocation;
                        setState(() {
                          firstTime = data.firstTime!;
                          toAddress = data.description!;
                          toLongitude = data.longitude!;
                          toLatitude = data.latitude!;
                          placeId = "";
                          branchId = "";
                          _controller.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target:
                                      LatLng(data.latitude!, data.longitude!),
                                  zoom: 17)));
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        size: 25.sp,
                      ))
                ],
                centerTitle: true,
                elevation: 1.0,
              ),
              body: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 320.h),
                    child: Stack(
                      children: [
                        GoogleMap(
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
                          onCameraIdle: () async {
                            print("onCameraIdle00********* ");
                            if (!firstTime) {
                              if (toLatitude != null && toLongitude != null) {
                                List<Placemark> placeMarks =
                                    await placemarkFromCoordinates(
                                        toLatitude!, toLongitude!);
                                Placemark place = placeMarks[0];
                                setState(() {
                                  toAddress =
                                      '${place.street!}, ${place.administrativeArea!}, ${place.subAdministrativeArea!}, ${place.country!}';
                                });
                              }
                            }
                          },
                          onCameraMove: (position) {
                            print("onCameraIdle11********* ");
                            setState(() {
                              toLatitude = position.target.latitude;
                              toLongitude = position.target.longitude;
                            });
                          },
                          initialCameraPosition: _cameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                          },
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.pin_drop,
                              color: redColor,
                              size: 70.sp,
                            ))
                      ],
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.r, vertical: 30.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LanguageCubit.get(context)
                                    .getTexts('SelectNextDestination')
                                    .toString(),
                                style: TextStyle(color: black, fontSize: 20.sp),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              InkWell(
                                child: Container(
                                  width: 1.sw,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.r, vertical: 15.r),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Text(
                                    toAddress.isNotEmpty
                                        ? toAddress
                                        : LanguageCubit.get(context)
                                            .getTexts('SetOnMap')
                                            .toString(),
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                ),
                                onTap: () async {
                                  CurrentLocation data =
                                      await navigateToWithRefreshPagePrevious(
                                              context, const SearchMapScreen())
                                          as CurrentLocation;
                                  setState(() {
                                    firstTime = data.firstTime!;
                                    toAddress = data.description!;
                                    toLongitude = data.longitude!;
                                    toLatitude = data.latitude!;
                                    placeId = "";
                                    branchId = "";
                                    _controller.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: LatLng(data.latitude!,
                                                    data.longitude!),
                                                zoom: 17)));
                                  });
                                },
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              defaultButton3(
                                  text: LanguageCubit.get(context)
                                      .getTexts('RecommendedPlaces')
                                      .toString(),
                                  press: () async {
                                    CurrentLocation data =
                                        await navigateToWithRefreshPagePrevious(
                                                context,
                                                const RecomendPlacesScreen())
                                            as CurrentLocation;

                                    print(
                                        "TripCreateScreen********* ${data.toString()}");
                                    setState(() {
                                      firstTime = data.firstTime!;
                                      toAddress = data.description!;
                                      toLongitude = data.longitude!;
                                      toLatitude = data.latitude!;
                                      data.placeId != null
                                          ? placeId = data.placeId!
                                          : placeId = "";
                                      data.branchId != null
                                          ? branchId = data.branchId!
                                          : branchId = "";
                                      _controller.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  target: LatLng(data.latitude!,
                                                      data.longitude!),
                                                  zoom: 17)));
                                    });
                                  },
                                  textColor: white,
                                  backColor: blueColor),
                              SizedBox(
                                height: 15.h,
                              ),
                              state is CreateTripInitial
                                  ? loading()
                                  : defaultButton3(
                                      text: LanguageCubit.get(context)
                                          .getTexts('Request')
                                          .toString(),
                                      press: () {
                                        if (toAddress.isNotEmpty) {
                                          TripCreateCubit.get(context)
                                              .canCreateTrip(
                                            CreateTripModel(
                                              from: From(
                                                placeTitle: fromAddress,
                                                placeLatitude: widget
                                                    .fromLatitude
                                                    .toString(),
                                                placeLongitude: widget
                                                    .fromLongitude
                                                    .toString(),
                                              ),
                                              to: To(
                                                placeTitle: toAddress,
                                                placeLatitude:
                                                    toLatitude.toString(),
                                                placeLongitude:
                                                    toLongitude.toString(),
                                              ),
                                              placeId: placeId,
                                              branchId: branchId,
                                              request: widget.requestId,
                                            ),
                                          );
                                        } else {
                                          showToastt(
                                              text: LanguageCubit.get(context)
                                                  .getTexts(
                                                      'ChooseDestinationFirst')
                                                  .toString(),
                                              state: ToastStates.error,
                                              context: context);
                                        }
                                      },
                                      textColor: white,
                                      backColor: accentColor),
                            ],
                          ),
                        ),
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

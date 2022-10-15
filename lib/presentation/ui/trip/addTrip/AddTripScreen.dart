import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getn_driver/data/model/CurrentLocation.dart';
import 'package:getn_driver/data/model/request/From.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/model/trips/To.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/trip/addTrip/SearchMapScreen.dart';
import 'package:getn_driver/presentation/ui/trip/addTrip/add_trip_cubit.dart';
import 'package:getn_driver/presentation/ui/trip/recomendPlaces/RecomendPlacesScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen(
      {Key? key, this.requestId, this.fromLatitude, this.fromLongitude})
      : super(key: key);

  final String? requestId;
  final double? fromLatitude;
  final double? fromLongitude;

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  late GoogleMapController _controller;
  late CameraPosition _cameraPosition;
  var setMapController = TextEditingController();
  String toAddress = "", fromAddress = "";
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTripCubit(),
      child: BlocConsumer<AddTripCubit, AddTripState>(
        listener: (context, state) {
          if (state is CreateTripSuccessState) {
            if (state.data!.id!.isNotEmpty) {
              Navigator.of(context).pop(widget.requestId!);
              showToastt(
                  text: "create successfully",
                  state: ToastStates.success,
                  context: context);
            }
          } else if (state is CreateTripErrorState) {
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Trip Details',
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
                        _controller.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(data.latitude!, data.longitude!),
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
                          print("onCameraIdle00********* " );
                          if(!firstTime){
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
                          print("onCameraIdle11********* " );
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
                              'Select Next Destination',
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
                                      : 'Set on map',
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
                                text: 'Recommended Places',
                                press: () async{
                                  CurrentLocation data =
                                      await navigateToWithRefreshPagePrevious(
                                      context, const RecomendPlacesScreen())
                                  as CurrentLocation;

                                  print("RecomendPlacesScreen********* ${data.toString()}");
                                  setState(() {
                                    firstTime = data.firstTime!;
                                    toAddress = data.description!;
                                    toLongitude = data.longitude!;
                                    toLatitude = data.latitude!;
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
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: black,
                                  ))
                                : defaultButton3(
                                    text: 'Request',
                                    press: () {
                                      if (toAddress.isNotEmpty) {
                                        getDistance(toLatitude!, toLongitude!)
                                            .then((value) {
                                          DateTime now = DateTime.now();
                                          // you should use package import 'package:intl/intl.dart';  for DateFormat
                                          //2022-03-08 08:45:55
                                          String currentDate =
                                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                                  .format(now);
                                          print(
                                              "toLatitude********* ${currentDate}");

                                          AddTripCubit.get(context).createTrip(
                                            Data(
                                                from: From(
                                                  placeTitle: fromAddress,
                                                  placeLatitude: widget
                                                      .fromLatitude
                                                      .toString(),
                                                  placeLongitude: widget
                                                      .fromLongitude
                                                      .toString(),
                                                ),
                                                startDate: currentDate,
                                                to: To(
                                                  placeTitle: toAddress,
                                                  placeLatitude:
                                                      toLatitude.toString(),
                                                  placeLongitude:
                                                      toLongitude.toString(),
                                                ),
                                                request: widget.requestId,
                                                consumptionKM: double.parse(
                                                    value.toStringAsFixed(2))),
                                          );
                                        });
                                      } else {
                                        showToastt(
                                            text:
                                                "you should choose destination first..",
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
          );
        },
      ),
    );
  }
}

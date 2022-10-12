import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddTrip extends StatefulWidget {
  const AddTrip({Key? key}) : super(key: key);

  @override
  State<AddTrip> createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  // custom marker
  // final Set<Marker> _markers = <Marker>{};
  // final LatLng destinationLatLng = const LatLng(30.149350, 31.738539);
  // final LatLng initialLatLng = const LatLng(30.1541371, 31.7397189);
  late GoogleMapController _controller;
  late CameraPosition _cameraPosition;

  // _setMapPins(List<LatLng> markersLocation) {
  //   _markers.clear();
  //   setState(() {
  //     // for (var markerLocation in markersLocation) {
  //     //   _markers.add(Marker(
  //     //     markerId: MarkerId(markerLocation.toString()),
  //     //     position: markerLocation,
  //     //     icon: customIcon,
  //     //   ));
  //     // }
  //     _markers.add(Marker(
  //       markerId: MarkerId(destinationLatLng.toString()),
  //       position: destinationLatLng,
  //     ));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

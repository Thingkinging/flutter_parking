import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_parking/repositories/dbhelper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  final List<Marker> markers = [];

  bool _isMarkerShow = false;

  addMarker(cordinate, marker_id, marker_name) {
    markers.add(Marker(
        position: cordinate,
        markerId: MarkerId(marker_id),
        infoWindow: InfoWindow(title: marker_name)));
  }

  final CameraPosition position = CameraPosition(
    target: LatLng(37.500784, 127.0368148),
    zoom: 15,
  );

  void _add_marker() {
    setState(() {
      _isMarkerShow = !_isMarkerShow;
      DBHelper dbHelper = DBHelper();
      dbHelper.parks().then((value) => value.forEach((element) {
            print(
                'parking_code: ${element.parking_code}, parking_name: ${element.parking_name}');
            addMarker(
              LatLng(element.lat, element.lng),
              element.parking_code,
              element.parking_name,
            );
          }));
    });
  }

  void _remove_marker() {
    setState(() {
      _isMarkerShow = !_isMarkerShow;
      markers.clear();
    });
  }

  void _moveToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(position.latitude, position.longitude),
          zoom: 17,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: position,
            markers: markers.toSet(),
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 20, right: 10),
            alignment: Alignment.topRight,
            child: Column(
              children: [
                FloatingActionButton.extended(
                  label: Text(
                    '주차장 위치',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(
                    Icons.local_parking,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.deepPurpleAccent[400],
                  onPressed: _isMarkerShow ? _add_marker : _add_marker,
                ),
                SizedBox(height: 10),
                FloatingActionButton.extended(
                  label: Text(
                    '현재위치',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(
                    Icons.gps_fixed,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.green[400],
                  onPressed: () {
                    _moveToCurrentLocation();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

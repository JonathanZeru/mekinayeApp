import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

import 'package:mekinaye/config/themes/data/app_theme.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // MapController _mapController = MapController();
  // Position? _currentPosition;
  // List<Marker> _gasStationMarkers = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _getCurrentLocation();
  // }

  // Future<void> _getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   setState(() {
  //     _currentPosition = position;
  //     _fetchGasStations(position.latitude, position.longitude);
  //   });
  // }

  // Future<void> _fetchGasStations(double latitude, double longitude) async {
  //   final response = await http.get(Uri.parse(
  //     'https://api.openrouteservice.org/v2/pois?api_key=YOUR_API_KEY& categories= fuel &bbox=${longitude - 0.1},${latitude - 0.1},${longitude + 0.1},${latitude + 0.1}'
  //   ));

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     List<Marker> markers = [];
  //     for (var feature in data['features']) {
  //       final coords = feature['geometry']['coordinates'];
  //       markers.add(Marker(
  //         point: LatLng(coords[1], coords[0]),
  //         builder: (ctx) => Icon(Icons.local_gas_station, color: Colors.blue),
  //       ));
  //     }
  //     setState(() {
  //       _gasStationMarkers = markers;
  //     });
  //   } else {
  //     throw Exception('Failed to load gas stations');
  //   }
  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Center(
      child: Scaffold(
          appBar: AppBar(
              title: Text(
            "Ethio Workshop",
            style: theme.typography.titleLarge.copyWith(
              color: theme.primaryText,
              fontSize: 20.0,
            ),
          )),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.construction,
                  size: 100,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Under Construction",
                  style: theme.typography.titleMedium.copyWith(
                      color: theme.primaryText,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "This page will be available very soon!",
                  style: theme.typography.titleMedium.copyWith(
                      color: theme.primaryText,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Gas Stations')),
  //     body: _currentPosition == null
  //         ? Center(child: CircularProgressIndicator())
  //         : FlutterMap(
  //             mapController: _mapController,
  //             options: MapOptions(
  //               center: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
  //               zoom: 13.0,
  //             ),
  //             layers: [
  //               TileLayerOptions(
  //                 urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  //                 subdomains: ['a', 'b', 'c'],
  //               ),
  //               MarkerLayerOptions(
  //                 markers: _gasStationMarkers,
  //               ),
  //             ],
  //           ),
  //   );
  // }
}

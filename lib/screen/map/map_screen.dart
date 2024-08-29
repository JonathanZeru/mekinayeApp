import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userLocation;
  bool isLocationFetched = false;
  bool isLoading = true;
  List<LatLng> gasStationLocations = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled
    print("started");
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Request user to enable location services
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Open app settings to let user enable location services
        if (await openAppSettings()) {
          print('Opened app settings to enable location services');
        } else {
          print('Failed to open app settings');
        }
        setState(() {
          isLoading = false;
        });
        return Future.error('Location services are disabled. Please enable them.');
      }
    }

    // Check and request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        setState(() {
          isLoading = false;
        });
        return Future.error('Location permission denied. Please grant access.');
      }
    }

    print("serviceEnabled = $serviceEnabled");
    try {
      // Fetch current position
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        print("userLocation = $userLocation");
        _fetchNearbyGasStations(position.latitude, position.longitude);
      });
    } catch (e) {
      // Handle exception when fetching location
      print('Error fetching location: $e');
      setState(() {
        isLoading = false;
      });
      return Future.error('Error fetching location.');
    }
  }

  Future<void> _fetchNearbyGasStations(double latitude, double longitude) async {
    print("_fetchNearbyGasStations = $userLocation");
    final url =
        'https://nominatim.openstreetmap.org/search?format=json&q=gas+station&limit=10&lat=$latitude&lon=$longitude';
    final response = await http.get(Uri.parse(url));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      setState(() {
        gasStationLocations = data.map((station) {
          return LatLng(
            double.parse(station['lat']),
            double.parse(station['lon']),
          );
        }).toList();
      });
      isLocationFetched = true;
      isLoading = false;
    } else {
      print('Failed to fetch gas stations');
    }
    isLocationFetched = true;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isLocationFetched
          ? FlutterMap(
        options: MapOptions(
            initialCenter: userLocation!,
            maxZoom: 20
        ),
        children: [
          TileLayer(
            urlTemplate:
            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: gasStationLocations.map((location) {
              return Marker(
                  point: location,
                  child: Icon(
                    Icons.local_gas_station,
                    color: Colors.red,
                    size: 40,
                  )
              );
            }).toList(),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

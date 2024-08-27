import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final List<LatLng> gasStationLocations = [
    LatLng(8.9931373, 38.7588295), // Example coordinates
    LatLng(8.9940000, 38.7600000), // Replace with actual gas station coordinates
    LatLng(8.9950000, 38.7620000), // Replace with actual gas station coordinates
    // Add more coordinates here
  ];

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
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(8.9931373, 38.7588295),
          maxZoom: 15.0
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
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
              ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
/**import 'package:flutter/material.dart';
    import 'package:google_maps_flutter/google_maps_flutter.dart';

    class MapScreen extends StatefulWidget {

    const MapScreen({Key? key}) : super(key: key);

    @override
    State<MapScreen> createState() => _MapScreenState();
    }

    class _MapScreenState extends State<MapScreen> {
    final Set<Marker> _markers = {};
    final List<LatLng> gasStationLocations = [
    LatLng(8.9931373, 38.7588295), // Example coordinates
    LatLng(8.9940000, 38.7600000), // Replace with actual gas station coordinates
    LatLng(8.9950000, 38.7620000), // Replace with actual gas station coordinates
    // Add more coordinates here
    ];
    @override
    void initState() {
    super.initState();
    _markers.addAll(gasStationLocations.map((location) => Marker(
    markerId: MarkerId(location.toString()),
    position: location,
    icon: BitmapDescriptor.defaultMarkerWithColor(Colors.red),
    )).toList());
    }

    @override
    Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    leading: IconButton(
    onPressed: () => Navigator.of(context).pop(),
    icon: const Icon(Icons.arrow_back),
    ),
    ),
    body: GoogleMap(
    initialCameraPosition: CameraPosition(
    target: widget.gasStationLocations.first,
    zoom: 15.0,
    ),
    markers: _markers,
    ),
    );
    }
    }*/
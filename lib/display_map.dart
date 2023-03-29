import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String location;

  const MapScreen(
      {Key? key,
      required this.latitude,
      required this.longitude,
      required this.location})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(widget.latitude, widget.longitude),
          zoom: 17.0,
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80,
                height: 80,
                point: LatLng(widget.latitude, widget.longitude),
                builder: (ctx) => Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                      Text(
                        widget.location,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

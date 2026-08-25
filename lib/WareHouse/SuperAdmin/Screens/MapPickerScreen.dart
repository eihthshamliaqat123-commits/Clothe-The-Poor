import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng selectedLocation = LatLng(33.6844, 73.0479); // default Islamabad

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLocation,
              zoom: 14,
            ),

            onTap: (latLng) {
              setState(() {
                selectedLocation = latLng;

                markers.clear();

                markers.add(
                  Marker(markerId: MarkerId("zone"), position: latLng),
                );
              });
            },

            markers: markers,
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,

            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "lat": selectedLocation.latitude,
                  "lng": selectedLocation.longitude,
                });
              },
              child: Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}

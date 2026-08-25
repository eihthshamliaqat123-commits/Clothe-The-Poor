import 'package:charity/widget/mapController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final c = Get.find<MapController>();

  @override
  void initState() {
    super.initState();
    c.initLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Obx(() {
        if (c.currentLocation.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: c.currentLocation.value!,
            zoom: 15,
          ),
          markers: c.markers,
          onTap: c.setMarker,
          onMapCreated: (map) => c.mapController = map,
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () => Navigator.pop(context, c.selectedLocation),
      ),
    );
  }
}

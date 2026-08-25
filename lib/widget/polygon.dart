import 'package:charity/widget/mapController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonPickerScreen extends StatefulWidget {
  const PolygonPickerScreen({super.key});

  @override
  State<PolygonPickerScreen> createState() => _PolygonPickerScreenState();
}

class _PolygonPickerScreenState extends State<PolygonPickerScreen> {
  final c = Get.find<MapController>();

  @override
  void initState() {
    super.initState();
    c.initLocation();
    c.clearPolygon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Draw Zone")),
      body: Obx(() {
        if (c.currentLocation.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: c.currentLocation.value!,
            zoom: 15,
          ),
          polygons: c.polygons,
          markers: c.markers,
          onTap: c.addPolygonPoint,
          onMapCreated: (map) => c.mapController = map,
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () => Navigator.pop(context, c.polygonPoints.toList()),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapController extends GetxController {
  GoogleMapController? mapController;

  var currentLocation = Rxn<LatLng>();

  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Polygon> polygons = <Polygon>{}.obs;
  RxList<LatLng> polygonPoints = <LatLng>[].obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  // 🔥 SELECTED LOCATION
  Rx<LatLng> selectedLatLng = const LatLng(33.6844, 73.0479).obs;

  var address = "".obs;
  final String googleApiKey = "AIzaSyCiYoKGFlfNDlYIy8lEnoiML75RypkFXJE";
  LatLng? selectedLocation;

  @override
  void onInit() {
    super.onInit();
    initLocation();
  }

  Future<void> initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        address.value = "Location service disabled";
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        address.value = "Permission permanently denied";
        return;
      }

      if (permission == LocationPermission.denied) {
        address.value = "Permission denied";
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: true,
        timeLimit: const Duration(seconds: 15),
      );

      print("CURRENT LAT => ${pos.latitude}");
      print("CURRENT LNG => ${pos.longitude}");

      LatLng loc = LatLng(pos.latitude, pos.longitude);

      currentLocation.value = loc;

      setMarker(loc);
    } catch (e) {
      print(e);

      address.value = "Location error: $e";
    }
  }

  // ================= ADDRESS =================
  Future<void> getAddress(double lat, double lng) async {
    try {
      var places = await placemarkFromCoordinates(lat, lng);

      address.value =
          "${places.first.locality}, ${places.first.administrativeArea}";
    } catch (e) {
      address.value = "Unknown location";
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // meters

    double dLat = _toRad(end.latitude - start.latitude);
    double dLng = _toRad(end.longitude - start.longitude);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(start.latitude)) *
            cos(_toRad(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRad(double degree) {
    return degree * pi / 180;
  }

  // Future<void> drawRoute(LatLng start, LatLng end) async {
  //   final String url =
  //       "https://maps.googleapis.com/maps/api/directions/json?"
  //       "origin=${start.latitude},${start.longitude}"
  //       "&destination=${end.latitude},${end.longitude}"
  //       "&key=$googleApiKey";

  //   final response = await http.get(Uri.parse(url));

  //   print(response.body); // 🔥 MUST DEBUG

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);

  //     if (data["status"] == "OK") {
  //       final points = data["routes"][0]["overview_polyline"]["points"];

  //       List<LatLng> routePoints = _decodePolyline(points);

  //       polylines.clear();
  //       polylines.add(
  //         Polyline(
  //           polylineId: PolylineId("route"),
  //           points: routePoints,
  //           width: 5,
  //         ),
  //       );

  //       polylines.refresh();
  //     } else {
  //       Get.snackbar("Direction Error", data["status"]);
  //     }
  //   }
  // }

  // List<LatLng> _decodePolyline(String encoded) {
  //   List<LatLng> points = [];
  //   int index = 0, len = encoded.length;
  //   int lat = 0, lng = 0;

  //   while (index < len) {
  //     int b, shift = 0, result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1f) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  //     lat += dlat;

  //     shift = 0;
  //     result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1f) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  //     lng += dlng;

  //     points.add(LatLng(lat / 1E5, lng / 1E5));
  //   }

  //   return points;
  // }

  // ================= MARKER =================
  void setMarker(LatLng point) {
    markers.clear();

    markers.add(Marker(markerId: const MarkerId("selected"), position: point));

    selectedLocation = point;

    // IMPORTANT
    selectedLatLng.value = point;

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(point, 15));

    getAddress(point.latitude, point.longitude);

    markers.refresh();
  }

  // ================= GET SELECTED =================
  LatLng? getSelectedLocation() {
    return selectedLocation ?? currentLocation.value;
  }

  // ================= POLYGON =================
  void addPolygonPoint(LatLng point) {
    polygonPoints.add(point);

    polygons.clear();

    polygons.add(
      Polygon(
        polygonId: const PolygonId("zone"),
        points: polygonPoints.toList(),
        strokeWidth: 2,
        fillColor: Colors.green.withOpacity(0.2),
      ),
    );

    polygons.refresh();
  }

  void clearPolygon() {
    polygonPoints.clear();
    polygons.clear();
    polygons.refresh();
  }

  // ================= RESET (IMPORTANT) =================
  void reset() {
    markers.clear();
    polygons.clear();
    polygonPoints.clear();
    selectedLocation = null;
    address.value = "";
  }
}

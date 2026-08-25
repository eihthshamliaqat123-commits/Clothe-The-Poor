import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:charity/widget/mapController.dart';

class ReusableMap extends StatelessWidget {
  ReusableMap({super.key, this.allowPolygon = false});

  final bool allowPolygon;
  final MapController c = Get.put(MapController());

  final TextEditingController searchController = TextEditingController();

  final String googleApiKey = "AIzaSyD5nXdOC1QsQEkWR-W_-iLxNFRhAbwkkv8";

  // =========================
  // SEARCH LOCATION
  // =========================
  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(query)}&key=$googleApiKey";

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      if (data["status"] == "OK") {
        final loc = data["results"][0]["geometry"]["location"];

        final target = LatLng(
          double.parse(loc["lat"].toString()),
          double.parse(loc["lng"].toString()),
        );

        c.setMarker(target);
        c.mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
      } else {
        Get.snackbar("Error", data["status"]);
      }
    } else {
      Get.snackbar("Error", "Failed to search location");
    }
  }

  // =========================
  // DISTANCE CHECK
  // =========================
  Future<double> _getDistance(double targetLat, double targetLng) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Get.snackbar("Error", "Location service disabled");
      return 999999;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Error", "Location permission denied forever");
      return 999999;
    }

    // 🔥 FORCE FRESH LOCATION
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    );

    print("========= LIVE LOCATION =========");
    print("CURRENT => ${pos.latitude}, ${pos.longitude}");

    print("TARGET => $targetLat, $targetLng");

    double distance = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      targetLat,
      targetLng,
    );

    print("DISTANCE => $distance");

    return distance;
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        backgroundColor: Colors.teal,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Location",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => searchLocation(searchController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: searchLocation,
            ),
          ),
        ),
      ),

      // =========================
      // BODY
      // =========================
      body: Obx(() {
        if (c.currentLocation.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: c.currentLocation.value!,
            zoom: 15,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: c.markers.value,
          polygons: c.polygons.value,

          onMapCreated: (map) {
            c.mapController = map;

            // Rider target preview
            if (args != null && args["lat"] != null && args["lng"] != null) {
              final target = LatLng(
                double.parse(args["lat"].toString()),
                double.parse(args["lng"].toString()),
              );

              c.setMarker(target);
              map.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
            }
          },

          onTap: (point) {
            if (allowPolygon) {
              c.addPolygonPoint(point);
            } else {
              c.setMarker(point);
            }
          },
        );
      }),

      // =========================
      // CONFIRM BUTTON
      // =========================
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          final args = Get.arguments;

          // =========================
          // RIDER MODE
          // =========================
          if (args != null && args["lat"] != null && args["lng"] != null) {
            final double targetLat = double.parse(args["lat"].toString());
            final double targetLng = double.parse(args["lng"].toString());

            final distance = await _getDistance(targetLat, targetLng);

            print("DISTANCE => $distance meters");

            if (distance > 300) {
              Get.snackbar("Error", "You are too far from target location");
              return;
            }

            Navigator.pop(context, true);
            return;
          }

          // =========================
          // DONOR MODE
          // =========================
          Navigator.pop(context, c.selectedLatLng.value);
        },
      ),
    );
  }
}

// import 'dart:convert';

// import 'package:charity/widget/mapController.dart';

// import 'package:flutter/material.dart';

// import 'package:geolocator/geolocator.dart';

// import 'package:get/get.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:http/http.dart' as http;

// class ReusableMap extends StatelessWidget {
//   ReusableMap({super.key, this.allowPolygon = false, this.onLocationSelected});

//   final bool allowPolygon;

//   final Function(LatLng)? onLocationSelected;

//   final MapController c = Get.put(MapController(), permanent: false);

//   final TextEditingController searchController = TextEditingController();

//   final String googleApiKey = "AIzaSyCiYoKGFlfNDlYIy8lEnoiML75RypkFXJE";

//   // =========================================================
//   // SEARCH LOCATION
//   // =========================================================

//   Future<void> searchLocation(String query) async {
//     if (query.isEmpty) return;

//     try {
//       final encodedQuery = Uri.encodeComponent(query);

//       final url =
//           "https://maps.googleapis.com/maps/api/geocode/json?address=$encodedQuery&key=$googleApiKey";

//       final response = await http.get(Uri.parse(url));

//       print(response.body);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data["status"] == "OK") {
//           final location = data["results"][0]["geometry"]["location"];

//           double lat = location["lat"];

//           double lng = location["lng"];

//           LatLng target = LatLng(lat, lng);

//           c.setMarker(target);

//           c.mapController?.animateCamera(
//             CameraUpdate.newLatLngZoom(target, 15),
//           );
//         } else {
//           Get.snackbar("Error", data["status"].toString());
//         }
//       } else {
//         Get.snackbar("Error", "Search failed");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final args = Get.arguments;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Location"),

//         backgroundColor: Colors.teal,

//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(70),

//           child: Padding(
//             padding: const EdgeInsets.all(10),

//             child: TextField(
//               controller: searchController,

//               decoration: InputDecoration(
//                 hintText: "Search Location",

//                 filled: true,

//                 fillColor: Colors.white,

//                 prefixIcon: const Icon(Icons.search),

//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.send),

//                   onPressed: () {
//                     searchLocation(searchController.text);
//                   },
//                 ),

//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),

//                   borderSide: BorderSide.none,
//                 ),
//               ),

//               onSubmitted: (value) {
//                 searchLocation(value);
//               },
//             ),
//           ),
//         ),
//       ),

//       body: Obx(() {
//         if (c.currentLocation.value == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return Stack(
//           children: [
//             // =====================================================
//             // GOOGLE MAP
//             // =====================================================
//             GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: c.currentLocation.value!,
//                 zoom: 15,
//               ),

//               myLocationEnabled: true,

//               myLocationButtonEnabled: true,

//               zoomControlsEnabled: true,

//               mapType: MapType.normal,

//               markers: c.markers.value,

//               polygons: c.polygons.value,

//               onMapCreated: (map) {
//                 c.mapController = map;

//                 // =========================================
//                 // RIDER TARGET LOCATION
//                 // =========================================

//                 if (args != null) {
//                   double lat = args["lat"];

//                   double lng = args["lng"];

//                   LatLng target = LatLng(lat, lng);

//                   c.setMarker(target);

//                   map.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
//                 }
//               },

//               // =========================================
//               // TAP
//               // =========================================
//               onTap: (point) {
//                 if (allowPolygon) {
//                   c.addPolygonPoint(point);
//                 } else {
//                   c.setMarker(point);
//                 }
//               },
//             ),

//             // =====================================================
//             // ADDRESS BOX
//             // =====================================================
//             Positioned(
//               top: 10,
//               left: 10,
//               right: 10,

//               child: Container(
//                 padding: const EdgeInsets.all(12),

//                 decoration: BoxDecoration(
//                   color: Colors.white,

//                   borderRadius: BorderRadius.circular(12),

//                   boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
//                 ),

//                 child: Text(
//                   c.address.value.isEmpty
//                       ? "Fetching Address..."
//                       : c.address.value,

//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ),

//             // =====================================================
//             // CONFIRM BUTTON
//             // =====================================================
//             Positioned(
//               bottom: 20,
//               left: 20,
//               right: 20,

//               child: SizedBox(
//                 height: 55,

//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),

//                   icon: const Icon(Icons.location_on, color: Colors.white),

//                   label: const Text(
//                     "Confirm Location",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   onPressed: () async {
//                     // =====================================
//                     // RIDER CASE
//                     // =====================================

//                     if (args != null) {
//                       double targetLat = args["lat"];

//                       double targetLng = args["lng"];

//                       Position pos = await Geolocator.getCurrentPosition();

//                       double distance = Geolocator.distanceBetween(
//                         pos.latitude,
//                         pos.longitude,
//                         targetLat,
//                         targetLng,
//                       );

//                       print("DISTANCE => $distance");

//                       // 100 METERS
//                       if (distance > 100) {
//                         Get.snackbar("Error", "You are not at target location");

//                         return;
//                       }

//                       Navigator.pop(context, true);

//                       return;
//                     }

//                     // =====================================
//                     // DONOR CASE
//                     // =====================================

//                     final LatLng selected = c.selectedLatLng.value;

//                     print("LAT => ${selected.latitude}");

//                     print("LNG => ${selected.longitude}");

//                     Navigator.pop(context, selected);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.check),

//         onPressed: () async {
//           final args = Get.arguments;

//           // 🔥 RIDER MODE
//           if (args != null && args["lat"] != null && args["lng"] != null) {
//             double targetLat = args["lat"];
//             double targetLng = args["lng"];

//             // 🔥 CURRENT LOCATION
//             Position pos = await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high,
//             );

//             // 🔥 DISTANCE
//             double distance = Geolocator.distanceBetween(
//               pos.latitude,
//               pos.longitude,
//               targetLat,
//               targetLng,
//             );

//             print("CURRENT LAT => ${pos.latitude}");
//             print("CURRENT LNG => ${pos.longitude}");

//             print("TARGET LAT => $targetLat");
//             print("TARGET LNG => $targetLng");

//             print("DISTANCE => $distance");

//             // 🔥 ALLOW 300 METERS
//             if (distance > 300) {
//               Get.snackbar("Error", "You are too far from target location");

//               return;
//             }

//             Navigator.pop(context, true);
//           }
//           // 🔥 DONOR MODE
//           else {
//             Navigator.pop(context, c.selectedLatLng.value);
//           }
//         },
//       ),
//     );
//   }
// }

// import 'dart:convert';

// import 'package:charity/widget/mapController.dart';

// import 'package:flutter/material.dart';

// import 'package:geolocator/geolocator.dart';

// import 'package:get/get.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:http/http.dart' as http;

// class ReusableMap extends StatelessWidget {
//   ReusableMap({super.key, this.allowPolygon = false, this.onLocationSelected});

//   final bool allowPolygon;

//   final Function(LatLng)? onLocationSelected;

//   final MapController c = Get.put(MapController(), permanent: false);

//   final TextEditingController searchController = TextEditingController();

//   final String googleApiKey = "AIzaSyCiYoKGFlfNDlYIy8lEnoiML75RypkFXJE";

//   // =========================================================
//   // SEARCH LOCATION
//   // =========================================================

//   Future<void> searchLocation(String query) async {
//     if (query.isEmpty) return;

//     try {
//       final encodedQuery = Uri.encodeComponent(query);

//       final url =
//           "https://maps.googleapis.com/maps/api/geocode/json?address=$encodedQuery&key=$googleApiKey";

//       final response = await http.get(Uri.parse(url));

//       print(response.body);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data["status"] == "OK") {
//           final location = data["results"][0]["geometry"]["location"];

//           double lat = location["lat"];

//           double lng = location["lng"];

//           LatLng target = LatLng(lat, lng);

//           c.setMarker(target);

//           c.mapController?.animateCamera(
//             CameraUpdate.newLatLngZoom(target, 15),
//           );
//         } else {
//           Get.snackbar("Error", data["status"].toString());
//         }
//       } else {
//         Get.snackbar("Error", "Search failed");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final args = Get.arguments;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Location"),

//         backgroundColor: Colors.teal,

//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(70),

//           child: Padding(
//             padding: const EdgeInsets.all(10),

//             child: TextField(
//               controller: searchController,

//               decoration: InputDecoration(
//                 hintText: "Search Location",

//                 filled: true,

//                 fillColor: Colors.white,

//                 prefixIcon: const Icon(Icons.search),

//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.send),

//                   onPressed: () {
//                     searchLocation(searchController.text);
//                   },
//                 ),

//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),

//                   borderSide: BorderSide.none,
//                 ),
//               ),

//               onSubmitted: (value) {
//                 searchLocation(value);
//               },
//             ),
//           ),
//         ),
//       ),

//       body: Obx(() {
//         if (c.currentLocation.value == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return Stack(
//           children: [
//             // =====================================================
//             // GOOGLE MAP
//             // =====================================================
//             GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: c.currentLocation.value!,
//                 zoom: 15,
//               ),

//               myLocationEnabled: true,

//               myLocationButtonEnabled: true,

//               zoomControlsEnabled: true,

//               mapType: MapType.normal,

//               markers: c.markers.value,

//               polygons: c.polygons.value,

//               onMapCreated: (map) {
//                 c.mapController = map;

//                 // =========================================
//                 // RIDER TARGET LOCATION
//                 // =========================================

//                 if (args != null) {
//                   double lat = args["lat"];

//                   double lng = args["lng"];

//                   LatLng target = LatLng(lat, lng);

//                   c.setMarker(target);

//                   map.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
//                 }
//               },

//               // =========================================
//               // TAP
//               // =========================================
//               onTap: (point) {
//                 if (allowPolygon) {
//                   c.addPolygonPoint(point);
//                 } else {
//                   c.setMarker(point);
//                 }
//               },
//             ),

//             // =====================================================
//             // ADDRESS BOX
//             // =====================================================
//             Positioned(
//               top: 10,
//               left: 10,
//               right: 10,

//               child: Container(
//                 padding: const EdgeInsets.all(12),

//                 decoration: BoxDecoration(
//                   color: Colors.white,

//                   borderRadius: BorderRadius.circular(12),

//                   boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
//                 ),

//                 child: Text(
//                   c.address.value.isEmpty
//                       ? "Fetching Address..."
//                       : c.address.value,

//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ),

//             // =====================================================
//             // CONFIRM BUTTON
//             // =====================================================
//             Positioned(
//               bottom: 20,
//               left: 20,
//               right: 20,

//               child: SizedBox(
//                 height: 55,

//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),

//                   icon: const Icon(Icons.location_on, color: Colors.white),

//                   label: const Text(
//                     "Confirm Location",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   onPressed: () async {
//                     // =====================================
//                     // RIDER CASE
//                     // =====================================

//                     if (args != null) {
//                       double targetLat = args["lat"];

//                       double targetLng = args["lng"];

//                       Position pos = await Geolocator.getCurrentPosition();

//                       double distance = Geolocator.distanceBetween(
//                         pos.latitude,
//                         pos.longitude,
//                         targetLat,
//                         targetLng,
//                       );

//                       print("DISTANCE => $distance");

//                       // 100 METERS
//                       if (distance > 100) {
//                         Get.snackbar("Error", "You are not at target location");

//                         return;
//                       }

//                       Navigator.pop(context, true);

//                       return;
//                     }

//                     // =====================================
//                     // DONOR CASE
//                     // =====================================

//                     final LatLng selected = c.selectedLatLng.value;

//                     print("LAT => ${selected.latitude}");

//                     print("LNG => ${selected.longitude}");

//                     Navigator.pop(context, selected);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// // import 'package:google_maps_flutter/google_maps_flutter.dart';

// // class ReusableMap extends StatefulWidget {
// //   const ReusableMap({super.key});

// //   @override
// //   State<ReusableMap> createState() => _ReusableMapState();
// // }

// // class _ReusableMapState extends State<ReusableMap> {
// //   GoogleMapController? mapController;

// //   // DEFAULT LOCATION
// //   LatLng selectedLocation = const LatLng(33.6844, 73.0479);

// //   Set<Marker> markers = {};

// //   @override
// //   void initState() {
// //     super.initState();

// //     markers.add(
// //       Marker(
// //         markerId: const MarkerId("selected"),

// //         position: selectedLocation,

// //         draggable: true,

// //         onDragEnd: (value) {
// //           setState(() {
// //             selectedLocation = value;

// //             markers = {
// //               Marker(
// //                 markerId: const MarkerId("selected"),

// //                 position: selectedLocation,

// //                 draggable: true,

// //                 onDragEnd: (v) {
// //                   setState(() {
// //                     selectedLocation = v;
// //                   });
// //                 },
// //               ),
// //             };
// //           });
// //         },
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Select Location")),

// //       body: Stack(
// //         children: [
// //           // =====================================
// //           // GOOGLE MAP
// //           // =====================================
// //           GoogleMap(
// //             initialCameraPosition: CameraPosition(
// //               target: selectedLocation,
// //               zoom: 14,
// //             ),

// //             myLocationEnabled: true,

// //             myLocationButtonEnabled: true,

// //             zoomControlsEnabled: true,

// //             mapType: MapType.normal,

// //             markers: markers,

// //             onMapCreated: (controller) {
// //               mapController = controller;
// //             },

// //             // TAP ON MAP
// //             onTap: (LatLng latLng) {
// //               setState(() {
// //                 selectedLocation = latLng;

// //                 markers = {
// //                   Marker(
// //                     markerId: const MarkerId("selected"),

// //                     position: selectedLocation,

// //                     draggable: true,

// //                     onDragEnd: (value) {
// //                       setState(() {
// //                         selectedLocation = value;
// //                       });
// //                     },
// //                   ),
// //                 };
// //               });
// //             },
// //           ),

// //           // =====================================
// //           // SELECT BUTTON
// //           // =====================================
// //           Positioned(
// //             bottom: 20,
// //             left: 20,
// //             right: 20,

// //             child: SizedBox(
// //               height: 55,

// //               child: ElevatedButton.icon(
// //                 onPressed: () {
// //                   print("SELECTED => ${selectedLocation.latitude}");

// //                   print("SELECTED => ${selectedLocation.longitude}");

// //                   // 🔥 RETURN LOCATION
// //                   Navigator.pop(context, selectedLocation);
// //                 },

// //                 icon: const Icon(Icons.location_on),

// //                 label: const Text(
// //                   "Confirm Location",
// //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // import 'dart:convert';
// // // import 'package:charity/widget/mapController.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:geolocator/geolocator.dart';
// // // import 'package:get/get.dart';
// // // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // // import 'package:http/http.dart' as http;

// // // class ReusableMap extends StatelessWidget {
// // //   final bool allowPolygon;
// // //   final Function(LatLng)? onLocationSelected;
// // //   ReusableMap({super.key, this.allowPolygon = false, this.onLocationSelected});
// // //   final MapController c = Get.put(MapController(), permanent: false);
// // //   final TextEditingController searchController = TextEditingController();
// // //   final String googleApiKey = "AIzaSyCiYoKGFlfNDlYIy8lEnoiML75RypkFXJE";
// // //   Future<void> searchLocation(String query) async {
// // //     if (query.isEmpty) return;
// // //     final encodedQuery = Uri.encodeComponent(query);
// // //     final url =
// // //         "https://maps.googleapis.com/maps/api/geocode/json?address=$encodedQuery&key=$googleApiKey";
// // //     final response = await http.get(Uri.parse(url));
// // //     print(response.body);
// // //     if (response.statusCode == 200) {
// // //       final data = jsonDecode(response.body);
// // //       if (data["status"] == "OK") {
// // //         final location = data["results"][0]["geometry"]["location"];
// // //         double lat = location["lat"];
// // //         double lng = location["lng"];
// // //         LatLng target = LatLng(lat, lng);
// // //         c.setMarker(target);
// // //         c.mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
// // //       } else {
// // //         Get.snackbar("Error", data["status"].toString());
// // //       }
// // //     } else {
// // //       Get.snackbar("Error", "Server error");
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final args = Get.arguments;
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text("Select Location"),
// // //         bottom: PreferredSize(
// // //           preferredSize: const Size.fromHeight(60),
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(8.0),
// // //             child: TextField(
// // //               controller: searchController,
// // //               decoration: InputDecoration(
// // //                 hintText: "Search location...",
// // //                 filled: true,
// // //                 fillColor: Colors.white,
// // //                 suffixIcon: IconButton(
// // //                   icon: const Icon(Icons.search),
// // //                   onPressed: () {
// // //                     searchLocation(searchController.text);
// // //                   },
// // //                 ),
// // //                 border: OutlineInputBorder(
// // //                   borderRadius: BorderRadius.circular(10),
// // //                 ),
// // //               ),
// // //               onSubmitted: (value) {
// // //                 searchLocation(value);
// // //               },
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //       body: Obx(() {
// // //         if (c.currentLocation.value == null) {
// // //           return const Center(child: CircularProgressIndicator());
// // //         }
// // //         return Column(
// // //           children: [
// // //             Text("Address: ${c.address.value}"),
// // //             Expanded(
// // //               child: GoogleMap(
// // //                 initialCameraPosition: CameraPosition(
// // //                   target: c.currentLocation.value!,
// // //                   zoom: 15,
// // //                 ),
// // //                 markers: c.markers.value,
// // //                 polygons: c.polygons.value,
// // //                 onMapCreated: (map) {
// // //                   c.mapController = map;
// // //                   if (args != null) {
// // //                     double lat = args["lat"];
// // //                     double lng = args["lng"];
// // //                     LatLng target = LatLng(lat, lng);
// // //                     c.setMarker(target);
// // //                     map.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
// // //                   }
// // //                 },
// // //                 onTap: (point) {
// // //                   if (allowPolygon) {
// // //                     c.addPolygonPoint(point);
// // //                   } else {
// // //                     c.setMarker(point);
// // //                   }
// // //                 },
// // //               ),
// // //             ),
// // //           ],
// // //         );
// // //       }),
// // //       floatingActionButton: FloatingActionButton(
// // //         child: const Icon(Icons.check),
// // //         onPressed: () async {
// // //           final args = Get.arguments;

// // //           if (args != null) {
// // //             double targetLat = args["lat"];
// // //             double targetLng = args["lng"];

// // //             // 🔥 CURRENT LOCATION
// // //             Position pos = await Geolocator.getCurrentPosition();

// // //             double distance = Geolocator.distanceBetween(
// // //               pos.latitude,
// // //               pos.longitude,
// // //               targetLat,
// // //               targetLng,
// // //             );

// // //             print("Distance: $distance");

// // //             if (distance > 100) {
// // //               Get.snackbar("Error", "You are not at location");
// // //               return;
// // //             }
// // //           }

// // //           Navigator.pop(context, true);
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }

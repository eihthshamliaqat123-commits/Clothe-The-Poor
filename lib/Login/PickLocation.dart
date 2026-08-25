// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _currentLocation;
//   Set<Marker> _markers = {};
//   String locationName = "";

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> getAddressFromLatLng(double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         locationName =
//             "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//         setState(() {});
//       }
//     } catch (e) {
//       print("Error in reverse geocoding: $e");
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please enable location services")),
//         );
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       _currentLocation = LatLng(position.latitude, position.longitude);

//       setState(() {
//         _markers.add(
//           Marker(
//             markerId: const MarkerId("current_location"),
//             position: _currentLocation!,
//             infoWindow: const InfoWindow(title: "You are here"),
//           ),
//         );
//       });

//       getAddressFromLatLng(position.latitude, position.longitude);
//     } catch (e) {
//       print("Error getting current location: $e");
//     }
//   }

//   void _onMapTapped(LatLng tappedPoint) {
//     setState(() {
//       _markers.removeWhere(
//         (marker) => marker.markerId.value == "selected_location",
//       );

//       _markers.add(
//         Marker(
//           markerId: const MarkerId("selected_location"),
//           position: tappedPoint,
//           infoWindow: const InfoWindow(title: "Selected Location"),
//         ),
//       );
//     });
//     getAddressFromLatLng(tappedPoint.latitude, tappedPoint.longitude);
//   }

//   void _onConfirmLocation() {
//     if (_markers.any(
//       (marker) => marker.markerId.value == "selected_location",
//     )) {
//       final marker = _markers.firstWhere(
//         (m) => m.markerId.value == "selected_location",
//       );
//       Navigator.pop(context, marker.position);
//     } else if (_currentLocation != null) {
//       Navigator.pop(context, _currentLocation);
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please select a location")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Location"),
//         backgroundColor: Colors.green,
//       ),
//       body: _currentLocation == null
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "Selected Location: $locationName",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   child: GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: _currentLocation!,
//                       zoom: 15,
//                     ),
//                     myLocationEnabled: true,
//                     myLocationButtonEnabled: true,
//                     markers: _markers,
//                     onTap: _onMapTapped,
//                     onMapCreated: (controller) {
//                       _mapController = controller;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.check),
//         onPressed: _onConfirmLocation,
//         tooltip: "Confirm Location",
//       ),
//     );
//   }
// }

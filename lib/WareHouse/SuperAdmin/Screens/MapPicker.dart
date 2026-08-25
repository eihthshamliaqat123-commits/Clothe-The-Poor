// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapPickerScreen extends StatefulWidget {
//   final String city;
//   final String zone;

//   const MapPickerScreen({super.key, required this.city, required this.zone});

//   @override
//   State<MapPickerScreen> createState() => _MapPickerScreenState();
// }

// class _MapPickerScreenState extends State<MapPickerScreen> {
//   LatLng? selectedLocation;

//   // static const CameraPosition initialPosition = CameraPosition(
//   //   target: LatLng(24.8607, 67.0011),
//   //   zoom: 12,
//   // );

//   void _onTap(LatLng position) {
//     setState(() {
//       selectedLocation = position;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Pin Zone Location")),
//       body: Column(
//         children: [
//           /// Map
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: initialPosition,
//               onTap: _onTap,
//               markers: selectedLocation == null
//                   ? {}
//                   : {
//                       Marker(
//                         markerId: const MarkerId("zone"),
//                         position: selectedLocation!,
//                       ),
//                     },
//             ),
//           ),

//           /// Coordinates
//           Container(
//             padding: const EdgeInsets.all(15),
//             child: Column(
//               children: [
//                 Text(
//                   selectedLocation == null
//                       ? "Tap map to select location"
//                       : "Lat: ${selectedLocation!.latitude}\nLng: ${selectedLocation!.longitude}",
//                   textAlign: TextAlign.center,
//                 ),

//                 const SizedBox(height: 15),

//                 /// Create Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: selectedLocation == null
//                         ? null
//                         : () {
//                             /// Here API call karna hoga
//                             print("City: ${widget.city}");
//                             print("Zone: ${widget.zone}");
//                             print("Lat: ${selectedLocation!.latitude}");
//                             print("Lng: ${selectedLocation!.longitude}");

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text("Zone Created")),
//                             );

//                             Navigator.popUntil(context, (r) => r.isFirst);
//                           },
//                     child: const Text("Create Zone"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:charity/Rider/Controller/RiderController.dart';
import 'package:charity/widget/ReuseAblemap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonorRidesScreen extends StatelessWidget {
  DonorRidesScreen({super.key});

  final RiderController controller = Get.put(RiderController());

  String getStatusText(int status) {
    switch (status) {
      case 1:
        return "Assigned";

      case 2:
        return "Picked Up";

      case 3:
        return "Completed";

      default:
        return "Unknown";
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.orange;

      case 2:
        return Colors.blue;

      case 3:
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donor Rides")),

      body: Obx(() {
        if (controller.requests.isEmpty) {
          return const Center(child: Text("No Assigned Rides"));
        }

        return ListView.builder(
          itemCount: controller.requests.length,

          itemBuilder: (context, index) {
            var ride = controller.requests[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Donor: ${ride.donorName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text("Phone: ${ride.phoneNo}"),

                        Text("Schedule: ${ride.scheduledTime}"),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            // ======================
                            // START PICKUP
                            // ======================
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),

                              onPressed: ride.status == 1
                                  ? () async {
                                      print("OPENING PICKUP MAP");

                                      var result = await Get.to(
                                        () => ReusableMap(),

                                        arguments: {
                                          "lat": (ride.latitude as num)
                                              .toDouble(),
                                          "lng": (ride.longitude as num)
                                              .toDouble(),
                                        },
                                      );

                                      print("PICKUP MAP RESULT => $result");

                                      if (result == true) {
                                        Get.dialog(
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          barrierDismissible: false,
                                        );

                                        try {
                                          await controller.markPickedUp(
                                            ride.donorRequestId,
                                          );

                                          await controller
                                              .fetchAssignedRequests();

                                          Get.back();

                                          Get.snackbar(
                                            "Success",
                                            "Donation Picked Up Successfully",
                                          );
                                        } catch (e) {
                                          Get.back();

                                          Get.snackbar("Error", e.toString());
                                        }
                                      }
                                    }
                                  : null,

                              child: const Text(
                                "Start PickUp",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            // ======================
                            // DELIVER
                            // ======================
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),

                              onPressed: ride.status == 2
                                  ? () async {
                                      print("OPENING DELIVERY MAP");

                                      var result = await Get.to(
                                        () => ReusableMap(),

                                        arguments: {
                                          "lat": (ride.warehouseLat as num)
                                              .toDouble(),
                                          "lng": (ride.warehouseLng as num)
                                              .toDouble(),
                                        },
                                      );

                                      print("DELIVERY MAP RESULT => $result");

                                      if (result == true) {
                                        Get.dialog(
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          barrierDismissible: false,
                                        );

                                        try {
                                          await controller.markCompleted(
                                            ride.donorRequestId,
                                          );

                                          await controller
                                              .fetchAssignedRequests();

                                          Get.back();

                                          Get.snackbar(
                                            "Success",
                                            "Donation Delivered Successfully",
                                          );
                                        } catch (e) {
                                          Get.back();

                                          Get.snackbar("Error", e.toString());
                                        }
                                      }
                                    }
                                  : null,

                              child: const Text(
                                "Deliver",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // ======================
                    // STATUS BADGE
                    // ======================
                    Positioned(
                      top: 0,
                      right: 0,

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: getStatusColor(ride.status),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          getStatusText(ride.status),

                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
// import 'package:charity/Rider/Controller/RiderController.dart';

// import 'package:charity/widget/ReuseAblemap.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DonorRidesScreen extends StatelessWidget {
//   DonorRidesScreen({super.key});

//   final RiderController controller = Get.put(RiderController());

//   String getStatusText(int status) {
//     switch (status) {
//       case 1:
//         return "Assigned";

//       case 2:
//         return "Picked Up";

//       case 3:
//         return "Completed";

//       default:
//         return "Unknown";
//     }
//   }

//   Color getStatusColor(int status) {
//     switch (status) {
//       case 1:
//         return Colors.orange;

//       case 2:
//         return Colors.blue;

//       case 3:
//         return Colors.green;

//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Donor Rides")),

//       body: Expanded(
//         child: Obx(() {
//           if (controller.requests.isEmpty) {
//             return const Center(child: Text("No Assigned Rides"));
//           }

//           return ListView.builder(
//             itemCount: controller.requests.length,

//             itemBuilder: (context, index) {
//               var ride = controller.requests[index];

//               return Card(
//                 margin: const EdgeInsets.all(10),

//                 child: Padding(
//                   padding: const EdgeInsets.all(12),

//                   child: Stack(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,

//                         children: [
//                           Text(
//                             "Donor: ${ride.donorName}",

//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),

//                           Text("Phone: ${ride.phoneNo}"),

//                           Text("Schedule: ${ride.scheduledTime}"),

//                           const SizedBox(height: 10),

//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                             children: [
//                               /// START PICKUP
//                               ElevatedButton(
//                                 onPressed: ride.status == 1
//                                     ? () async {
//                                         var result = await Get.to(
//                                           () => ReusableMap(),

//                                           arguments: {
//                                             "lat": ride.latitude,
//                                             "lng": ride.longitude,
//                                           },
//                                         );

//                                         if (result == true) {
//                                           controller.markPickedUp(
//                                             ride.donorRequestId,
//                                           );
//                                         }
//                                       }
//                                     : null,

//                                 child: const Text("Start PickUp"),
//                               ),

//                               /// DELIVER
//                               ElevatedButton(
//                                 onPressed: ride.status == 2
//                                     ? () async {
//                                         var result = await Get.to(
//                                           () => ReusableMap(),

//                                           arguments: {
//                                             "lat": ride.warehouseLat,

//                                             "lng": ride.warehouseLng,
//                                           },
//                                         );

//                                         if (result == true) {
//                                           controller.markCompleted(
//                                             ride.donorRequestId,
//                                           );
//                                         }
//                                       }
//                                     : null,

//                                 child: const Text("Deliver"),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),

//                       /// STATUS BADGE
//                       Positioned(
//                         top: 0,
//                         right: 0,

//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 5,
//                           ),

//                           decoration: BoxDecoration(
//                             color: getStatusColor(ride.status),

//                             borderRadius: BorderRadius.circular(20),
//                           ),

//                           child: Text(
//                             getStatusText(ride.status),

//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:charity/Rider/Controller/RiderHDonee.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RiderDoneeDeliveriesScreen extends StatefulWidget {
  const RiderDoneeDeliveriesScreen({super.key});

  @override
  State<RiderDoneeDeliveriesScreen> createState() =>
      _RiderDoneeDeliveriesScreenState();
}

class _RiderDoneeDeliveriesScreenState
    extends State<RiderDoneeDeliveriesScreen> {
  final controller = Get.put(RiderDoneeController());

  @override
  void initState() {
    super.initState();

    controller.fetchDoneeDeliveries();
  }

  Future<void> openMap(double lat, double lng) async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open map");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donee Deliveries")),

      body: Obx(() {
        if (controller.deliveries.isEmpty) {
          return const Center(child: Text("No Deliveries"));
        }

        return ListView.builder(
          itemCount: controller.deliveries.length,

          itemBuilder: (_, index) {
            var d = controller.deliveries[index];

            return Card(
              margin: const EdgeInsets.all(12),

              child: Padding(
                padding: const EdgeInsets.all(14),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Request #${d.doneeRequestId}",

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Request #${d.doneeRequestId}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text("Donee: ${d.doneeName}"),

                    Text("Phone: ${d.phone}"),

                    Text("Date: ${d.requestDate}"),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              openMap(d.latitude, d.longitude);
                            },
                            child: const Text("Open Map"),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.deliverDoneeRequest(d.rideLogId);
                            },

                            child: const Text("Delivered"),
                          ),
                        ),
                      ],
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

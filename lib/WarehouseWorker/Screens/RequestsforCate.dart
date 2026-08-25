import 'package:charity/WarehouseWorker/Controller/WarehouseWorkerController.dart';
import 'package:charity/WarehouseWorker/Screens/Categorize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkerInventoryScreen extends StatelessWidget {
  final controller = Get.put(WarehouseWorkerController());

  WorkerInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getWashedDonations();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Warehouse Worker",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F8F7A),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        /// 🔥 FIX
        if (controller.washedDonations.isEmpty) {
          return const Center(child: Text("No Assigned Donations"));
        }

        return ListView.builder(
          itemCount: controller.washedDonations.length,

          itemBuilder: (context, index) {
            var item = controller.washedDonations[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Donor Request # ${item["DonorRequestId"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Text("Comments : ${item["Comments"]}"),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        Get.to(
                          () => CategorizeDonationScreen(
                            donorRequestId: item["DonorRequestId"],
                          ),
                        );
                      },

                      child: const Text("Start Categorizing"),
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

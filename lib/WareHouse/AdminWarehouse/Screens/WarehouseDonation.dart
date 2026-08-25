import 'package:charity/WareHouse/AdminWarehouse/Controller/WarehouseAdminCont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehouseDonation extends StatelessWidget {
  final controller = Get.put(AdminWarehouseController());

  WarehouseDonation({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchWarehouseDonations(); // 🔥 load on open

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pending Donations",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0F8F7A),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.donations.isEmpty) {
          return const Center(child: Text("No pending donations"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.donations.length,
          itemBuilder: (context, index) {
            final item = controller.donations[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text("Comments: ${item.comments}"),

                    const SizedBox(height: 6),

                    Text(
                      "Lat: ${item.latitude.toStringAsFixed(4)}, "
                      "Lng: ${item.longitude.toStringAsFixed(4)}",
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.acceptPendingDonations(item.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Accept"),
                        ),

                        const SizedBox(width: 8),

                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text("Reject"),
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

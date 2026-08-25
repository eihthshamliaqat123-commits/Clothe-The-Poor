import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charity/WareHouse/AdminWarehouse/Controller/WarehouseAdminCont.dart';

class DeliveredDonationsScreen extends StatelessWidget {
  final controller = Get.put(AdminWarehouseController(), permanent: true);

  DeliveredDonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivered Donations"),
        backgroundColor: Color(0xFF0F8F7A),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.deliveredList.isEmpty) {
          return const Center(child: Text("No Delivered Donations"));
        }

        return ListView.builder(
          itemCount: controller.deliveredList.length,
          itemBuilder: (context, index) {
            var item = controller.deliveredList[index];

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(item.donorName ?? "No Name"),
                subtitle: Text(item.comments ?? "No Comments"),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        controller.acceptRequest(item.donorRequestId);
                      },
                      child: const Text("Accept"),
                    ),

                    const SizedBox(width: 8),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        controller.moveToWaiting(item);
                      },
                      child: const Text("Wait"),
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

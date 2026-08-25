import 'package:charity/WarehouseWorker/Controller/WarehouseWorkerController.dart';
import 'package:charity/WarehouseWorker/Model/WorkerDoneeRequests.dart';
import 'package:charity/WarehouseWorker/Screens/InventorySearch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackagePreparationScreen extends StatelessWidget {
  final WorkerDoneeRequestModel request;

  PackagePreparationScreen({super.key, required this.request});

  final controller = Get.find<WarehouseWorkerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prepare Package")),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: request.items.length,
              itemBuilder: (_, index) {
                var item = request.items[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    title: Text(item.itemType),

                    subtitle: Text("${item.category}\nQty : ${item.quantity}"),

                    trailing: ElevatedButton(
                      child: const Text("Search"),

                      onPressed: () {
                        Get.to(() => InventorySearchScreen(requestItem: item));
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(10),

              child: Text(
                "Selected Inventory : ${controller.selectedItems.length}",

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            );
          }),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              child: const Text("Create Package"),

              onPressed: () {
                print(controller.selectedItems.length);

                print(
                  controller.selectedItems.map((e) => e.inventoryId).toList(),
                );
                controller.createPackage(
                  request.doneeRequestId,

                  controller.selectedItems,
                );
              },
            ),
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

import 'package:charity/WarehouseWorker/Controller/WarehouseWorkerController.dart';
import 'package:charity/WarehouseWorker/Model/WorkerDoneeItemModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventorySearchScreen extends StatefulWidget {
  final WorkerRequestItemModel requestItem;

  const InventorySearchScreen({super.key, required this.requestItem});

  @override
  State<InventorySearchScreen> createState() => _InventorySearchScreenState();
}

class _InventorySearchScreenState extends State<InventorySearchScreen> {
  final controller = Get.find<WarehouseWorkerController>();

  @override
  void initState() {
    super.initState();

    controller.searchInventory(widget.requestItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory")),

      body: Obx(() {
        if (controller.searchResult.isEmpty) {
          return const Center(child: Text("No Inventory"));
        }

        return ListView.builder(
          itemCount: controller.searchResult.length,

          itemBuilder: (_, index) {
            var item = controller.searchResult[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: ListTile(
                title: Text(item.itemType),

                subtitle: Text("${item.category}\n${item.qrCode}"),

                trailing: ElevatedButton(
                  child: const Text("Select"),

                  onPressed: () {
                    bool already = controller.selectedItems.any(
                      (e) => e.inventoryId == item.inventoryId,
                    );

                    if (!already) {
                      controller.selectedItems.add(item);
                    }

                    Get.back();
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

import 'package:charity/WareHouse/AdminWarehouse/Controller/WarehouseTransferC.dart';
import 'package:charity/WareHouse/AdminWarehouse/Models/WarehouseTransfer.dart';
import 'package:charity/WareHouse/AdminWarehouse/Models/WarehouseTransferREquest.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferInventoryScreen extends StatefulWidget {
  final TransferRequestModel request;

  const TransferInventoryScreen({super.key, required this.request});

  @override
  State<TransferInventoryScreen> createState() =>
      _TransferInventoryScreenState();
}

class _TransferInventoryScreenState extends State<TransferInventoryScreen> {
  final controller = Get.find<WarehouseTransferController>();

  List<int> selectedInventory = [];

  @override
  void initState() {
    super.initState();

    controller.getMatchingInventory(widget.request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transfer Inventory")),

      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.inventory.length,

          itemBuilder: (_, index) {
            final item = controller.inventory[index];

            return CheckboxListTile(
              value: selectedInventory.contains(item.inventoryId),

              onChanged: (value) {
                if (value == true) {
                  selectedInventory.add(item.inventoryId);
                } else {
                  selectedInventory.remove(item.inventoryId);
                }

                setState(() {});
              },

              title: Text(item.itemType),

              subtitle: Text("${item.category} | ${item.size}"),

              secondary: Text(item.qrCode),
            );
          },
        );
      }),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),

        child: ElevatedButton(
          onPressed: () {
            controller.transferItems(
              WarehouseTransferModel(
                warehouseRequestId: widget.request.warehouseRequestId,

                inventoryIds: selectedInventory,
              ),
            );
          },

          child: const Text("Transfer Selected"),
        ),
      ),
    );
  }
}

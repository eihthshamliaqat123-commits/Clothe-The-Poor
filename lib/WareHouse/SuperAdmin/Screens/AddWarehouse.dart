import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charity/WareHouse/SuperAdmin/Controller/WarehouseController.dart';

class AddWarehouseScreen extends StatelessWidget {
  final WarehouseController controller = Get.put(WarehouseController());
  final TextEditingController warehouseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Warehouse")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: warehouseController,
              decoration: InputDecoration(
                labelText: "Warehouse Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Dynamic Zones Dropdown
            Obx(() {
              if (controller.zones.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return DropdownButton<int>(
                value: controller.selectedZoneId.value == 0
                    ? null
                    : controller.selectedZoneId.value,
                hint: Text("Select Zone"),
                isExpanded: true,
                items: controller.zones.map((zone) {
                  return DropdownMenuItem<int>(
                    value: zone.zoneId,
                    child: Text(zone.zoneName),
                  );
                }).toList(),
                onChanged: (val) {
                  controller.selectedZoneId.value = val ?? 0;
                },
              );
            }),

            SizedBox(height: 20),

            Obx(
              () => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.createWarehouse(warehouseController.text);
                      },
                      child: Text("Save Warehouse"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

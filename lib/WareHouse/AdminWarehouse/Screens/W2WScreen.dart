import 'package:charity/WareHouse/AdminWarehouse/Controller/WarehouseTransferC.dart';
import 'package:charity/WareHouse/AdminWarehouse/Screens/TransferInventory.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarehouseTransferScreen extends StatefulWidget {
  @override
  State<WarehouseTransferScreen> createState() =>
      _WarehouseTransferScreenState();
}

class _WarehouseTransferScreenState extends State<WarehouseTransferScreen> {
  final controller = Get.put(WarehouseTransferController());

  int warehouseId = 0;

  Future<void> loadWarehouse() async {
    final prefs = await SharedPreferences.getInstance();

    warehouseId = prefs.getInt("userId") ?? 0;

    controller.getWarehouseRequests(warehouseId);
  }

  @override
  void initState() {
    super.initState();

    loadWarehouse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Warehouse Requests")),

      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.requests.length,

          itemBuilder: (_, index) {
            final request = controller.requests[index];

            return Card(
              margin: const EdgeInsets.all(12),

              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      request.requestingWarehouse,

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...request.items.map((item) {
                      return ListTile(
                        title: Text(item.itemType),

                        subtitle: Text("${item.category} | ${item.size}"),

                        trailing: Text("Qty : ${item.quantity}"),
                      );
                    }),

                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => TransferInventoryScreen(request: request));
                      },

                      child: const Text("Transfer"),
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

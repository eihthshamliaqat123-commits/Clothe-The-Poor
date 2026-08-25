import 'package:charity/WareHouse/AdminWarehouse/Controller/WarehouseAdminCont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonorDonationsScreen extends StatelessWidget {
  DonorDonationsScreen({super.key});

  final controller = Get.put(AdminWarehouseController());

  @override
  Widget build(BuildContext context) {
    controller.fetchWarehouseDonations();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Warehouse Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F8F7A),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              /// =======================
              /// 🔵 PENDING REQUESTS
              /// =======================
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Pending Requests",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.pending.length,
                itemBuilder: (context, index) {
                  var item = controller.pending[index];

                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.comments ?? ""),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// ACCEPT
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              controller.acceptRequest(item.id);
                            },
                          ),

                          /// REJECT
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              //controller.rejectRequest(item.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              /// =======================
              /// 📦 DELIVERED (STATUS 3)
              /// =======================
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Delivered (Waiting Receive)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.delivered.length,
                itemBuilder: (context, index) {
                  var item = controller.delivered[index];

                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: const Text("Delivered by Rider"),

                      trailing: ElevatedButton(
                        onPressed: () {
                          //controller.receiveDonation(item.id);
                        },
                        child: const Text("Receive"),
                      ),
                    ),
                  );
                },
              ),

              /// =======================
              /// 🏢 RECEIVED (STATUS 4)
              /// =======================
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Received at Warehouse",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.received.length,
                itemBuilder: (context, index) {
                  var item = controller.received[index];

                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.comments ?? ""),

                      trailing: ElevatedButton(
                        onPressed: () {
                          Get.toNamed("/categorize", arguments: item);
                        },
                        child: const Text("Categorize"),
                      ),
                    ),
                  );
                },
              ),

              /// =======================
              /// 📚 INVENTORY DONE
              /// =======================
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Inventory Completed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.inventoryDone.length,
                itemBuilder: (context, index) {
                  var item = controller.inventoryDone[index];

                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: const Text("Added to Inventory"),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

import 'package:charity/WarehouseWorker/Controller/WarehouseWorkerController.dart';
import 'package:charity/WarehouseWorker/Screens/PackagePreparationScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkerDoneeRequestsScreen extends StatefulWidget {
  const WorkerDoneeRequestsScreen({super.key});

  @override
  State<WorkerDoneeRequestsScreen> createState() =>
      _WorkerDoneeRequestsScreenState();
}

class _WorkerDoneeRequestsScreenState extends State<WorkerDoneeRequestsScreen> {
  final controller = Get.put(WarehouseWorkerController());

  final Map<int, String> sizeNameMap = {
    1: "Double Extra Large",
    2: "Extra Large",
    3: "Large",
    4: "Medium",
    5: "Small",
    6: "11-12 Years",
    7: "8-10 Years",
    8: "5-7 Years",
    9: "2-4 Years",
    10: "Infants Upto (1 Year)",
  };

  @override
  void initState() {
    super.initState();
    controller.getWorkerDoneeRequests();
    Future.delayed(const Duration(seconds: 2), () {
      print("Total Requests = ${controller.workerRequests.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),

      appBar: AppBar(
        backgroundColor: const Color(0xff0F8F7A),
        centerTitle: true,
        title: const Text(
          "Prepare Dispatch",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(() {
        if (controller.workerRequests.isEmpty) {
          return const Center(
            child: Text("No Requests Found", style: TextStyle(fontSize: 16)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: controller.workerRequests.length,
          itemBuilder: (context, index) {
            final req = controller.workerRequests[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xff0F8F7A),
                          child: Icon(Icons.inventory_2, color: Colors.white),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "Request #${req.doneeRequestId}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              if (req.recipentId == 1)
                                const Text(
                                  "Self Request",
                                  style: TextStyle(color: Colors.grey),
                                ),

                              if (req.recipentId == 2)
                                Text(
                                  "NGO : ${req.ngoName}",
                                  style: const TextStyle(color: Colors.grey),
                                ),

                              if (req.recipentId == 3)
                                Text(
                                  "Behalf : ${req.behalfName}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    const Divider(),
                    const SizedBox(height: 12),

                    const Text(
                      "Requested Items",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Column(
                      children: List.generate(req.items.length, (i) {
                        final item = req.items[i];

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              itemRow("Item Type", item.itemType),

                              itemRow("Category", item.category),

                              itemRow("Season", item.season),

                              itemRow("Quantity", item.quantity.toString()),

                              itemRow(
                                "Size",
                                sizeNameMap[item.sizeId] ?? "Unknown",
                              ),
                            ],
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 52,

                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Get.to(() => PackagePreparationScreen(request: req));

                          controller.getWorkerDoneeRequests();
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0F8F7A),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        icon: const Icon(
                          Icons.local_shipping,
                          color: Colors.white,
                        ),

                        label: const Text(
                          "Prepare Package",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget itemRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$title :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff0F8F7A),
              ),
            ),
          ),

          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}

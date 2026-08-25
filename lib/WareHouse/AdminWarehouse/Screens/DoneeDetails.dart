import 'package:charity/WareHouse/AdminWarehouse/Controller/DoneeHandler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehouseDoneeRequestsScreen extends StatefulWidget {
  const WarehouseDoneeRequestsScreen({super.key});

  @override
  State<WarehouseDoneeRequestsScreen> createState() =>
      _WarehouseDoneeRequestsScreenState();
}

class _WarehouseDoneeRequestsScreenState
    extends State<WarehouseDoneeRequestsScreen> {
  final controller = Get.put(WarehouseDoneeController());

  @override
  void initState() {
    super.initState();

    controller.getDoneeRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donee Requests")),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.requests.isEmpty) {
          return const Center(child: Text("No Requests"));
        }

        return ListView.builder(
          itemCount: controller.requests.length,

          itemBuilder: (_, index) {
            var req = controller.requests[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Request # ${req.doneeRequestId}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (req.ngoName.isNotEmpty) Text("NGO : ${req.ngoName}"),

                    if (req.behalfName.isNotEmpty)
                      Text("Behalf : ${req.behalfName}"),

                    const SizedBox(height: 10),

                    // const Text(
                    //   "Requested Items",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),

                    // const SizedBox(height: 10),

                    // ...req.items.map((item) {
                    //   return Container(
                    //     margin: const EdgeInsets.only(bottom: 10),

                    //     padding: const EdgeInsets.all(10),

                    //     decoration: BoxDecoration(
                    //       border: Border.all(),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),

                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,

                    //       children: [
                    //         Text(
                    //           item.itemType,
                    //           style: const TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),

                    //         Text("Category : ${item.category}"),

                    //         Text("Season : ${item.season}"),

                    //         Text("Quantity : ${item.quantity}"),

                    //         Text("SizeId : ${item.sizeId}"),
                    //       ],
                    //     ),
                    //   );
                    // }).toList(),
                    const SizedBox(height: 15),
                    if (req.status == 1)
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () {
                            controller.acceptRequest(req.doneeRequestId);
                          },

                          child: const Text("Accept & Assign Worker"),
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
}

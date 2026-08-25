import 'package:charity/WareHouse/SuperAdmin/Controller/DoneeRequests.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ManageDoneeRequests extends StatefulWidget {
  const ManageDoneeRequests({super.key});

  @override
  State<ManageDoneeRequests> createState() => _ManageDoneeRequestsState();
}

class _ManageDoneeRequestsState extends State<ManageDoneeRequests> {
  final controller = Get.put(Doneerequests());

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

        return ListView.builder(
          itemCount: controller.doneeRequests.length,

          itemBuilder: (_, index) {
            var item = controller.doneeRequests[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.ngoName.isNotEmpty
                          ? item.ngoName
                          : item.behalfName.isNotEmpty
                          ? item.behalfName
                          : "Self Request",

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text("Warehouse: ${item.warehouseName}"),

                    Text("Status: ${item.status}"),

                    Text("Date: ${item.requestDate}"),

                    const SizedBox(height: 15),

                    if (item.status == 1)
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () {
                            controller.acceptDoneeRequest(item.doneeRequestId);
                          },

                          child: const Text("Assign Warehouse"),
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

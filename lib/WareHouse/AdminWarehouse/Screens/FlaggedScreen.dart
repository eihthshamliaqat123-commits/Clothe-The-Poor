import 'package:charity/WareHouse/AdminWarehouse/Controller/FlaggedDonorCont.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class FlaggedDonorScreen extends StatelessWidget {
  FlaggedDonorScreen({super.key});

  final controller = Get.put(FlaggedDonorController());

  @override
  Widget build(BuildContext context) {
    controller.fetchFlaggedDonors();

    return Scaffold(
      appBar: AppBar(title: const Text("Blocked Donors")),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.donors.isEmpty) {
          return const Center(child: Text("No Blocked Donors"));
        }

        return ListView.builder(
          itemCount: controller.donors.length,

          itemBuilder: (_, index) {
            var d = controller.donors[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: ListTile(
                title: Text(d.name),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text("Wearable: ${d.wearableCount}"),

                    Text("Non Wearable: ${d.nonWearableCount}"),

                    Text(d.blockedReason),
                  ],
                ),

                trailing: d.isBlocked
                    ? const Icon(Icons.block, color: Colors.red)
                    : null,
              ),
            );
          },
        );
      }),
    );
  }
}

import 'package:charity/WarehouseWorker/Controller/WashingController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';

class MarkWashedScreen extends StatefulWidget {
  const MarkWashedScreen({super.key});

  @override
  State<MarkWashedScreen> createState() => _MarkWashedScreenState();
}

class _MarkWashedScreenState extends State<MarkWashedScreen> {
  final controller = Get.put(WashingOfficerController());
  @override
  void initState() {
    super.initState();

    controller.getDeliveredDonations();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F8F7A),
        title: const Text(
          'Mark Washed',
          style: TextStyle(color: Colors.white),
        ),

        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.donations.length,
          itemBuilder: (_, index) {
            var item = controller.donations[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: Padding(
                padding: const EdgeInsets.all(10),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text("Request # ${item["DonorRequestId"]}"),

                    Text(item["Comments"] ?? ""),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () {
                          controller.markWashed(item["DonorRequestId"]);
                        },

                        child: const Text("Mark Washed"),
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

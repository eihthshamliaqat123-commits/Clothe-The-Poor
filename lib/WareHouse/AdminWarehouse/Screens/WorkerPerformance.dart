import 'package:charity/WareHouse/AdminWarehouse/Controller/ViewRating.dart';
import 'package:charity/WareHouse/AdminWarehouse/Models/BonusModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class WorkersPerformanceScreen extends StatefulWidget {
  const WorkersPerformanceScreen({super.key});

  @override
  State<WorkersPerformanceScreen> createState() =>
      _WorkersPerformanceScreenState();
}

class _WorkersPerformanceScreenState extends State<WorkersPerformanceScreen> {
  final controller = Get.put(WorkersRatingController());

  @override
  void initState() {
    super.initState();

    // API call
    controller.getWorkersPerformance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workers Performance")),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.performanceList.length,

          itemBuilder: (_, index) {
            var item = controller.performanceList[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: Card(
                elevation: 4,

                margin: const EdgeInsets.all(10),

                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          CircleAvatar(child: Text("${index + 1}")),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  item["WorkerName"],

                                  style: const TextStyle(
                                    fontSize: 18,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(item["Role"]),
                              ],
                            ),
                          ),

                          // Icon(Icons.star, color: Colors.amber),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Text("Average Rating : ${item["AverageRating"]}"),

                      Text("Total Ratings : ${item["TotalRatings"]}"),

                      Text("Salary : Rs ${item["Salary"]}"),

                      Text("Current Bonus : Rs ${item["Bonus"]}"),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        onPressed: () {
                          showBonusDialog(item);
                        },

                        child: const Text("Assign Bonus"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void showBonusDialog(dynamic worker) {
    double percentage = 5;

    showDialog(
      context: context,

      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(worker["WorkerName"]),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  DropdownButton<double>(
                    value: percentage,

                    items: [5, 10, 15, 20, 25]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.toDouble(),

                            child: Text("$e %"),
                          ),
                        )
                        .toList(),

                    onChanged: (v) {
                      setState(() {
                        percentage = v!;
                      });
                    },
                  ),
                ],
              ),

              actions: [
                ElevatedButton(
                  onPressed: () {
                    controller.updateBonus(
                      BonusModel(
                        userId: worker["WorkerId"],

                        bonusPercentage: percentage,
                      ),
                    );

                    Navigator.pop(context);
                  },

                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

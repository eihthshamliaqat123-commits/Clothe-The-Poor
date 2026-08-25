import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/WarehouseAdminCont.dart';

class TopWorstWorkersScreen extends StatefulWidget {
  const TopWorstWorkersScreen({super.key});

  @override
  State<TopWorstWorkersScreen> createState() => _TopWorstWorkersScreenState();
}

class _TopWorstWorkersScreenState extends State<TopWorstWorkersScreen> {
  final controller = Get.put(AdminWarehouseController());

  @override
  void initState() {
    super.initState();

    controller.getTopWorstWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workers Ranking")),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              //---------------------------------
              const Padding(
                padding: EdgeInsets.all(10),

                child: Text(
                  "🏆 Top 5 Workers",

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: controller.topWorkers.length,

                itemBuilder: (_, index) {
                  var worker = controller.topWorkers[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.workspace_premium,

                        color: Colors.green,
                      ),

                      title: Text(worker.workerName),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(worker.role),

                          Text("⭐ ${worker.averageRating}"),

                          Text("Ratings : ${worker.totalRatings}"),
                        ],
                      ),
                    ),
                  );
                },
              ),

              //---------------------------------
              const SizedBox(height: 25),

              const Padding(
                padding: EdgeInsets.all(10),

                child: Text(
                  "⚠ Worst 5 Workers",

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: controller.worstWorkers.length,

                itemBuilder: (_, index) {
                  var worker = controller.worstWorkers[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.warning, color: Colors.red),

                      title: Text(worker.workerName),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(worker.role),

                          Text("⭐ ${worker.averageRating}"),

                          Text("Ratings : ${worker.totalRatings}"),
                        ],
                      ),
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

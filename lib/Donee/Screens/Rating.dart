import 'package:charity/Donee/Controller/DoneeRequest.dart';
import 'package:charity/Donee/Model/SortingRating.dart';
import 'package:charity/Donee/Model/SubmitRatingModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageDetailScreen extends StatelessWidget {
  const PackageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoneeController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0F8F7A),
        title: const Text(
          "Package Details",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Obx(() {
        if (controller.selectedPackage.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final package = controller.selectedPackage.value!;

        //----------------------------------------------------
        // Group Sorting Workers
        //----------------------------------------------------

        Map<int, List<dynamic>> grouped = {};

        for (var item in package.items) {
          grouped.putIfAbsent(item.sortingWorkerId, () => []);

          grouped[item.sortingWorkerId]!.add(item);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(15),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //------------------------------------------
              // PACKAGE INFO
              //------------------------------------------
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Package #${package.packageId}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text("QR : ${package.qrCode}"),

                      Text("Items : ${package.items.length}"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //------------------------------------------
              // PACKAGING WORKER
              //------------------------------------------
              Card(
                elevation: 4,

                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Packaging Worker",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(package.packagingWorkerName),

                      const SizedBox(height: 15),

                      Row(
                        children: List.generate(5, (index) {
                          return Obx(() {
                            return IconButton(
                              onPressed: () {
                                controller.packagingRating.value = index + 1.0;
                              },

                              icon: Icon(
                                index < controller.packagingRating.value
                                    ? Icons.star
                                    : Icons.star_border,

                                color: Colors.amber,

                                size: 32,
                              ),
                            );
                          });
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //------------------------------------------
              // SORTING WORKERS
              //------------------------------------------
              ...grouped.entries.map((worker) {
                var workerItems = worker.value;

                String workerName = workerItems.first.sortingWorkerName;

                return Card(
                  margin: const EdgeInsets.only(bottom: 20),

                  child: Padding(
                    padding: const EdgeInsets.all(15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          workerName,

                          style: const TextStyle(
                            fontSize: 18,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Divider(),

                        ...workerItems.map((item) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),

                            padding: const EdgeInsets.all(10),

                            decoration: BoxDecoration(
                              border: Border.all(),

                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(item.itemType),

                                Text(item.category),

                                Text(item.color),

                                Text(item.season),

                                const SizedBox(height: 10),

                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return Row(
                                      children: List.generate(5, (i) {
                                        return IconButton(
                                          onPressed: () {
                                            setState(() {
                                              item.rating = i + 1.0;
                                            });
                                          },

                                          icon: Icon(
                                            i < item.rating
                                                ? Icons.star
                                                : Icons.star_border,

                                            color: Colors.amber,
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),

              //------------------------------------------
              // SUBMIT
              //------------------------------------------
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0F8F7A),

                    padding: const EdgeInsets.all(15),
                  ),

                  onPressed: () {
                    List<SortingRatingModel> ratings = [];

                    for (var item in package.items) {
                      ratings.add(
                        SortingRatingModel(
                          inventoryId: item.inventoryId,
                          requestedItemId: item.requestedItemId,
                          workerId: item.sortingWorkerId,
                          rating:
                              (controller.sortingRatings[item.inventoryId] ?? 1)
                                  .toInt(),
                        ),
                      );
                    }

                    SubmitRatingModel model = SubmitRatingModel(
                      packageId: package.packageId,
                      doneeRequestId: package.doneeRequestId,
                      packagingWorkerId: package.packagingWorkerId,
                      packagingRating: controller.packagingRating.value.toInt(),
                      sortingRatings: ratings,
                    );

                    controller.submitRating(model);
                  },

                  child: const Text(
                    "Submit Rating",

                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

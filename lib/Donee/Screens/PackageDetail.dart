import 'package:charity/Donee/Controller/DoneeRequest.dart';
import 'package:charity/Donee/Model/SortingRating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../Model/SubmitRatingModel.dart';

class PackageDetailScreen extends StatelessWidget {
  PackageDetailScreen({super.key});

  final controller = Get.find<DoneeController>();

  @override
  Widget build(BuildContext context) {
    final package = controller.selectedPackage.value;

    if (package == null) {
      return const Scaffold(body: Center(child: Text("Package Not Found")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Package Details"),
        backgroundColor: const Color(0xff0F8F7A),
      ),

      body: ListView(
        padding: const EdgeInsets.all(15),

        children: [
          Card(
            child: ListTile(
              title: Text("QR : ${package.qrCode}"),
              subtitle: Text("Package #${package.packageId}"),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Packaging Worker",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    package.packagingWorkerName,
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 15),

                  Obx(() {
                    return RatingBar.builder(
                      initialRating: controller.packagingRating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 35,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        controller.packagingRating.value = rating;
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Items",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 10),

          ...package.items.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 15),

              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.itemType,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text("Category : ${item.category}"),

                    Text("Season : ${item.season}"),

                    Text("Color : ${item.color}"),

                    const Divider(),

                    Text(
                      "Sorting Worker",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Text(item.sortingWorkerName),

                    Obx(() {
                      double value =
                          controller.sortingRatings[item.inventoryId] ?? 1;

                      return RatingBar.builder(
                        initialRating: value,
                        minRating: 1,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 30,
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          controller.sortingRatings[item.inventoryId] = rating;
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          const Text(
            "Donor Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    'DonorName : ${controller.donorName}',
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 15),

                  Obx(() {
                    return RatingBar.builder(
                      initialRating: controller.DonorRating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 35,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        controller.DonorRating.value = rating;
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0F8F7A),
            ),

            onPressed: () {
              List<SortingRatingModel> ratings = [];

              for (var item in package.items) {
                ratings.add(
                  SortingRatingModel(
                    inventoryId: item.inventoryId,
                    requestedItemId: item.requestedItemId,
                    workerId: item.sortingWorkerId,
                    rating: (controller.sortingRatings[item.inventoryId] ?? 1)
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
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

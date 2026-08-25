import 'package:charity/Donor/Controller/DonationController.dart';
import 'package:charity/baseUrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonationImagesScreen extends StatefulWidget {
  const DonationImagesScreen({super.key});

  @override
  State<DonationImagesScreen> createState() => _DonationImagesScreenState();
}

class _DonationImagesScreenState extends State<DonationImagesScreen> {
  final controller = Get.find<DonorRequestController>();

  late int donorRequestId;

  @override
  void initState() {
    super.initState();

    donorRequestId = Get.arguments["donorRequestId"];

    controller.getDonationImages(donorRequestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Donation Images")),

      body: Obx(() {
        if (controller.donationImages.isEmpty) {
          return const Center(child: Text("No Images Found"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),

          itemCount: controller.donationImages.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,

            crossAxisSpacing: 10,

            mainAxisSpacing: 10,

            childAspectRatio: .75,
          ),

          itemBuilder: (_, index) {
            final item = controller.donationImages[index];

            return Card(
              elevation: 5,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),

                        topRight: Radius.circular(12),
                      ),

                      child: Image.network(
                        BaseapiController.ImageURL + item.itemImage,

                        width: double.infinity,

                        fit: BoxFit.cover,

                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, size: 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          item.itemType,

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,

                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text("Category : ${item.category}"),

                        Text("Color : ${item.color}"),

                        Text("Season : ${item.season}"),

                        Text("Size : ${item.sizeId}"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

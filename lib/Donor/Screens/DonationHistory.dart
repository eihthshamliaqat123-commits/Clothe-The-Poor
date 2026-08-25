import 'package:charity/Donor/Controller/DonationController.dart';
import 'package:charity/Donor/Model/DonationImageModel.dart';
import 'package:charity/Donor/Screens/SupportMessageScreen.dart';
import 'package:charity/Donor/Screens/ViewImages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonorHistoryScreen extends StatefulWidget {
  const DonorHistoryScreen({super.key});

  @override
  State<DonorHistoryScreen> createState() => _DonorHistoryScreenState();
}

class _DonorHistoryScreenState extends State<DonorHistoryScreen> {
  final controller = Get.put(DonorRequestController());
  RxBool isLoading = false.obs;

  RxList<DonationImageModel> donationImages = <DonationImageModel>[].obs;

  @override
  void initState() {
    super.initState();

    controller.fetchDonationHistory();
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return "Waiting";

      case 1:
        return "Accepted";

      case 2:
        return "Rider Assigned";

      case 3:
        return "Picked Up";

      case 4:
        return "Delivered";

      case 5:
        return "Completed";

      default:
        return "Unknown";
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;

      case 1:
        return Colors.blue;

      case 2:
        return Colors.deepPurple;

      case 3:
        return Colors.teal;

      case 4:
        return Colors.green;

      case 5:
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.pending;

      case 1:
        return Icons.check_circle;

      case 2:
        return Icons.delivery_dining;

      case 3:
        return Icons.shopping_bag;

      case 4:
        return Icons.done_all;

      case 5:
        return Icons.done;

      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F8F7A),

        title: const Text(
          "Donation History",
          style: TextStyle(color: Colors.white),
        ),

        centerTitle: true,
      ),

      body: Obx(() {
        print(controller.history.length);

        if (controller.history.isEmpty) {
          return const Center(child: Text("No Donation History"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),

          itemCount: controller.history.length,

          itemBuilder: (context, index) {
            var h = controller.history[index];

            return Card(
              elevation: 4,

              margin: const EdgeInsets.only(bottom: 15),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,

                          backgroundColor: getStatusColor(h.status),

                          child: Icon(
                            getStatusIcon(h.status),
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "Donation #${h.donorRequestId}",

                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),

                                decoration: BoxDecoration(
                                  color: getStatusColor(h.status),

                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Text(
                                  getStatusText(h.status),

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Comments",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      h.comments ?? "No comments",
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 15),

                    if (h.status == 5)
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F8F7A),
                            foregroundColor: Colors.white,
                          ),

                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();

                            int userId = prefs.getInt("userId") ?? 0;

                            Get.to(
                              () => SupportMessagesScreen(
                                conversationId: h.conversationId,

                                userId: userId,

                                donorRequestId: h.donorRequestId ?? 0,
                              ),
                            );
                          },

                          icon: const Icon(Icons.chat),

                          label: const Text("Support Chat & Images"),
                        ),
                      ),
                    if (h.status == 5)
                      ElevatedButton(
                        onPressed: () {
                          Get.to(
                            () => const DonationImagesScreen(),

                            arguments: {"donorRequestId": h.donorRequestId},
                          );
                        },

                        child: const Text("View Images"),
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

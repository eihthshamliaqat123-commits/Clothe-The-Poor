import 'package:charity/Login/Login.dart';
import 'package:charity/Rider/Controller/RiderController.dart';
import 'package:charity/Rider/Screens/DoneeDeliveriesScreen.dart';
import 'package:charity/Rider/Screens/DonorRides.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RiderDashboard extends StatelessWidget {
  RiderDashboard({super.key});

  final RiderController controller = Get.put(RiderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rider Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F8F7A),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              Get.offAll(() => LoginScreen());
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// ONLINE OFFLINE BAR
            Obx(
              () => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: controller.isOnline.value ? Colors.green : Colors.red,

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      controller.isOnline.value
                          ? "You are Online"
                          : "You are Offline",

                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),

                      onPressed: controller.toggleActiveStatus,

                      child: Text(
                        controller.isOnline.value ? "Go Offline" : "Go Online",

                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// DONOR RIDES BUTTON
            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => DonorRidesScreen());
                },

                child: const Text(
                  "Donor Rides",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DONEE RIDES BUTTON
            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const RiderDoneeDeliveriesScreen());
                },

                child: const Text(
                  "Donee Rides",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

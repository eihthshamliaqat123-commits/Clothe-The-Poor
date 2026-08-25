import 'package:charity/Login/Login.dart';
import 'package:charity/WarehouseWorker/Screens/MarkWashed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // pure package ko import karna behtar hai

class WashingDashboard extends StatefulWidget {
  const WashingDashboard({super.key});

  @override
  State<WashingDashboard> createState() => _WashingDashboardState();
}

class _WashingDashboardState extends State<WashingDashboard> {
  @override
  // 1. Future aur async yahan se hata diya
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F8F7A),
        title: const Text(
          'Washing Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),

            onPressed: () {
              Get.offAll(() => LoginScreen());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              // 2. onPressed ko standard function banaya aur screen ke aage () lagaya
              onPressed: () {
                Get.to(
                  () => const MarkWashedScreen(),
                ); // GetX ka standard tareeqa
              },
              child: const Text("Wash Clothes"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:charity/Login/Login.dart';
import 'package:charity/WarehouseWorker/Screens/ScanQR.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class CategorizationDashboard extends StatelessWidget {
  const CategorizationDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F8F7A),
        title: const Text(
          'Categorization Dashboard',
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
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => const ScanQRScreen());
          },

          child: const Text("Start Sorting"),
        ),
      ),
    );
  }
}

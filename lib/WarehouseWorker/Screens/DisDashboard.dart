import 'package:charity/Login/Login.dart';
import 'package:charity/WarehouseWorker/Screens/ManageDoneeR.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class DispatchingDashboard extends StatelessWidget {
  const DispatchingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F8F7A),
        title: const Text(
          'Dispatching Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),

            onPressed: () {
              Get.offAll(() => LoginScreen());
            },
          ),
        ],
      ),

      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => WorkerDoneeRequestsScreen());
          },
          child: const Text("Start Dispatching"),
        ),
      ),
    );
  }
}

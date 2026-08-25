import 'package:charity/WarehouseWorker/Screens/Categorize.dart';
import 'package:charity/WarehouseWorker/Screens/RateItemScreen.dart';
import 'package:charity/WarehouseWorker/Screens/RequestsforCate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../Controller/WarehouseWorkerController.dart';

class ScanQRNewScreen extends StatefulWidget {
  const ScanQRNewScreen({super.key});

  @override
  State<ScanQRNewScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRNewScreen> {
  final controller = Get.put(WarehouseWorkerController());

  final MobileScannerController cameraController = MobileScannerController();

  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Worker QR"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),

            onPressed: () {
              Get.offAll(() => WorkerInventoryScreen());
            },
          ),
        ],
      ),

      body: MobileScanner(
        controller: cameraController,

        onDetect: (capture) async {
          if (scanned) {
            Get.to(Rateitemscreen());
          }

          final barcode = capture.barcodes.first;

          String? value = barcode.rawValue;

          if (value == null) return;

          scanned = true;

          int workerId = int.parse(value);

          bool valid = await controller.validateWorkerQR(workerId);

          if (valid) {
            Get.offAll(() => Rateitemscreen());
          } else {
            scanned = false;
          }
        },
      ),
    );
  }
}

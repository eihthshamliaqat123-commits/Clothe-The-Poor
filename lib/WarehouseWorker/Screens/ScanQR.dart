import 'package:charity/WarehouseWorker/Screens/Categorize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../Controller/WarehouseWorkerController.dart';
import 'RequestsforCate.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final controller = Get.put(WarehouseWorkerController());

  final MobileScannerController cameraController = MobileScannerController();

  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Worker QR")),

      body: MobileScanner(
        controller: cameraController,

        onDetect: (capture) async {
          if (scanned) return;

          final barcode = capture.barcodes.first;

          String? value = barcode.rawValue;

          if (value == null) return;

          scanned = true;

          int workerId = int.parse(value);

          bool valid = await controller.validateWorkerQR(workerId);

          if (valid) {
            //Get.offAll(() => CategorizeDonationScreen());
            Get.off(() => WorkerInventoryScreen());
          } else {
            scanned = false;
          }
        },
      ),
    );
  }
}

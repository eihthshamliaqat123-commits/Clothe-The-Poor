import 'package:charity/Donee/Controller/DoneeRequest.dart';
import 'package:charity/Donee/Screens/PackageDetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PackageQRScannerScreen extends StatefulWidget {
  const PackageQRScannerScreen({super.key});

  @override
  State<PackageQRScannerScreen> createState() => _PackageQRScannerScreenState();
}

class _PackageQRScannerScreenState extends State<PackageQRScannerScreen> {
  final controller = Get.find<DoneeController>();

  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0F8F7A),
        title: const Text(
          "Scan Package",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: MobileScanner(
        onDetect: (capture) async {
          if (scanned) return;

          scanned = true;

          final code = capture.barcodes.first.rawValue;

          print("SCANNED = $code");

          if (code == null || code.isEmpty) {
            scanned = false;
            return;
          }

          bool result = await controller.getPackageDetails(code);

          print("RESULT = $result");

          if (result) {
            Get.off(() => PackageDetailScreen());
          } else {
            scanned = false;
          }
        },
      ),
    );
  }
}

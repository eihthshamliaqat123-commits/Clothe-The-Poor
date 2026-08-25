import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class PackageQRScreen extends StatelessWidget {
  final String qrCode;

  PackageQRScreen({super.key, required this.qrCode});

  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> saveQR() async {
    await Permission.storage.request();

    Uint8List? image = await screenshotController.capture();

    if (image == null) {
      Get.snackbar("Error", "QR Capture Failed");
      return;
    }

    final result = await ImageGallerySaverPlus.saveImage(
      image,
      quality: 100,
      name: qrCode,
    );

    if (result != null) {
      Get.snackbar("Success", "QR Saved Successfully");
    } else {
      Get.snackbar("Error", "Save Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0F8F7A),
        title: const Text("Package QR", style: TextStyle(color: Colors.white)),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Screenshot(
              controller: screenshotController,

              child: Container(
                color: Colors.white,

                padding: const EdgeInsets.all(20),

                child: QrImageView(
                  data: qrCode,

                  version: QrVersions.auto,

                  size: 250,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              qrCode,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 40),

            ElevatedButton(onPressed: saveQR, child: const Text("Download QR")),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                Get.until((route) => route.isFirst);
              },

              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}

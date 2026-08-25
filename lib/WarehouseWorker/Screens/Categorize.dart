import 'dart:typed_data';

import 'package:charity/WarehouseWorker/Controller/WarehouseWorkerController.dart';
import 'package:charity/WarehouseWorker/Model/InventoryModel.dart';
import 'package:charity/WarehouseWorker/Screens/ScanQrNewScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class CategorizeDonationScreen extends StatefulWidget {
  final int donorRequestId;

  const CategorizeDonationScreen({super.key, required this.donorRequestId});

  @override
  State<CategorizeDonationScreen> createState() =>
      _CategorizeDonationScreenState();
}

class _CategorizeDonationScreenState extends State<CategorizeDonationScreen> {
  final controller = Get.put(WarehouseWorkerController());
  String? donorQRCode = "Donor-4032";
  final ScreenshotController screenshotController = ScreenshotController();

  final itemTypeController = TextEditingController();
  //  final quantityController = TextEditingController(text: "1");

  File? imageFile;
  final picker = ImagePicker();

  String selectedCategory = "Male";
  String selectedSeason = "Summer";
  String selectedCondition = "Good";
  String selectedSize = "Small";
  String selectedColor = "Red";

  final categories = ["Male", "Female"];

  final seasons = ["Summer", "Winter"];

  final conditions = [
    "Excellent",
    "Good",
    "Average",
    "Need Rapair",
    "Non Wearable",
  ];

  final sizes = [
    "Double Extra Large",
    "Extra Large",
    "Large",
    "Medium",
    "Small",
    "11-12 Years",
    "8-10 Years",
    "5-7 Years",
    "2-4 Years",
    "Infants Upto (1 Year)",
  ];

  final colors = [
    "Red",
    "Green",
    "White",
    "Blue",
    "Yellow",
    "Orange",
    "Grey",
    "Purple",
    "Pink",
    "Black",
    "Brown",
  ];

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<String> convertBase64(File file) async {
    List<int> bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  int getSizeId(String size) {
    switch (size) {
      case "Double Extra Large":
        return 1;
      case "Extra Large":
        return 2;
      case "Large":
        return 3;
      case "Medium":
        return 4;
      case "Small":
        return 5;
      case "11-12 Years":
        return 6;
      case "8-10 Years":
        return 7;
      case "5-7 Years":
        return 8;
      case "2-4 Years":
        return 9;
      case "Infants Upto (1 Year)":
        return 10;
      default:
        return 0;
    }
  }

  Future<void> saveQR() async {
    await Permission.storage.request();

    Uint8List? image = await screenshotController.capture();

    if (image == null) {
      Get.snackbar("Saved", "QR Captured");
      return;
    }

    final result = await ImageGallerySaverPlus.saveImage(
      image,
      quality: 100,
      name: donorQRCode,
    );

    if (result != null) {
      Get.snackbar("Success", "QR Saved Successfully");
    } else {
      Get.snackbar("Saved", "Save To Gallery");
    }
  }

  Future<void> saveItem() async {
    if (imageFile == null) {
      Get.snackbar("Error", "Capture image first");
      return;
    }

    String base64Image = await convertBase64(imageFile!);

    int workerId = await controller.getWorkerId();

    InventoryModel model = InventoryModel(
      sourceType: "DONOR",
      sourceId: widget.donorRequestId,
      itemImage: base64Image,
      itemType: itemTypeController.text.trim(),
      category: selectedCategory,
      season: selectedSeason,
      condition: selectedCondition,
      sizeId: getSizeId(selectedSize),
      //quantity: int.parse(quantityController.text),
      status: 1,
      color: selectedColor,
      userId: workerId,
    );

    await controller.addInventoryItem(model);

    Get.snackbar("Success", "Item Added");

    setState(() {
      imageFile = null;
      itemTypeController.clear();
      //quantityController.text = "1";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categorize Donation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F8F7A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// IMAGE
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imageFile == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 40),
                          SizedBox(height: 10),
                          Text("Take Item Picture"),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(imageFile!, fit: BoxFit.cover),
                      ),
              ),
            ),

            const SizedBox(height: 15),

            /// ITEM TYPE
            TextField(
              controller: itemTypeController,
              decoration: const InputDecoration(
                labelText: "Item Type",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// QUANTITY
            // TextField(
            //   controller: quantityController,
            //   keyboardType: TextInputType.number,
            //   decoration: const InputDecoration(
            //     labelText: "Quantity",
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            const SizedBox(height: 15),

            /// CATEGORY
            DropdownButtonFormField(
              value: selectedCategory,
              items: categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() => selectedCategory = v!);
              },
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// SEASON
            DropdownButtonFormField(
              value: selectedSeason,
              items: seasons
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() => selectedSeason = v!);
              },
              decoration: const InputDecoration(
                labelText: "Season",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// CONDITION
            DropdownButtonFormField(
              value: selectedCondition,
              items: conditions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() => selectedCondition = v!);
              },
              decoration: const InputDecoration(
                labelText: "Condition",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// SIZE
            DropdownButtonFormField(
              value: selectedSize,
              items: sizes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() => selectedSize = v!);
              },
              decoration: const InputDecoration(
                labelText: "Size",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// COLOR
            DropdownButtonFormField(
              value: selectedColor,
              items: colors
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() => selectedColor = v!);
              },
              decoration: const InputDecoration(
                labelText: "Color",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F8F7A),
                ),
                child: const Text(
                  "Add To Inventory",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveQR,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F8F7A),
                ),
                child: const Text(
                  "Download QrCode",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  Get.to(ScanQRNewScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F8F7A),
                ),
                child: const Text(
                  "Scan QrCode",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:charity/Donee/Controller/DoneeRequest.dart';
import 'package:charity/Donee/Model/DoneeRequestModel.dart';
import 'package:charity/Donee/Model/RequestItemModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BehalfRequestScreen extends StatefulWidget {
  const BehalfRequestScreen({super.key});

  @override
  State<BehalfRequestScreen> createState() => _BehalfRequestScreenState();
}

class _BehalfRequestScreenState extends State<BehalfRequestScreen> {
  final controller = Get.put(DoneeController());

  @override
  void initState() {
    super.initState();

    controller.getNearestWarehouses();
  }

  final quantityController = TextEditingController();
  final behalfNameController = TextEditingController();
  final contactController = TextEditingController();

  File? selectedImage;
  String? base64Image;

  List<DoneeItemModel> items = [];

  String category = "Male";
  String season = "Winter";
  String selectedColor = "Red";
  String selectedItemType = "Shirt";
  String selectedSize = "Medium";

  final colors = ["Red", "Blue", "Black", "White", "Green"];

  final itemTypes = [
    "Shirt",
    "Pant",
    "Jacket",
    "Sweater",
    "Hoodie",
    "Coat",
    "Shalwar Kameez",
    "T-Shirt",
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

  final Map<String, int> sizeMap = {
    "Double Extra Large": 1,
    "Extra Large": 2,
    "Large": 3,
    "Medium": 4,
    "Small": 5,
    "11-12 Years": 6,
    "8-10 Years": 7,
    "5-7 Years": 8,
    "2-4 Years": 9,
    "Infants Upto (1 Year)": 10,
  };

  final Color themeColor = const Color(0xFF0F8F7A);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      List<int> bytes = await selectedImage!.readAsBytes();
      base64Image = base64Encode(bytes);
      setState(() {});
    }
  }

  void addItem() {
    // Basic formatting guard
    if (quantityController.text.trim().isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter quantity",
        backgroundColor: Colors.amber.shade100,
      );
      return;
    }

    DoneeItemModel item = DoneeItemModel(
      itemType: selectedItemType,
      category: category,
      color: selectedColor,
      season: season,
      sizeId: sizeMap[selectedSize]!,
      quantity: int.parse(quantityController.text),
    );

    items.add(item);
    quantityController.clear();
    setState(() {});
  }

  void removeItem(int index) {
    items.removeAt(index);
    setState(() {});
  }

  Future<void> submitRequest() async {
    if (behalfNameController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Enter Person Name",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    if (contactController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Enter Contact Number",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    if (items.isEmpty) {
      Get.snackbar(
        "Error",
        "Please Add At Least One Item",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    if (base64Image == null) {
      Get.snackbar(
        "Error",
        "Please Upload CNIC",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    DoneeRequestModel model = DoneeRequestModel(
      userId: prefs.getInt("userId") ?? 0,
      recipentId: 3,
      ngoName: "",
      behalfName: behalfNameController.text,
      behalfContact: contactController.text,
      identityImage: base64Image,
      latitude: 33.6,
      longitude: 73.0,
      scheduledTime: DateTime.now().toString(),
      warehouseId: controller.selectedWarehouseId.value,
      items: items,
    );

    await controller.createRequest(model);
    Get.back();
  }

  // Common input styling layout helper
  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(prefixIcon, color: themeColor),
      labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
      floatingLabelStyle: TextStyle(
        color: themeColor,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeColor, width: 1.5),
      ),
    );
  }

  // --- Sub UI Sections Helpers ---

  Widget _personInfo() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recipient Information",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: behalfNameController,
              decoration: _buildInputDecoration(
                labelText: "Person Name",
                prefixIcon: Icons.person_outline_rounded,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              decoration: _buildInputDecoration(
                labelText: "Contact Number",
                prefixIcon: Icons.phone_android_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemSection() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Item Requirements",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: selectedItemType,
              decoration: _buildInputDecoration(
                labelText: "Item Type",
                prefixIcon: Icons.checkroom_rounded,
              ),
              items: itemTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedItemType = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedSize,
              decoration: _buildInputDecoration(
                labelText: "Size",
                prefixIcon: Icons.straighten_rounded,
              ),
              items: sizes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedSize = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: category,
              decoration: _buildInputDecoration(
                labelText: "Category",
                prefixIcon: Icons.wc_rounded,
              ),
              items: [
                "Male",
                "Female",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => category = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: season,
              decoration: _buildInputDecoration(
                labelText: "Season",
                prefixIcon: Icons.wb_sunny_rounded,
              ),
              items: [
                "Winter",
                "Summer",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => season = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedColor,
              decoration: _buildInputDecoration(
                labelText: "Color",
                prefixIcon: Icons.palette_rounded,
              ),
              items: colors
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedColor = v!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration(
                labelText: "Quantity",
                prefixIcon: Icons.format_list_numbered_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _batchList() {
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(
              Icons.playlist_remove_rounded,
              size: 38,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 6),
            Text(
              "No items added to current batch yet.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: CircleAvatar(
              backgroundColor: themeColor.withOpacity(0.1),
              child: Text(
                "${item.quantity}x",
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            title: Text(
              item.itemType,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "${item.category} • ${item.season} • ${item.color} • Size: ${sizes[item.sizeId - 1]}",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
              onPressed: () => removeItem(index),
            ),
          ),
        );
      },
    );
  }

  Widget _submitButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : submitRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
            disabledBackgroundColor: themeColor.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  "Submit Batch Request",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      appBar: AppBar(
        title: const Text(
          "Request On Behalf",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _personInfo(),
            const SizedBox(height: 20),

            // Section: CNIC Verification Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CNIC Verification",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          selectedImage == null
                              ? "Required for request validation"
                              : "Document attached successfully",
                          style: TextStyle(
                            fontSize: 12,
                            color: selectedImage == null
                                ? Colors.grey.shade500
                                : themeColor,
                            fontWeight: selectedImage == null
                                ? FontWeight.normal
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: Icon(
                      selectedImage == null
                          ? Icons.cloud_upload_outlined
                          : Icons.check_circle_rounded,
                      size: 18,
                      color: selectedImage == null ? themeColor : Colors.white,
                    ),
                    label: Text(
                      selectedImage == null ? "Upload" : "Done",
                      style: TextStyle(
                        color: selectedImage == null
                            ? themeColor
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedImage == null
                          ? themeColor.withOpacity(0.1)
                          : themeColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _itemSection(),
            const SizedBox(height: 16),

            // Section: Add to batch control
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: addItem,
                icon: Icon(Icons.add_box_rounded, color: themeColor),
                label: Text(
                  "Add Item To Current Batch",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: themeColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Current Batch List",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                if (items.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${items.length} Items",
                      style: TextStyle(
                        fontSize: 12,
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),

            Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              }

              return DropdownButtonFormField<int>(
                value: controller.selectedWarehouseId.value == 0
                    ? null
                    : controller.selectedWarehouseId.value,

                items: controller.warehouses.map((e) {
                  return DropdownMenuItem(
                    value: e.id,

                    child: Text(
                      "${e.name} (${e.distance.toStringAsFixed(2)} KM)",
                    ),
                  );
                }).toList(),

                onChanged: (value) {
                  controller.selectWarehouse(value!);
                },
              );
            }),
            const SizedBox(height: 12),

            _batchList(),
            const SizedBox(height: 32),

            _submitButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

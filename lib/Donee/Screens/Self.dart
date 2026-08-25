import 'dart:convert';
import 'dart:io';

import 'package:charity/Donee/Controller/DoneeRequest.dart';
import 'package:charity/Donee/Model/DoneeRequestModel.dart';
import 'package:charity/Donee/Model/RequestItemModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelfRequestScreen extends StatefulWidget {
  const SelfRequestScreen({super.key});

  @override
  State<SelfRequestScreen> createState() => _SelfRequestScreenState();
}

class _SelfRequestScreenState extends State<SelfRequestScreen> {
  final controller = Get.put(DoneeController());

  @override
  void initState() {
    super.initState();

    controller.getNearestWarehouses();
  }

  final quantityController = TextEditingController();

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
      season: season,
      color: selectedColor,
      sizeId: sizeMap[selectedSize]!,
      quantity: int.parse(quantityController.text),
    );

    items.add(item);
    quantityController.clear(); // Clears field after adding successfully

    Get.snackbar(
      "Added",
      "$selectedItemType Added to list",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F8F7A),
      colorText: Colors.white,
    );

    setState(() {});
  }

  void removeItem(int index) {
    items.removeAt(index);
    setState(() {});
  }

  Future<void> submitRequest() async {
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
      recipentId: 1,
      ngoName: "",
      behalfName: "",
      behalfContact: "",
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

  // Common Input Decoration helper to keep fields consistently beautiful
  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData prefixIcon,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF0F8F7A)),
      labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
      floatingLabelStyle: const TextStyle(
        color: Color(0xFF0F8F7A),
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
        borderSide: const BorderSide(color: Color(0xFF0F8F7A), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF0F8F7A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      appBar: AppBar(
        title: const Text(
          "Self Request",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Item specs configuration card
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedItemType,
                      decoration: _buildInputDecoration(
                        labelText: "Item Type",
                        prefixIcon: Icons.checkroom_rounded,
                      ),
                      items: itemTypes
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
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
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
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
                      items: ["Male", "Female"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => category = v!),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: season,
                      decoration: _buildInputDecoration(
                        labelText: "Season",
                        prefixIcon: Icons.wb_sunny_rounded,
                      ),
                      items: ["Winter", "Summer"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
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
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
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
                        hintText: "Enter Quantity",
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: addItem,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          "Add Item to List",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

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

            const SizedBox(height: 28),

            // Section 2: Render added items section title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Added Items (${items.length})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                if (items.isNotEmpty)
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: themeColor,
                    size: 22,
                  ),
              ],
            ),
            const SizedBox(height: 12),

            if (items.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.layers_clear_outlined,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "No items added yet.",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

            if (items.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${item.quantity}x",
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      title: Text(
                        item.itemType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildMiniChip(item.category),
                            _buildMiniChip(item.season),
                            _buildMiniChip(item.color),
                            _buildMiniChip("Size: ${sizes[item.sizeId - 1]}"),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () => removeItem(index),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 28),

            // Section 3: Identity Upload Box Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Upload CNIC Image Verification",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ensure your identification is clearly visible.",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  if (selectedImage != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            selectedImage!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),

                  if (selectedImage == null)
                    InkWell(
                      onTap: pickImage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 42,
                              color: themeColor.withOpacity(0.6),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Tap to capture or select CNIC image",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (selectedImage == null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: pickImage,
                        icon: Icon(
                          Icons.upload_file_rounded,
                          color: themeColor,
                        ),
                        label: Text(
                          "Choose Image File",
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: themeColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Section 4: Final Screen Submission Controller Button
            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    disabledBackgroundColor: themeColor.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 1,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Submit Donation Request",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Small inline chip helper function for modern list aesthetics
  Widget _buildMiniChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

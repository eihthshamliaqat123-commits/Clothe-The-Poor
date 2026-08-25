import 'package:charity/Donee/Controller/DoneeRequest.dart';
import 'package:charity/Donee/Model/DoneeRequestModel.dart';
import 'package:charity/Donee/Model/RequestItemModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NGOItemsScreen extends StatefulWidget {
  final String ngoName;
  final String image;

  const NGOItemsScreen({super.key, required this.ngoName, required this.image});

  @override
  State<NGOItemsScreen> createState() => _NGOItemsScreenState();
}

class _NGOItemsScreenState extends State<NGOItemsScreen> {
  final controller = Get.put(DoneeController());

  final quantityController = TextEditingController();

  List<DoneeItemModel> items = [];

  String category = "Male";
  String season = "Winter";
  String selectedColor = "Red";

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

  String selectedItemType = "Shirt";

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

  String selectedSize = "Medium";

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

  void addItem() {
    DoneeItemModel item = DoneeItemModel(
      itemType: selectedItemType,
      color: selectedColor,
      category: category,
      season: season,
      quantity: int.parse(quantityController.text),
      sizeId: sizeMap[selectedSize]!,
    );

    items.add(item);

    quantityController.clear();

    setState(() {});
  }

  Future<void> submitRequest() async {
    if (items.isEmpty) {
      Get.snackbar("Error", "Add Items First");
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    DoneeRequestModel model = DoneeRequestModel(
      userId: prefs.getInt("userId") ?? 0,
      recipentId: 2,
      ngoName: widget.ngoName,
      behalfName: "",
      behalfContact: "",
      identityImage: widget.image,
      latitude: 33.6,
      longitude: 73.0,
      scheduledTime: DateTime.now().toString(),
      items: items,
    );

    await controller.createRequest(model);

    Get.back();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NGO Items")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            DropdownButtonFormField(
              value: selectedItemType,

              items: itemTypes.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),

              onChanged: (v) {
                setState(() {
                  selectedItemType = v!;
                });
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: selectedSize,

              items: sizes.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),

              onChanged: (v) {
                setState(() {
                  selectedSize = v!;
                });
              },

              decoration: const InputDecoration(labelText: "Select Size"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: "Quantity"),
            ),

            const SizedBox(height: 15),

            ElevatedButton(onPressed: addItem, child: const Text("Add Item")),

            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: items.length,

              itemBuilder: (_, index) {
                var item = items[index];

                return Card(
                  child: ListTile(
                    title: Text(item.itemType),
                    subtitle: Text(" Size: ${sizes[item.sizeId - 1]}"),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: submitRequest,
                child: const Text("Submit Request"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

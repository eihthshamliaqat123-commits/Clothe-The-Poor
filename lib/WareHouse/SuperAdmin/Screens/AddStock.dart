import 'package:flutter/material.dart';

class AddStockScreen extends StatefulWidget {
  const AddStockScreen({super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _formKey = GlobalKey<FormState>();

  final donationIdController = TextEditingController();
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedCategory;
  String? selectedCondition;

  final categories = ["Clothes", "Shoes", "Food", "Books", "Other"];
  final conditions = ["New", "Good", "Used"];

  void submitStock() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "DonationId": donationIdController.text,
        "ItemName": itemNameController.text,
        "Quantity": quantityController.text,
        "Category": selectedCategory,
        "Condition": selectedCondition,
        "Notes": notesController.text,
      };

      print("Stock Submitted => $data");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Stock Added Successfully")));

      Navigator.pop(context, true);
    }
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Warehouse Stock",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// Donation ID
              TextFormField(
                controller: donationIdController,
                decoration: inputDecoration("DonorRequest ID"),
                validator: (v) => v!.isEmpty ? "Donation ID required" : null,
              ),
              const SizedBox(height: 15),

              /// Item Name
              TextFormField(
                controller: itemNameController,
                decoration: inputDecoration("Item Name"),
                validator: (v) => v!.isEmpty ? "Item name required" : null,
              ),
              const SizedBox(height: 15),

              /// Quantity
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Quantity"),
                validator: (v) => v!.isEmpty ? "Quantity required" : null,
              ),
              const SizedBox(height: 15),

              /// Category Dropdown
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: inputDecoration("Category"),
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
                validator: (v) => v == null ? "Select category" : null,
              ),
              const SizedBox(height: 15),

              /// Condition Dropdown
              DropdownButtonFormField<String>(
                value: selectedCondition,
                decoration: inputDecoration("Condition"),
                items: conditions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCondition = val),
                validator: (v) => v == null ? "Select condition" : null,
              ),
              const SizedBox(height: 15),

              /// Notes
              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: inputDecoration("Notes (Optional)"),
              ),
              const SizedBox(height: 25),

              /// Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: submitStock,
                child: const Text("Add Stock"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

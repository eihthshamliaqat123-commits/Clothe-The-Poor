import 'package:flutter/material.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Item Detail")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Product: Denim Jacket"),
            Text("Condition: Excellent"),
            Text("Age Group: Adult"),
            Text("Gender: Men"),
            Text("Size: Large"),
            Text("Material: Denim"),
            Text("Quantity Available: 5"),
          ],
        ),
      ),
    );
  }
}

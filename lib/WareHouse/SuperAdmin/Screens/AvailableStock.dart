import 'package:flutter/material.dart';

class AvailableStockScreen extends StatelessWidget {
  const AvailableStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Stock")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(child: Icon(Icons.checkroom, size: 80)),
                Text("Denim Jacket"),
                Text("Qty: 5"),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StockCard extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback? onView;

  const StockCard({
    super.key,
    required this.title,
    required this.count,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$count",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            TextButton(onPressed: onView, child: const Text("View Details")),
          ],
        ),
      ),
    );
  }
}

import 'package:charity/Rider/Screens/CategorizeItem.dart';
import 'package:flutter/material.dart';

class PickupDetailsScreen extends StatelessWidget {
  const PickupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pickup Details")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Task"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              title: Text("Jane Doe"),
              trailing: Icon(Icons.call, color: Colors.red),
            ),
            const Text("📍 123 Charity Lane, Kindness City"),
            const SizedBox(height: 10),
            const Text(
              "Please ring the bell twice. If no one answers, leave donation at front door.",
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Start Navigation"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CategorizeItemScreen(),
                  ),
                );
              },
              child: const Text("Arrived at Donor"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RiderHistoryScreen extends StatelessWidget {
  const RiderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          historyTile("Jane Doe", "Pickup", "Completed"),
          historyTile("John Smith", "Delivery", "Completed"),
        ],
      ),
    );
  }
}

class historyTile extends StatelessWidget {
  final String name, type, status;
  const historyTile(this.name, this.type, this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text("$type • Oct 25, 2023"),
        trailing: Chip(label: Text(status), backgroundColor: Colors.green[100]),
      ),
    );
  }
}

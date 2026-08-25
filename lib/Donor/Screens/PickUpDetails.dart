import 'package:flutter/material.dart';

class PickupDetailsScreen extends StatelessWidget {
  final DateTime? dateTime;

  const PickupDetailsScreen({super.key, this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanks For Donation")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: ListTile(
            title: const Text("Pickup Details"),
            subtitle: Text(
              dateTime == null
                  ? "No date selected"
                  : "Pickup Time:\n"
                        "${dateTime!.day}-${dateTime!.month}-${dateTime!.year} "
                        "${dateTime!.hour}:${dateTime!.minute}",
            ),
          ),
        ),
      ),
    );
  }
}

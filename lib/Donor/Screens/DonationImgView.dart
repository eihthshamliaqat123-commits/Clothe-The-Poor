import 'package:flutter/material.dart';

class DonationImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donation Image")),
      body: Center(child: Icon(Icons.image, size: 200, color: Colors.grey)),
    );
  }
}

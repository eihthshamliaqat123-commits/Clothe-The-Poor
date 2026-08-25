import 'package:flutter/material.dart';

class CategorizeItemScreen extends StatelessWidget {
  const CategorizeItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categorize Item")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          categoryTile("Adult Male"),
          categoryTile("Adult Female"),
          categoryTile("Boys / Child Male"),
          categoryTile("Girls / Child Female"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Confirm & Proceed"),
          ),
        ],
      ),
    );
  }

  Widget categoryTile(String title) {
    return Card(
      child: ExpansionTile(
        title: Text(title),
        children: const [
          ListTile(
            title: Text("Shirts"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.remove), Text("0"), Icon(Icons.add)],
            ),
          ),
          ListTile(
            title: Text("Trousers"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.remove), Text("0"), Icon(Icons.add)],
            ),
          ),
        ],
      ),
    );
  }
}

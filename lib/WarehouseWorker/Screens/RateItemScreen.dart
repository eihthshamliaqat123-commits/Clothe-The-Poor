import 'package:charity/Donee/Controller/DoneeRequest.dart';
import 'package:charity/WarehouseWorker/Controller/WarehouseWorkerController.dart';
import 'package:charity/WarehouseWorker/Model/RateSortingItem.dart';
import 'package:flutter/material.dart';

class Rateitemscreen extends StatefulWidget {
  const Rateitemscreen({super.key});

  @override
  State<Rateitemscreen> createState() => _RateitemscreenState();
}

class _RateitemscreenState extends State<Rateitemscreen> {
  @override
  final controller = WarehouseWorkerController();
  List<Map<String, dynamic>> rateItem = [
    {"SourceId": 4032, "ItemType": "Pent"},
    {"SourceId": 2029, "ItemType": "Shirt"},
    {"SourceId": 2026, "ItemType": "Pent"},
  ];
  TextEditingController RatingField = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "RateItems Screen",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F8F7A),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: rateItem.length,
              itemBuilder: (context, index) {
                final item = rateItem[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SourceId : $item",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // const SizedBox(height: 6),
                        TextField(
                          controller: RatingField,
                          decoration: InputDecoration(
                            labelText: "Rate Cloth",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // const SizedBox(height: 6),

                        // Text(
                        //   "Lat: ${item.latitude.toStringAsFixed(4)}, "
                        //   "Lng: ${item.longitude.toStringAsFixed(4)}",
                        // ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Ratesortingitem item = Ratesortingitem(
                                  SourceId: 4032,
                                  Rating: int.parse(RatingField.text),
                                );
                                controller.postRating(item);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text("Submit Rating"),
                            ),

                            // ElevatedButton(
                            //   onPressed: () {},
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.red,
                            //   ),
                            //   child: const Text("Reject"),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

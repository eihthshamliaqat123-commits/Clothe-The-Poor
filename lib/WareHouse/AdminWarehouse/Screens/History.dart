import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WarehouseRequestHistoryScreen extends StatefulWidget {
  const WarehouseRequestHistoryScreen({super.key});

  @override
  State<WarehouseRequestHistoryScreen> createState() =>
      _WarehouseRequestHistoryScreenState();
}

class _WarehouseRequestHistoryScreenState
    extends State<WarehouseRequestHistoryScreen> {
  List requests = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchWarehouseRequests();
  }

  Future<void> fetchWarehouseRequests() async {
    try {
      // LOGIN WALA WAREHOUSE ID
      int warehouseId = 1;

      var response = await http.get(
        Uri.parse(
          "http://YOURIP/FYP/api/Warehouse/GetWarehouseRequestsByWarehouse?warehouseId=$warehouseId",
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          requests = jsonDecode(response.body);

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });

        Get.snackbar("Error", "Failed to load requests");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      Get.snackbar("Exception", e.toString());
    }
  }

  Future<void> updateStatus(int warehouseRequestId, int status) async {
    try {
      var response = await http.post(
        Uri.parse(
          "http://YOURIP/FYP/api/Warehouse/UpdateWarehouseRequestStatus?warehouseRequestId=$warehouseRequestId&status=$status",
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Status Updated");

        fetchWarehouseRequests();
      } else {
        Get.snackbar("Error", "Failed to update status");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return "Pending";

      case 1:
        return "Accepted";

      case 2:
        return "Rejected";

      case 3:
        return "Fulfilled";

      default:
        return "Unknown";
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;

      case 1:
        return Colors.blue;

      case 2:
        return Colors.red;

      case 3:
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Warehouse Requests",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F8F7A),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(child: Text("No Requests Found"))
          : ListView.builder(
              itemCount: requests.length,

              itemBuilder: (context, index) {
                var item = requests[index];

                int status = item["Status"];

                List requestedItems = item["RequestedItems"];

                return Card(
                  margin: const EdgeInsets.all(10),

                  elevation: 4,

                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(
                              child: Text(
                                item["RequestingWarehouseName"].toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: getStatusColor(status),

                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Text(
                                getStatusText(status),

                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text("Notes: ${item["Notes"]}"),

                        const SizedBox(height: 10),

                        Text("Request Date: ${item["RequestDate"]}"),

                        const Divider(),

                        const Text(
                          "Requested Items",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        Column(
                          children: requestedItems.map<Widget>((e) {
                            return Card(
                              color: Colors.grey.shade100,

                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(e["Quantity"].toString()),
                                ),

                                title: Text(e["ItemType"]),

                                subtitle: Text(
                                  "${e["Category"]} | ${e["Size"]} | ${e["Season"]}",
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 10),

                        if (status == 0)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),

                                  onPressed: () {
                                    updateStatus(item["WarehouseRequestId"], 1);
                                  },

                                  child: const Text("Accept"),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),

                                  onPressed: () {
                                    updateStatus(item["WarehouseRequestId"], 2);
                                  },

                                  child: const Text("Reject"),
                                ),
                              ),
                            ],
                          ),

                        if (status == 1)
                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),

                              onPressed: () {
                                updateStatus(item["WarehouseRequestId"], 3);
                              },

                              child: const Text("Mark Fulfilled"),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

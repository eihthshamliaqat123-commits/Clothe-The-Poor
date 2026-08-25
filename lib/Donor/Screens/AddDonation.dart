import 'package:charity/Donor/Controller/DonationController.dart';
import 'package:charity/widget/ReuseAblemap.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddDonationScreen extends StatelessWidget {
  AddDonationScreen({super.key});

  final DonorRequestController controller = Get.put(DonorRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Donation")),

      body: GetBuilder<DonorRequestController>(
        builder: (c) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // =====================================
                // COMMENTS
                // =====================================
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Comments / No of Bags",
                    border: OutlineInputBorder(),
                  ),

                  onChanged: (value) {
                    c.comments = value;
                  },
                ),

                const SizedBox(height: 20),

                // =====================================
                // DATE TIME
                // =====================================
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );

                      if (date == null) return;

                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (time == null) return;

                      c.scheduledTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );

                      c.update();
                    },

                    child: Text(
                      c.scheduledTime == null
                          ? "Select Date & Time"
                          : c.scheduledTime.toString(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =====================================
                // LOCATION
                // =====================================
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ReusableMap()),
                      );

                      if (result != null && result is LatLng) {
                        c.latitude = result.latitude;
                        c.longitude = result.longitude;

                        print("LAT => ${c.latitude}");
                        print("LNG => ${c.longitude}");

                        await c.getNearestWarehouses(c.latitude!, c.longitude!);

                        c.update();
                      }
                    },

                    child: Text(
                      c.latitude == null
                          ? "Select Location"
                          : "Location Selected",
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =====================================
                // IMAGE
                // =====================================
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await c.pickImageFromCamera();
                    },

                    icon: const Icon(Icons.camera),

                    label: const Text("Capture Image"),
                  ),
                ),

                const SizedBox(height: 15),

                // =====================================
                // IMAGE PREVIEW
                // =====================================
                if (c.selectedImage != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),

                      child: Image.file(
                        c.selectedImage!,
                        height: 180,
                        width: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // =====================================
                // LOADING
                // =====================================
                Obx(() {
                  if (c.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (c.warehouses.isEmpty) {
                    return const Text("No Nearby Warehouses");
                  }

                  return DropdownButtonFormField<int>(
                    value: c.selectedWarehouseId,

                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nearest Warehouses",
                    ),

                    items: c.warehouses.map((w) {
                      return DropdownMenuItem<int>(
                        value: w.id,

                        child: Text(
                          "${w.name} (${w.distance.toStringAsFixed(2)} KM)",
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      if (value != null) {
                        c.selectWarehouse(value);
                      }
                    },
                  );
                }),

                const SizedBox(height: 35),

                // =====================================
                // SUBMIT BUTTON
                // =====================================
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: c.isLoading.value
                        ? null
                        : () {
                            c.submitDonorRequest();
                          },

                    child: c.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Add Donation"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

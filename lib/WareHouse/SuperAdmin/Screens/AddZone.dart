import 'package:charity/WareHouse/SuperAdmin/Controller/ZoneController.dart';
import 'package:charity/WareHouse/SuperAdmin/Screens/MapPickerScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddZoneScreen extends StatelessWidget {
  final ZoneController controller = Get.put(ZoneController());
  final TextEditingController zoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Zone")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: zoneController,
              decoration: InputDecoration(
                labelText: "Zone Name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            Obx(
              () => Text(
                "Lat: ${controller.latitude.value}, Lng: ${controller.longitude.value}",
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapPickerScreen()),
                );

                if (result != null) {
                  controller.latitude.value = result["lat"];
                  controller.longitude.value = result["lng"];
                }
              },
              child: Text("Select Location from Map"),
            ),

            SizedBox(height: 20),

            Obx(
              () => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.createZone(zoneController.text);
                      },
                      child: Text("Save Zone"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ZoneController extends GetxController {
  // Reactive variables
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLoading = false.obs;

  // API call
  Future<void> createZone(String zoneName) async {
    if (zoneName.isEmpty) {
      Get.snackbar("Error", "Zone name is required");
      return;
    }

    if (latitude.value == 0 || longitude.value == 0) {
      Get.snackbar("Error", "Please select location on map");
      return;
    }

    isLoading.value = true;

    try {
      final url = Uri.parse("${BaseapiController.BaseURL}Zones/CreateZone");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ZoneName": zoneName,
          "Latitude": latitude.value,
          "Longitude": longitude.value,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Zone created successfully");
      } else {
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

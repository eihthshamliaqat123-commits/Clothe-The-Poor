import 'dart:convert';

import 'package:charity/Rider/Model/RiderDoneeDelivery.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class RiderDoneeController extends GetxController {
  var deliveries = <RiderDoneeDeliveryModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchDoneeDeliveries() async {
    final prefs = await SharedPreferences.getInstance();

    int riderId = prefs.getInt("userId") ?? 0;

    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}RiderDashBoard/GetAssignedDoneeDeliveries?riderId=$riderId",
      ),
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      deliveries.value = (data as List)
          .map((e) => RiderDoneeDeliveryModel.fromJson(e))
          .toList();
    }
  }

  Future<void> deliverDoneeRequest(int rideLogId) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
          "${BaseapiController.BaseURL}"
          "RiderDashBoard/DeliverDoneeRequest"
          "?rideLogId=$rideLogId",
        ),
      );

      print("Status Code : ${response.statusCode}");
      print("Response : ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Get.snackbar(
          "Success",
          data["Message"] ?? "Request Delivered Successfully",
        );

        await fetchDoneeDeliveries();
      } else {
        Get.snackbar("Error", "Delivery Failed");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

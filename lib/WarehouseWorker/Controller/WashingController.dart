import 'dart:convert';
import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WashingOfficerController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<Map<String, dynamic>> donations = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> washedDonations = <Map<String, dynamic>>[].obs;

  Future<void> getDeliveredDonations() async {
    isLoading.value = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId") ?? 0;

    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "WarehouseWorker/GetDeliveredDonations?userId=$userId",
      ),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      donations.value = List<Map<String, dynamic>>.from(data);
    }
    isLoading.value = false;
  }

  Future<void> markWashed(int donorRequestId) async {
    try {
      var response = await http.post(
        Uri.parse(
          "${BaseapiController.BaseURL}"
          "WarehouseWorker/MarkWashed"
          "?donorRequestId=$donorRequestId",
        ),
      );

      print(response.body);

      if (response.statusCode == 200) {
        donations.removeWhere((e) => e["DonorRequestId"] == donorRequestId);

        Get.snackbar("Success", "Marked Washed Successfully");
      } else {
        Get.snackbar("Error", "Failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> getWashedDonations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId") ?? 0;

    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "WarehouseWorker/GetWashedDonations"
        "?userId=$userId",
      ),
    );

    if (response.statusCode == 200) {
      washedDonations.value = List<Map<String, dynamic>>.from(
        jsonDecode(response.body),
      );
    }
  }
}

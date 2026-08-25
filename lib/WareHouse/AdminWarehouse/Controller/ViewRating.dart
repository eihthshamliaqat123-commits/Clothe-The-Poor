import 'dart:convert';
import 'package:charity/WareHouse/AdminWarehouse/Models/BonusModel.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WorkersRatingController extends GetxController {
  RxList<Map<String, dynamic>> performanceList = <Map<String, dynamic>>[].obs;

  RxBool isLoading = false.obs;

  Future<void> getWorkersPerformance() async {
    isLoading.value = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId") ?? 0;

    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "Warehouse/GetWorkersPerformance?userId=$userId",
      ),
    );

    if (response.statusCode == 200) {
      performanceList.value = List<Map<String, dynamic>>.from(
        jsonDecode(response.body),
      );
    }

    isLoading.value = false;
  }

  Future<void> updateBonus(BonusModel model) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("${BaseapiController.BaseURL}Warehouse/UpdateWorkerBonus"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode(model.toJson()),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Bonus Updated Successfully");

        // Refresh Worker List
        getWorkersPerformance();
      } else {
        Get.snackbar("Error", "Failed to Update Bonus");
      }
    } catch (e) {
      print(e);

      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

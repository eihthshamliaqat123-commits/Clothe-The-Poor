import 'dart:convert';
import 'package:charity/WareHouse/AdminWarehouse/Models/WarehouseDonee.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WarehouseDoneeController extends GetxController {
  RxList<WarehouseDoneeModel> requests = <WarehouseDoneeModel>[].obs;

  RxBool isLoading = false.obs;

  // 🔥 GET REQUESTS
  Future<void> getDoneeRequests() async {
    isLoading.value = true;

    final prefs = await SharedPreferences.getInstance();

    int UserId = prefs.getInt("userId") ?? 0;

    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "Warehouse/GetWarehouseDoneeRequests"
        "?userId=$UserId",
      ),
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      requests.value = data
          .map<WarehouseDoneeModel>((e) => WarehouseDoneeModel.fromJson(e))
          .toList();

      print(requests.length);
    }

    isLoading.value = false;
  }

  // 🔥 ACCEPT REQUEST
  Future<void> acceptRequest(int doneeRequestId) async {
    var response = await http.post(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "Warehouse/AcceptWarehouseDoneeRequest"
        "?doneeRequestId=$doneeRequestId",
      ),
    );

    print(response.body);

    if (response.statusCode == 200) {
      Get.snackbar("Success", "Worker Assigned");

      getDoneeRequests();
    }
  }
}

import 'dart:convert';

import 'package:charity/WareHouse/AdminWarehouse/Models/WarehouseRequestModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WarehouseToWarehouseController extends GetxController {
  var isLoading = false.obs;

  Future<void> sendWarehouseRequest(WarehouseRequestModel model) async {
    try {
      isLoading.value = true;

      var response = await http.post(
        Uri.parse(
          "http://YOURIP/FYP/api/Warehouse/WarehouseToWarehouseRequest",
        ),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode(model.toJson()),
      );

      print(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Warehouse request sent successfully");
      } else {
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

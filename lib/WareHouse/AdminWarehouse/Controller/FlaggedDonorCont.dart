import 'dart:convert';

import 'package:charity/WareHouse/AdminWarehouse/Models/FlaggedDonor.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class FlaggedDonorController extends GetxController {
  RxList<FlaggedDonorModel> donors = <FlaggedDonorModel>[].obs;

  RxBool isLoading = false.obs;

  Future<void> fetchFlaggedDonors() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();

      int warehouseId = prefs.getInt("warehouseId") ?? 0;

      var response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}Warehouse/GetFlaggedDonors?warehouseId=$warehouseId",
        ),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        donors.value = data.map((e) => FlaggedDonorModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

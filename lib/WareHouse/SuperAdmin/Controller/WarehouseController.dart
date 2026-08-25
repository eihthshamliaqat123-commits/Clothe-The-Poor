import 'package:charity/WareHouse/SuperAdmin/Model.dart/GetZoneModel.dart';
import 'package:charity/WareHouse/SuperAdmin/Model.dart/CreateWarehouseModel.dart';
import 'package:charity/WareHouse/SuperAdmin/Model.dart/WarehouesSForAdmins.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WarehouseController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt selectedZoneId = 0.obs;

  RxList<ZoneModel> zones = <ZoneModel>[].obs;
  RxString selectedZoneName = "".obs;
  RxList<WarehouseModel> warehouses = <WarehouseModel>[].obs;
  RxInt selectedWarehouseId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchZones();
    fetchWarehouses();
  }

  Future<void> fetchZones() async {
    try {
      var response = await http.get(
        Uri.parse("${BaseapiController.BaseURL}Zones/GetAllZones"),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        zones.value = data.map((z) => ZoneModel.fromJson(z)).toList();
      } else {
        Get.snackbar("Error", "Failed to fetch zones");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> createWarehouse(String warehouseName) async {
    if (warehouseName.isEmpty) {
      Get.snackbar("Error", "Warehouse name is required");
      return;
    }

    if (selectedZoneId.value == 0) {
      Get.snackbar("Error", "Please select a zone");
      return;
    }

    try {
      isLoading.value = true;

      var model = CreateWarehouseModel(
        wareHouseName: warehouseName,
        zoneId: selectedZoneId.value,
      );

      var response = await http.post(
        Uri.parse("${BaseapiController.BaseURL}WareHouse/CreateWarehouse"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(model.toJson()),
      );
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["success"] == true) {
          Get.snackbar("Success", data["message"]);
        } else {
          Get.snackbar("Error", "Failed to create warehouse");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.toString()}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWarehouses() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse("${BaseapiController.BaseURL}Warehouse/GetAllWarehouses"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        warehouses.value = data
            .map<WarehouseModel>((e) => WarehouseModel.fromJson(e))
            .toList();
      } else {
        Get.snackbar("Error", "Failed to load warehouses");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectWarehouse(int id) {
    selectedWarehouseId.value = id;
  }
}

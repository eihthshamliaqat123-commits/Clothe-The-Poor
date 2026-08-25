import 'dart:convert';
import 'package:charity/WareHouse/AdminWarehouse/Models/InventoryW.dart';
import 'package:charity/WareHouse/AdminWarehouse/Models/WarehouseTransfer.dart';
import 'package:charity/WareHouse/AdminWarehouse/Models/WarehouseTransferREquest.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

class WarehouseTransferController extends GetxController {
  RxList<TransferRequestModel> requests = <TransferRequestModel>[].obs;
  RxList<InventoryModel> inventory = <InventoryModel>[].obs;

  RxBool loading = false.obs;

  Future<void> getWarehouseRequests(int warehouseId) async {
    loading.value = true;

    final res = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "Warehouse/GetWarehouseRequestsByWarehouse"
        "?warehouseId=$warehouseId",
      ),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      requests.value = (data as List)
          .map((e) => TransferRequestModel.fromJson(e))
          .toList();
    }

    loading.value = false;
  }

  Future<void> transferItems(WarehouseTransferModel model) async {
    final res = await http.post(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "Warehouse/TransferWarehouseItems",
      ),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode(model.toJson()),
    );

    if (res.statusCode == 200) {
      Get.snackbar("Success", "Items transferred");
    } else {
      Get.snackbar("Error", res.body);
    }
  }

  Future<void> getMatchingInventory(TransferRequestModel request) async {
    loading.value = true;

    final res = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "Warehouse/GetMatchingInventory"
        "?warehouseRequestId=${request.warehouseRequestId}",
      ),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      inventory.value = (data as List)
          .map((e) => InventoryModel.fromJson(e))
          .toList();
    }

    loading.value = false;
  }
}

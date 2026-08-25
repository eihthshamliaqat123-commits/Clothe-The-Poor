import 'dart:async';
import 'dart:convert';
import 'package:charity/WareHouse/SuperAdmin/Model.dart/DonorRequest.dart'
    show DonorRequestModel;
import 'package:charity/baseUrl.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

class WareHouseDonorRequestController extends GetxController {
  var isLoading = false.obs;
  RxList<DonorRequestModel> requests = <DonorRequestModel>[].obs;
  var acceptedRequests = <DonorRequestModel>[].obs;
  var rejectedRequests = <DonorRequestModel>[].obs;

  @override
  void onInit() {
    fetchRequests();
    super.onInit();
  }

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse("${BaseapiController.BaseURL}Warehouse/GetPendingDonations"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        requests.value = data
            .map((item) => DonorRequestModel.fromJson(item))
            .toList();
      } else {
        Get.snackbar("Error", "Failed to load requests");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptRequest(int donorRequestId) async {
    await _updateStatus(donorRequestId);

    var item = requests.firstWhere((e) => e.id == donorRequestId);

    requests.removeWhere((e) => e.id == donorRequestId);
    acceptedRequests.add(item);
  }

  void rejectRequest(int index) {
    var item = requests[index];
    requests.removeAt(index);
    rejectedRequests.add(item);
  }

  Future<void> _updateStatus(int id) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${BaseapiController.BaseURL}Warehouse/UpdateDonationStatus"
          "?donorRequestId=$id",
        ),
      );

      if (response.statusCode == 200) {
        requests.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Request accepted");
      } else {
        Get.snackbar("Error", "Failed to update status");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error");
    }
  }

  String _formatTime(String dateTime) {
    final dt = DateTime.parse(dateTime);
    return "${dt.day}-${dt.month}-${dt.year} ${dt.hour}:${dt.minute}";
  }
}

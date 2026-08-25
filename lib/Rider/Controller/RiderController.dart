import 'dart:convert';
import 'package:charity/Rider/Model/AssignRide.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RiderController extends GetxController {
  var isOnline = false.obs;
  // var requests = [].obs;
  //var isActive = false.obs;
  RxList<AssignedRideModel> requests = <AssignedRideModel>[].obs;

  int userId = 0;

  @override
  void onInit() {
    super.onInit();
    loadUser();
    fetchAssignedRequests();
  }

  /// GET USER FROM SHARED PREF
  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId") ?? 0;

    var url = Uri.parse(
      "${BaseapiController.BaseURL}RiderDashBoard/GetRiderStatus?userId=$userId",
    );
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      isOnline.value = data['status'] == 1;
    }
  }

  /// UPDATE RIDER STATUS
  Future<void> updateStatus(int status) async {
    var url = Uri.parse(
      "${BaseapiController.BaseURL}RiderDashBoard/UpdateRiderStatus?userId=$userId&status=$status",
    );

    print(url);

    var response = await http.post(url);

    print(response.body);

    if (response.statusCode == 200) {
      isOnline.value = status == 1;
    }
  }

  Future<void> fetchAssignedRequests() async {
    print("API CALL STARTeD");
    final prefs = await SharedPreferences.getInstance();
    int? riderId = prefs.getInt("userId");

    if (riderId == null) return;

    final response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}RiderDashBoard/GetAssignedDonations?riderId=$riderId",
      ),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      requests.value = data
          .map((item) => AssignedRideModel.fromJson(item))
          .toList();
    }
  }

  Future<void> markPickedUp(int requestId) async {
    var url = Uri.parse(
      "${BaseapiController.BaseURL}RiderDashBoard/MarkPickedUp?donorRequestId=$requestId",
    );

    var response = await http.post(url);

    print("API RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      fetchAssignedRequests(); // refresh
      Get.snackbar("Success", "Pickup Completed");
    } else {
      Get.snackbar("Error", "Failed");
    }
  }

  Future<void> markCompleted(int requestId) async {
    var url = Uri.parse(
      "${BaseapiController.BaseURL}RiderDashBoard/MarkCompleted?donorRequestId=$requestId",
    );

    var response = await http.post(url);

    if (response.statusCode == 200) {
      fetchAssignedRequests();
      Get.snackbar("Success", "Delivered Successfully");
    } else {
      Get.snackbar("Error", "Failed");
    }
  }

  Future<void> toggleActiveStatus() async {
    try {
      final response = await http.post(
        Uri.parse(
          "${BaseapiController.BaseURL}RiderDashBoard/UpdateActiveStatus?userId=$userId&isActive=${!isOnline.value}",
        ),
      );

      if (response.statusCode == 200) {
        isOnline.value = !isOnline.value;

        Get.snackbar(
          "Success",
          isOnline.value ? "You are Online" : "You are Offline",
        );
      } else {
        Get.snackbar("Error", "Failed to update status");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

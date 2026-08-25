import 'dart:convert';
import 'package:charity/WareHouse/AdminWarehouse/Models/PendingDonationsAW.dart';
import 'package:charity/WareHouse/AdminWarehouse/Models/RegisterWoker.dart';
import 'package:charity/WareHouse/AdminWarehouse/Models/WorkerModel.dart';
import 'package:charity/WarehouseWorker/Model/DeliveredDonation.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminWarehouseController extends GetxController {
  RxList<PendingDonationModel> donations = <PendingDonationModel>[].obs;
  //RxList<RawItemModel> rawItems = <RawItemModel>[].obs;
  RxList<DeliveredDonationModel> deliveredList = <DeliveredDonationModel>[].obs;

  RxList<DeliveredDonationModel> waitingList = <DeliveredDonationModel>[].obs;
  RxBool isLoading = false.obs;
  var acceptedRequests = <PendingDonationModel>[].obs;
  var rejectedRequests = <PendingDonationModel>[].obs;
  var selectedRoleId = 1008.obs;

  // RxBool isLoading = false.obs;

  RxList<WorkerModel> topWorkers = <WorkerModel>[].obs;

  RxList<WorkerModel> worstWorkers = <WorkerModel>[].obs;

  var pending = [].obs;
  var delivered = [].obs;
  var received = [].obs;
  var inventoryDone = [].obs;

  var roles = [
    {"id": 1008, "name": "Warehouse Worker"},
    {"id": 1009, "name": "Categorization Officer"},
    {"id": 1010, "name": "Dispatch Officer"},
    {"id": 1011, "name": "Washing Officer"},
    {"id": 1012, "name": "Repairing Officer"},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDeliveredDonations();
  }

  Future<void> acceptRequest(int donorRequestId) async {
    final prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId") ?? 0;

    var res = await http.post(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "Warehouse/AcceptDeliveredDonation"
        "?donorRequestId=$donorRequestId"
        "&userId=$userId",
      ),
    );

    print(res.body);

    if (res.statusCode == 200) {
      Get.snackbar("Success", "Worker Assigned");

      fetchDeliveredDonations();
    } else {
      Get.snackbar("Error", "Failed");
    }
  }

  void moveToWaiting(DeliveredDonationModel item) {
    deliveredList.remove(item); // Delivered se hatao
    waitingList.add(item); // Waiting me daalo
  }

  Future<void> registerWorker(RegisterWorkerModel model) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
          "${BaseapiController.BaseURL}WarehouseWorker/RegisterWorker?adminId=${model.adminId}",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Name": model.name,
          "Email": model.email,
          "PhoneNo": model.phone,
          "Password": model.password,
          "RoleId": model.roleId,
        }),
      );

      // print(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Worker Registered");
      } else {
        Get.snackbar("Error", "Failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDeliveredDonations() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt("userId") ?? 0;

      print("USER ID: $userId");

      var res = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}Warehouse/GetDeliveredDonations?userId=$userId",
        ),
      );

      print("API RESPONSE: ${res.body}");

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print("DATA TYPE: ${data.runtimeType}");
        print("FIRST ITEM: ${data[0]}");

        try {
          deliveredList.value = data
              .map<DeliveredDonationModel>(
                (e) => DeliveredDonationModel.fromJson(e),
              )
              .toList();
        } catch (e) {
          print("PARSE ERROR: $e");
        }

        print("LIST LENGTH: ${deliveredList.length}");
      } else {
        Get.snackbar("Error", "Failed to load");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWarehouseDonations() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;

      if (userId == 0) {
        Get.snackbar("Error", "User not found");
        return;
      }

      print("UserId: $userId"); // debug

      final response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}Warehouse/GetPendingDonationsByUser?userId=$userId",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        donations.value = data
            .map<PendingDonationModel>((e) => PendingDonationModel.fromJson(e))
            .toList();
      } else {
        Get.snackbar("Error", "Failed to load donations");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptPendingDonations(int donorRequestId) async {
    try {
      isLoading.value = true;

      int userId = await getAdminId();

      if (userId == 0) return;

      final url = Uri.parse(
        "${BaseapiController.BaseURL}"
        "Warehouse/UpdateDonationStatus"
        "?donorRequestId=$donorRequestId"
        "&userId=$userId",
      );

      var response = await http.post(url);

      print(response.body);

      var data = jsonDecode(response.body);

      /// 🔥 IF RESPONSE IS STRING
      if (data is String) {
        Get.snackbar("Message", data);
      }
      /// 🔥 IF RESPONSE IS OBJECT
      else {
        Get.snackbar("Success", data["Message"].toString());
      }

      fetchWarehouseDonations();
    } catch (e) {
      print(e);

      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTopWorstWorkers() async {
    try {
      isLoading.value = true;

      int adminId = await getAdminId();

      var response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}"
          "Warehouse/GetTopWorstWorkers"
          "?userId=$adminId",
        ),
      );

      print(response.statusCode);

      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        topWorkers.value = (data["TopWorkers"] as List)
            .map((e) => WorkerModel.fromJson(e))
            .toList();

        worstWorkers.value = (data["WorstWorkers"] as List)
            .map((e) => WorkerModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// GET ADMIN
  Future<int> getAdminId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId") ?? 0;
  }
}

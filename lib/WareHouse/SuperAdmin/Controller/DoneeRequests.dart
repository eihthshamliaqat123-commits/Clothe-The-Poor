import 'dart:convert';
import 'package:charity/WareHouse/SuperAdmin/Model.dart/superAdminAccDoneeR.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Doneerequests extends GetxController {
  RxList<SuperAdminDoneeRequestModel> doneeRequests =
      <SuperAdminDoneeRequestModel>[].obs;

  RxBool isLoading = false.obs;

  Future<void> getDoneeRequests() async {
    isLoading.value = true;

    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "SuperAdmin/GetDoneeRequests",
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      doneeRequests.value = data
          .map<SuperAdminDoneeRequestModel>(
            (e) => SuperAdminDoneeRequestModel.fromJson(e),
          )
          .toList();
    }

    isLoading.value = false;
  }

  Future<void> acceptDoneeRequest(int doneeRequestId) async {
    var response = await http.post(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "SuperAdmin/AcceptDoneeRequest"
        "?doneeRequestId=$doneeRequestId",
      ),
    );
    print(response.body);

    Get.snackbar("Message", response.body);

    getDoneeRequests();
  }

  // Future<void> approveRequest(int requestId) async {
  //   var response = await http.post(
  //     Uri.parse(
  //       "${BaseapiController.BaseURL}"
  //       "SuperAdmin/ApproveDoneeRequest"
  //       "?doneeRequestId=$requestId",
  //     ),
  //   );

  //   print(response.body);

  //   if (response.statusCode == 200) {
  //     Get.snackbar("Success", "Request Approved");

  //     fetchDoneeRequests();
  //   }
  // }
}

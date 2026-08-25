import 'dart:convert';
import 'package:charity/Donee/Model/DoneeRequestModel.dart';
import 'package:charity/Donee/Model/NearByWarehouse.dart';
import 'package:charity/Donee/Model/PackagingWorkerModel.dart';
import 'package:charity/Donee/Model/SortingItemModel.dart';
import 'package:charity/Donee/Model/SortingRating.dart';
import 'package:charity/Donee/Model/SortingWorkerModel.dart';
import 'package:charity/Donee/Model/SubmitRatingModel.dart';
import 'package:charity/Donee/Model/packageDetail.dart';
import 'package:charity/Donee/Screens/PackageDetail.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DoneeController extends GetxController {
  RxList<NearbyWarehouseModel> warehouses = <NearbyWarehouseModel>[].obs;

  String donorName = "Qulsum Bibi";
  RxDouble packagingRating = 1.0.obs;
  RxDouble DonorRating = 1.0.obs;

  Rxn<PackageDetailModel> selectedPackage = Rxn<PackageDetailModel>();

  RxMap<int, double> sortingRatings = <int, double>{}.obs;

  RxInt selectedWarehouseId = 0.obs;
  RxBool isLoading = false.obs;
  RxList<DoneeRequestModel> historyList = <DoneeRequestModel>[].obs;
  Rx<PackagingWorkerModel?> packagingWorker = Rx<PackagingWorkerModel?>(null);

  RxList<SortingWorkerModel> sortingWorkers = <SortingWorkerModel>[].obs;
  // RxList<RatingItems> ratingItems = <RatingItems>[].obs;

  // Future<bool> getPackageDetails(String qrCode) async {
  //   isLoading.value = true;

  //   try {
  //     var response = await http.get(
  //       Uri.parse(
  //         "${BaseapiController.BaseURL}"
  //         "Doneee/GetPackageDetails"
  //         "?qrCode=$qrCode",
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       selectedPackage.value = PackageDetailModel.fromJson(
  //         jsonDecode(response.body),
  //       );

  //       isLoading.value = false;

  //       return true;
  //     }

  //     isLoading.value = false;

  //     Get.snackbar("Error", "Package Not Found");

  //     return false;
  //   } catch (e) {
  //     isLoading.value = false;

  //     Get.snackbar("Error", e.toString());

  //     return false;
  //   }
  // }

  Future<void> createRequest(DoneeRequestModel model) async {
    try {
      isLoading.value = true;

      var response = await http.post(
        Uri.parse("${BaseapiController.BaseURL}Donee/CreateDoneeRequest"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode(model.toJson()),
      );

      print(response.statusCode);

      print(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Request Submitted Successfully");
      } else {
        var data = jsonDecode(response.body);

        Get.snackbar("Request", data["Message"] ?? "Request Failed");
      }
    } catch (e) {
      print(e);

      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId") ?? 0;

    var res = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}Donee/GetMyDoneeRequests?userId=$userId",
      ),
    );

    print(res.body);

    if (res.statusCode == 200) {
      // 🔥 JSON LIST
      final data = jsonDecode(res.body);

      // 🔥 CLEAR OLD DATA
      historyList.clear();

      // 🔥 LOOP
      for (var item in data) {
        historyList.add(DoneeRequestModel.fromJson(item));
      }
    }
  }

  Future<void> getRatingItems(int doneeRequestId) async {
    final res = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}Donee/GetDoneeRequestItems?doneeRequestId=$doneeRequestId",
      ),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);

      groupRatingItems(data);
    }
  }

  void groupRatingItems(List data) {
    if (data.isEmpty) return;

    packagingWorker.value = PackagingWorkerModel(
      workerId: data.first["PackagingWorkerId"],
      workerName: data.first["PackagingWorkerName"],
    );

    Map<int, SortingWorkerModel> map = {};

    for (var item in data) {
      int workerId = item["SortingWorkerId"];

      if (!map.containsKey(workerId)) {
        map[workerId] = SortingWorkerModel(
          workerId: workerId,
          workerName: item["SortingWorkerName"],
          items: [],
        );
      }

      map[workerId]!.items.add(SortingItemModel.fromJson(item));
    }

    sortingWorkers.value = map.values.toList();
  }

  Future<bool> getPackageDetails(String qrCode) async {
    try {
      print("========== QR ==========");
      print(qrCode);

      var url =
          "${BaseapiController.BaseURL}Donee/GetPackageDetails?qrCode=$qrCode";

      print(url);

      var response = await http.get(Uri.parse(url));

      print("STATUS = ${response.statusCode}");
      print("BODY = ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        selectedPackage.value = PackageDetailModel.fromJson(data);

        return true;
      }

      return false;
    } catch (e, s) {
      print("ERROR = $e");
      print(s);
      return false;
    }
  }

  Future<void> submitRating(SubmitRatingModel model) async {
    try {
      var response = await http.post(
        Uri.parse("${BaseapiController.BaseURL}Donee/SubmitWorkerRating"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(model.toJson()),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Rating Submitted");
        Get.back();
      } else {
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getNearestWarehouses() async {
    try {
      isLoading.value = true;

      warehouses.clear();

      final prefs = await SharedPreferences.getInstance();

      int userId = prefs.getInt("userId") ?? 0;

      final response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}"
          "Donee/GetNearbyWarehouses"
          "?userId=$userId",
        ),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        warehouses.value = data
            .map((e) => NearbyWarehouseModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void selectWarehouse(int id) {
    selectedWarehouseId.value = id;
  }

  // Future<void> submitRating(SubmitRatingModel model) async {
  //   try {
  //     isLoading.value = true;

  //     var response = await http.post(
  //       Uri.parse(
  //         "${BaseapiController.BaseURL}"
  //         "Doneee/SubmitWorkerRating",
  //       ),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(model.toJson()),
  //     );

  //     if (response.statusCode == 200) {
  //       Get.snackbar("Success", "Rating Submitted");
  //     } else {
  //       Get.snackbar("Error", response.body);
  //     }
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}

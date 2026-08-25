import 'dart:convert';
import 'package:charity/Donee/Model/SortingItemModel.dart';
import 'package:charity/Donee/Screens/packageQrScanner.dart';
import 'package:charity/WarehouseWorker/Model/AssignedDonationModel.dart';
import 'package:charity/WarehouseWorker/Model/CreatePackageModel.dart';
import 'package:charity/WarehouseWorker/Model/DeliveredDonation.dart';
import 'package:charity/WarehouseWorker/Model/InventoryModel.dart';
import 'package:charity/WarehouseWorker/Model/PackageItemModel.dart';
import 'package:charity/WarehouseWorker/Model/RateSortingItem.dart';
import 'package:charity/WarehouseWorker/Model/Size.dart';
import 'package:charity/WarehouseWorker/Model/WorkerDoneeItemModel.dart';
import 'package:charity/WarehouseWorker/Model/WorkerDoneeRequests.dart';
import 'package:charity/WarehouseWorker/Model/WorkerInventoryFSearch.dart';
import 'package:charity/WarehouseWorker/Model/packageDetail.dart';
import 'package:charity/WarehouseWorker/Screens/PackageQrScreen.dart';
import 'package:charity/baseUrl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WarehouseWorkerController extends GetxController {
  RxList<DeliveredDonationModel> Receiveddonation =
      <DeliveredDonationModel>[].obs;
  RxList<WorkerDoneeRequestModel> workerRequests =
      <WorkerDoneeRequestModel>[].obs;
  RxList<Map<String, dynamic>> washedDonations = <Map<String, dynamic>>[].obs;
  RxList<PackageItemModel> packageItems = <PackageItemModel>[].obs;

  RxList<WorkerInventoryModel> searchResult = <WorkerInventoryModel>[].obs;

  RxList<WorkerInventoryModel> selectedItems = <WorkerInventoryModel>[].obs;

  /// Selected Package
  Rxn<PackageDetailModel> selectedPackage = Rxn<PackageDetailModel>();

  /// Loading
  RxBool packageLoading = false.obs;

  var inventoryItems = <WorkerInventoryModel>[].obs;

  var selectedItemType = "".obs;
  var items = [].obs;
  RxBool isLoading = false.obs;
  RxList<SizeModel> sizes = <SizeModel>[].obs;
  RxList<AssignedDonationModel> assignedList = <AssignedDonationModel>[].obs;

  Future<void> fetchAssignedDonations() async {
    final prefs = await SharedPreferences.getInstance();

    int workerId = prefs.getInt("userId") ?? 0;

    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "WarehouseWorker/GetAssignedDonations"
        "?workerId=$workerId",
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      assignedList.value = data
          .map<AssignedDonationModel>((e) => AssignedDonationModel.fromJson(e))
          .toList();
    }
  }

  Future<void> fetchSizes() async {
    try {
      var res = await http.get(
        Uri.parse("${BaseapiController.BaseURL}Warehouse/GetSizes"),
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        sizes.value = data
            .map<SizeModel>((e) => SizeModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> getPackageDetails(String qrCode) async {
    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "WarehouseWorker/GetPackageDetails"
        "?qrCode=$qrCode",
      ),
    );

    if (response.statusCode == 200) {
      print('final response ${response.body}');
      // selectedPackage.value = PackageDetailModel.fromJson(
      //   jsonDecode(response.body),
      // );
      var data = jsonDecode(response.body);

      print(data.runtimeType);
    }
  }

  Future<void> searchInventory(WorkerRequestItemModel item) async {
    final prefs = await SharedPreferences.getInstance();

    int workerId = prefs.getInt("userId") ?? 0;

    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "WarehouseWorker/SearchInventory"
        "?workerId=$workerId"
        "&itemType=${item.itemType}"
        "&category=${item.category}"
        "&color=${item.color}"
        "&season=${item.season}"
        "&sizeId=${item.sizeId}",
      ),
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var data = jsonDecode(response.body);

      searchResult.value = data
          .map<WorkerInventoryModel>((e) => WorkerInventoryModel.fromJson(e))
          .toList();
      // print("Total Items = ${searchResult.length}");
    }
  }

  void addToPackage(WorkerInventoryModel item) {
    if (packageItems.any((x) => x.inventoryId == item.inventoryId)) {
      Get.snackbar("Already Added", "This item is already inside package");

      return;
    }

    packageItems.add(
      PackageItemModel(
        inventoryId: item.inventoryId,

        qrCode: item.qrCode,

        itemType: item.itemType,

        category: item.category,

        color: item.color,
      ),
    );
  }

  void removeItem(int inventoryId) {
    packageItems.removeWhere((x) => x.inventoryId == inventoryId);
  }

  Future<void> createPackage(
    int doneeeRequestId,
    List<WorkerInventoryModel> items,
  ) async {
    try {
      int workerId = await getWorkerId();

      CreatePackageModel model = CreatePackageModel(
        doneeRequestId: doneeeRequestId,

        dispatchingWorkerId: workerId,

        inventoryIds: items.map((e) => e.inventoryId).toList(),
      );

      print("========== CREATE PACKAGE ==========");
      print(model.toJson());

      var response = await http.post(
        Uri.parse("${BaseapiController.BaseURL}WarehouseWorker/CreatePackage"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode(model.toJson()),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Package Created");
        var data = jsonDecode(response.body);

        String qrCode = data["QRCode"];
        Get.off(() => PackageQRScreen(qrCode: qrCode));
        packageItems.clear();

        getWorkerDoneeRequests();
      } else {
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      print(e);

      Get.snackbar("Error", e.toString());
    }
  }

  //int SourceId, int Rating
  Future<void> postRating(Ratesortingitem item) async {
    int? SourceId = 4032;

    try {
      var response = await http.post(
        Uri.parse(
          "${BaseapiController.BaseURL}WarehouseWorker/PostRating?SourceId=$SourceId",
        ),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Rating Submitted");
      } else {
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      print(e);

      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> addInventoryItem(InventoryModel model) async {
    var response = await http.post(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "WarehouseWorker/AddInventoryItem",
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    print(response.body);

    if (response.statusCode == 200) {
      Get.snackbar("Success", "Item Added");
    } else {
      Get.snackbar("Error", "Failed");
    }
  }

  Future<void> fetchInventoryByType(String itemType) async {
    final prefs = await SharedPreferences.getInstance();

    int workerId = prefs.getInt("userId") ?? 0;

    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "Warehouse/GetWarehouseInventoryByType"
        "?workerId=$workerId"
        "&itemType=$itemType",
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      inventoryItems.value = (data as List)
          .map((e) => WorkerInventoryModel.fromJson(e))
          .toList();
    }
  }

  Future<void> readyDoneeeRequest(int doneeeRequestId) async {
    try {
      var response = await http.post(
        Uri.parse(
          "${BaseapiController.BaseURL}"
          "WarehouseWorker/ReadyDoneeeRequest"
          "?doneeeRequestId=$doneeeRequestId",
        ),
      );

      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        Get.snackbar("Success", data["Message"]);

        if (data["QRCode"] != null) {
          Get.to(() => PackageQRScreen(qrCode: data["QRCode"]));
        }

        getWorkerDoneeRequests();
      } else {
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> getWorkerDoneeRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int workerId = prefs.getInt("userId") ?? 0;

    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "WarehouseWorker/GetWorkerDoneeRequests"
        "?workerId=$workerId",
      ),
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print("API Count = ${data.length}");

      workerRequests.value = data
          .map<WorkerDoneeRequestModel>(
            (e) => WorkerDoneeRequestModel.fromJson(e),
          )
          .toList();

      print("Model Count = ${workerRequests.length}");

      for (var r in workerRequests) {
        print(
          "Request ${r.doneeRequestId} | Recipient=${r.recipentId} | Items=${r.items.length}",
        );
      }
    }
  }

  Future<void> getWashedDonations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int userId = prefs.getInt("userId") ?? 0;

      var response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}"
          "WarehouseWorker/GetWashedDonations"
          "?userId=$userId",
        ),
      );

      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        washedDonations.value = List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<bool> validateWorkerQR(int workerId) async {
    var response = await http.post(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "WarehouseWorker/ValidateWorkerQR"
        "?workerId=$workerId",
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data["Success"] == true) {
        return true;
      } else {
        Get.snackbar("Error", data["Message"]);

        return false;
      }
    }

    return false;
  }

  Future<int> getWorkerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId") ?? 0;
  }
}

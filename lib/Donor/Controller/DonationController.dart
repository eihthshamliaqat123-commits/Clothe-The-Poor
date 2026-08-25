import 'dart:convert';
import 'dart:io';

import 'package:charity/Donor/Model/DonationHistoryModel.dart';
import 'package:charity/Donor/Model/DonationImageModel.dart';
import 'package:charity/Donor/Model/WarehouseZoneModel.dart';
import 'package:charity/baseUrl.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DonorRequestController extends GetxController {
  // =====================================================
  // IMAGE PICKER
  // =====================================================

  RxList<DonationImageModel> donationImages = <DonationImageModel>[].obs;

  final ImagePicker _picker = ImagePicker();

  File? selectedImage;

  // =====================================================
  // LOADING
  // =====================================================

  RxBool isLoading = false.obs;

  // =====================================================
  // FORM DATA
  // =====================================================

  String comments = "";

  double? latitude;
  double? longitude;

  DateTime? scheduledTime;

  // =====================================================
  // PROFILE
  // =====================================================

  RxString name = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString location = "".obs;

  // =====================================================
  // PENDING REQUESTS
  // =====================================================

  RxList<Map<String, dynamic>> pendingRequests = <Map<String, dynamic>>[].obs;

  // =====================================================
  // HISTORY
  // =====================================================

  RxList<DonationHistoryModel> history = <DonationHistoryModel>[].obs;

  // =====================================================
  // WAREHOUSES
  // =====================================================

  RxList<WarehouseZoneModel> warehouses = <WarehouseZoneModel>[].obs;

  int? selectedWarehouseId;

  // =====================================================
  // INIT
  // =====================================================

  @override
  void onInit() {
    super.onInit();

    fetchProfile();

    fetchMyPendingRequests();

    fetchDonationHistory();
  }

  // =====================================================
  // FETCH PROFILE
  // =====================================================

  Future<void> fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      int userId = prefs.getInt("userId") ?? 0;

      if (userId == 0) return;

      var response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}Donor/GetDonorProfile?userId=$userId",
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        name.value = data["Name"] ?? "";

        email.value = data["Email"] ?? "";

        phone.value = data["Phone"] ?? "";

        location.value = data["Location"] ?? "";
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> getDonationImages(int donorRequestId) async {
    var response = await http.get(
      Uri.parse(
        "${BaseapiController.BaseURL}"
        "Donor/GetDonationImages"
        "?donorRequestId=$donorRequestId",
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      donationImages.value = (data as List)
          .map((e) => DonationImageModel.fromJson(e))
          .toList();
    }
  }
  // =====================================================
  // FETCH PENDING REQUESTS
  // =====================================================

  Future<void> fetchMyPendingRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      int userId = prefs.getInt("userId") ?? 0;

      if (userId == 0) return;

      isLoading.value = true;

      final response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}Donor/GetPendingRequests?userId=$userId",
        ),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        pendingRequests.clear();

        pendingRequests.value = data.map<Map<String, dynamic>>((e) {
          return {
            "id": e["DonorRequestId"],

            "comments": e["Comments"] ?? "",

            "time": e["ScheduledTime"] != null
                ? DateTime.parse(e["ScheduledTime"])
                : DateTime.now(),

            "status": e["Status"] ?? 0,
          };
        }).toList();
      } else {
        Get.snackbar("Error", "Failed to load requests");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // FETCH DONATION HISTORY
  // =====================================================

  Future<void> fetchDonationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      int userId = prefs.getInt("userId") ?? 0;

      var response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}Donor/GetDonorRequestsByUserId?userId=$userId",
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        history.value = (data as List)
            .map((e) => DonationHistoryModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // =====================================================
  // PICK IMAGE
  // =====================================================

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (image != null) {
        selectedImage = File(image.path);

        update();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // =====================================================
  // BASE64 IMAGE
  // =====================================================

  String? getBase64Image() {
    if (selectedImage == null) return null;

    final bytes = selectedImage!.readAsBytesSync();

    return base64Encode(bytes);
  }

  // =====================================================
  // GET NEAREST WAREHOUSES
  // =====================================================

  Future<void> getNearestWarehouses(double lat, double lng) async {
    try {
      isLoading.value = true;

      warehouses.clear();

      final response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}Warehouse/GetNearbyWarehouses?latitude=$lat&longitude=$lng",
        ),
      );

      print(response.statusCode);

      print(response.body);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        warehouses.value = data
            .map((e) => WarehouseZoneModel.fromJson(e))
            .toList();

        print("WAREHOUSES => ${warehouses.length}");

        update();
      } else {
        Get.snackbar("Error", "No warehouses found");
      }
    } catch (e) {
      print(e);

      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;

      update();
    }
  }

  // =====================================================
  // SELECT WAREHOUSE
  // =====================================================

  void selectWarehouse(int id) {
    selectedWarehouseId = id;

    update();
  }

  // =====================================================
  // SUBMIT DONOR REQUEST
  // =====================================================

  Future<void> submitDonorRequest() async {
    if (selectedImage == null) {
      Get.snackbar("Error", "Please capture image");

      return;
    }

    if (selectedWarehouseId == null) {
      Get.snackbar("Error", "Please select warehouse");

      return;
    }

    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();

      int userId = prefs.getInt("userId") ?? 0;

      if (userId == 0) {
        Get.snackbar("Error", "User not logged in");

        return;
      }

      final body = {
        "UserId": userId,

        "DonationImageUrl": getBase64Image(),

        "Comments": comments,

        "Latitude": latitude,

        "Longitude": longitude,

        "ScheduledTime": scheduledTime?.toIso8601String(),

        "WarehouseId": selectedWarehouseId,
      };

      final response = await http.post(
        Uri.parse("${BaseapiController.BaseURL}Donor/AddDonorRequest"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode(body),
      );

      print(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Donation Request Added");

        clearForm();

        fetchMyPendingRequests();

        fetchDonationHistory();
      } else {
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // CLEAR FORM
  // =====================================================

  void clearForm() {
    selectedImage = null;

    comments = "";

    latitude = null;

    longitude = null;

    scheduledTime = null;

    selectedWarehouseId = null;

    warehouses.clear();

    update();
  }
}

import 'dart:convert';
import 'package:charity/Donee/Screens/Dashboard.dart';
import 'package:charity/Donor/Screens/Dashboard.dart';
import 'package:charity/Rider/Screens/Dashboard.dart';
import 'package:charity/WareHouse/SuperAdmin/Screens/Dashboard.dart';
import 'package:charity/WareHouse/SuperAdmin/Screens/WarehouseAdmin.dart';
import 'package:charity/WarehouseWorker/Screens/CateDashboard.dart';
import 'package:charity/WarehouseWorker/Screens/DisDashboard.dart';
import 'package:charity/WarehouseWorker/Screens/WashDashboard.dart';
import 'package:charity/baseUrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupController {
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNo,
    required int roleId,
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse("${BaseapiController.BaseURL}SignUp/SignUpUser");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Name": name,
          "Email": email,
          "Password": password,
          "PhoneNo": phoneNo,
          "RoleId": roleId,
          "Latitude": latitude,
          "Longitude": longitude,
        }),
      );

      final body = jsonDecode(response.body);

      return {"statusCode": response.statusCode, "body": body};
    } catch (e) {
      return {
        "statusCode": 500,
        "body": {"Message": "Something went wrong", "Error": e.toString()},
      };
    }
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}SignUp/Login?email=$email&password=$password",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["Success"] == false) {
          Get.snackbar(
            "Blocked",

            data["Message"],

            backgroundColor: Colors.red,

            colorText: Colors.white,
          );

          return;
        }

        print(data);

        int userId = data['UserId'];
        int roleId = data['RoleId'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);
        await prefs.setInt('roleId', roleId);

        print("Saved UserId => $userId");

        print("Saved UserId => ${prefs.getInt('userId')}");
        switch (roleId) {
          case 5:
            Get.offAll(() => DonorDashboard());
            break;

          case 6:
            Get.offAll(() => DoneeDashboard());
            break;

          case 7:
            Get.offAll(() => RiderDashboard());
            break;

          case 8:
            Get.offAll(() => SuperAdminDashboard());
            break;
          case 9:
            Get.offAll(() => WarehouseAdmin());
          case 1009:
            Get.offAll(() => CategorizationDashboard());
            break;

          case 1010:
            Get.offAll(() => DispatchingDashboard());
            break;

          case 1011:
            Get.offAll(() => WashingDashboard());

          default:
            Get.snackbar("Error", "Invalid role");
        }
      } else {
        Get.snackbar("Error", "Invalid email or password");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error, try again");
    }
  }

  // static Future<Map<String, dynamic>> logout({required int userId}) async {
  //   final url = Uri.parse("$baseUrl/Logout?userId=$userId");

  //   try {
  //     final response = await http.get(url);

  //     final body = jsonDecode(response.body);

  //     return {"statusCode": response.statusCode, "body": body};
  //   } catch (e) {
  //     return {
  //       "statusCode": 500,
  //       "body": {"Message": "Something went wrong", "Error": e.toString()},
  //     };
  //   }
  // }
}

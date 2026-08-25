import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:charity/baseUrl.dart';

class AdminService {
  static Future<Map<String, dynamic>> createAdmin({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int warehouseId,
  }) async {
    final url = Uri.parse("${BaseapiController.BaseURL}SuperAdmin/CreateAdmin");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Name": name,
          "Email": email,
          "Password": password,
          "PhoneNo": phone,
          "WarehouseId": warehouseId,
        }),
      );

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body),
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "body": {"Message": e.toString()},
      };
    }
  }

  static Future<List> getAdmins() async {
    final response = await http.get(
      Uri.parse("${BaseapiController.BaseURL}Admin/GetAdmins"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }
}

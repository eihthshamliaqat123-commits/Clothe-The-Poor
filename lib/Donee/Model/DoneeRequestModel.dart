import 'package:charity/Donee/Model/RequestItemModel.dart';

class DoneeRequestModel {
  int? doneeRequestId;

  int userId;

  int recipentId;

  String scheduledTime;

  double latitude;

  double longitude;

  String? ngoName;

  String? behalfName;

  String? behalfContact;

  String? identityImage;

  int? warehouseId;

  List<DoneeItemModel> items;

  DoneeRequestModel({
    this.doneeRequestId,
    required this.userId,
    required this.recipentId,
    required this.scheduledTime,
    required this.latitude,
    required this.longitude,
    this.ngoName,
    this.behalfName,
    this.behalfContact,
    this.identityImage,
    this.warehouseId,
    required this.items,
  });

  factory DoneeRequestModel.fromJson(Map<String, dynamic> json) {
    return DoneeRequestModel(
      doneeRequestId: json["DoneeRequestId"],

      userId: json["UserId"] ?? 0,

      recipentId: json["RecipentId"] ?? 0,

      scheduledTime: json["ScheduledTime"] ?? "",

      latitude: (json["Latitude"] ?? 0).toDouble(),

      longitude: (json["Longitude"] ?? 0).toDouble(),

      ngoName: json["NGOName"],

      // 🔥 IMPORTANT
      behalfName: json["BehalfName"],

      // 🔥 IMPORTANT
      behalfContact: json["BehalfContact"],

      identityImage: json["IdentityImage"],

      items: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "UserId": userId,
      "RecipentId": recipentId,
      "ScheduledTime": scheduledTime,
      "Latitude": latitude,
      "Longitude": longitude,
      "NGOName": ngoName,
      "BehalfName": behalfName,
      "BehalfContact": behalfContact,
      "IdentityImage": identityImage,
      "WareHouseId": warehouseId,
      "Items": items.map((e) => e.toJson()).toList(),
    };
  }
}

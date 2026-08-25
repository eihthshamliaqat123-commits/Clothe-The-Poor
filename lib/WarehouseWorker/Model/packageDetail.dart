import 'package:charity/WarehouseWorker/Model/packageInventoryModel.dart';

class PackageDetailModel {
  int packageId;
  String qrCode;

  List<PackageInventoryModel> items;

  PackageDetailModel({
    required this.packageId,
    required this.qrCode,
    required this.items,
  });

  factory PackageDetailModel.fromJson(Map<String, dynamic> json) {
    return PackageDetailModel(
      packageId: json["PackageId"] ?? 0,
      qrCode: json["QRCode"] ?? "",
      items: (json["Items"] as List? ?? [])
          .map((e) => PackageInventoryModel.fromJson(e))
          .toList(),
    );
  }
}

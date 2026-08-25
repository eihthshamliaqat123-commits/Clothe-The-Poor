import 'package:charity/Donee/Model/packageItem.dart';

class PackageDetailModel {
  int packageId;

  String qrCode;

  int doneeRequestId;

  int packagingWorkerId;

  String packagingWorkerName;

  List<PackageItemModel> items;

  PackageDetailModel({
    required this.packageId,
    required this.qrCode,
    required this.doneeRequestId,
    required this.packagingWorkerId,
    required this.packagingWorkerName,
    required this.items,
  });

  factory PackageDetailModel.fromJson(Map<String, dynamic> json) {
    return PackageDetailModel(
      packageId: json["PackageId"] ?? 0,

      qrCode: json["QRCode"] ?? "",

      doneeRequestId: json["DoneeRequestId"] ?? 0,

      packagingWorkerId: (json["Items"] as List).isNotEmpty
          ? json["Items"][0]["PackagingWorkerId"]
          : 0,

      packagingWorkerName: (json["Items"] as List).isNotEmpty
          ? json["Items"][0]["PackagingWorkerName"] ?? ""
          : "",

      items: (json["Items"] as List)
          .map((e) => PackageItemModel.fromJson(e))
          .toList(),
    );
  }
}

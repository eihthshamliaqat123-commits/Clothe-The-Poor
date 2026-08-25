import 'package:charity/WarehouseWorker/Model/WorkerDoneeItemModel.dart';

class WorkerDoneeRequestModel {
  int doneeRequestId;
  String? ngoName;
  String? behalfName;
  int? recipentId;

  List<WorkerRequestItemModel> items;

  WorkerDoneeRequestModel({
    required this.doneeRequestId,
    this.ngoName,
    this.behalfName,
    this.recipentId,
    required this.items,
  });

  factory WorkerDoneeRequestModel.fromJson(Map<String, dynamic> json) {
    return WorkerDoneeRequestModel(
      doneeRequestId: json['DoneeRequestId'] ?? 0,

      ngoName: json['NGOName'] ?? "",

      behalfName: json['BehalfName'] ?? "",

      recipentId: json['RecipentId'] ?? 0,

      items: json['Items'] == null
          ? []
          : (json['Items'] as List)
                .map((e) => WorkerRequestItemModel.fromJson(e))
                .toList(),
    );
  }
}

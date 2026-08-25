import 'package:charity/WareHouse/AdminWarehouse/Models/TranserItemModel.dart';

class TransferRequestModel {
  int warehouseRequestId;

  String requestingWarehouse;

  String notes;

  List<TransferItemModel> items;

  TransferRequestModel({
    required this.warehouseRequestId,

    required this.requestingWarehouse,

    required this.notes,

    required this.items,
  });

  factory TransferRequestModel.fromJson(Map<String, dynamic> json) {
    return TransferRequestModel(
      warehouseRequestId: json["WarehouseRequestId"],

      requestingWarehouse: json["RequestingWarehouseName"],

      notes: json["Notes"] ?? "",

      items: (json["RequestedItems"] as List)
          .map((e) => TransferItemModel.fromJson(e))
          .toList(),
    );
  }
}

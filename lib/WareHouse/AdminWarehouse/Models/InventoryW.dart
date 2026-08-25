class InventoryModel {
  int inventoryId;

  String itemType;

  String category;

  String size;

  String qrCode;

  InventoryModel({
    required this.inventoryId,

    required this.itemType,

    required this.category,

    required this.size,

    required this.qrCode,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      inventoryId: json["InventoryId"],

      itemType: json["ItemType"],

      category: json["Category"],

      size: json["Size"],

      qrCode: json["QRCode"] ?? "",
    );
  }
}

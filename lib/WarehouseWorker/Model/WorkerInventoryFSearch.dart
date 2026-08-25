class WorkerInventoryModel {
  int inventoryId;
  String qrCode;
  String itemType;
  String category;
  String season;
  String condition;
  String? color;
  int quantity;
  int sizeId;

  WorkerInventoryModel({
    required this.inventoryId,
    required this.qrCode,
    required this.itemType,
    required this.category,
    required this.season,
    required this.condition,
    this.color,
    required this.quantity,
    required this.sizeId,
  });

  factory WorkerInventoryModel.fromJson(Map<String, dynamic> json) {
    return WorkerInventoryModel(
      inventoryId: json["InventoryId"] ?? 0,

      qrCode: json["QRCode"] ?? "",

      itemType: json["ItemType"] ?? "",

      category: json["Category"] ?? "",

      season: json["Season"] ?? "",

      condition: json["Condition"] ?? "",

      color: json["Color"],

      quantity: json["Quantity"] ?? 1,

      sizeId: json["SizeId"] ?? 0,
    );
  }
}

class InventoryModel {
  // DONOR ya DONEE
  String sourceType;

  // DonorRequestId ya DoneeRequestId
  int sourceId;

  // Base64 image
  String itemImage;

  String itemType;

  String category;

  String season;

  String condition;

  int sizeId;

  // int quantity;

  int status;

  String color;

  // Worker jisne item add kiya
  int userId;

  // ⭐ Item kis warehouse ka stock hai

  InventoryModel({
    required this.sourceType,
    required this.sourceId,
    required this.itemImage,
    required this.itemType,
    required this.category,
    required this.season,
    required this.condition,
    required this.sizeId,
    // required this.quantity,
    required this.status,
    required this.color,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      "SourceType": sourceType,
      "SourceId": sourceId,
      "ItemImage": itemImage,
      "ItemType": itemType,
      "Category": category,
      "Season": season,
      "Condition": condition,
      "SizeId": sizeId,
      // "Quantity": quantity,
      "Status": status,
      "Color": color,
      "UserId": userId,

      // ⭐ New field
      //   "WarehouseId": warehouseId,
    };
  }
}

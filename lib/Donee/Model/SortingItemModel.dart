class SortingItemModel {
  int inventoryId;

  String itemType;

  String category;

  String season;

  String color;

  int sizeId;

  String qrCode;

  double rating;

  SortingItemModel({
    required this.inventoryId,
    required this.itemType,
    required this.category,
    required this.season,
    required this.color,
    required this.sizeId,
    required this.qrCode,
    this.rating = 5,
  });

  factory SortingItemModel.fromJson(Map<String, dynamic> json) {
    return SortingItemModel(
      inventoryId: json["InventoryId"] ?? 0,
      itemType: json["ItemType"] ?? "",
      category: json["Category"] ?? "",
      season: json["Season"] ?? "",
      color: json["Color"] ?? "",
      sizeId: json["SizeId"] ?? 0,

      qrCode: json["QRCode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"InventoryId": inventoryId, "Rating": rating};
  }
}

class SortingItemModel {
  int inventoryId;

  String qrCode;

  String itemType;

  String category;

  String season;

  String color;

  int sizeId;

  double rating;

  SortingItemModel({
    required this.inventoryId,

    required this.qrCode,

    required this.itemType,

    required this.category,

    required this.season,

    required this.color,

    required this.sizeId,

    this.rating = 5,
  });

  factory SortingItemModel.fromJson(Map<String, dynamic> json) {
    return SortingItemModel(
      inventoryId: json["InventoryId"],

      qrCode: json["QRCode"] ?? "",

      itemType: json["ItemType"] ?? "",

      category: json["Category"] ?? "",

      season: json["Season"] ?? "",

      color: json["Color"] ?? "",

      sizeId: json["SizeId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {"InventoryId": inventoryId, "Rating": rating};
  }
}

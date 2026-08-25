class DonationImageModel {
  int inventoryId;

  String itemImage;

  String itemType;

  String category;

  String color;

  String season;

  int sizeId;

  DonationImageModel({
    required this.inventoryId,

    required this.itemImage,

    required this.itemType,

    required this.category,

    required this.color,

    required this.season,

    required this.sizeId,
  });

  factory DonationImageModel.fromJson(Map<String, dynamic> json) {
    return DonationImageModel(
      inventoryId: json["InventoryId"],

      itemImage: json["ItemImage"],

      itemType: json["ItemType"],

      category: json["Category"],

      color: json["Color"],

      season: json["Season"],

      sizeId: json["SizeId"],
    );
  }
}

class TransferItemModel {
  int warehouseRequestedItemId;

  String itemType;

  String category;

  String season;

  String size;

  int quantity;

  TransferItemModel({
    required this.warehouseRequestedItemId,

    required this.itemType,

    required this.category,

    required this.season,

    required this.size,

    required this.quantity,
  });

  factory TransferItemModel.fromJson(Map<String, dynamic> json) {
    return TransferItemModel(
      warehouseRequestedItemId: json["WarehouseRequestedItemId"],

      itemType: json["ItemType"],

      category: json["Category"],

      season: json["Season"],

      size: json["Size"],

      quantity: json["Quantity"],
    );
  }
}

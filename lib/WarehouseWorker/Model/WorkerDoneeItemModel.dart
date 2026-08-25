class WorkerRequestItemModel {
  String itemType;
  String category;
  String season;
  int quantity;
  int sizeId;
  String? color;

  WorkerRequestItemModel({
    required this.itemType,
    required this.category,
    required this.season,
    required this.quantity,
    required this.sizeId,
    this.color,
  });

  factory WorkerRequestItemModel.fromJson(Map<String, dynamic> json) {
    return WorkerRequestItemModel(
      itemType: json["ItemType"] ?? "",
      category: json["Category"] ?? "",
      season: json["Season"] ?? "",
      quantity: json["Quantity"] ?? 0,
      sizeId: json["SizeId"] ?? 0,
      color: json["Color"], // Capital C
    );
  }
}

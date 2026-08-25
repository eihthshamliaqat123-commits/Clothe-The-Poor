class DoneeItemModel {
  String itemType;
  String category;
  String season;
  String color;
  int sizeId;
  int quantity;

  DoneeItemModel({
    required this.itemType,
    required this.category,
    required this.season,
    required this.color,
    required this.sizeId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      "ItemType": itemType,
      "Category": category,
      "Season": season,
      "Color": color, // 🔥 NEW
      "SizeId": sizeId,
      "Quantity": quantity,
    };
  }
}

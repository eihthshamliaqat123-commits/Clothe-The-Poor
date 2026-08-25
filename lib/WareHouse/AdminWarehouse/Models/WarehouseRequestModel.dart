class WarehouseRequestItem {
  String itemType;
  String category;
  String size;
  String season;
  int quantity;

  WarehouseRequestItem({
    required this.itemType,
    required this.category,
    required this.size,
    required this.season,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      "ItemType": itemType,
      "Category": category,
      "Size": size,
      "Season": season,
      "Quantity": quantity,
    };
  }
}

class WarehouseRequestModel {
  int requestingWarehouseId;
  String notes;
  List<WarehouseRequestItem> items;

  WarehouseRequestModel({
    required this.requestingWarehouseId,
    required this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "RequestingWarehouseId": requestingWarehouseId,
      "Notes": notes,
      "Items": items.map((e) => e.toJson()).toList(),
    };
  }
}

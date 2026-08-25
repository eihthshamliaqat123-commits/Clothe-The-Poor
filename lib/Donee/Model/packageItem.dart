class PackageItemModel {
  int inventoryId;

  String itemType;

  String category;

  String season;

  String color;

  int sizeId;
  int requestedItemId;

  int sortingWorkerId;

  String sortingWorkerName;
  double rating;

  PackageItemModel({
    required this.inventoryId,
    required this.itemType,
    required this.category,
    required this.season,
    required this.color,
    required this.sizeId,
    required this.requestedItemId,
    required this.sortingWorkerId,
    required this.sortingWorkerName,
    this.rating = 1,
  });

  factory PackageItemModel.fromJson(Map<String, dynamic> json) {
    return PackageItemModel(
      inventoryId: json["InventoryId"] ?? 0,

      itemType: json["ItemType"],

      category: json["Category"],

      season: json["Season"],

      color: json["Color"] ?? "",

      sizeId: json["SizeId"] ?? 0,
      requestedItemId: json["RequestedItemId"] ?? 0,
      sortingWorkerId: json["SortingWorkerId"] ?? 0,

      sortingWorkerName: json["SortingWorkerName"] ?? "",
    );
  }
}

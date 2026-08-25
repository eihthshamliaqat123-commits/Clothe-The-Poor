class PackageInventoryModel {
  int inventoryId;

  String itemType;

  String category;

  String season;

  String color;

  String condition;

  int sizeId;

  int sortingWorkerId;

  String sortingWorkerName;

  int packagingWorkerId;

  String packagingWorkerName;

  PackageInventoryModel({
    required this.inventoryId,
    required this.itemType,
    required this.category,
    required this.season,
    required this.color,
    required this.condition,
    required this.sizeId,
    required this.sortingWorkerId,
    required this.sortingWorkerName,
    required this.packagingWorkerId,
    required this.packagingWorkerName,
  });

  factory PackageInventoryModel.fromJson(Map<String, dynamic> json) {
    return PackageInventoryModel(
      inventoryId: json["InventoryId"] ?? 0,
      itemType: json["ItemType"] ?? "",
      category: json["Category"] ?? "",
      season: json["Season"] ?? "",
      color: json["Color"] ?? "",
      condition: json["Condition"] ?? "",
      sizeId: json["SizeId"] ?? 0,
      sortingWorkerId: json["SortingWorkerId"] ?? 0,
      sortingWorkerName: json["SortingWorkerName"] ?? "",
      packagingWorkerId: json["PackagingWorkerId"] ?? 0,
      packagingWorkerName: json["PackagingWorkerName"] ?? "",
    );
  }
}

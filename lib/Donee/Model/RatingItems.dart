class RatingItems {
  int? requestedItemId;
  int? inventoryId;

  String? itemType;
  String? category;
  String? color;

  String? qrCode; // <-- ADD

  int quantity;

  int? sortingWorkerId;
  String? sortingWorkerName;

  int? packagingWorkerId;
  String? packagingWorkerName;

  double sortingRating;
  double packagingRating;

  String sortingFeedback;
  String packagingFeedback;

  RatingItems({
    this.requestedItemId,
    this.inventoryId,
    this.itemType,
    this.category,
    this.color,
    this.qrCode,
    required this.quantity,
    this.sortingWorkerId,
    this.sortingWorkerName,
    this.packagingWorkerId,
    this.packagingWorkerName,
    this.sortingRating = 5,
    this.packagingRating = 5,
    this.sortingFeedback = "",
    this.packagingFeedback = "",
  });

  factory RatingItems.fromJson(Map<String, dynamic> json) {
    return RatingItems(
      requestedItemId: json["RequestedItemId"] ?? 0,
      inventoryId: json["InventoryId"] ?? 0,

      itemType: json["ItemType"] ?? "",
      category: json["Category"] ?? "",
      color: json["Color"] ?? "",

      qrCode: json["QRCode"] ?? "",

      quantity: json["Quantity"] ?? 0,

      sortingWorkerId: json["SortingWorkerId"] ?? 0,
      sortingWorkerName: json["SortingWorkerName"] ?? "",

      packagingWorkerId: json["PackagingWorkerId"] ?? 0,
      packagingWorkerName: json["PackagingWorkerName"] ?? "",

      sortingRating: (json["SortingRating"] ?? 5).toDouble(),
      packagingRating: (json["PackagingRating"] ?? 5).toDouble(),

      sortingFeedback: json["SortingFeedback"] ?? "",
      packagingFeedback: json["PackagingFeedback"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "RequestedItemId": requestedItemId,
      "InventoryId": inventoryId,

      "SortingWorkerId": sortingWorkerId,
      "PackagingWorkerId": packagingWorkerId,

      "SortingRating": sortingRating,
      "PackagingRating": packagingRating,

      "SortingFeedback": sortingFeedback,
      "PackagingFeedback": packagingFeedback,
    };
  }
}

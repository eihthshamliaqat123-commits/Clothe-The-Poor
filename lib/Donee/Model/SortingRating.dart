class SortingRatingModel {
  int inventoryId;
  int requestedItemId;
  int workerId;
  int rating;

  SortingRatingModel({
    required this.inventoryId,
    required this.requestedItemId,
    required this.workerId,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      "InventoryId": inventoryId,
      "RequestedItemId": requestedItemId,
      "WorkerId": workerId,
      "Rating": rating,
    };
  }
}

class CreatePackageModel {
  int doneeRequestId;

  int dispatchingWorkerId;

  List<int> inventoryIds;

  CreatePackageModel({
    required this.doneeRequestId,

    required this.dispatchingWorkerId,

    required this.inventoryIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "DoneeRequestId": doneeRequestId,

      "DispatchingWorkerId": dispatchingWorkerId,

      "InventoryIds": inventoryIds,
    };
  }
}

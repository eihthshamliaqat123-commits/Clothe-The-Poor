class WarehouseTransferModel {
  int warehouseRequestId;

  List<int> inventoryIds;

  WarehouseTransferModel({
    required this.warehouseRequestId,

    required this.inventoryIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "WarehouseRequestId": warehouseRequestId,

      "InventoryIds": inventoryIds,
    };
  }
}

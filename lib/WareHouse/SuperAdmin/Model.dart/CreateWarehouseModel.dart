class CreateWarehouseModel {
  String wareHouseName;
  int zoneId;

  CreateWarehouseModel({required this.wareHouseName, required this.zoneId});

  Map<String, dynamic> toJson() {
    return {"WareHouseName": wareHouseName, "ZoneId": zoneId};
  }
}

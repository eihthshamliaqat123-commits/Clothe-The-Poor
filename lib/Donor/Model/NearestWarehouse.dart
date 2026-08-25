class WarehouseZoneModel {
  int id;
  String name;
  double distance;

  WarehouseZoneModel({
    required this.id,
    required this.name,
    required this.distance,
  });

  factory WarehouseZoneModel.fromJson(Map<String, dynamic> json) {
    return WarehouseZoneModel(
      id: json["WareHouseId"] ?? 0,

      name: json["WareHouseName"] ?? "",

      distance: (json["DistanceKm"] ?? 0).toDouble(),
    );
  }
}

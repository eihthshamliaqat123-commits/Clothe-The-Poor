class WarehouseZoneModel {
  int id;
  String name;
  String zoneName;
  double distance;

  WarehouseZoneModel({
    required this.id,
    required this.name,
    required this.zoneName,
    required this.distance,
  });

  factory WarehouseZoneModel.fromJson(Map<String, dynamic> json) {
    return WarehouseZoneModel(
      id: json['WareHouseId'],
      name: json['WareHouseName'],
      zoneName: json['ZoneName'],
      distance: (json['DistanceKm'] ?? 0).toDouble(),
    );
  }
}

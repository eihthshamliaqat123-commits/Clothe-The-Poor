class NearbyWarehouseModel {
  int id;

  String name;

  double distance;

  NearbyWarehouseModel({
    required this.id,

    required this.name,

    required this.distance,
  });

  factory NearbyWarehouseModel.fromJson(Map<String, dynamic> json) {
    return NearbyWarehouseModel(
      id: json["Id"],

      name: json["Name"],

      distance: (json["Distance"] as num).toDouble(),
    );
  }
}

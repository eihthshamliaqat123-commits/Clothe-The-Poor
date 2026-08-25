class WarehouseModel {
  final int id;
  final String name;

  WarehouseModel({required this.id, required this.name});

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(id: json['WareHouseId'], name: json['WareHouseName']);
  }
}

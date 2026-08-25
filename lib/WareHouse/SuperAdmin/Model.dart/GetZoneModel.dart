class ZoneModel {
  int zoneId;
  String zoneName;

  ZoneModel({required this.zoneId, required this.zoneName});

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(zoneId: json["ZoneId"], zoneName: json["ZoneName"]);
  }
}

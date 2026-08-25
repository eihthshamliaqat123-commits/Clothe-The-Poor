class CreateZoneModel {
  String zoneName;
  double latitude;
  double longitude;

  CreateZoneModel({
    required this.zoneName,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {"ZoneName": zoneName, "Latitude": latitude, "Longitude": longitude};
  }
}

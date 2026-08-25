class DonorRequestModel {
  final int id;
  final String name;
  final String comments;
  final double lat;
  final double lng;

  DonorRequestModel({
    required this.id,
    required this.name,
    required this.comments,
    required this.lat,
    required this.lng,
  });

  factory DonorRequestModel.fromJson(Map<String, dynamic> json) {
    return DonorRequestModel(
      id: json["DonorRequestId"],
      name: json["UserName"] ?? "Unknown",
      comments: json["Comments"] ?? "No Comments",
      lat: json["Latitude"] == null
          ? 0.0
          : (json["Latitude"] as num).toDouble(),
      lng: json["Longitude"] == null
          ? 0.0
          : (json["Longitude"] as num).toDouble(),
    );
  }
}

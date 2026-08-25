class AssignedRideModel {
  final int rideLogId;
  final int donorRequestId;
  final String donorName;
  final String phoneNo;
  final String scheduledTime;

  /// 📍 PICKUP
  final double latitude;
  final double longitude;

  /// 📦 DELIVERY (ZONE)
  final double warehouseLat;
  final double warehouseLng;

  final int status; // 0=Assigned, 1=PickedUp, 2=Completed

  AssignedRideModel({
    required this.rideLogId,
    required this.donorRequestId,
    required this.donorName,
    required this.phoneNo,
    required this.scheduledTime,
    required this.latitude,
    required this.longitude,
    required this.warehouseLat,
    required this.warehouseLng,
    required this.status,
  });

  factory AssignedRideModel.fromJson(Map<String, dynamic> json) {
    return AssignedRideModel(
      rideLogId: json["RideLogId"] ?? 0,

      donorRequestId: json["DonorRequestId"] ?? 0,

      donorName: json["donorName"] ?? "",

      phoneNo: json["phoneNo"] ?? "",

      scheduledTime: json["scheduledTime"] ?? "",

      status: json["status"] ?? 0,

      latitude: double.tryParse(json["latitude"]?.toString() ?? "0") ?? 0.0,

      longitude: double.tryParse(json["longitude"]?.toString() ?? "0") ?? 0.0,

      warehouseLat:
          double.tryParse(json["warehouseLat"]?.toString() ?? "0") ?? 0.0,

      warehouseLng:
          double.tryParse(json["warehouseLng"]?.toString() ?? "0") ?? 0.0,
    );
  }
}

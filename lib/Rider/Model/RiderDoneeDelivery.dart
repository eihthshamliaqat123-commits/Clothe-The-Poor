class RiderDoneeDeliveryModel {
  int rideLogId;

  int? doneeRequestId;

  String? doneeName;

  String? phone;

  double latitude;

  double longitude;

  String? requestDate;

  RiderDoneeDeliveryModel({
    required this.rideLogId,
    required this.doneeRequestId,
    required this.doneeName,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.requestDate,
  });

  factory RiderDoneeDeliveryModel.fromJson(Map<String, dynamic> json) {
    return RiderDoneeDeliveryModel(
      rideLogId: json['RideLogId'] ?? 0,

      doneeRequestId: json['DoneeRequestId'] ?? 0,

      doneeName: json['DoneeName'] ?? "",

      phone: json['Phone'] ?? "",

      latitude: double.tryParse(json['Latitude'].toString()) ?? 0.0,

      longitude: double.tryParse(json['Longitude'].toString()) ?? 0.0,

      requestDate: json['RequestDate'] ?? "",
    );
  }
}

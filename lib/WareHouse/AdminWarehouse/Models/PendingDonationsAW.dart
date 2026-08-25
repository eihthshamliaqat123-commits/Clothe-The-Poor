class PendingDonationModel {
  int id;
  int userId;
  String userName;
  String comments;
  double latitude;
  double longitude;
  int status;
  int warehouseId;

  PendingDonationModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comments,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.warehouseId,
  });

  factory PendingDonationModel.fromJson(Map<String, dynamic> json) {
    return PendingDonationModel(
      id: json['DonorRequestId'] ?? 0,
      userId: json['UserId'] ?? 0,
      userName: json['UserName'] ?? "",
      comments: json['Comments'] ?? "",
      latitude: (json['Latitude'] ?? 0).toDouble(),
      longitude: (json['Longitude'] ?? 0).toDouble(),
      status: json['Status'] ?? 0,
      warehouseId: json['WarehouseId'] ?? 0,
    );
  }
}

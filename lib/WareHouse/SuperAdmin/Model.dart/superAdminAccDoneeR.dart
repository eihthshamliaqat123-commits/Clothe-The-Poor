class SuperAdminDoneeRequestModel {
  int doneeRequestId;

  String ngoName;

  String behalfName;

  String behalfContact;

  int status;

  String requestDate;

  String warehouseName;

  SuperAdminDoneeRequestModel({
    required this.doneeRequestId,
    required this.ngoName,
    required this.behalfName,
    required this.behalfContact,
    required this.status,
    required this.requestDate,
    required this.warehouseName,
  });

  factory SuperAdminDoneeRequestModel.fromJson(Map<String, dynamic> json) {
    return SuperAdminDoneeRequestModel(
      doneeRequestId: json['DoneeRequestId'],

      ngoName: json['NGOName'] ?? "",

      behalfName: json['BehalfName'] ?? "",

      behalfContact: json['BehalfContact'] ?? "",

      status: json['Status'] ?? 0,

      requestDate: json['RequestDate'].toString(),

      warehouseName: json['WarehouseName'] ?? "",
    );
  }
}

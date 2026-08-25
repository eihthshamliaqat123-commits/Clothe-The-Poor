class WarehouseDoneeModel {
  int doneeRequestId;
  String ngoName;
  String behalfName;
  int status;

  WarehouseDoneeModel({
    required this.doneeRequestId,
    required this.ngoName,
    required this.behalfName,
    required this.status,
  });

  factory WarehouseDoneeModel.fromJson(Map<String, dynamic> json) {
    return WarehouseDoneeModel(
      doneeRequestId: json["DoneeRequestId"],
      ngoName: json["NGOName"] ?? "",
      behalfName: json["BehalfName"] ?? "",
      status: json["Status"],
    );
  }

  //   get items => null;
}

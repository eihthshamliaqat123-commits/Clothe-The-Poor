class AssignedDonationModel {
  int donorRequestId;

  String? donorName;

  String? comments;

  String? donationImageUrl;

  AssignedDonationModel({
    required this.donorRequestId,
    required this.donorName,
    required this.comments,
    required this.donationImageUrl,
  });

  factory AssignedDonationModel.fromJson(Map<String, dynamic> json) {
    return AssignedDonationModel(
      donorRequestId: json["DonorRequestId"],

      donorName: json["donorName"] ?? "",

      comments: json["Comments"] ?? "",

      donationImageUrl: json["DonationImageUrl"] ?? "",
    );
  }
}

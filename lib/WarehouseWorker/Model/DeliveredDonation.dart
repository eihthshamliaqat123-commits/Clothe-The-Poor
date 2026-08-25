class DeliveredDonationModel {
  int donorRequestId;
  String? donorName;
  String? phoneNo;
  String? comments;
  String? scheduledTime;
  String? donationDate;

  DeliveredDonationModel({
    required this.donorRequestId,
    required this.donorName,
    required this.phoneNo,
    required this.comments,
    required this.scheduledTime,
    required this.donationDate,
  });

  factory DeliveredDonationModel.fromJson(Map<String, dynamic> json) {
    return DeliveredDonationModel(
      donorRequestId: json["DonorRequestId"],
      donorName: json["donorName"],
      phoneNo: json["phoneNo"],
      comments: json["Comments"] ?? "",
      scheduledTime: json["ScheduledTime"],
      donationDate: json["DonationDate"],
    );
  }
}

class DeliveredDonationModel {
  int donorRequestId;
  String donorName;
  String comments;
  String scheduledTime;

  DeliveredDonationModel({
    required this.donorRequestId,
    required this.donorName,
    required this.comments,
    required this.scheduledTime,
  });

  factory DeliveredDonationModel.fromJson(Map<String, dynamic> json) {
    return DeliveredDonationModel(
      donorRequestId: json["DonorRequestId"] is int
          ? json["DonorRequestId"]
          : int.parse(json["DonorRequestId"].toString()),

      donorName: json["donorName"]?.toString() ?? "",

      comments: json["Comments"]?.toString() ?? "",

      scheduledTime: json["ScheduledTime"]?.toString() ?? "",
    );
  }
}

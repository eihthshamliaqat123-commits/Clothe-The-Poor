class DonationHistoryModel {
  int donorRequestId;
  String comments;
  int status;
  int conversationId;
  int recipientId;

  DonationHistoryModel({
    required this.donorRequestId,
    required this.comments,
    required this.status,
    required this.conversationId,
    required this.recipientId,
  });

  factory DonationHistoryModel.fromJson(Map<String, dynamic> json) {
    return DonationHistoryModel(
      donorRequestId: json["DonorRequestId"] ?? 0,

      comments: json["Comments"] ?? "",

      status: json["Status"] ?? 0,

      conversationId: json["ConversationId"] ?? 0,
      recipientId: json['RecipientId'] ?? 0,
    );
  }
}

class SupportMessageModel {
  int messageId;

  int conversationId;

  int senderId;

  int recipientId;

  String? senderName;

  String? messageType;

  String? messageText;

  String? imageUrl;

  String? responseValue;

  bool isRead;

  DateTime? sentAt;

  SupportMessageModel({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.recipientId,
    required this.isRead,

    this.senderName,
    this.messageType,
    this.messageText,
    this.imageUrl,
    this.responseValue,
    this.sentAt,
  });

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      messageId: json["MessageId"] ?? 0,

      conversationId: json["ConversationId"] ?? 0,

      senderId: json["SenderId"] ?? 0,

      recipientId: json["RecipientId"] ?? 0,

      senderName: json["SenderName"],

      messageType: json["MessageType"],

      messageText: json["MessageText"],

      imageUrl: json["ImageUrl"],

      responseValue: json["ResponseValue"],

      isRead: json["IsRead"] ?? false,

      sentAt: json["SentAt"] != null ? DateTime.parse(json["SentAt"]) : null,
    );
  }
}

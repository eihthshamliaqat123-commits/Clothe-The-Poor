class MessageModel {
  int messageId;
  int senderId;
  int recipientId;
  String? messageText;
  String? imageUrl;
  String? messageType;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.recipientId,
    this.messageText,
    this.imageUrl,
    this.messageType,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['MessageId'],
      senderId: json['SenderId'],
      recipientId: json['RecipientId'],
      messageText: json['MessageText'],
      imageUrl: json['ImageUrl'],
      messageType: json['MessageType'],
    );
  }
}

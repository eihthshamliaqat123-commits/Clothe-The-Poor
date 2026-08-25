class ChatConversationModel {
  int conversationId;

  String conversationType;

  int? donorRequestId;

  int? doneeRequestId;

  int otherUserId;

  int warehouseAdminId;

  String otherUserName;

  String warehouseAdminName;

  String? lastMessage;

  int unreadCount;

  ChatConversationModel({
    required this.conversationId,
    required this.conversationType,
    required this.otherUserId,
    required this.warehouseAdminId,
    required this.otherUserName,
    required this.warehouseAdminName,
    required this.unreadCount,

    this.lastMessage,
    this.donorRequestId,
    this.doneeRequestId,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      conversationId: json["ConversationId"] ?? 0,

      conversationType: json["ConversationType"] ?? "",

      donorRequestId: json["DonorRequestId"],

      doneeRequestId: json["DoneeRequestId"],

      otherUserId: json["OtherUserId"] ?? 0,

      warehouseAdminId: json["WarehouseAdminId"] ?? 0,

      otherUserName: json["OtherUserName"] ?? "",

      warehouseAdminName: json["WarehouseAdminName"] ?? "",

      lastMessage: json["LastMessage"]?["MessageText"],

      unreadCount: json["UnreadCount"] ?? 0,
    );
  }
}

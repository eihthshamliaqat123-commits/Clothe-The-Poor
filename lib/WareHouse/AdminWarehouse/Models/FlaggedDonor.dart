class FlaggedDonorModel {
  int userId;

  String name;

  bool isBlocked;

  String blockedReason;

  int wearableCount;

  int nonWearableCount;

  FlaggedDonorModel({
    required this.userId,
    required this.name,
    required this.isBlocked,
    required this.blockedReason,
    required this.wearableCount,
    required this.nonWearableCount,
  });

  factory FlaggedDonorModel.fromJson(Map<String, dynamic> json) {
    return FlaggedDonorModel(
      userId: json["UserId"],

      name: json["Name"],

      isBlocked: json["IsBlocked"] ?? false,

      blockedReason: json["BlockedReason"] ?? "",

      wearableCount: json["WearableCount"] ?? 0,

      nonWearableCount: json["NonWearableCount"] ?? 0,
    );
  }
}

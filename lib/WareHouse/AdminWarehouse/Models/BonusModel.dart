class BonusModel {
  int userId;

  double bonusPercentage;

  BonusModel({required this.userId, required this.bonusPercentage});

  Map<String, dynamic> toJson() {
    return {"UserId": userId, "BonusPercentage": bonusPercentage};
  }
}

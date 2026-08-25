class WorkerModel {
  int userId;
  String workerName;
  String role;

  double averageRating;

  int totalRatings;

  double salary;

  double bonus;

  WorkerModel({
    required this.userId,
    required this.workerName,
    required this.role,
    required this.averageRating,
    required this.totalRatings,
    required this.salary,
    required this.bonus,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      userId: json["UserId"],

      workerName: json["WorkerName"],

      role: json["Role"],

      averageRating: (json["AverageRating"] ?? 0).toDouble(),

      totalRatings: json["TotalRatings"] ?? 0,

      salary: (json["Salary"] ?? 0).toDouble(),

      bonus: (json["Bonus"] ?? 0).toDouble(),
    );
  }
}

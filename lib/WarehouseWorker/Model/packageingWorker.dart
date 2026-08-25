class PackagingWorker {
  int userId;

  String name;

  PackagingWorker({required this.userId, required this.name});

  factory PackagingWorker.fromJson(Map<String, dynamic> json) {
    return PackagingWorker(userId: json["UserId"], name: json["Name"]);
  }
}

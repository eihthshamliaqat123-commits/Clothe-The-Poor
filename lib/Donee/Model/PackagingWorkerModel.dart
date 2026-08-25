class PackagingWorkerModel {
  int workerId;
  String workerName;
  double rating = 5;

  PackagingWorkerModel({required this.workerId, required this.workerName});

  factory PackagingWorkerModel.fromJson(Map<String, dynamic> json) {
    return PackagingWorkerModel(
      workerId: json["WorkerId"],
      workerName: json["WorkerName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"WorkerId": workerId, "Rating": rating};
  }
}

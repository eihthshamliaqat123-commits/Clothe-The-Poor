import 'package:charity/Donee/Model/SortingItemModel.dart';

class SortingWorkerModel {
  int workerId;

  String workerName;

  List<SortingItemModel> items;

  SortingWorkerModel({
    required this.workerId,
    required this.workerName,
    required this.items,
  });

  factory SortingWorkerModel.fromJson(Map<String, dynamic> json) {
    return SortingWorkerModel(
      workerId: json["WorkerId"],

      workerName: json["WorkerName"],

      items: (json["Items"] as List)
          .map((e) => SortingItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "WorkerId": workerId,
      "Items": items.map((e) => e.toJson()).toList(),
    };
  }
}

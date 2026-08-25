class SizeModel {
  int id;
  String name;

  SizeModel({required this.id, required this.name});

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(id: json['SizeId'], name: json['SizeName']);
  }
}

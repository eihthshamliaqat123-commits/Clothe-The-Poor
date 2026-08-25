class DoneeRequestModel {
  int doneeRequestId;
  int recipentId;
  String? ngoName;
  String? behalfName;
  String? behalfContact;
  int status;

  List<DoneeItemModel> items;

  DoneeRequestModel({
    required this.doneeRequestId,
    required this.recipentId,
    this.ngoName,
    this.behalfName,
    this.behalfContact,
    required this.status,
    required this.items,
  });

  factory DoneeRequestModel.fromJson(Map<String, dynamic> json) {
    return DoneeRequestModel(
      doneeRequestId: json['DoneeRequestId'],
      recipentId: json['RecipentId'],
      ngoName: json['NGOName'],
      behalfName: json['BehalfName'],
      behalfContact: json['BehalfContact'],
      status: json['Status'],

      items: (json['Items'] as List)
          .map((e) => DoneeItemModel.fromJson(e))
          .toList(),
    );
  }
}

class DoneeItemModel {
  int requestedItemId;
  String itemType;
  String category;
  String season;
  int quantity;

  DoneeItemModel({
    required this.requestedItemId,
    required this.itemType,
    required this.category,
    required this.season,
    required this.quantity,
  });

  factory DoneeItemModel.fromJson(Map<String, dynamic> json) {
    return DoneeItemModel(
      requestedItemId: json['RequestedItemId'],
      itemType: json['ItemType'] ?? "",
      category: json['Category'] ?? "",
      season: json['Season'] ?? "",
      quantity: json['Quantity'] ?? 0,
    );
  }
}

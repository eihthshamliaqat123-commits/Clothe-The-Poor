import 'package:charity/Donee/Model/SortingRating.dart';

class SubmitRatingModel {
  int packageId;
  int doneeRequestId;
  int packagingWorkerId;
  int packagingRating;

  List<SortingRatingModel> sortingRatings;

  SubmitRatingModel({
    required this.packageId,
    required this.doneeRequestId,
    required this.packagingWorkerId,
    required this.packagingRating,
    required this.sortingRatings,
  });

  Map<String, dynamic> toJson() {
    return {
      "PackageId": packageId,
      "DoneeRequestId": doneeRequestId,
      "PackagingWorkerId": packagingWorkerId,
      "PackagingRating": packagingRating,
      "SortingRatings": sortingRatings.map((e) => e.toJson()).toList(),
    };
  }
}

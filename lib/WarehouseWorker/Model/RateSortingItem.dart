class Ratesortingitem {
  int SourceId;

  int Rating = 3;

  Ratesortingitem({required this.SourceId, required this.Rating});
  Map<String, dynamic> toJson() {
    return {"SourceId": SourceId, "Rating": Rating};
  }
}

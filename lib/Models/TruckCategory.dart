class TruckCategory {
  String truckCatID;
  String truckCatName;

  TruckCategory({this.truckCatID, this.truckCatName});

  factory TruckCategory.fromJson(Map<String, dynamic> parsedJson) {
    return TruckCategory(
      truckCatID: parsedJson['trk_cat_id'],
      truckCatName: parsedJson['trk_cat_name'],
    );
  }
}

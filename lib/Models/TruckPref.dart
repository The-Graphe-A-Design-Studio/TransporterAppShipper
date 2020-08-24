class TruckPref {
  String id;
  String cat;
  String name;

  TruckPref({this.id, this.cat, this.name});

  factory TruckPref.fromJson(Map<String, dynamic> parsedJson) {
    return TruckPref(
      id: parsedJson['ty_id'],
      cat: parsedJson['ty_cat'],
      name: parsedJson['ty_name'],
    );
  }
}

class LoadMaterialType {
  String id;
  String name;

  LoadMaterialType({this.id, this.name});

  factory LoadMaterialType.fromJson(Map<String, dynamic> parsedJson) {
    return LoadMaterialType(
      id: parsedJson['mat_id'],
      name: parsedJson['mat_name'],
    );
  }
}

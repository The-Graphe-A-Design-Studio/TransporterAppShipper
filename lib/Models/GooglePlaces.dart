class GooglePlaces {
  String description;
  String placeId;

  GooglePlaces({
    this.description,
    this.placeId,
  });

  factory GooglePlaces.fromJson(Map<String, dynamic> parsedJson) {
    return GooglePlaces(
      description: parsedJson['description'],
      placeId: parsedJson['place_id'],
    );
  }
}

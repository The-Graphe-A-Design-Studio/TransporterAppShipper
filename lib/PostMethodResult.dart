class PostResultOne {
  bool success;
  String message;

  PostResultOne({
    this.success,
    this.message,
  });

  factory PostResultOne.fromJson(Map<String, dynamic> parsedJson) {
    return PostResultOne(
        success: parsedJson['success'] == '1' ? true : false,
        message: parsedJson['message']);
  }
}

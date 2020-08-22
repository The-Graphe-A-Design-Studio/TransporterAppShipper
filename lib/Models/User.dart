class UserTransporter {
  bool success;
  String id;
  String message;
  String verified;
  String registered;
  String mobileNumber;
  String mobileNumberCode;

  UserTransporter({
    this.success,
    this.id,
    this.message,
    this.verified,
    this.mobileNumber,
    this.mobileNumberCode,
    this.registered,
  });

  factory UserTransporter.fromJson(Map<String, dynamic> parsedJson) {
    return UserTransporter(
        success: parsedJson['success'] == '1' ? true : false,
        id: parsedJson['shipper id'],
        message: parsedJson['message'],
        verified: parsedJson['verified'],
        mobileNumber: parsedJson['shipper phone'],
        mobileNumberCode: parsedJson['shipper phone country code'],
        registered: parsedJson['registered on']);
  }

  Map<String, dynamic> toJson() => {
        'success': "1",
        'shipper id': this.id,
        'message': this.message,
        'verified': this.verified,
        'shipper phone': this.mobileNumber,
        'shipper phone country code': this.mobileNumberCode,
        'registered on': this.registered,
      };
}

class UserTransporter {
  bool success;
  String id;
  String message;
  String planType;
  String verified;
  String registered;
  String mobileNumber;
  String mobileNumberCode;
  String compName;

  UserTransporter({
    this.success,
    this.id,
    this.planType,
    this.message,
    this.verified,
    this.mobileNumber,
    this.mobileNumberCode,
    this.registered,
    this.compName,
  });

  factory UserTransporter.fromJson(Map<String, dynamic> parsedJson) {
    return UserTransporter(
        success: parsedJson['success'] == '1' ? true : false,
        id: parsedJson['shipper id'],
        planType: parsedJson['plan type'],
        message: parsedJson['message'],
        verified: parsedJson['verified'],
        mobileNumber: parsedJson['shipper phone'],
        mobileNumberCode: parsedJson['shipper phone country code'],
        registered: parsedJson['registered on'],
        compName: parsedJson['shipper company name']);
  }

  Map<String, dynamic> toJson() => {
        'success': "1",
        'shipper id': this.id,
        'message': this.message,
        'verified': this.verified,
        'shipper phone': this.mobileNumber,
        'shipper phone country code': this.mobileNumberCode,
        'registered on': this.registered,
        'shipper company name': this.compName
      };
}

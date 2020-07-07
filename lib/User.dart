class UserDriver {
  bool success;
  String dId;
  String dName;
  String dEmail;
  String dPhoneCode;
  String dPhone;
  String dPassword;
  String dAddress;
  String dRc;
  String dLicense;
  String dInsurance;
  String dRoadTax;
  String dRto;
  String dPan;
  String dBank;
  String dIfsc;
  bool dVerified;
  String dRegistered;

  UserDriver(
      {this.success,
        this.dId,
        this.dName,
        this.dEmail,
        this.dPhoneCode,
        this.dPhone,
        this.dPassword,
        this.dAddress,
        this.dRc,
        this.dLicense,
        this.dInsurance,
        this.dRoadTax,
        this.dRto,
        this.dPan,
        this.dBank,
        this.dIfsc,
        this.dVerified,
        this.dRegistered});

  factory UserDriver.fromJson(Map<String, dynamic> parsedJson) {
    return UserDriver(
        success: parsedJson['success'] == '1' ? true : false,
        dId: parsedJson['d_id'],
        dName: parsedJson['d_name'],
        dEmail: parsedJson['d_email'],
        dPhoneCode: parsedJson['d_phone_code'],
        dPhone: parsedJson['d_phone'],
        dPassword: parsedJson['d_password'],
        dAddress: parsedJson['d_address'],
        dRc: parsedJson['d_rc'],
        dLicense: parsedJson['d_license'],
        dInsurance: parsedJson['d_insurance'],
        dRoadTax: parsedJson['d_road_tax'],
        dRto: parsedJson['d_rto'],
        dPan: parsedJson['d_pan'],
        dBank: parsedJson['d_bank'],
        dIfsc: parsedJson['d_ifsc'],
        dVerified: parsedJson['d_verified'] == '1' ? true : false,
        dRegistered: parsedJson['d_registered']);
  }
}
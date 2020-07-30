class UserOwner {
  bool success;
  String oId;
  String oName;
  String oEmail;
  String oPhoneCode;
  String oPhone;
  String oAddress;
  String oCity;
  String oOperatingRoute;
  String oPermitStates;
  String oPan;
  String oBank;
  String oIfsc;
  String oRegistered;

  UserOwner(
      {this.success,
        this.oId,
        this.oName,
        this.oEmail,
        this.oPhoneCode,
        this.oPhone,
        this.oAddress,
        this.oCity,
        this.oOperatingRoute,
        this.oPermitStates,
        this.oPan,
        this.oBank,
        this.oIfsc,
        this.oRegistered});

  factory UserOwner.fromJson(Map<String, dynamic> parsedJson) {
    return UserOwner(
        success: parsedJson['success'] == '1' ? true : false,
        oId: parsedJson['id'],
        oName: parsedJson['name'],
        oEmail: parsedJson['email'],
        oPhoneCode: parsedJson['phone_con_code'],
        oPhone: parsedJson['phone'],
        oAddress: parsedJson['address'],
        oCity: parsedJson['city'],
        oOperatingRoute: parsedJson['operating routes'],
        oPermitStates: parsedJson['permit states'],
        oPan: parsedJson['pan'],
        oBank: parsedJson['bank'],
        oIfsc: parsedJson['ifsc'],
        oRegistered: parsedJson['registered on']);
  }
}

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
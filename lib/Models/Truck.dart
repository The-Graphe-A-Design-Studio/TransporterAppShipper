class Truck {
  String truckId;
  String truckOwner;
  String truckCat;
  String truckNumber;
  String truckLoad;
  String truckDriverName;
  String truckDriverPhoneCode;
  String truckDriverPhone;
  String truckDriverLicense;
  String truckRc;
  String truckInsurance;
  String truckRoadTax;
  String truckRTO;
  bool truckActive;


  Truck({this.truckId, this.truckOwner, this.truckCat, this.truckNumber,
      this.truckLoad, this.truckDriverName, this.truckDriverPhoneCode,
      this.truckDriverPhone, this.truckDriverLicense, this.truckRc,
      this.truckInsurance, this.truckRoadTax, this.truckRTO, this.truckActive});

  factory Truck.fromJson(Map<String, dynamic> parsedJson) {
    return Truck(
      truckId: parsedJson['trk_id'],
      truckOwner: parsedJson['trk_owner'],
      truckCat: parsedJson['trk_cat'],
      truckNumber: parsedJson['trk_num'],
      truckLoad: parsedJson['trk_load'],
      truckDriverName: parsedJson['trk_dr_name'],
      truckDriverPhoneCode: parsedJson['trk_dr_phone_code'],
      truckDriverPhone: parsedJson['trk_dr_phone'],
      truckDriverLicense: parsedJson['trk_dr_license'],
      truckRc: parsedJson['trk_rc'],
      truckInsurance: parsedJson['trk_insurance'],
      truckRoadTax: parsedJson['trk_road_tax'],
      truckRTO: parsedJson['trk_rto'],
      truckActive: parsedJson['trk_active']=="1" ? true : false,
    );
  }
}

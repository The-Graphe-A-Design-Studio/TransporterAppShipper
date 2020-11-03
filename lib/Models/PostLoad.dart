class PostLoad {
  String postId;
  String cId;
  List<String> source;
  List<String> destination;
  String material;
  String tonnage;
  String noTruck;
  String truckPref;
  List<String> truckType;
  String exPrice;
  String payMode;
  String createdOn;
  String expiresOn;
  String contactPerson;
  String contactPhone;

  PostLoad(
      {this.postId,
      this.cId,
      this.source,
      this.destination,
      this.material,
      this.tonnage,
      this.noTruck,
      this.truckPref,
      this.truckType,
      this.exPrice,
      this.payMode,
      this.createdOn,
      this.expiresOn,
      this.contactPerson,
      this.contactPhone});

  factory PostLoad.fromJson(Map<String, dynamic> parsedJson, bool isTonnage) {
    List<String> temp1 = [], temp2 = [], temp3 = [];
    int a = 1;
    for (var i in parsedJson['sources']) {
      temp1.add(i["source $a"]);
      a++;
    }
    a = 1;
    for (var i in parsedJson['destinations']) {
      temp2.add(i["destination $a"]);
      a++;
    }
    a = 1;
    for (var i in parsedJson['truck types']) {
      temp3.add(i["type $a"]);
      a++;
    }
    return PostLoad(
        postId: parsedJson['post id'],
        cId: parsedJson['customer id'],
        source: temp1,
        destination: temp2,
        material: parsedJson['material'],
        tonnage: isTonnage ? parsedJson['tonnage'] : "",
        truckPref: parsedJson['truck preference'],
        noTruck: isTonnage ? "" : parsedJson['number of trucks'],
        truckType: temp3,
        exPrice: parsedJson['expected price'],
        payMode: parsedJson['payment mode'],
        createdOn: parsedJson['created on'],
        expiresOn: parsedJson['expired on'],
        contactPerson: parsedJson['contact person'],
        contactPhone: parsedJson['contact person phone']);
  }
}

class PostLoad1 {
  String postId;
  String cId;
  List<String> source;
  List<String> destination;
  String material;
  String tonnage;
  String noTruck;
  String truckPref;
  List<String> truckType;
  String exPrice;
  String payMode;
  String createdOn;
  String expiresOn;
  String contactPerson;
  String contactPhone;
  String quantity;
  String unit;

  PostLoad1({
    this.postId,
    this.cId,
    this.source,
    this.destination,
    this.material,
    this.tonnage,
    this.noTruck,
    this.truckPref,
    this.truckType,
    this.exPrice,
    this.payMode,
    this.createdOn,
    this.expiresOn,
    this.contactPerson,
    this.contactPhone,
    this.quantity,this.unit,
  });

  factory PostLoad1.fromJson(Map<String, dynamic> parsedJson, bool isTonnage) {
    List<String> temp1 = [], temp2 = [], temp3 = [];
    int a = 1;
    for (var i in parsedJson['sources']) {
      temp1.add(i["source"]);
      a++;
    }
    a = 1;
    for (var i in parsedJson['destinations']) {
      temp2.add(i["destination"]);
      a++;
    }
    a = 1;
    for (var i in parsedJson['truck types']) {
      temp3.add(i["type $a"]);
      a++;
    }
    return PostLoad1(
      postId: parsedJson['post id'],
      cId: parsedJson['customer id'],
      source: temp1,
      destination: temp2,
      material: parsedJson['material'],
      tonnage: isTonnage ? parsedJson['tonnage'] : "",
      truckPref: parsedJson['truck preference'],
      noTruck: isTonnage ? "" : parsedJson['number of trucks'],
      truckType: temp3,
      exPrice: parsedJson['expected price'],
      payMode: parsedJson['payment mode'],
      createdOn: parsedJson['created on'],
      expiresOn: parsedJson['expired on'],
      contactPerson: parsedJson['contact person'],
      contactPhone: parsedJson['contact person phone'],
      quantity: parsedJson['quantity'],
      unit: parsedJson['unit'],
    );
  }
}

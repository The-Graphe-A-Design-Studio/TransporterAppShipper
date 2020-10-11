import 'package:shipperapp/Models/Location.dart';

class Post {
  String postId;
  String customerId;
  List<Location> sources;
  List<Location> destinations;
  String material;
  String tonnage;
  String truckPreferences;
  List<String> truckTypes;
  String expectedPrice;
  var paymentMode;
  String createdOn;
  String expiredOn;
  String contactPerson;
  String contactPersonPhone;

  Post({
    this.postId,
    this.customerId,
    this.sources,
    this.destinations,
    this.material,
    this.tonnage,
    this.truckPreferences,
    this.truckTypes,
    this.expectedPrice,
    this.paymentMode,
    this.createdOn,
    this.expiredOn,
    this.contactPerson,
    this.contactPersonPhone,
  });

  factory Post.fromJson(Map<String, dynamic> parsedJson) {
    List<Location> tempS = [];
    for (int i = 0; i < parsedJson['sources'].length; i++)
      tempS.add(Location.fromJson(i + 1, parsedJson['sources'][i]));

    List<Location> tempD = [];
    for (int i = 0; i < parsedJson['destinations'].length; i++)
      tempD.add(Location.fromJson(i + 1, parsedJson['destinations'][i]));

    List<String> tempP = [];
    for (var i in parsedJson['truck types']) {
      for (var j in i.keys) tempP.add(i[j]);
    }

    return Post(
      postId: parsedJson['post id'],
      customerId: parsedJson['customer id'],
      sources: tempS,
      destinations: tempD,
      material: parsedJson['material'],
      tonnage: parsedJson['tonnage'],
      truckPreferences: parsedJson['truck preference'],
      truckTypes: tempP,
      expectedPrice: parsedJson['expected price'],
      paymentMode: parsedJson['payment mode'],
      createdOn: parsedJson['created on'],
      expiredOn: parsedJson['expired on'],
      contactPerson: parsedJson['contact person'],
      contactPersonPhone: parsedJson['contact person phone'],
    );
  }
}

class DeliveryTruck {
  String deleteTruckId;
  String truckNumber;
  String driverName;
  String driverPhone;
  String otp;

  DeliveryTruck({
    this.deleteTruckId,
    this.truckNumber,
    this.driverName,
    this.driverPhone,
    this.otp,
  });

  factory DeliveryTruck.fromJson(Map<String, dynamic> parsedJson) {
    return DeliveryTruck(
      deleteTruckId: parsedJson['del truck id'],
      truckNumber: parsedJson['truck number'],
      driverName: parsedJson['driver name'],
      driverPhone: parsedJson['driver phone'],
      otp: (parsedJson['status'] == null) ? parsedJson['otp'] : '000000',
    );
  }
}

class Delivery {
  String deliveryId;
  String priceUnit;
  String quantity;
  String dealPrice;
  String gst;
  String totalPrice;
  String deliveryTrucksStatus;
  List<DeliveryTruck> deliveryTrucks;
  String deliveryStatus;
  Post load;
  String modeName;
  var payment;

  Delivery({
    this.deliveryId,
    this.priceUnit,
    this.quantity,
    this.dealPrice,
    this.gst,
    this.totalPrice,
    this.deliveryTrucksStatus,
    this.deliveryTrucks,
    this.deliveryStatus,
    this.load,
    this.modeName,
    this.payment,
  });

  factory Delivery.fromJson(Map<String, dynamic> parsedJson) {
    List<DeliveryTruck> tempTrucks = [];
    if (parsedJson['delivery trucks']['status'] != '0')
      for (var i = 0; i < parsedJson['delivery trucks']['trucks'].length; i++)
        tempTrucks.add(
            DeliveryTruck.fromJson(parsedJson['delivery trucks']['trucks'][i]));
    return Delivery(
      deliveryId: parsedJson['delivery id'],
      priceUnit: parsedJson['price unit'],
      quantity: parsedJson['quantity'],
      dealPrice: parsedJson['deal price'],
      gst: parsedJson['GST'],
      totalPrice: parsedJson['total amount'],
      deliveryTrucksStatus: parsedJson['delivery trucks']['status'],
      deliveryTrucks: tempTrucks,
      deliveryStatus: parsedJson['delivery status'],
      load: Post.fromJson(parsedJson['load details']),
      modeName: parsedJson['payment mode']['mode name'],
      payment: parsedJson['payment mode']['payment']
    );
  }
}

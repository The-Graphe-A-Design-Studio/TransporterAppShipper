class Bidder {
  String bidId;
  String bidderId;
  String price;
  String type;
  String bidStatus;
  String bidderName;
  String bidderContact;

  Bidder({
    this.bidId,
    this.bidderId,
    this.price,
    this.type,
    this.bidStatus,
    this.bidderName,
    this.bidderContact,
  });

  factory Bidder.fromJson(Map<String, dynamic> parsedJson) {
    return Bidder(
      bidId: parsedJson['bid id'],
      bidderId: parsedJson['bidder details'][0]['bidder id'],
      price: parsedJson['bidder price'],
      type: parsedJson['bidder type'],
      bidStatus: parsedJson['bid status'],
      bidderName: parsedJson['bidder details'][0]['bidder name'],
      bidderContact: parsedJson['bidder details'][0]['bidder phone'],
    );
  }
}

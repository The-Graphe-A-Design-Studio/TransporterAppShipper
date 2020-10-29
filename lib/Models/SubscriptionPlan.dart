class SubscriptionPlan {
  int planId;
  int planType;
  double planOriginalPrice;
  double planSellingPrice;
  String planDiscount;
  String duration;
  String finalPrice;

  SubscriptionPlan({
    this.planId,
    this.planType,
    this.planOriginalPrice,
    this.planSellingPrice,
    this.planDiscount,
    this.duration,
    this.finalPrice,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> parsedJson) {
    return SubscriptionPlan(
      planId: int.parse(parsedJson['plan id']),
      planType: int.parse(parsedJson['plan type']),
      planOriginalPrice: double.parse(parsedJson['plan original price']),
      planSellingPrice: double.parse(parsedJson['plan selling price']),
      planDiscount: parsedJson['plan discount'],
      duration: parsedJson['plan duration'],
      finalPrice: parsedJson['final price'],
    );
  }
}

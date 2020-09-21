import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipperapp/DialogScreens/DialogProcessing.dart';
import 'package:shipperapp/DialogScreens/DialogSuccess.dart';
import 'package:shipperapp/Models/Bidder.dart';
import 'package:shipperapp/Models/MaterialType.dart';
import 'package:shipperapp/Models/PostLoad.dart';
import 'package:shipperapp/Models/SubscriptionPlan.dart';
import 'package:shipperapp/Models/TruckCategory.dart';
import 'package:shipperapp/Models/TruckPref.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:shipperapp/PostMethodResult.dart';

class HTTPHandler {
  String baseURL = 'https://truckwale.co.in/api';
  String baseURLShipper = 'https://truckwale.co.in/api/customer';

  final _random = new Random();

  void signOut(BuildContext context, {String userMobile}) async {
    DialogProcessing().showCustomDialog(context,
        title: "Sign Out", text: "Processing, Please Wait!");
    await http.post(
      '$baseURLShipper/shipper_enter_exit',
      body: {'logout_number': userMobile},
    );
    await SharedPreferences.getInstance()
        .then((value) => value.setBool("rememberMe", false));
    await Future.delayed(Duration(seconds: 1), () {});
    Navigator.pop(context);
    DialogSuccess().showCustomDialog(context, title: "Sign Out");
    await Future.delayed(Duration(seconds: 1), () {});
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
        context, introLoginOptionPage, (route) => false);
  }

  Future<List<TruckCategory>> getTruckCategory() async {
    try {
      var result =
          await http.get("https://truckwale.co.in/api/truck_categories");
      var ret = json.decode(result.body);
      List<TruckCategory> list = [];
      for (var i in ret) {
        list.add(TruckCategory.fromJson(i));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  Future<List<LoadMaterialType>> getMaterialType() async {
    try {
      var result = await http.get("https://truckwale.co.in/api/material_types");
      var ret = json.decode(result.body);
      List<LoadMaterialType> list = [];
      for (var i in ret) {
        list.add(LoadMaterialType.fromJson(i));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  Future<List<TruckPref>> getTruckPref(List data) async {
    try {
      var result = await http.post(
          "https://truckwale.co.in/api/truck_category_type",
          body: {"truck_cat_id": data[0]});
      var ret = json.decode(result.body);
      List<TruckPref> list = [];
      for (var i in ret) {
        list.add(TruckPref.fromJson(i));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  //Rishav

  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      var result = await http.get('$baseURL/shipper_subscription_plan');

      var ret = json.decode(result.body);
      List<SubscriptionPlan> list = [];
      for (var i in ret) {
        list.add(SubscriptionPlan.fromJson(i));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  /*-------------------------- Customer API's ---------------------------*/
  Future<PostResultOne> registerLoginCustomer(List data) async {
    try {
      var result = await http.post("$baseURLShipper/shipper_enter_exit", body: {
        'cu_phone_code': data[0],
        'cu_phone': data[1],
        'cu_token': data[2]
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> logoutCustomer(List data) async {
    try {
      var result = await http.post("$baseURLShipper/shipper_enter_exit", body: {
        'logout_number': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> uploadDocsPic(List data) async {
    try {
      var url = "$baseURLShipper/profile";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['cu_phone'] = data[0];
      request.files
          .add(await http.MultipartFile.fromPath('${data[1]}', data[2]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> uploadOfficeAddPic(List data) async {
    try {
      var url = "$baseURLShipper/profile";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['cu_phone'] = data[0];
      request.fields['cu_co_name'] = data[1];
      request.files
          .add(await http.MultipartFile.fromPath('cu_office_address', data[2]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> uploadAddProof(List data) async {
    try {
      var url = "$baseURLShipper/profile";
      var request = http.MultipartRequest('POST', Uri.parse(url));
      print(data);
      request.fields['cu_phone'] = data[0];
      request.fields['cu_address_type'] = data[1].toString();
      request.files
          .add(await http.MultipartFile.fromPath('cu_address_front', data[2]));
      request.files
          .add(await http.MultipartFile.fromPath('cu_address_back', data[3]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<dynamic>> registerVerifyOtpCustomer(List data) async {
    try {
      var result = await http.post("$baseURLShipper/shipper_verification",
          body: {'phone_number': data[0], 'otp': data[1]});
      SharedPreferences.getInstance().then((value) async {
        await value.setString('trial_period_status',
            (json.decode(result.body))['trial period status']);
        value
            .setString('trial_period_upto',
                (json.decode(result.body))['trial period upto'])
            .then((value1) {
          print((json.decode(result.body))['trial period status']);
          print(value.getString('trial_period_upto'));
          print('data stored');
        });
      });
      return [PostResultOne.fromJson(json.decode(result.body)), result.body];
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerResendOtpCustomer(List data) async {
    try {
      var result =
          await http.post("$baseURLShipper/shipper_verification", body: {
        'resend_otp_on': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<List<PostLoad>> getPostLoad(List data) async {
    try {
      var result = await http.post("$baseURLShipper/view_all_posts",
          body: {"customer_id": data[0], "post_status": data[1]});
      var ret = json.decode(result.body);
      print(ret);
      List<PostLoad> list = [];
      if (ret == "null" || ret == null) {
        return list;
      }
      print(data[0]);
      print(ret);
      for (var i in ret) {
        print(i.toString().contains("tonnage"));
        list.add(PostLoad.fromJson(i, i.toString().contains("tonnage")));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> postNewLoad(List data) async {
    try {
      var url = "$baseURLShipper/create_load";
      var request = http.MultipartRequest('POST', Uri.parse(url));
      print(data);
      request.fields['cust_id'] = data[0];
      request.fields['source'] = data[1];
      request.fields['destination'] = data[2];
      request.fields['material'] = data[3];
      request.fields['price_unit'] = data[4];
      request.fields['quantity'] = data[5];
      request.fields['truck_preference'] = data[6];
      request.fields['truck_types'] = data[7];
      request.fields['expected_price'] = data[8];
      request.fields['payment_mode'] = data[9];
      request.fields['advance_pay'] = data[10];
      request.fields['expire_date_time'] = data[11];
      request.fields['contact_person_name'] = data[12];
      request.fields['contact_person_phone'] = data[13];
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  //RISHAV

  /// Getting user documents
  Future<Map<dynamic, dynamic>> getUserDocumentsData(String userId) async {
    try {
      var response = await http.post(
        '$baseURLShipper/documents',
        body: {'customer_id': userId},
      );
      return json.decode(response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Generating Razorpay payment ID
  Future<String> generateRazorpayOrderId(int amount) async {
    try {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$RAZORPAY_ID:$RAZORPAY_SECRET'));

      Map<String, dynamic> orderData = {
        'amount': amount,
        'currency': 'INR',
        'receipt': 'AATA_${1000 + _random.nextInt(9999 - 1000)}',
        'payment_capture': 1,
        'notes': {
          'notes_key_1': 'Aatawala is developed by Graphe',
        },
      };

      print(1000 + _random.nextInt(9999 - 1000));

      http.Response response = await http.post(
        'https://api.razorpay.com/v1/orders',
        headers: <String, String>{
          'Authorization': basicAuth,
          'Content-Type': 'application/json'
        },
        body: json.encode(orderData),
      );

      print(json.decode(response.body));

      if ((json.decode(response.body)).containsKey('error')) {
        return null;
      } else {
        return (json.decode(response.body))['id'];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Storing payment data
  Future<PostResultOne> storeData(
    UserTransporter user,
    SubscriptionPlan plan,
    PaymentSuccessResponse paymentResponse,
  ) async {
    try {
      var response = await http.post('$baseURL/subscription_payment', body: {
        'user_type': '1',
        'user_id': user.id,
        'amount': plan.planSellingPrice.toString(),
        'duration': plan.duration[0],
        'razorpay_order_id': paymentResponse.orderId ?? 'graphe123',
        'razorpay_payment_id': paymentResponse.paymentId,
        'razorpay_signature': paymentResponse.signature ?? 'graphe123',
      });

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  ///Get bids per load
  Future<List<Bidder>> getBids(String loadId) async {
    try {
      var response =
          await http.post('$baseURLShipper/bidders', body: {'load_id': loadId});

      if (json.decode(response.body)['success'] == '0') {
        return [];
      }
      List<Bidder> bids = [];

      for (var i = 0; i < json.decode(response.body).length; i++)
        bids.add(Bidder.fromJson(json.decode(response.body)[i]));

      print(bids.toString());
      return bids;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Accept Bid
  Future<PostResultOne> acceptBid(String loadId, String bidId) async {
    try {
      var response = await http.post('$baseURLShipper/bidders', body: {
        'load_id_for_accepting': loadId,
        'bid_id_for_accepting': bidId,
      });

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

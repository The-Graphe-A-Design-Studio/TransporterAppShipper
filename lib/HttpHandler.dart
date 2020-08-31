import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipperapp/DialogScreens/DialogProcessing.dart';
import 'package:shipperapp/DialogScreens/DialogSuccess.dart';
import 'package:shipperapp/Models/MaterialType.dart';
import 'package:shipperapp/Models/PostLoad.dart';
import 'package:shipperapp/Models/TruckCategory.dart';
import 'package:shipperapp/Models/TruckPref.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:shipperapp/PostMethodResult.dart';

class HTTPHandler {
  String baseURLShipper = 'https://truckwale.co.in/api/customer';

  void signOut(BuildContext context) async {
    DialogProcessing().showCustomDialog(context,
        title: "Sign Out", text: "Processing, Please Wait!");
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

  /*-------------------------- Customer API's ---------------------------*/
  Future<PostResultOne> registerLoginCustomer(List data) async {
    try {
      var result = await http.post("$baseURLShipper/register-login-logout",
          body: {
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
      var result =
          await http.post("$baseURLShipper/register-login-logout", body: {
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
      var result = await http.post("$baseURLShipper/verification",
          body: {'phone_number': data[0], 'otp': data[1]});
      return [PostResultOne.fromJson(json.decode(result.body)), result.body];
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerResendOtpCustomer(List data) async {
    try {
      var result = await http.post("$baseURLShipper/verification", body: {
        'resend_otp_on': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<List<PostLoad>> getPostLoad(List data) async {
    /*try {*/
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
    /*} catch (error) {
      throw error;
    }*/
  }

  Future<PostResultOne> postNewLoad(List data) async {
    try {
      var url = "$baseURLShipper/create_load";
      var request = http.MultipartRequest('POST', Uri.parse(url));
      print(data);
      request.fields['cust_id'] = data[0];
      request.fields['source[]'] = data[1];
      request.fields['source[]'] = data[2];
      request.fields['source[]'] = data[3];
      request.fields['destination[]'] = data[4];
      request.fields['destination[]'] = data[5];
      request.fields['destination[]'] = data[6];
      request.fields['material'] = data[7];
      request.fields['price_unit'] = data[8];
      request.fields['quantity'] = data[9];
      request.fields['truck_preference'] = data[10];
      request.fields['truck_types[]'] = data[11];
      request.fields['truck_types[]'] = data[12];
      request.fields['truck_types[]'] = data[13];
      request.fields['expected_price'] = data[14];
      request.fields['payment_mode'] = data[15];
      request.fields['advance_pay'] = data[16];
      request.fields['expire_date_time'] = data[17];
      request.fields['contact_person_name'] = data[18];
      request.fields['contact_person_phone'] = data[19];
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }
}

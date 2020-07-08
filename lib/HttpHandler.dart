import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportationapp/PostMethodResult.dart';
import 'package:transportationapp/User.dart';

class HTTPHandler {
  String baseURLDriver =
      'https://developers.thegraphe.com/transport/api/drivers/login';
  String baseURLTransporter =
      'https://developers.thegraphe.com/transport/api/drivers/login';

  Future<PostResultOne> registerDriver(List data) async {
    try {
      var url = "$baseURLDriver/register";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['d_name'] = data[0];
      request.fields['d_email'] = data[1];
      request.fields['d_phone_code'] = data[2];
      request.fields['d_phone'] = data[3];
      request.fields['d_password'] = data[4];
      request.fields['d_cnf_password'] = data[5];
      request.fields['d_address'] = data[6];
      request.files.add(await http.MultipartFile.fromPath('d_rc', data[7]));
      request.files
          .add(await http.MultipartFile.fromPath('d_license', data[8]));
      request.files
          .add(await http.MultipartFile.fromPath('d_insurance', data[9]));
      request.files
          .add(await http.MultipartFile.fromPath('d_road_tax', data[10]));
      request.files.add(await http.MultipartFile.fromPath('d_rto', data[11]));
      request.fields['d_pan'] = data[12];
      request.fields['d_bank'] = data[13];
      request.fields['d_ifsc'] = data[14];

      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerVerifyOtpDriver(List data) async {
    try {
      var result = await http.post("$baseURLDriver/register",
          body: {'phone_number': data[0], 'otp': data[1]});
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerResendOtpDriver(List data) async {
    try {
      var result = await http.post("$baseURLDriver/register", body: {
        'resend_otp': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<List> loginDriver(List data) async {
    try {
      var result = await http.post("$baseURLDriver/login", body: {
        'phone_code': '91',
        'phone': data[0],
        'password': data[1]
      });
      var jsonResult = json.decode(result.body);
      if (jsonResult['success'] == '1') {
        UserDriver userDriver = UserDriver.fromJson(jsonResult);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', data[2]);
        prefs.setString('userDriver', result.body);
        return [true, userDriver];
      } else {
        PostResultOne postResultOne = PostResultOne.fromJson(jsonResult);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', false);
        return [false, postResultOne];
      }
    } catch (error) {
      throw error;
    }
  }
}

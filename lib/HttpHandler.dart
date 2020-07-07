import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transportationapp/PostMethodResult.dart';

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
      request.files.add(await http.MultipartFile.fromPath('d_license', data[8]));
      request.files.add(await http.MultipartFile.fromPath('d_insurance', data[9]));
      request.files.add(await http.MultipartFile.fromPath('d_road_tax', data[10]));
      request.files.add(await http.MultipartFile.fromPath('d_rto', data[11]));
      request.fields['d_pan'] = data[12];
      request.fields['d_bank'] = data[13];
      request.fields['d_ifsc'] = data[14];

      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      PostResultOne postResultOne = PostResultOne.fromJson(json.decode(finalResult.body));
      return postResultOne;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> registerResendOtpDriver() async {
    try {} catch (error) {
      throw error;
    }
  }

  Future<bool> registerVerifyOtpDriver() async {
    try {} catch (error) {
      throw error;
    }
  }

  Future<bool> LoginDriver() async {
    try {} catch (error) {
      throw error;
    }
  }
}

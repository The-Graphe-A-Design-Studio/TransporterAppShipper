import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportationapp/Models/Truck.dart';
import 'package:transportationapp/Models/User.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/DialogScreens/DialogProcessing.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/DialogScreens/DialogSuccess.dart';
import 'package:transportationapp/MyConstants.dart';
import 'package:transportationapp/PostMethodResult.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/Models/TruckCategory.dart';

class HTTPHandler {
  String baseURLDriver =
      'https://developers.thegraphe.com/transport/api/drivers';
  String baseURLOwner = 'https://truckwale.co.in/api/truck_owner';
  String baseURLCustomer = 'https://truckwale.co.in/api/customer';

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

  void saveLocalChangesOwner(UserOwner userOwner) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(userOwner.toJson()));
  }

  /*-------------------------- Owner API's ---------------------------*/
  Future<PostResultOne> registerOwner(List data) async {
    try {
      var result = await http.post("$baseURLOwner/register", body: {
        'to_name': data[0],
        'to_phone_code': data[1],
        'to_phone': data[2],
        'to_email': data[3],
        'to_address': data[4],
        'to_city': data[5],
        'to_password': data[6],
        'to_cnf_password': data[7],
        'to_operating_routes': data[8],
        'to_state_permits': data[9],
        'to_pan': data[10],
        'to_bank': data[11],
        'to_ifsc': data[12]
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerVerifyOtpOwner(List data) async {
    try {
      var result = await http.post("$baseURLOwner/register",
          body: {'phone_number': data[0], 'otp': data[1]});
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerResendOtpOwner(List data) async {
    try {
      var result = await http.post("$baseURLOwner/register", body: {
        'resend_otp': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<List> loginOwner(List data) async {
    try {
      var result = await http.post("$baseURLOwner/login",
          body: {'phone_code': data[0], 'phone': data[1], 'password': data[2]});
      var jsonResult = json.decode(result.body);
      if (jsonResult['success'] == '1') {
        UserOwner userOwner = UserOwner.fromJson(jsonResult);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', data[3]);
        prefs.setString('userType', truckOwnerUser);
        prefs.setString('userData', result.body);
        return [true, userOwner];
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

  Future<PostResultOne> editOwnerInfo(List data) async {
    try {
      var result = await http.post("$baseURLOwner/profile", body: {
        'to_id': data[0],
        'to_name': data[1],
        'to_phone_code': data[2],
        'to_phone': data[3],
        'to_email': data[4],
        'to_address': data[5],
        'to_city': data[6],
        'to_operating_routes': data[7],
        'to_state_permits': data[8],
        'to_pan': data[9],
        'to_bank': data[10],
        'to_ifsc': data[11]
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editOwnerInfoVerifyOTP(List data) async {
    try {
      var result = await http.post("$baseURLOwner/profile", body: {
        'to_id': data[0],
        'phone_number': data[1],
        'otp': data[2],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editOwnerInfoResendOTP(List data) async {
    try {
      var result = await http.post("$baseURLOwner/profile", body: {
        'resend_otp': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editOwnerInfoChangePassword(List data) async {
    try {
      var result = await http.post("$baseURLOwner/profile", body: {
        'to_id': data[0],
        'curr_password': data[1],
        'new_password': data[2],
        'cnf_new_password': data[3],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  /*-------------------------- Truck API's ---------------------------*/
  Future<List<TruckCategory>> getTruckCategory() async {
    try {
      var result = await http.get("$baseURLOwner/truck_categories");
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

  Future<PostResultOne> addTrucksOwner(List data) async {
    try {
      var url = "$baseURLOwner/trucks";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_owner'] = data[0];
      request.fields['trk_cat'] = data[1];
      request.fields['trk_num'] = data[2];
      request.fields['trk_load'] = data[3];
      request.fields['trk_dr_name'] = data[4];
      request.fields['trk_dr_phone_code'] = data[5];
      request.fields['trk_dr_phone'] = data[6];
      request.files.add(await http.MultipartFile.fromPath('trk_rc', data[7]));
      request.files
          .add(await http.MultipartFile.fromPath('trk_dr_license', data[8]));
      request.files
          .add(await http.MultipartFile.fromPath('trk_insurance', data[9]));
      request.files
          .add(await http.MultipartFile.fromPath('trk_road_tax', data[10]));
      request.files.add(await http.MultipartFile.fromPath('trk_rto', data[11]));

      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editTruckInfo(List data) async {
    try {
      var result = await http.post("$baseURLOwner/trucks", body: {
        'trk_id': data[0],
        'trk_cat_edit': data[1],
        'trk_num_edit': data[2],
        'trk_load_edit': data[3],
        'trk_dr_name_edit': data[4],
        'trk_dr_phone_code_edit': data[5],
        'trk_dr_phone_edit': data[6]
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<List<Truck>> viewAllTrucks(List data) async {
    try {
      var result = await http
          .post("$baseURLOwner/trucks", body: {'truck_owner_id': data[0]});
      var ret = json.decode(result.body);
      List<Truck> list = [];
      for (var i in ret) {
        list.add(Truck.fromJson(i));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> deleteTrucks(List data) async {
    try {
      var result = await http
          .post("$baseURLOwner/trucks", body: {'del_truck_id': data[0]});
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> changeTruckStatus(List data) async {
    try {
      print(data);
      var result = await http.post("$baseURLOwner/trucks",
          body: {'trk_id': data[0], 'trk_status': data[1]});
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editTruckImage(List data) async {
    try {
      var url = "$baseURLOwner/trucks";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_id'] = data[0];
      request.files
          .add(await http.MultipartFile.fromPath('${data[1]}', data[2]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  /*Future<PostResultOne> editTruckRTO(List data) async {
    try {
      var url = "$baseURLOwner/trucks";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_id'] = data[0];
      request.files
          .add(await http.MultipartFile.fromPath('trk_rto_edit', data[1]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editTruckRoadTax(List data) async {
    try {
      var url = "$baseURLOwner/trucks";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_id'] = data[0];
      request.files
          .add(await http.MultipartFile.fromPath('trk_road_tax_edit', data[1]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editTruckInsurance(List data) async {
    try {
      var url = "$baseURLOwner/trucks";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_id'] = data[0];
      request.files.add(
          await http.MultipartFile.fromPath('trk_insurance_edit', data[1]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editTruckRc(List data) async {
    try {
      var url = "$baseURLOwner/trucks";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_id'] = data[0];
      request.files
          .add(await http.MultipartFile.fromPath('trk_rc_edit', data[1]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editTruckDriverLicense(List data) async {
    try {
      var url = "$baseURLOwner/trucks";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_id'] = data[0];
      request.files.add(
          await http.MultipartFile.fromPath('trk_dr_license_edit', data[1]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }*/

  /*-------------------------- Customer API's ---------------------------*/
  Future<PostResultOne> registerCustomerIndividual(List data) async {
    try {
      var result =
          await http.post("$baseURLCustomer/individual_register", body: {
        'in_cu_name': data[0],
        'in_cu_phone_code': data[1],
        'in_cu_phone': data[2],
        'in_cu_email': data[3],
        'in_cu_address': data[4],
        'in_cu_city': data[5],
        'in_cu_password': data[6],
        'in_cu_cnf_password': data[7],
        'in_cu_pan': data[8],
        'in_cu_pin': data[9],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerCustomerCompany(List data) async {
    try {
      var result = await http.post("$baseURLCustomer/company_register", body: {
        'co_cu_name': data[0],
        'co_cu_phone_code': data[1],
        'co_cu_phone': data[2],
        'co_cu_email': data[3],
        'co_cu_address': data[4],
        'co_cu_city': data[5],
        'co_cu_password': data[6],
        'co_cu_cnf_password': data[7],
        'co_cu_pan': data[8],
        'co_cu_pin': data[9],
        'co_name': data[7],
        'co_type': data[8],
        'co_service_tax': data[9],
        'co_pan_num': data[7],
        'co_website': data[8],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerVerifyOtpCustomer(List data) async {
    try {
      var result = await http.post("$baseURLCustomer/verification",
          body: {'phone_number': data[0], 'otp': data[1]});
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerResendOtpCustomer(List data) async {
    try {
      var result = await http.post("$baseURLCustomer/verification", body: {
        'resend_otp': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<List> loginCustomer(List data) async {
    try {
      var result = await http.post("$baseURLCustomer/login", body: {
        'cu_type': data[0],
        'phone_code': data[1],
        'phone': data[2],
        'password': data[3]
      });
      var jsonResult = json.decode(result.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (jsonResult['success'] == '1') {
        if (data[0] == "2") {
          UserCustomerCompany userCustomerCompany =
              UserCustomerCompany.fromJson(jsonResult);
          prefs.setBool('rememberMe', data[4]);
          prefs.setString('userType', transporterUserCompany);
          prefs.setString('userData', result.body);
          return [true, userCustomerCompany];
        } else if (data[0] == "1") {
          UserCustomerIndividual userCustomerIndividual =
              UserCustomerIndividual.fromJson(jsonResult);
          prefs.setBool('rememberMe', data[4]);
          prefs.setString('userType', transporterUserIndividual);
          prefs.setString('userData', result.body);
          return [true, userCustomerIndividual];
        } else {
          throw "error";
        }
      } else {
        PostResultOne postResultOne = PostResultOne.fromJson(jsonResult);
        prefs.setBool('rememberMe', false);
        return [false, postResultOne];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editCustomerIndividual(List data) async {
    try {
      var result =
          await http.post("$baseURLCustomer/individual_profile", body: {
        'cu_id': data[0],
        'cu_name': data[1],
        'cu_phone_code': data[2],
        'cu_phone': data[3],
        'cu_email': data[4],
        'cu_address': data[5],
        'cu_city': data[6],
        'cu_pan': data[7],
        'cu_pin': data[8],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editCustomerCompany(List data) async {
    try {
      var result = await http.post("$baseURLCustomer/company_register", body: {
        'cu_name': data[0],
        'cu_phone_code': data[1],
        'cu_phone': data[2],
        'cu_email': data[3],
        'cu_address': data[4],
        'cu_city': data[5],
        'cu_pan': data[8],
        'cu_pin': data[9],
        'cu_co_name': data[7],
        'cu_co_type': data[8],
        'cu_co_service_tax': data[9],
        'cu_co_pan_num': data[7],
        'cu_co_website': data[8],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  /*-------------------------- Driver API's ---------------------------*/
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
      var result = await http.post("$baseURLDriver/login",
          body: {'phone_code': '91', 'phone': data[0], 'password': data[1]});
      var jsonResult = json.decode(result.body);
      if (jsonResult['success'] == '1') {
        UserDriver userDriver = UserDriver.fromJson(jsonResult);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', data[2]);
        prefs.setString('userType', driverUser);
        prefs.setString('userData', result.body);
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

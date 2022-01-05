import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:IQRA/models/login_model.dart';
import 'package:IQRA/models/user_profile_model.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfileModel userProfileModel;
  LoginModel loginModel;
 myResponse()async{
   final response =
   await http.get(Uri.parse(APIData.userProfileApi), headers: {
     "Accept": "application/json",
     HttpHeaders.authorizationHeader: "Bearer $authToken",
   });
   var mymessage = jsonDecode(response.body);
   print('myMessage ${mymessage['paypal'][0]['subscription_to']}');
   return mymessage;
 }
  Future<UserProfileModel> getUserProfile(BuildContext context) async {
    try {
      final response =
          await http.get(Uri.parse(APIData.userProfileApi), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken",
      });
      print("11111111111111111111111");
      print(response.body);
      if (response.statusCode == 200) {
        print(response.statusCode);

        userProfileModel = UserProfileModel.fromJson(json.decode(response.body));

      } else {
        throw "Can't get user profile";
      }

      print(response);
    } catch (error) {
      print("--------------------");
      print(error);
      return null;
    }

    notifyListeners();

    return userProfileModel;
  }
}

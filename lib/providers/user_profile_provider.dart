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

  Future<UserProfileModel> getUserProfile(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(APIData.userProfileApi), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken",
      });
      print("you");
      print(response.body);
      if (response.statusCode == 200) {
        userProfileModel =
            UserProfileModel.fromJson(json.decode(response.body));
      } else {
        throw "Can't get user profile";
      }
    } catch (error) {
      return null;
    }
    notifyListeners();
    return userProfileModel;
  }
}

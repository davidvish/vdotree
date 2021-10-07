import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/models/login_model.dart';
import 'package:IQRA/providers/faq_provider.dart';
import 'package:IQRA/providers/main_data_provider.dart';
import 'package:IQRA/providers/menu_data_provider.dart';
import 'package:IQRA/providers/menu_provider.dart';
import 'package:IQRA/providers/movie_tv_provider.dart';
import 'package:IQRA/providers/slider_provider.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';
import '../common/apipath.dart';

class LoginProvider extends ChangeNotifier {
  LoginModel loginModel;
  bool loginStatus, loading1, loading2, emailVerify, loadData;
  String emailVerifyMsg = '';

  Future<void> login(String email, String password, BuildContext ctx) async {
    MenuProvider menuProvider = Provider.of<MenuProvider>(ctx, listen: false);
    UserProfileProvider userProfileProvider =
        Provider.of<UserProfileProvider>(ctx, listen: false);
    MainProvider mainProvider = Provider.of<MainProvider>(ctx, listen: false);
    SliderProvider sliderProvider =
        Provider.of<SliderProvider>(ctx, listen: false);
    MovieTVProvider movieTVProvider =
        Provider.of<MovieTVProvider>(ctx, listen: false);
    FAQProvider faqProvider = Provider.of<FAQProvider>(ctx, listen: false);
    try {
      final response = await http.post(
        APIData.loginApi,
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        loginModel = LoginModel.fromJson(json.decode(response.body));
        loginStatus = true;
        emailVerify = true;
        authToken = loginModel.accessToken;
        var rToken = loginModel.refreshToken;
        await storage.write(key: "login", value: "true");
        await storage.write(key: "authToken", value: "$authToken");
        await storage.write(key: "refreshToken", value: "$rToken");
        await menuProvider.getMenus(ctx);
        loading2 = true;
        await sliderProvider.getSlider();
        await userProfileProvider.getUserProfile(ctx);
        await faqProvider.fetchFAQ(ctx);
        await mainProvider.getMainApiData(ctx);
        await movieTVProvider.getMoviesTVData(ctx);
        loading2 = false;
        notifyListeners();
      } else if (response.statusCode == 401) {
        loginStatus = false;
      } else if (response.statusCode == 201) {
        emailVerify = false;
        emailVerifyMsg = response.body;
      } else {
        loginStatus = false;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> register(String name, String email, String password,
      String mobile,String code, BuildContext ctx) async {
    MenuProvider menuProvider = Provider.of<MenuProvider>(ctx, listen: false);
    UserProfileProvider userProfileProvider =
        Provider.of<UserProfileProvider>(ctx, listen: false);
    MainProvider mainProvider = Provider.of<MainProvider>(ctx, listen: false);
    SliderProvider sliderProvider =
        Provider.of<SliderProvider>(ctx, listen: false);
    MovieTVProvider movieTVProvider =
        Provider.of<MovieTVProvider>(ctx, listen: false);
    FAQProvider faqProvider = Provider.of<FAQProvider>(ctx, listen: false);
    try {
      final response = await http.post(
        APIData.registerApi,
        headers: {"Accept": "application/json"},
        body: {
          'email': email,
          'password': password,
          'name': name,
          "mobile": mobile,
          "code":code
        },
      );
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        loginModel = LoginModel.fromJson(json.decode(response.body));
        authToken = loginModel.accessToken;
        var rToken = loginModel.refreshToken;
        await storage.write(key: "login", value: "true");
        await storage.write(key: "authToken", value: "$authToken");
        await storage.write(key: "refreshToken", value: "$rToken");
        loading2 = true;
        await menuProvider.getMenus(ctx);
        await sliderProvider.getSlider();
        await userProfileProvider.getUserProfile(ctx);
        await faqProvider.fetchFAQ(ctx);
        await mainProvider.getMainApiData(ctx);
        await movieTVProvider.getMoviesTVData(ctx);
        loading2 = false;
        loginStatus = true;
        notifyListeners();
      } else if (response.statusCode == 401) {
        loginStatus = false;
      } else if (response.statusCode == 301) {
        emailVerify = false;
        emailVerifyMsg = response.body;
      } else {
        loginStatus = false;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> getAllData(BuildContext ctx) async {
    MenuProvider menuProvider = Provider.of<MenuProvider>(ctx, listen: false);
    UserProfileProvider userProfileProvider =
        Provider.of<UserProfileProvider>(ctx, listen: false);
    MainProvider mainProvider = Provider.of<MainProvider>(ctx, listen: false);
    SliderProvider sliderProvider =
        Provider.of<SliderProvider>(ctx, listen: false);
    MovieTVProvider movieTVProvider =
        Provider.of<MovieTVProvider>(ctx, listen: false);
    await userProfileProvider.getUserProfile(ctx);
    await menuProvider.getMenus(ctx);
    await sliderProvider.getSlider();
    await mainProvider.getMainApiData(ctx);
    await movieTVProvider.getMoviesTVData(ctx);
    notifyListeners();
  }
}

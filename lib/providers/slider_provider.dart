import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:IQRA/common/apipath.dart';
import '../common/global.dart';
import '../models/slider_model.dart';
import 'package:http/http.dart' as http;

class SliderProvider with ChangeNotifier {
  SliderModel sliderModel;

  Future<SliderModel> getSlider() async {
    final response = await http.get(Uri.parse(APIData.sliderApi), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $authToken",
    });
    sliderModel = SliderModel.fromJson(json.decode(response.body));
    notifyListeners();
    print("anam");
    print(sliderModel);
    return sliderModel;
  }
}

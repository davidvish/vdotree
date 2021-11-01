import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/models/faq_model.dart';

class FAQProvider with ChangeNotifier {
  FaqModel faqModel;

  Future<FaqModel> fetchFAQ(BuildContext context) async {
    final response = await http.get(Uri.parse(APIData.faq), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (response.statusCode == 200) {
      faqModel = FaqModel.fromJson(json.decode(response.body));
    } else {
      throw "Can't faq data";
    }
    notifyListeners();
    return faqModel;
  }
}

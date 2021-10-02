import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/models/payment_key_model.dart';
import 'package:http/http.dart' as http;

class PaymentKeyProvider with ChangeNotifier {
  PaymentKeyModel paymentKeyModel;

  Future<PaymentKeyModel> fetchPaymentKeys() async {
    try {
      final response = await http.get(APIData.stripeDetailApi,
          headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
      print(response.statusCode);
      if (response.statusCode == 200) {
        paymentKeyModel = PaymentKeyModel.fromJson(json.decode(response.body));
      } else {
        throw "Can't get payment keys";
      }
      notifyListeners();
      return paymentKeyModel;
    } catch (error) {
      throw error;
    }
  }
}

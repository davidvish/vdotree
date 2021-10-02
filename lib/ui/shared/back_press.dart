import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IQRA/common/global.dart';

class OnBackPress {
  //  Handle back press
  static Future<bool> onWillPopS() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit.");
      return Future.value(false);
    }
    return SystemNavigator.pop();
  }
}

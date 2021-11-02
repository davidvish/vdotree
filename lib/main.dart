import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:IQRA/common/styles.dart';
import 'common/global.dart';
import 'my_app.dart';
import 'package:IQRA/services/repository/database_creator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterDownloader.initialize();
  await DatabaseCreator().initDatabase();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: kDarkBgLight,
    statusBarColor: kDarkBgLight,
    //statusBarColor: Colors.black45,
  ));
  authToken = await storage.read(key: "token");
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(MyApp());
  OneSignal.shared.setAppId("07ef6c88-0305-4f67-b1af-471aa9cdbdf7");
  // OneSignal.shared
  //     .setInFocusDisplayType(OSNotificationDisplayType.notification);

  OneSignal.shared.promptUserForPushNotificationPermission();
  // OneSignal.shared
  //     .setNotificationReceivedHandler((OSNotification notification) {
  //   // will be called whenever a notification is received
  // });
  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // will be called whenever a notification is opened/button pressed.
  });
  runApp(MyApp(
    token: authToken,
  ));
}


//4fe1e977-b5e1-4462-ba6f-0e32d1f57463

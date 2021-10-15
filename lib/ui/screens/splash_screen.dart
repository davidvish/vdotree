import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:IQRA/common/styles.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:IQRA/providers/main_data_provider.dart';
import 'package:IQRA/providers/menu_provider.dart';
import 'package:IQRA/providers/movie_tv_provider.dart';
import 'package:IQRA/providers/slider_provider.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:IQRA/ui/screens/multi_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({this.token});
  final String token;
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _flexibleUpdateAvailable = false;
  AppUpdateInfo _updateInfo;
  // ignore: unused_field
  String _debugLabelString = "";

  // ignore: unused_field
  bool _enableConsentButton = false;
  bool _requireConsent = true;
  TargetPlatform platform;

  // Future<Null> setLocalPath() async {
  //   // setState(() {
  //   //   localPath = APIData.localPath;
  //   // });
  //   if (Platform.isAndroid) {
  //     // print("path!!!!!!!!    android    " + APIData.localPath);
  //     // setState(() {
  //     //   localPath = APIData.localPath;
  //     // });
  //     final directory = //await getApplicationDocumentsDirectory();
  //     await getExternalStorageDirectory();
  //     print("path!!!!!!!!     android   " + directory.path);
  //     setState(() {
  //       localPath = directory.path + "/Download";
  //     });
  //   }else {
  //     final directory =
  //     await getApplicationDocumentsDirectory();
  //     print("path!!!!!!!!    ios    " + directory.path);
  //     setState(() {
  //       localPath = directory.path + "/Download";
  //     });
  //   }
  // }

  Future<Null> setLocalPath() async {
    print('sms');
    var deviceLocalPath =
        (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    print('local path: splash screen!!!!!!!!!!!!!!!    $deviceLocalPath');
    setState(() {
      localPath = deviceLocalPath;
      dLocalPath = deviceLocalPath;
    });
  }

  Future<String> _findLocalPath() async {
    if(Platform.isAndroid)
      {
        final directory = await getExternalStorageDirectory();
        print("Android Path splash!!!!!!!!! " + directory.path);
        return directory.path;
      }
    final directory = await getApplicationDocumentsDirectory();
    print("ios Path splash!!!!!!!!! " + directory.path);
    return directory.path;
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) => _showError(e));
    if (_updateInfo.updateAvailable) {
      InAppUpdate.startFlexibleUpdate().then((_) {
        setState(() {
          _flexibleUpdateAvailable = true;
        });
      }).catchError((e) => _showError(e));
    }
    if (!_flexibleUpdateAvailable) {
      InAppUpdate.completeFlexibleUpdate().then((_) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Success!')));
      }).catchError((e) => _showError(e));
    }
  }

  void _showError(dynamic exception) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(exception.toString())));
  }

  // For One Signal notification
  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared
        .setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      this.setState(() {
        _debugLabelString =
            "Received notification: \n${event.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      this.setState(() {
        _debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      this.setState(() {
        _debugLabelString =
            "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {});

    OneSignal.shared
        .setPermissionObserver((OSPermissionStateChanges changes) {});

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {});

    await OneSignal.shared.setAppId(APIData.onSignalAppId);

    // OneSignal.shared
    //     .setInFocusDisplayType(OSNotificationDisplayType.notification);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    this.setState(() {
      _enableConsentButton = requiresConsent;
    });
    oneSignalInAppMessagingTriggerExamples();
  }

  oneSignalInAppMessagingTriggerExamples() async {
    OneSignal.shared.addTrigger("trigger_1", "one");

    Map<String, Object> triggers = new Map<String, Object>();
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.shared.addTriggers(triggers);

    OneSignal.shared.removeTriggerForKey("trigger_2");

    // ignore: unused_local_variable
    Object triggerValue =
        await OneSignal.shared.getTriggerValueForKey("trigger_3");
    List<String> keys = new List<String>();
    keys.add("trigger_1");
    keys.add("trigger_3");
    OneSignal.shared.removeTriggersForKeys(keys);

    OneSignal.shared.pauseInAppMessages(false);
  }

  // For One Signal permission
  void _handleConsent() {
    OneSignal.shared.consentGranted(true);
    this.setState(() {
      _enableConsentButton = false;
    });
  }

  @override
  void initState() {
    super.initState();
//   In app update and it works only in live mode after deploying on PlayStore
//    checkForUpdate();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setLocalPath();
      checkLoginStatus();
    });
  }

  Widget logoImage(myModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset(
              'assets/logo.png',
              width: 90.0,
              height: 80.0,
            ),
          ),
        )
      ],
    );
  }

  Future checkLoginStatus() async {
    final appConfig = Provider.of<AppConfig>(context, listen: false);
    await appConfig.getHomeData(context);
    print(appConfig.slides);
    print("bhati");
    final all = await storage.read(key: "login");
    print("anam");
    print(all);
    if (all == "true") {
      _handleConsent();
      initPlatformState();
      var token = await storage.read(key: "authToken");
      setState(() {
        authToken = token;
      });
      final menuProvider = Provider.of<MenuProvider>(context, listen: false);
      final userProfileProvider =
          Provider.of<UserProfileProvider>(context, listen: false);
      final mainProvider = Provider.of<MainProvider>(context, listen: false);
      final sliderProvider =
          Provider.of<SliderProvider>(context, listen: false);
      final movieTVProvider =
          Provider.of<MovieTVProvider>(context, listen: false);
      await userProfileProvider.getUserProfile(context);
      await menuProvider.getMenus(context);
      await sliderProvider.getSlider();
      await mainProvider.getMainApiData(context);
      await movieTVProvider.getMoviesTVData(context);
      var userDetails =
          Provider.of<UserProfileProvider>(context, listen: false);
      print(userDetails.userProfileModel);
      if (userDetails.userProfileModel.active == "1" ||
          userDetails.userProfileModel.active == 1) {
        if (userDetails.userProfileModel.payment == "Free") {
          Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
        } else {
          var activeScreen = await storage.read(key: "activeScreen");
          var actScreenCount = await storage.read(key: "screenCount");
          if (activeScreen == null) {
            Navigator.pushNamed(context, RoutePaths.multiScreen);
          } else {
            setState(() {
              myActiveScreen = activeScreen;
              screenCount = actScreenCount;
            });
            getAllScreens();
            Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
          }
        }
      } else {
        Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
      }
    } else {
      if (appConfig.slides.length == 0) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool _seen = (prefs.getBool('seen') ?? false);
        if (_seen) {
          // Navigator.pushNamed(context, RoutePaths.introSlider
          Navigator.pushNamed(context, RoutePaths.loginHome);
        } else {
          await prefs.setBool('seen', true);
          Navigator.pushNamed(context, RoutePaths.introSlider);
        }
      } else {
        Navigator.pushNamed(context, RoutePaths.introSlider);
      }
    }
  }

  Future<String> getAllScreens() async {
    final getAllScreensResponse =
        await http.get(Uri.encodeFull(APIData.showScreensApi), headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json"
    });
    if (getAllScreensResponse.statusCode == 200) {
      var screensRes = json.decode(getAllScreensResponse.body);
      setState(() {
        screen1 = screensRes['screen']['screen1'] == null
            ? "Screen1"
            : screensRes['screen']['screen1'];
        screen2 = screensRes['screen']['screen2'] == null
            ? "Screen2"
            : screensRes['screen']['screen2'];
        screen3 = screensRes['screen']['screen3'] == null
            ? "Screen3"
            : screensRes['screen']['screen3'];
        screen4 = screensRes['screen']['screen4'] == null
            ? "Screen4"
            : screensRes['screen']['screen4'];

        activeScreen = screensRes['screen']['activescreen'];
        screenUsed1 = screensRes['screen']['screen_1_used'];
        screenUsed2 = screensRes['screen']['screen_2_used'];
        screenUsed3 = screensRes['screen']['screen_3_used'];
        screenUsed4 = screensRes['screen']['screen_4_used'];
        screenList = [
          ScreenProfile(0, screen1, screenUsed1),
          ScreenProfile(1, screen2, screenUsed2),
          ScreenProfile(2, screen3, screenUsed3),
          ScreenProfile(3, screen4, screenUsed4),
        ];
      });
    } else if (getAllScreensResponse.statusCode == 401) {
      storage.deleteAll();
      Navigator.pushNamed(context, RoutePaths.login);
    } else {
      throw "Can't get screens data";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<AppConfig>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        body: Stack(
          children: [
            // Container(
            //     height: MediaQuery.of(context).size.height * 1,
            //     width: MediaQuery.of(context).size.width * 1,
            //     decoration: new BoxDecoration(
            //       image: new DecorationImage(
            //         image: new ExactAssetImage('assets/netflix.jpg'),
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //     child: new ImageFiltered(
            //         imageFilter: ImageFilter.blur(
            //             sigmaY: 2,
            //             sigmaX:
            //                 2), //SigmaX and Y are just for X and Y directions
            //         child: Image.asset(
            //           'assets/netflix.jpg',
            //           fit: BoxFit.cover,
            //         ) //here you can use any widget you'd like to blur .
            //         )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                logoImage(myModel),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "VDOTREE",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Watch and find movies that",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 20),
                  child: Text(
                    "bring your mood back",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                CircularProgressIndicator(
                  backgroundColor: primaryBlue,
                ),
              ],
            ),
          ],
        ));
  }
}

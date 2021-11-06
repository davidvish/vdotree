import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'common/apipath.dart';
import 'providers/actor_movies_provider.dart';
import 'providers/app_config.dart';
import 'common/route_paths.dart';
import 'package:provider/provider.dart';
import 'common/styles.dart';
import 'providers/faq_provider.dart';
import 'providers/login_provider.dart';
import 'providers/main_data_provider.dart';
import 'providers/menu_data_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/movie_tv_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/payment_key_provider.dart';
import 'providers/slider_provider.dart';
import 'providers/user_profile_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/coupon_provider.dart';
import 'ui/route_generator.dart';
import 'ui/screens/splash_screen.dart';
import 'providers/watch_history_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MyApp extends StatefulWidget {
  MyApp({this.token});
  final String token;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _outtaxt = "761aaf28-acf7-4e70-8e2a-936cd3f33a35";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // OneSignal.shared.setNotificationWillShowInForegroundHandler((event) { })((OSNotification notification) {
    //   print("setNotificationReceivedHandler");

    //   // Navigator.push(
    //   //   context,
    //   //   MaterialPageRoute(
    //   //     builder: (context) => LiveSession(),
    //   //   ),
    //   // );
    // });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("setNotificationOpenedHandler");
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => LiveSession(),
//     ),
//   );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppConfig()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => SliderProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(create: (_) => MovieTVProvider()),
        ChangeNotifierProvider(create: (_) => MenuDataProvider()),
        ChangeNotifierProvider(create: (_) => WishListProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => FAQProvider()),
        ChangeNotifierProvider(create: (_) => PaymentKeyProvider()),
        ChangeNotifierProvider(create: (_) => WatchHistoryProvider()),
        ChangeNotifierProvider(create: (_) => ActorMoviesProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
      ],
      child: MaterialApp(
            
        debugShowCheckedModeBanner: false,
        supportedLocales: [
             Locale('en','US'),
           ],
           localizationsDelegates:
           [
             CountryLocalizations.delegate
           ],
        title: RoutePaths.appTitle,
        theme: buildDarkTheme(),
        initialRoute: RoutePaths.splashScreen,
        onGenerateRoute: RouteGenerator.generateRoute,
        routes: {
          RoutePaths.splashScreen: (context) =>
              SplashScreen(token: widget.token),
        },
      ),
    );
  }

  Future<String> initOneSignal() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId(APIData.onSignalAppId);
    OneSignal.shared.sendUniqueOutcome(OSNotificationDisplayType.notification as String);
    OneSignal.shared
        .setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      this.setState(() {
        _outtaxt =
            "Received notification: \n${event.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      this.setState(() {});
    });
  }
}

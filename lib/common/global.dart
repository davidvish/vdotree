import 'dart:io';
import 'package:IQRA/ui/screens/multi_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:IQRA/models/task_info.dart';
import 'package:IQRA/models/todo.dart';
import 'package:IQRA/ui/screens/multi_screen.dart';
import 'package:IQRA/ui/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

var authToken;
DateTime currentBackPressTime;
final storage = FlutterSecureStorage();
var menuId;
List<Todo> todos = List();
List<ScreenProfile> screenList = [];
List<ScreenProfileMenu> screenListMenu = [];

Database database;
List<TaskInfo> dTasks;
List<ItemHolder> dItems;
bool isLoading;
bool permissionReady = false;
String dLocalPath;
File jsonFile;
Directory dir;
String fileName = "userJSON.json";
bool fileExists = false;
Map<dynamic, dynamic> fileContent;
var dCount;
var download;
SharedPreferences prefs;
var downFileName;
bool boolValue;
var checkConnectionStatus;
String dailyAmountAp;
var dailyAmount;
var seasonEpisodeData;
var episodesCount;
var seasonId;
var ser;
var myActiveScreen;
var screenCount;
var screenStatus;
var screenName;
String ip = 'Unknown';
String localPath;
var activeScreen;
var playerTitle;
var braintreeClientNonce;
var screenUsed1;
var screenUsed2;
var screenUsed3;
var screenUsed4;
var screen1, screen2, screen3, screen4;

Color activeDotColor = const Color.fromRGBO(125, 183, 91, 1.0);

class Constants {
  static const double sliderHeight = 190.0;
  static const double genreListHeight = 60.0;
  static const double genreItemHeight = 60.0;
  static const double genreItemWidth = 110.0;
  static const double genreItemRightMargin = 10.0;
  static const double genreItemLeftMargin = 15.0;
  static const List<Color> gradientRed = [Color(0xFF7EA6F6), Color(0xFF85C3EF)];
  static const List<Color> gradientBlue = [
    Color(0xFFC6428D),
    Color(0xFFD189E2)
  ];
  static const List<Color> gradientGreen = [
    Color(0xFFF09E59),
    Color(0xFFF4AF64)
  ];
  static const List<Color> gradientYellow = [
    Color(0xFF9A80F6),
    Color(0xFFCA7CF2)
  ];
  static const List<Color> gradientPurple = [
    Color(0xFF304C89),
    Color(0xFF648DE5)
  ];
  static const List<Color> gradientPink = [
    Color(0xFF923C01),
    Color(0xFFEF8B47)
  ];
  static const List<Color> gradientOrange = [
    Color(0xFF6202E2),
    Color(0xFFA76AFF)
  ];
  static const List<Color> gradientAmber = [
    Color(0xFF64E2C2),
    Color(0xFF68E8CC)
  ];
  static const List gradientColors = [
    gradientRed,
    gradientBlue,
    gradientGreen,
    gradientYellow,
    gradientPurple,
    gradientPink,
    gradientOrange,
    gradientAmber
  ];

  static const String blog_home_title = "Our Blog Posts";
}

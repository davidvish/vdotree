import 'dart:convert';
import 'dart:io';
import 'package:IQRA/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_ip/get_ip.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:IQRA/ui/screens/bottom_navigations_bar.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class MultiMenuScreen extends StatefulWidget {

  @override
  _MultiMenuScreenState createState() => _MultiMenuScreenState();
}

class _MultiMenuScreenState extends State<MultiMenuScreen> {
   Widget appBar() {
    var appConfig = Provider.of<AppConfig>(context, listen: false).appModel;
    return AppBar(
      title: Image.network(
        '${APIData.logoImageUri}${appConfig.config.logo}',
        scale: 1.7,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.edit,
            size: 30,
            color: Colors.white,
          ),
          padding: EdgeInsets.only(right: 15.0),
          onPressed: () => Navigator.pushNamed(
            context,
            RoutePaths.createScreen,
          ),
        ),
      ],
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Color.fromRGBO(34, 34, 34, 1.0).withOpacity(0.98),
    );
  }

  Future<void> initPlatformState() async {
    String ipAddress;
    try {
      ipAddress = await GetIp.ipAddress;
    } on PlatformException {
      ipAddress = 'Failed to get ipAddress.';
    }
    if (!mounted) return;
    setState(() {
      ip = ipAddress;
    });
  }

  updateScreens(screen, count, index) async {
    print("saad bhati");
    final updateScreensResponse =
        await http.post(APIData.updateScreensApi, body: {
      "macaddress": '$ip',
      "screen": '$screen',
      "count": '$count',
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    });
    print(updateScreensResponse.body);
    if (updateScreensResponse.statusCode == 200) {
      storage.write(
          key: "screenName", value: "${screenList[index].screenName}");
      storage.write(key: "screenStatus", value: "YES");
      storage.write(key: "screenCount", value: "${screenList[index].id + 1}");
      storage.write(
          key: "activeScreen", value: "${screenList[index].screenName}");
      Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
    } else {
      Fluttertoast.showToast(msg: "Error in selecting profile");
      throw "Can't select profile";
    }
  }

  Future<String> getAllScreens() async {
    final getAllScreensResponse =
        await http.get(Uri.encodeFull(APIData.showScreensApi), headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json"
    });
    print("saad anam");
    print(getAllScreensResponse.body);
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
        screenListMenu = [
          ScreenProfileMenu(0, screen1, screenUsed1),
          ScreenProfileMenu(1, screen2, screenUsed2),
          ScreenProfileMenu(2, screen3, screenUsed3),
          ScreenProfileMenu(3, screen4, screenUsed4),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getAllScreens();
    initPlatformState();
  }

  _signOutDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
             shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
              color: Colors.blue, width: 1, style: BorderStyle.solid)),
            backgroundColor: Colors.black87,
            contentTextStyle: TextStyle(color: Colors.yellow, fontSize: 17),
            titleTextStyle: TextStyle(
                color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold),
            title: Text(
              'Sign Out?',
              textAlign: TextAlign.center,
            ),
            content: Text('Are you sure that you want to logout?',textAlign: TextAlign.center,),

            actions: <Widget>[
              SizedBox(
                width: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 20),
                      backgroundColor: Colors.black87,
                    ),
                    onPressed: () {
                      print("you choose no");
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                     onTap: () async {
                      print("logout");
                      await storage.deleteAll();
                      Navigator.pushNamed(context, RoutePaths.loginHome);
                      // screenLogout();
                    },
                    
                    child: Container(

                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 5),
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(

                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(5)),
                      
                        child: Text(
                          'Confirm',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                    ),
                
                ],
              ),
              // TextButton(
              //   style: TextButton.styleFrom(
              //     textStyle: TextStyle(fontSize: 20),
              //     backgroundColor: Colors.black87,
              //   ),
              //   onPressed: () {
              //     print("logout");
              //     screenLogout();
              //   },
              //   child: Text(
              //     'Confirm',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              SizedBox(
                width: 50,
              ),
            ],
          );
        });
  }

  bool isShowing = true;
  screenLogout() async {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    setState(() {
      isShowing = false;
    });
    var screenLogOutResponse, screenCount, actScreen;

    if (userDetails.active == "1" || userDetails.active == 1) {
      if (userDetails.payment == "Free") {
        screenLogOutResponse = await http.post(APIData.screenLogOutApi,
            headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
      } else {
        screenCount = await storage.read(key: "screenCount");
        actScreen = await storage.read(key: "activeScreen");
        screenLogOutResponse = await http.post(APIData.screenLogOutApi, body: {
          "screen": '$actScreen',
          "count": '$screenCount',
          "macaddress": '$ip',
        }, headers: {
          HttpHeaders.authorizationHeader: "Bearer $authToken"
        });
      }
    } else {
      screenLogOutResponse = await http.post(APIData.screenLogOutApi,
          headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    }
    if (screenLogOutResponse.statusCode == 200) {
      setState(() {
        isShowing = true;
      });
      await storage.deleteAll();
      Navigator.pushNamed(context, RoutePaths.loginHome);
    } else {
      setState(() {
        isShowing = true;
      });
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }
  final List<String>  imageProfile = ['assets/1.png','assets/2.png','assets/3.png','assets/4.png'];

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    return WillPopScope(
        child: Scaffold(
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.only(right: 0.0),
          //   child: FloatingActionButton(
          //     child: Icon(
          //       Icons.settings_power,
          //       color: Colors.black,
          //     ),
          //     backgroundColor: primaryBlue,
          //     onPressed: () {
          //       _signOutDialog();
          //     },
          //   ),
          // ),
          backgroundColor: Colors.white,
          appBar: customAppBar(context, "Select Profile"),
          body: screenList.length == 0
              ? Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 4,),
                    
                      Icon(Icons.warning,size: 70,),
                      SizedBox(height: 40,),
                      Center(
                       child:Padding(
                         padding: const EdgeInsets.only(left: 11,right: 11),
                         child: FittedBox(child: Text('No Series and Movies found with this genres',style: TextStyle(fontSize: 20),)),
                       )
                      ),
                    ],
                  ),
                )
              : Container(
                  color: Colors.black,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 30.0, bottom: 30.0),
                                  child: Text(
                                    "Who's Watching?",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9,
                                  crossAxisSpacing: 20),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(
                                        //color: Colors.blue,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 0),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            border: Border.all(
                                             // color: Colors.blue,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        height: 110.0,
                                        child: Column(
                                          children: <Widget>[
                                            FittedBox(
                                              child: Container(
                                                child: Image.asset(
                                                  imageProfile[index],
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .4,
                                                  height: 110.0,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            FittedBox(
                                              child: Text(
                                                "${screenList[index].screenName}",
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: primaryBlue,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        print("ok");
                                        print(screenList[index].screenStatus);
                                        if ("${screenList[index].screenStatus}" ==
                                            "YES") {
                                          Fluttertoast.showToast(
                                              msg: "Profile already in use.");
                                        } else {
                                          setState(() {
                                            myActiveScreen =
                                                screenList[index].screenName;
                                            screenCount = index + 1;
                                          });
                                          print("ok");
                                          updateScreens(myActiveScreen,
                                              screenCount, index);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: userProfile.screen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        onWillPop: onWillPopS);
  }
}
class ScreenProfileMenu {
  int id;
  String screenName;
  String screenStatus;

  ScreenProfileMenu(this.id, this.screenName, this.screenStatus);
}
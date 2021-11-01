import 'dart:convert';
import 'dart:io';
import 'package:IQRA/common/styles.dart';
import 'package:IQRA/ui/screens/multi_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

import 'package:share/share.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String platform;

// user name
  Widget userName() {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    return Container(
      margin: EdgeInsets.only(right: 100, top: 20),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 0,
            ),
            child: Text(userDetails.user.name,
                style: TextStyle(
                    color: primaryBlue,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400)),
          ),
          FittedBox(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                userDetails.user.email,
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Manage Profile
  Widget manageProfile(width, context) {
    return Container(
      padding: EdgeInsets.only(right: 120, left: 20),
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text(
              "Manage Profile",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            color: primaryBlue,
            onPressed: () {
              Navigator.pushNamed(context, RoutePaths.manageProfile);
            },
          ),
        ],
      ),
    );
  }

  Widget profileImage() {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            right: 10.0,
          ),
          height: 120.0,
          width: 120.0,
          child: ClipRRect(
            borderRadius: new BorderRadius.all(Radius.circular(60.0)),
            child: userDetails.user.image != null
                ? Image.network(
                    "${APIData.profileImageUri}" + "${userDetails.user.image}",
                    scale: 1.7,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/avatar.jpg",
                    scale: 1.7,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ],
    );
  }

  updateScreens(screen, count, index) async {
    final updateScreensResponse =
        await http.post(APIData.updateScreensApi, body: {
      "macaddress": '$ip',
      "screen": '$screen',
      "count": '$count',
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    });
    print(updateScreensResponse.statusCode);
    if (updateScreensResponse.statusCode == 200) {
      storage.write(
          key: "screenName", value: "${screenList[index].screenName}");
      storage.write(key: "screenStatus", value: "YES");
      storage.write(key: "screenCount", value: "${index + 1}");
      storage.write(
          key: "activeScreen", value: "${screenList[index].screenName}");
    } else {
      Fluttertoast.showToast(msg: "Error in selecting profile");
      throw "Can't select profile";
    }
  }

//  Drawer Header
  Widget drawerHeader(width) {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    return Container(
        color: Colors.black,
        width: width,
        child: DrawerHeader(
          margin: EdgeInsets.fromLTRB(0, 0.0, 20, 0),
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.black,
                height: 15.0,
              ),
              // userDetails.active == "1" || userDetails.active == 1
              //     ? userDetails.payment == "Free"
              //         ? profileImage()
              Container(
                color: Colors.black,
                height: 130,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child:
                            //  "${screenList[index].id + 1}" == '1'
                            //     ?
                            Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10, left: 30),
                              height: 120.0,
                              width: 120.0,
                              child: ClipRRect(
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(60.0)),
                                child: userDetails.user.image != null
                                    ? Image.network(
                                        "${APIData.profileImageUri}" +
                                            "${userDetails.user.image}",
                                        scale: 1.7,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/avatar.jpg",
                                        scale: 1.7,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                userName(),
                                // Container(
                                //   padding: EdgeInsets.only(
                                //     right: 0,
                                //   ),
                                //   child: Text(
                                //     userDetails.user.email,
                                //     textAlign: TextAlign.center,
                                //     style:
                                //         TextStyle(fontSize: 16),
                                //   ),
                                // ),
                                manageProfile(width, context),
                              ],
                            ),
                            // manageProfile(width, context),

                            // Container(
                            //   height: 70.0,
                            //   margin:
                            //       EdgeInsets.only(right: 10.0),
                            //   width: 70,
                            //   child: userDetails.user.image !=
                            //           null
                            //       ? Image.network(
                            //           "${APIData.profileImageUri}" +
                            //               "${userDetails.user.image}",
                            //           fit: BoxFit.cover,
                            //         )
                            //       : Image.asset(
                            //           "assets/avatar.png",
                            //           width:
                            //               MediaQuery.of(context)
                            //                       .size
                            //                       .width /
                            //                   4.5,
                            //           fit: BoxFit.cover,
                            //         ),
                            //   decoration: BoxDecoration(
                            //       border: Border.all(
                            //           color: Colors.white,
                            //           width: 1.0)),
                            // ),
                            // SizedBox(
                            //   height: 10.0,
                            // ),
                            // Text(
                            //   screenList[index].screenName,
                            //   style: TextStyle(
                            //       fontSize: 12.0,
                            //       color: primaryBlue),
                            // ),
                          ],
                        ),
                        // : Column(
                        //     children: <Widget>[
                        //       Container(
                        //         margin: EdgeInsets.only(
                        //             top: 10, left: 30),
                        //         height: 120.0,
                        //         width: 120.0,
                        //         child: ClipRRect(
                        //           borderRadius:
                        //               new BorderRadius.all(
                        //                   Radius.circular(60.0)),
                        //           child: userDetails.user.image !=
                        //                   null
                        //               ? Image.network(
                        //                   "${APIData.profileImageUri}" +
                        //                       "${userDetails.user.image}",
                        //                   scale: 1.7,
                        //                   fit: BoxFit.cover,
                        //                 )
                        //               : Image.asset(
                        //                   "assets/avatar.jpg",
                        //                   scale: 1.7,
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //         ),
                        //       ),
                        //       // SizedBox(
                        //       //   height: 10.0,
                        //       // ),
                        //       // userName(
                        //       //     screenList[index].screenName),
                        //     ],
                        //   ),
                        onTap: () {
                          if ("${screenList[index].screenStatus}" == "YES") {
                            Fluttertoast.showToast(
                                msg: "Profile already in use.");
                          } else {
                            setState(() {
                              myActiveScreen = screenList[index].screenName;
                              screenCount = index + 1;
                            });
                            updateScreens(myActiveScreen, screenCount, index);
                          }
                        },
                      );
                    }),
              ),
              //  profileImage(),
              Container(
                color: Colors.black,
                height: 15.0,
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ));
  }

//  Notification
  Widget notification() {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth <= 768) {
        return Container(
          // padding: EdgeInsets.only(bottom: 10),
          // color: Colors.black,

          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.notifications);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.notifications_active,
                        size: 20, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Notifications",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.notifications);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.notifications_active,
                        size: 29, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Notifications",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      }
    });
  }

  Widget multiScrenMenu() {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth <= 768) {
        return Container(
          // color: Colors.black,
          // padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => MultiMenuScreen()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.splitscreen, size: 20, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Update Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => MultiMenuScreen()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.splitscreen, size: 29, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Update Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      }
    });
  }

//  App settings
  Widget appSettings() {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth <= 768) {
        return Container(
          // padding: EdgeInsets.only(bottom: 10),

          // color: Colors.black,
          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.appSettings);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.settings, size: 20, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "App Settings",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.appSettings);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.settings, size: 29, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "App Setting",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      }
    });
  }

  //  watch  history
  Widget watchHistory() {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth <= 768) {
        return Container(
          // padding: EdgeInsets.only(bottom: 10),

          // color: Colors.black,
          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.watchHistory);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.solidPlayCircle,
                        size: 20, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Watch History",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.watchHistory);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.solidPlayCircle,
                        size: 29, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Watch History",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      }
    });
  }

//  Account
  Widget account() {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth <= 768) {
        return Container(
          // padding: EdgeInsets.only(bottom: 10),

          // color: Colors.black,
          child: InkWell(
              onTap: () {
                _onButtonPressed();
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.account_box, size: 20, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () {
                _onButtonPressed();
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.account_box, size: 29, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      }
    });
  }

  void _showDialog3() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: new Text(
            "Subscription Alert",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          content: new Text(
            "You already have Subscription",
            style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 16.0),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: activeDotColor, fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(color: activeDotColor, fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//  Subscribe
  Widget subscribe() {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth <= 768) {
        return Container(
          // padding: EdgeInsets.only(bottom: 10),

          // color: Colors.black,
          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.subscriptionPlans);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.subscriptions, size: 20, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Subscribe",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.subscriptionPlans);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.subscriptions, size: 29, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Subscribe",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      }
    });
  }

//  Help
  Widget help() {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth <= 768) {
        return Container(
          // padding: EdgeInsets.only(bottom: 10),

          // color: Colors.black,

          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.faq);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.message, size: 20, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "FAQ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.faq);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.message, size: 29, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "FAQ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      }
    });
  }

  // Blog
  Widget blog() {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.blogList);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.queue_play_next_sharp, size: 20, color: Colors.white),
              SizedBox(
                width: 20.0,
              ),
              Text(
                "Blog",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  // Donate
  Widget donate() {
    return InkWell(
        onTap: () {
          // Navigator.pushNamed(context, RoutePaths.donation);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Donate",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

//  Rate Us
  Widget rateUs() {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth <= 768) {
        return Container(
          // padding: EdgeInsets.only(bottom: 10),

          // color: Colors.black,
          child: InkWell(
              onTap: () => launch(
                  'https://play.google.com/store/apps/details?id=com.vdotree.vdotree'),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.star, size: 20, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Rate Us",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () => launch(
                  'https://play.google.com/store/apps/details?id=com.vdotree.vdotree'),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.star, size: 29, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ), 
                    Text(
                      "Rate Us",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      }
    });
  }

//  Share app
  Widget shareApp() {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth <= 768) {
        return Container(
          // padding: EdgeInsets.only(bottom: 10),

          // color: Colors.black,
          child: InkWell(
              onTap: () {
                String os = Platform.operatingSystem; //in your code
                if (os == 'android') {
                  if (APIData.androidAppId != '') {
                    Share.share(APIData.shareAndroidAppUrl);
                  } else {
                    Fluttertoast.showToast(msg: 'PlayStore id not available');
                  }
                } else {
                  if (APIData.iosAppId != '') {
                    Share.share(APIData.iosAppId);
                  } else {
                    Fluttertoast.showToast(msg: 'AppStore id not available');
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.share, size: 20, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Share app",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () {
                String os = Platform.operatingSystem; //in your code
                if (os == 'android') {
                  if (APIData.androidAppId != '') {
                    Share.share(APIData.shareAndroidAppUrl);
                  } else {
                    Fluttertoast.showToast(msg: 'PlayStore id not available');
                  }
                } else {
                  if (APIData.iosAppId != '') {
                    Share.share(APIData.iosAppId);
                  } else {
                    Fluttertoast.showToast(msg: 'AppStore id not available');
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.share, size: 29, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Share app",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      }
    });
  }

//  Sign Out
  Widget signOut() {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth <= 768) {
        return Container(
          // padding: EdgeInsets.only(bottom: 10),

          // color: Colors.black,
          child: InkWell(
              onTap: () {
                _signOutDialog();
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.settings_power, size: 20, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Sign Out",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10),

          child: InkWell(
              onTap: () {
                _signOutDialog();
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.settings_power, size: 29, color: Colors.white),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Sign Out",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.black,
          //     width: 3.0,
          //   ),
          // )),
        );
      }
    });
  }

  // Bottom Sheet after on tapping account
  Widget _buildBottomSheet() {
    return Container(
      color: Color.fromRGBO(255, 255, 0, 1.0),
      child: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              title: Text(
                'Membership',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.membership);
              },
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 15.0, color: Colors.black),
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 0, 1.0),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                  ),
                )),
          ),
          Container(
            child: ListTile(
              title: Text('Payment History',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  )),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 15.0, color: Colors.black),
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.otherHistory);
              },
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 0, 1.0),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                  ),
                )),
          ),
        ],
      ),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.blue),
      //   color: Colors.black,
      //   borderRadius: BorderRadius.only(
      //     topLeft: const Radius.circular(10.0),
      //     topRight: const Radius.circular(10.0),
      //   ),
      // ),
    );
  }

//  Drawer body container
  Widget drawerBodyContainer() {
    var appConfig = Provider.of<AppConfig>(context, listen: false).appModel;
    final size = MediaQuery.of(context).size.width;
    return Container(
      height: size <= 768 ?  600 : MediaQuery.of(context).size.height ,
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(8.0),
            //   color: Colors.grey,
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black,
            //       blurRadius: 2.0,
            //       spreadRadius: 0.0,
            //       offset: Offset(2.0, 2.0), // shadow direction: bottom right
            //     )
            //   ],
            // ),
            child: Column(
              children: [
                notification(),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Divider(
                    color: Colors.white,
                    height: 2.0,
                  ),
                ),
                multiScrenMenu(),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Divider(
                    color: Colors.white,
                    height: 2.0,
                  ),
                ),
                watchHistory(),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Divider(
                    color: Colors.white,
                    height: 2.0,
                  ),
                ),
                appSettings(),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Divider(
                    color: Colors.white,
                    height: 2.0,
                  ),
                ),
                account(),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Divider(
                    color: Colors.white,
                    height: 2.0,
                  ),
                ),
                // appConfig.config.donation == 1 ||
                //         "${appConfig.config.donation}" == "1"
                //     ? donate()
                //     : SizedBox.shrink(),
                // appConfig.blogs.length != 0 ? blog() : SizedBox.shrink(),
                subscribe(),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Divider(
                    color: Colors.white,
                    height: 2.0,
                  ),
                ),
              ],
            ),
          ),
          help(),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Divider(
              color: Colors.white,
              height: 2.0,
            ),
          ),
          rateUs(),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Divider(
              color: Colors.white,
              height: 2.0,
            ),
          ),
          shareApp(),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Divider(
              color: Colors.white,
              height: 2.0,
            ),
          ),
          signOut(),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Divider(
              color: Colors.white,
              height: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLandscape() {
    drawerBodyContainer();
  }

//  Navigation drawer
  Widget drawer(
    width,
  ) {
    return Drawer(
      child: Container(
        color: Colors.black,
        height: 600,
        // height: 760,
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    drawerHeader(width),
                    drawerBodyContainer(),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double height2 = (height * 76.75) / 100;
    var userProfile = Provider.of<UserProfileProvider>(context, listen: false);
    return SizedBox(
      width: width,
      child: drawer(
        width,
      ),
    );
  }

  void _onButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 114.0,
            color: Colors.black, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(34, 34, 34, 1.0),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: _buildBottomSheet()),
          );
        });
  }

  _signOutDialog() {
    final size = MediaQuery.of(context).size.width;
    return showDialog(
    
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                      color: Colors.blue, width: 1, style: BorderStyle.solid)),
              backgroundColor: Colors.black87,
              contentTextStyle: TextStyle(color: Colors.yellow, fontSize: 17),
              titleTextStyle: TextStyle(
                  color: Colors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              title: Container(
                // color: Colors.red,
                height: size <= 768 ?null :80,
                // width:150,
                child: Column(
                  children: [
                    Text(
                      'Sign Out?',
                      textAlign: TextAlign.center,
                    ),
                    
                  ],
                ),
              ),
              content: Text(
                'Are you sure that you want to logout?',
                textAlign: TextAlign.center,
              ),
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
                        screenLogout();
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
            ),
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
    print(screenLogOutResponse.body);
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

  goToDialog() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: AlertDialog(
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).backgroundColor),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      "Loading ..",
                      style:
                          TextStyle(color: Theme.of(context).backgroundColor),
                    )
                  ],
                ),
              ),
              onWillPop: () async => false));
    } else {
      Navigator.pop(context);
    }
  }
}

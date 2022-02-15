import 'dart:convert';
import 'dart:io';
import 'package:IQRA/common/styles.dart';
import 'package:IQRA/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:IQRA/ui/seekbar/fluttery_seekbar.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/common/global.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'ForgotPassword.dart';

var sw = '';
var acct;

class ManageProfileScreen extends StatefulWidget {
  @override
  _ManageProfileScreenState createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  DateTime _date;
  DateTime currentDate;
  var userPlanStart;
  var userPlanEnd;
  var planDays;
  var progressWidth;
  var diff;
  var difference;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

//  Pop menu button to edit profile
  Widget _selectPopup(isAdmin) {
    return isAdmin == "1"
        ? PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Change Password"),
              ),
            ],
            onCanceled: () {
              print("You have canceled the menu.");
            },
            onSelected: (value) {
              if (value == 1) {
                Navigator.pushNamed(context, RoutePaths.changePassword);
              }
            },
            icon: Icon(Icons.more_vert),
          )
        : PopupMenuButton<int>(
            color: Theme.of(context).primaryColorLight,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Edit Profile"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Change Password"),
              ),
            ],
            onCanceled: () {
              print("You have canceled the menu.");
            },
            onSelected: (value) {
              if (value == 1) {
                print("value:$value");
                Navigator.pushNamed(context, RoutePaths.updateProfile);
              } else if (value == 2) {
                Navigator.pushNamed(context, RoutePaths.changePassword);
              }
            },
            icon: Icon(Icons.more_vert),
          );
  }

  // Changed designing
  // Start

  Widget userProfileImage1() {
    var userDetails =
        Provider.of<UserProfileProvider>(context).userProfileModel;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10, top: 20),
          height: 160.0,
          width: 160.0,
          child: ClipRRect(
            borderRadius: new BorderRadius.all(Radius.circular(80.0)),
            child: userDetails.user.image != null
                ? Image.network(
                    "${APIData.profileImageUri}" + "${userDetails.user.image}",
                    scale: 1.7,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/avatar.png",
                    scale: 1.7,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ],
    );
  }

  Widget userName() {
    var userDetails =
        Provider.of<UserProfileProvider>(context).userProfileModel;
    return Container(
      margin: EdgeInsets.only(top: 190),
      child: (Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 10, left: 50, right: 50),
                  child: FittedBox(
                    child: Text(
                      userDetails.user.name,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white70,
                  thickness: 0.3,
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget mailId() {
    final padding = MediaQuery.of(context).size.width;

    var userDetails =
        Provider.of<UserProfileProvider>(context).userProfileModel;
    return Padding(
      padding: EdgeInsets.only(top: 250),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 100,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 20, bottom: 5),
                  child: Text(
                    'User Email',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: padding <= 768 ? null : 27),
                  )),
              Container(
                  margin: EdgeInsets.only(right: 20, bottom: 5),
                  child: Text(userDetails.user.email,
                      style: TextStyle(fontSize: padding <= 768 ? null : 27),
                      textAlign: TextAlign.end)),
            ],
          ),
          Divider(
            color: Colors.white,
            thickness: 0.3,
          )
        ],
      ),
    );
  }

  Widget phoneNumber() {
    final padding = MediaQuery.of(context).size.width;
    var userDetails =
        Provider.of<UserProfileProvider>(context).userProfileModel;
    return Padding(
      padding: EdgeInsets.only(top: 295),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 100,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, bottom: 5),
            padding:
                padding <= 768 ? null : EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'Phone Number',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: padding <= 768 ? null : 27),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 20, bottom: 5),
            padding:
                padding <= 768 ? null : EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              userDetails.user.mobile == null
                  ? "N/A"
                  : "${userDetails.user.mobile}",
                  // : " ${userDetails.user.code} - ${userDetails.user.mobile}",
                  // : " ${userDetails.user.code.toString()}",

              // : userDetails.user.mobile,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: padding <= 768 ? null : 27),
            ),
            decoration: BoxDecoration(border: Border.all(width: 1)),
          ),
          Divider(
            color: Colors.white,
            thickness: 0.3,
          )
        ],
      ),
    );
  }

  Widget birthDate() {
    var userDetails =
        Provider.of<UserProfileProvider>(context).userProfileModel;
    final padding = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: 340),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 100,
        children: <Widget>[
          Container(
              padding:
                  padding <= 768 ? null : EdgeInsets.only(top: 30, bottom: 10),
              margin: EdgeInsets.only(left: 20, bottom: 5),
              child: Text(
                'Birthdate',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: padding <= 768 ? null : 27),
              )),
          Container(
            margin: EdgeInsets.only(right: 20, bottom: 5),
            padding:
                padding <= 768 ? null : EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              userDetails.user.dob == null ? "N/A" : userDetails.user.dob,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: padding <= 768 ? null : 27),
            ),
            decoration: BoxDecoration(border: Border.all(width: 1)),
          ),
          Divider(
            color: Colors.white,
            thickness: 0.3,
          )
        ],
      ),
    );
  }

  Widget joinedDate() {
    final padding = MediaQuery.of(context).size.width;

    var userDetails =
        Provider.of<UserProfileProvider>(context).userProfileModel;
    return Padding(
      padding: EdgeInsets.only(top: 385),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 100,
        children: <Widget>[
          Container(
              margin: padding <= 768
                  ? EdgeInsets.only(left: 20, bottom: 5)
                  : EdgeInsets.only(left: 20, bottom: 10, top: 50),
              child: Text(
                'Joined On',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: padding <= 768 ? null : 27),
              )),
          Container(
              margin: padding <= 768
                  ? EdgeInsets.only(left: 20, bottom: 5, right: 20)
                  : EdgeInsets.only(left: 20, bottom: 10, top: 50, right: 20),
              child: Text(
                DateFormat("dd-MM-y").format(userDetails.user.createdAt),
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: padding <= 768 ? null : 27),
              )),
          Divider(
            color: Colors.white,
            thickness: 0.3,
          )
        ],
      ),
    );
  }

  Widget subscriptionExpiryDate() {
    final padding = MediaQuery.of(context).size.width;

    var userDetails =
        Provider.of<UserProfileProvider>(context).userProfileModel;
    return Padding(
      padding: EdgeInsets.only(top: 430),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 100,
        children: <Widget>[
          Container(
              margin: padding <= 768
                  ? EdgeInsets.only(left: 20, bottom: 5)
                  : EdgeInsets.only(left: 20, bottom: 10, top: 70),
              child: Text(
                'Subscription End On',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: padding <= 768 ? null : 27),
              )),
          Container(
            margin: padding <= 768
                ? EdgeInsets.only(left: 20, bottom: 5, right: 20)
                : EdgeInsets.only(left: 20, bottom: 10, top: 70, right: 20),
            child: userDetails.active == "1"
                ? Text(
                    "${userDetails.end}" == ''
                        ? sw
                        : '${DateFormat.yMMMd().format(_date)}',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: padding <= 768 ? null : 27),
                  )
                : Text(
                    sw,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: padding <= 768
                            ? null
                            : MediaQuery.of(context).size.width / 35),
                    textAlign: TextAlign.right,
                  ),
          ),
          Divider(
            color: Colors.white,
            thickness: 0.3,
          )
        ],
      ),
    );
  }

  Widget userAccountStatus() {
    final padding = MediaQuery.of(context).size.width;

    var userDetails =
        Provider.of<UserProfileProvider>(context).userProfileModel;
    return Container(
      padding: EdgeInsets.only(top: 195),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: padding <= 768
                      ? EdgeInsets.only(left: 20, bottom: 5)
                      : EdgeInsets.only(left: 20, bottom: 10, top: 90),
                  child: accountStatusText()),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  margin: padding <= 768
                      ? EdgeInsets.only(left: 20, bottom: 5)
                      : EdgeInsets.only(left: 20, bottom: 10, top: 90),
                  child: userDetails.active == "0"
                      ? inactiveStatus()
                      : activeStatus(),
                ),
              ),
            ],
          ),
          Divider(color: Colors.white70, thickness: 0.3),
        ],
      ),
    );
  }

  Widget editProfile() {
    final size = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth < 600) {
        return Container(
          margin: EdgeInsets.only(top: 510, right: 220, left: 20),
          // margin:EdgeInsets.only(top:510,left: 10, right:430),
          height: 100,
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  color: Color.fromRGBO(255, 255, 0, 1.0),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.updateProfile);
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          // color: size <= 768 ? Colors.yellow : Colors.red,
          // margin: EdgeInsets.only(top: 510, right: 220, left: 20),
          margin: size <= 768
              ? EdgeInsets.only(top: 510, left: 10, right: 430)
              : EdgeInsets.only(top: 630, left: 59, right: 500),
          height: 100,
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                        color: Colors.black, fontSize: size <= 768 ? null : 25),
                  ),
                  color: Color.fromRGBO(255, 255, 0, 1.0),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.updateProfile);
                  },
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget resetPassword() {
    final size = MediaQuery.of(context).size.width;

    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth < 600) {
        return Container(
            margin: EdgeInsets.only(top: 510, right: 20, left: 220),
            // margin: EdgeInsets.only(top:510,right:10,left: 420),
            height: 100,

            // width:200,
            child: Row(children: <Widget>[
              Expanded(
                  child: RaisedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(
                  //     builder: (BuildContext context) {
                  //       return ForgotPassword();
                  //     })
                  // );
                  pass();
                  //  Navigator.pushNamed(context, RoutePaths.changePassword);
                },
                color: Color.fromRGBO(255, 255, 0, 1.0),
                child: FittedBox(
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              )),
            ]));
      } else {
        return Container(

            // margin: EdgeInsets.only(top: 510, right: 20, left: 220),
            margin: size <= 768
                ? EdgeInsets.only(top: 510, right: 10, left: 420)
                : EdgeInsets.only(top: 630, right: 50, left: 500),
            height: 100,

            // width:200,
            child: Row(children: <Widget>[
              Expanded(
                  child: RaisedButton(
                onPressed: () {
                  pass();
                  // Navigator.pushNamed(context, RoutePaths.changePassword);
                },
                color: Color.fromRGBO(255, 255, 0, 1.0),
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: size <= 768 ? null : 25,
                    color: Colors.black,
                  ),
                ),
              )),
            ]));
      }
    });
  }

  //End

//  User profile image
  Widget userProfileImage() {
    var userDetails =
        Provider.of<UserProfileProvider>(context).userProfileModel;
    return Padding(
      padding: const EdgeInsets.only(left: 50.0, top: 20.0),
      child: Container(
        height: 170.0,
        width: 130.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0)),
        ),
        child: ClipRRect(
          borderRadius: new BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0)),
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
    );
  }

//  Rounded SeekBar
  Widget roundedSeekBar() {
    diff = difference == null ? sw : '$difference' + ' Days Remaining';
    return RadialSeekBar(
      trackColor: Color.fromRGBO(20, 20, 20, 1.0),
      trackWidth: 8.0,
      progressColor:
          difference == null ? Colors.red : Color.fromRGBO(72, 163, 198, 1.0),
      progressWidth: 8.0,
      progress: difference == null ? 1.0 : progressWidth,
      centerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(diff),
          )
        ],
      ),
    );
  }

//  Rounded SeekBar Container
  Widget roundedSeekBarContainer() {
    return Container(
      height: 200.0,
      margin: EdgeInsets.only(top: 480.0, bottom: 15.0),
      padding: EdgeInsets.only(left: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: SizedBox(
              width: 200.0,
              height: 200.0,
              child: roundedSeekBar(),
            ),
          ),
        ],
      ),
    );
  }

//  Pop menu button to edit profile
  Widget popUpMenu() {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    var w = MediaQuery.of(context).size.width;
    w = w - 40;
    return Padding(
        padding: EdgeInsets.only(
          left: w,
          top: 26.0,
        ),
        child: _selectPopup(userDetails.user.isAdmin));
  }

//  Account status text
  Widget accountStatusText() {
    final padding = MediaQuery.of(context).size.width;

    return new Padding(
      padding: EdgeInsets.only(
        top: 275.0,
      ),
      child: Text(
        'Account status',
        textAlign: TextAlign.start,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: padding <= 768 ? null : 27),
      ),
    );
  }

//  When user is active
  Widget activeStatus() {
    final padding = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.only(top: 267, left: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(top: 10.0),
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Color.fromRGBO(125, 183, 91, 1.0), width: 1.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: new BoxDecoration(
                        //                    color: Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Color.fromRGBO(125, 183, 91, 1.0),
                            width: 2.5)),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 5.0),
              child: Text(
                'Active',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: padding <= 768 ? null : 27),
              ),
            ),
          ],
        ));
  }

//  When user is inactive
  Widget inactiveStatus() {
    final padding = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.only(top: 267, left: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(top: 10.0),
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                  //                    color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 1.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    // margin: EdgeInsets.only(bottom: 10),
                    width: 12.0,
                    height: 12.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 2.5)),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 5.0),
              child: Text(
                'Inactive',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: padding <= 768 ? null : 27),
              ),
            ),
          ],
        ));
  }

//  When user account status
  // Widget userAccountStatus() {
  //   var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
  //       .userProfileModel;
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //     children: <Widget>[
  //       Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           accountStatusText(),
  //           //    Radial progress bar is used to show the remaining days of user subscription
  //           userDetails.active == "0" ? inactiveStatus() : activeStatus(),
  //         ],
  //       ),
  //     ],
  //   );
  // }

//  User subscription end date
  Widget subExpiryDate() {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            //    This shows subscription end date on manage profile page and also show status of user subscription.
            Container(
              margin: EdgeInsets.only(top: 125.0, right: 50.0),
              child: Text(
                "${userDetails.end}" == '' ? '' : 'Subscription will end on',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2.0, right: 100.0),
              child: userDetails.active == "1"
                  ? Text(
                      "${userDetails.end}" == ''
                          ? sw
                          : '${DateFormat.yMMMd().format(_date)}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                    )
                  : Text(
                      sw,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.right,
                    ),
            )
          ],
        )
      ],
    );
  }

//  Divider Container
  Widget dividerContainer() {
    return Expanded(
      flex: 0,
      child: new Container(
        height: 80.0,
        width: 1.0,
        decoration: new BoxDecoration(
          border: Border(
            right: BorderSide(
              //                    <--- top side
              color: Colors.white10,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

//  Show mobile number
  Widget mobileNumberText(mobile) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(top: 0.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Mobile Number',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                mobile == null ? "N/A" : "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.right,
              )
            ]),
      ),
    );
  }

//  Show date of birth
  Widget dobText(mobile) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(top: 0.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Birthdate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                mobile == null ? "N/A" : mobile,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.right,
              )
            ]),
      ),
    );
  }

//  Date of birth and mobile text container
  Widget dobAndMobile() {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;

    return Container(
      height: 80.0,
      margin: EdgeInsets.only(top: 210.0),
      padding: EdgeInsets.only(left: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          dobText(userDetails.user.dob),
          dividerContainer(),
          mobileNumberText(userDetails.user.mobile),
        ],
      ),
    );
  }

//  Show joined date text
  Widget joinedDateText(createdAt) {
    var sd = DateFormat("dd-MM-y HH:MM").format(createdAt);
    var split = "$sd".split(' ').map((i) {
      if (i == "") {
        return Divider();
      } else {
        return Text(
          i,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
          textAlign: TextAlign.left,
        );
      }
    }).toList();

    return Expanded(
      flex: 1,
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    "Joined on" + " - ",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    textAlign: TextAlign.left,
                  ),
                  split[0],
                  Text(" ,  "),
                  split[1],
                ],
              ),
            ]),
      ),
    );
  }

//  Show name and joined date container
  Widget nameAndJoinedDateContainer() {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    return Container(
      height: 100.0,
      margin: EdgeInsets.only(top: 290.0),
      padding: EdgeInsets.only(left: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: 100,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      height: 50,
                      child: Row(
                        children: [
                          Text(
                            'Username' + ' - ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            userDetails.user.name,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 0, 1.0),
                                fontSize: 16.0),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      decoration: new BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white10,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Useremail' + ' - ',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            TextSpan(
                                text: userDetails.user.email,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(255, 255, 0, 1.0))),
                          ],
                        ),
                      ),
                    ),
                  ]),
              decoration: new BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white10,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          joinedDateText(userDetails.user.createdAt),
        ],
      ),
    );
  }

//  Container used as border
  Widget borderContainer1() {
    return Container(
      margin: EdgeInsets.only(left: 50.0),
      height: 210.0,
      decoration: new BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
            width: 2.0,
          ),
        ),
      ),
    );
  }

//  Container used as border
  Widget borderContainer2() {
    return Container(
      margin: EdgeInsets.only(left: 50.0),
      height: 292.0,
      decoration: new BoxDecoration(
        border: Border(
          bottom: BorderSide(
            //                    <--- top side
            color: Colors.white10,
            width: 2.0,
          ),
        ),
      ),
    );
  }

//  Overall UI of this page is in stack
  // Widget stack() {
  //   return Stack(
  //     children: <Widget>[
  //       userProfileImage1(),
  //       userName(),
  //       subscriptionExpiryDate(),
  //       userAccountStatus(),
  //       mailId(),
  //       phoneNumber(),
  //       birthDate(),
  //       // subExpiryDate(),
  //       // borderContainer1(),
  //       // dobAndMobile(),
  //       // borderContainer2(),
  //       // nameAndJoinedDateContainer(),
  //       joinedDate(),
  //       // roundedSeekBarContainer(),
  //       // popUpMenu(),
  //       editProfile(),
  //       resetPassword(),
  //     ],
  //   );
  // }

//  Scaffold body
  Widget scaffoldBody() {
    final padding = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        height: padding <= 768 ? 600 : MediaQuery.of(context).size.height,
        color: Colors.black,
        // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            userProfileImage1(),
            userName(),
            userAccountStatus(),
            mailId(),
            phoneNumber(),

            birthDate(),
            // subExpiryDate(),
            // borderContainer1(),
            // dobAndMobile(),
            // borderContainer2(),
            // nameAndJoinedDateContainer(),
            joinedDate(),
            subscriptionExpiryDate(),
            // roundedSeekBarContainer(),
            // popUpMenu(),
// OrientationBuilder(builder: (_,orientation) => orientation == Orientation.portrait? buildpotraitButton(): buildLandscapeButton()
            // orientationAnalyze()
            editProfile(),
            resetPassword(),
// )
          ],
        ),
      ),
    );
  }

  Widget buildPotrait() => scaffoldBody();

  Widget buildLandscape() => Container(
      height: 900, child: SingleChildScrollView(child: scaffoldBody()));

// Widget orientationAnalyze(){
// OrientationBuilder(builder: (_,orientation) => orientation == Orientation.portrait ? buildpotraitButton():buildLandscapeButton() );
// }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    if ("${userDetails.end}" == '' ||
        "${userDetails.end}" == 'N/A' ||
        "${userDetails.end}" == null ||
        "${userDetails.active}" == "0") {
      sw = 'N/A';
      setState(() {
        difference = null;
      });
    } else {
      setState(() {
        _date = userDetails.end;
      });
      difference = "${userDetails.active}" == "1"
          ? _date.difference(userDetails.currentDate).inDays
          : 0.0;
      planDays = userDetails.end.difference(userDetails.start).inDays;
      print(difference / planDays);
      progressWidth = difference / planDays;
    }
    return SafeArea(
      child: Container(
        color: Colors.red,
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: customAppBar(context, "Manage Profile"),
            body: Container(
                height: size.height,
                child: OrientationBuilder(
                    builder: (context, orientation) =>
                        orientation == Orientation.portrait
                            ? buildPotrait()
                            : buildLandscape()))),
      ),
    );
  }

  bool _spincontorller = false;

  pass() async {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    setState(() {
      _spincontorller = !_spincontorller;
    });
    var response = await http.post(Uri.parse(APIData.change), body: {
      "email": "${userDetails.user.email}"
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json",
      // "Content-Type": "application/json"
    });
    setState(() {
      _spincontorller = !_spincontorller;
    });
    print(response);
    var res1 = jsonDecode(response.body);
    print('resposne$res1');
    if (res1["message"] == "A reset password link has been send your email address.") {
      Fluttertoast.showToast(
          msg: "A reset password link has been send your email address.");
      // msg: "An Email with Password Reset Link is send to yours Email.");
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (BuildContext context) {
      //   return SplashScreen();
      // }));
    } else {
      Fluttertoast.showToast(
          msg: "Getting Some Error, Please Try After Some Time.");
    }
  }
}

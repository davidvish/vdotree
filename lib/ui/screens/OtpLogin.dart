import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:IQRA/common/styles.dart';
import 'package:flutter/services.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:IQRA/providers/login_provider.dart';

class OtpLogin extends StatefulWidget {
  final email;
  final pass;
  const OtpLogin({Key key, this.email, this.pass}) : super(key: key);
  @override
  _OtpLoginState createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  


  TextEditingController otp = TextEditingController();
  bool _spincontorller = false;


@override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

@override
  void dispose() {
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context, "VERIFICATION CODE"),
        // backgroundColor: kWhiteColor,
        body: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new ExactAssetImage('assets/netflix.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: new ImageFiltered(
                    imageFilter: ImageFilter.blur(
                        sigmaY: 2,
                        sigmaX:
                            2), //SigmaX and Y are just for X and Y directions
                    child: Image.asset(
                      'assets/netflix.jpg',
                      fit: BoxFit.cover,
                    ) //here you can use any widget you'd like to blur .
                    )),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              "Almost Logged in !",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40, top: 15),
                            child: Text(
                              "Enter 4 Digit OTP verification code",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40, top: 5),
                            child: Text(
                              "We've send on given number",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            // color: Colors.red,
                            width: MediaQuery.of(context).size.width * 0.67,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // SizedBox(width: 0.1,),
                                Container(
                                  width: 30,
                                  height: 50,
                                  alignment: Alignment.bottomCenter,
                                  // color: Colors.amber,
                                  // child: Text(
                                  //   '__',
                                  //   style: TextStyle(
                                  //       fontSize: 30, color: primaryBlue),
                                  // ),
                                  // height:
                                  //     MediaQuery.of(context).size.width * 0.15,
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.15,
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     border: Border.all(
                                  //         color: Colors.white, width: 1)),
                                ),

                                // SizedBox(width:10),
                                Container(
                                  width: 30,
                                  height: 50,
                                  alignment: Alignment.bottomCenter,
                                  // // color: Colors.amber,
                                  // child: Text(
                                  //   '__',
                                  //   style: TextStyle(
                                  //       fontSize: 30, color: primaryBlue),
                                  // ),
                                  // height:
                                  //     MediaQuery.of(context).size.width * 0.15,
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.15,
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     border: Border.all(
                                  //         color: Colors.white, width: 1)),
                                ),
                                // SizedBox(width: 0,),
                                Container(
                                  // width: 20,
                                  height: 27,
                                  alignment: Alignment.bottomCenter,
                                  // color: Colors.amber,
                                  // child: Text(
                                  //   '|',
                                  //   style: TextStyle(
                                  //       fontSize: 30, color: primaryBlue),
                                  // ),
                                  // height:
                                  //     MediaQuery.of(context).size.width * 0.15,
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.15,
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     border: Border.all(
                                  //         color: Colors.white, width: 1)),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  margin: EdgeInsets.only(right:13),
                                  alignment: Alignment.bottomCenter,
                                  // color: Colors.amber,
                                  // child: Text(
                                  //   '|',
                                  //   style: TextStyle(
                                  //       fontSize: 30, color: primaryBlue),
                                  // ),
                                  // color: Colors.green,

                                  // height:
                                  //     MediaQuery.of(context).size.width * 0.15,
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.15,
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     border: Border.all(
                                  //         color: Colors.white, width: 1)),
                                ),
                                // SizedBox(width: 1,)
                              ],
                            ),
                          ),
                          Container(
                            // color: Colors.red,
                            // alignment: Alignment.center,
                            // color: Colors.red,
                            width:
                             MediaQuery.of(context).size.width * 0.77,
                            child: TextFormField(
                              // maxLength: 1,
                              controller: otp,
                              showCursor: false,
                              textAlign: TextAlign.start,
                              
                              cursorColor: Colors.transparent,
                              style: TextStyle(letterSpacing: 60),
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 19),
                                fillColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  borderSide:
                                      BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(60),

                                  borderSide:
                                      BorderSide(color: Colors.yellow),
                                ),

                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4)
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the code?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              resendotp();
                            },
                            child: Text(
                              " RESEND",
                              style: TextStyle(
                                  color: primaryBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                otpenter();
                                // Navigator.push(context, MaterialPageRoute(
                                //     builder: (BuildContext context) {
                                //   return ResetPassword();
                                // }));
                              },
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: primaryBlue,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      // ],
                      ),
                ),
                // ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                  child: (_spincontorller == true)
                      ? Container(
                          margin: const EdgeInsets.only(
                              bottom: 6.0), //Same as `blurRadius` i guess
                          height: 100.0,
                          width: 120.0,
                          child: SpinKitRing(
                              color: primaryBlue,
                              size: _spincontorller ? 40 : 0),
                        )
                      : null),
            ),
          ],
        ),
      ),
    );
  }

  otpenter() async {
    print("saad");
    setState(() {
      _spincontorller = !_spincontorller;
    });
    var response1 = await http.post(APIData.otpverifyon, body: {
      "email": widget.email,
      "otp": otp.text,
      "password": widget.pass
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json",
      // "Content-Type": "application/json"
    });
    setState(() {
      _spincontorller = !_spincontorller;
    });
    print(response1.body);

    var response = jsonDecode(response1.body);
    if (response["type"] == "success") {
      setState(() {
        _spincontorller = !_spincontorller;
      });
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      try {
        print(widget.email);
        print(widget.pass);
        await loginProvider.login(widget.email, widget.pass, context);
        print(loginProvider.loginStatus);
        setState(() {
          _spincontorller = !_spincontorller;
        });
        if (loginProvider.loginStatus == true) {
          final userDetails =
              Provider.of<UserProfileProvider>(context, listen: false)
                  .userProfileModel;
          if (userDetails.payment == "Free") {
            Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
          } else if (userDetails.active == 1 || userDetails.active == "1") {
            Navigator.pushNamed(context, RoutePaths.multiScreen);
          } else {
            Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
          }
        } else if (loginProvider.emailVerify == false) {
          showAlertDialog(context, loginProvider.emailVerifyMsg);
        } else {
          Fluttertoast.showToast(
            msg: "The user credentials were incorrect..!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (error) {
        print(error);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Text(
              'An error occurred!',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.blueAccent,
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      }
      // setState(() {
      //   _isLoading = false;
      // });
    } else {
      otp.clear();

      Fluttertoast.showToast(
        msg: "OTP Does Not Match Please Try Again ",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  showAlertDialog(BuildContext context, String msg) {
    var msg1 = msg.replaceAll('"', "");
    Widget okButton = FlatButton(
      color: primaryBlue,
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  resendotp() async {
    print(authToken);
    var response1 = await http.post(APIData.loginotpresend, body: {
      "email": widget.email,
      "password": widget.pass
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json",
      // "Content-Type": "application/json"
    });
    print(response1.body);
    var response = jsonDecode(response1.body);
    if (response["type"] == "success") {
      otp.clear();
      Fluttertoast.showToast(
        msg: "OTP Resend Succesfully",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Getting Some Errror",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}

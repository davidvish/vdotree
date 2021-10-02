import 'package:IQRA/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
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

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();
  bool _spincontorller = false;
  Widget emailField() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
      child: Container(
        color: Colors.white,
        child: TextFormField(
          style: TextStyle(
              fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
          controller: _emailController,
          validator: (value) {
            if (value.length == 0) {
              return 'Email can not be empty';
            } else {
              if (!value.contains('@')) {
                return 'Invalid Email';
              } else {
                return null;
              }
            }
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.mail_outline,
              color: Colors.black,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            labelText: 'E-mail Address',
            labelStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context, "Forgot Password"),
        // backgroundColor: kWhiteColor,
        body: Stack(
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              // decoration: new BoxDecoration(
              //   image: new DecorationImage(
              //     image: new ExactAssetImage('assets/netflix.jpg'),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              // child: new ImageFiltered(
              //     imageFilter: ImageFilter.blur(
              //         sigmaY: 2,
              //         sigmaX: 2), //SigmaX and Y are just for X and Y directions
              //     child: Image.asset(
              //       'assets/netflix.jpg',
              //       fit: BoxFit.cover,
              //     ) //here you can use any widget you'd like to blur .
              //     ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      height: 90,
                      width: 90,
                      child: Image.asset("assets/logo.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Enter your email address and your password will be reset and email to you.",
                      style: TextStyle(
                          // color: Color.fromRGBO(255, 255, 0, 1.0),
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .25,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 40),
                      //       child: Text(
                      //         "Almost Logged in !",
                      //         style: TextStyle(
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 40, top: 15),
                      //       child: Text(
                      //         "Enter 4 Digit OTP verification code",
                      //         style: TextStyle(
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 40, top: 5),
                      //       child: Text(
                      //         "We've send on given number",
                      //         style: TextStyle(
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      emailField(),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (_emailController.text.isNotEmpty) {
                                  if (_emailController.text
                                      .contains("@gmail.com")) {
                                    resendotp();
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Please Provide a Valid Email",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Please provide a valid email address",
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                }
                                // otpenter();
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: primaryBlue,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Center(
                                            child: Text(
                                          "Send me password reset link",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800),
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Remember your password ? ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return LoginScreen();
                                }));
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: primaryBlue,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      )
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

  resendotp() async {
    setState(() {
      _spincontorller = !_spincontorller;
    });
    // print(authToken);
    var response1 = await http.post(APIData.newforgotpassword, body: {
      "email": _emailController.text,
      // "password": widget.pass
    }, headers: {
      // HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json",
      // "Content-Type": "application/json"
    });
    setState(() {
      _spincontorller = !_spincontorller;
    });
    print(response1.body);
    var response = jsonDecode(response1.body);
    if (response["type"] == "success") {
      Fluttertoast.showToast(
        msg: response["message"],
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: response["message"],
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}

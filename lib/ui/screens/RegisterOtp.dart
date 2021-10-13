import 'dart:async';
import 'dart:ui';

import 'package:IQRA/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:IQRA/providers/login_provider.dart';
import 'package:IQRA/providers/user_profile_provider.dart';

class RegisterOtp extends StatefulWidget {
  final mobile;
  final email;
  final code;
  final name;
  final password;
  const RegisterOtp(
      {Key key, this.mobile, this.email, this.name, this.password, this.code})
      : super(key: key);
  @override
  _RegisterOtpState createState() => _RegisterOtpState();
}

class _RegisterOtpState extends State<RegisterOtp> {
  TextEditingController otp = TextEditingController();


  @override
  void initState() {
SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
     timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });  }

@override
  void dispose() {
 SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    timer.cancel();
    super.dispose();  }

    int secondsRemaining = 30;
  bool enableResend = false;
  Timer timer;
  @override
  Widget build(BuildContext context) {
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
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {
                      //         Navigator.pop(context);
                      //       },
                      //       icon: Icon(
                      //         Icons.arrow_back,
                      //         color: primaryBlue,
                      //       ),
                      //       // color: kWhiteColor,
                      //       iconSize: 30,
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 20),
                      //       child: Text(
                      //         "VERIFICATION CODE",
                      //         style: TextStyle(
                      //             fontSize: 26,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.22,
                      // ),
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       "Phone Verification",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 22,
                      //           fontWeight: FontWeight.w600),
                      //     ),
                      //     Text(
                      //       "We have send code to your",
                      //       style: TextStyle(
                      //           // color: kGreyColor,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w400),
                      //     ),
                      //     Text(
                      //       "phone number ${widget.mobile} ",
                      //       style: TextStyle(
                      //           // color: kGreyColor,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w400),
                      //     ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              "Almost Registered !",
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
                            width: MediaQuery.of(context).size.width * 0.72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                   width: 30,
                                  height: 50,
                                  alignment: Alignment.bottomCenter,
                                  // color: Colors.amber,
                                  // child: Text(
                                  //   '___',
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
                                  height: 50,
                                  alignment: Alignment.bottomCenter,
                                  // color: Colors.amber,
                                  // child: Text(
                                  //   '___',
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
                                  height: 27,

                                  // width: 50,
                                  // height: 50,
                                  alignment: Alignment.bottomCenter,
                                  // color: Colors.amber,
                                  // child: Text(
                                  //   '___',
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
                                  height: 50,
                                  alignment: Alignment.bottomCenter,
                                  // color: Colors.amber,
                                  // child: Text(
                                  //   '___',
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
                        enableResend ?
                         
                                  
                        
                          InkWell(
                            onTap:enableResend ? resendotp : null,
                            child: Text(
                              " RESEND",
                              style: TextStyle(
                                  color: primaryBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )

                          :
                           Padding(
                             padding: const EdgeInsets.only(left:5),
                             child: TweenAnimationBuilder(
                                tween: Tween(begin: 30.0, end: 0),
                                duration: Duration(seconds: 30),
                                builder: (context, value, child) => Text(
                                      '00:${value.toInt()}',
                                      style: TextStyle(color: primaryBlue,fontSize: 16),
                                    )),
                           )
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
                           InkWell (
                              onTap: () async{
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
              child: Center (
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

  bool _spincontorller = false;

  Future otpenter() async {
    print("saad");
    setState(() {
      _spincontorller = !_spincontorller;
    });
    var response1 = await http.post(APIData.registerverify, body: {
      "email": widget.email,
      "code":widget.code,
      "otp": otp.text,
      "password": widget.password,
      "mobile": widget.mobile,
      // "name": widget.name
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json",
      // "Content-Type": "application/json"
    });
    // setState(() {
    //   _spincontorller = !_spincontorller;
    // });
    print(response1.body);
    var response = jsonDecode(response1.body);
    setState(() {
      _spincontorller = !_spincontorller;
    });
    if (response["type"] == "success") {
      setState(() {
        _spincontorller = !_spincontorller;
      });
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      // final form = _formKey.currentState;

      await loginProvider.register(
          widget.name, widget.email, widget.password,widget.mobile,widget.code, context);
      setState(() {
        _spincontorller = !_spincontorller;
      });
      if (loginProvider.loginStatus == true) {
        final userDetails =
            Provider.of<UserProfileProvider>(context, listen: false)
                .userProfileModel;
        if (userDetails.active == 1 || userDetails.active == "1") {
          if (userDetails.payment == "Free") {
            Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
          } else {
            Navigator.pushNamed(context, RoutePaths.multiScreen);
          }
        } else {
          Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
        }
      } else {
        Fluttertoast.showToast(
          msg: "Getting Some Errror",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      }
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

  resendotp() async {
    print(authToken);
    var response1 = await http.post(APIData.registerotpresend, body: {
      "email": widget.email,
      "password": widget.password,
      "name": widget.name,
      "mobile": widget.mobile
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
        setState((){
      secondsRemaining = 30;
      enableResend = false;
    });
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

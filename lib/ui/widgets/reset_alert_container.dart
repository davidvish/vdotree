import 'dart:io';
import 'package:IQRA/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:http/http.dart' as http;
import 'package:IQRA/ui/screens/forgot_password_screen.dart';

class ResetAlertBoxContainer extends StatefulWidget {
  @override
  _ResetAlertBoxContainerState createState() => _ResetAlertBoxContainerState();
}

class _ResetAlertBoxContainerState extends State<ResetAlertBoxContainer> {
  final formKey1 = new GlobalKey<FormState>();
  final TextEditingController _resetEmailController =
      new TextEditingController();
  final TextEditingController _otpController = new TextEditingController();
  bool hiddenOTP = true;
  bool hiddenEmail = false;

  Widget emailField() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: TextFormField(
        controller: _resetEmailController,
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 12.0, bottom: 5.0, left: 2.0, right: 2.0),
            hintText: "Enter Email",
            hintStyle: TextStyle(fontSize: 12.0, color: Colors.white)),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        validator: (val) {
          if (val.length == 0) {
            return 'Email can not be empty';
          } else {
            if (!val.contains('@')) {
              return 'Invalid Email';
            } else {
              return null;
            }
          }
        },
        onSaved: (val) => _resetEmailController.text = val,
      ),
    );
  }

  Widget otpField() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: TextFormField(
        controller: _otpController,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.only(top: 14.0, bottom: 0.0, left: 2.0, right: 2.0),
          hintText: "Enter OTP",
          suffixIcon: IconButton(
            splashColor: Color.fromRGBO(72, 163, 198, 1.0),
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            icon: Text(
              "Resend",
              style: TextStyle(color: activeDotColor, fontSize: 10),
            ),
            onPressed: () {
              Fluttertoast.showToast(msg: "OTP Sent");
            },
          ),
          hintStyle: TextStyle(fontSize: 12.0),
        ),
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

// Verify OTP code
  Future<String> verifyOtp() async {
    final sendOtpResponse = await http.post(Uri.parse(APIData.verifyOTPApi), body: {
      "email": _resetEmailController.text,
      "code": _otpController.text,
    });
    print("OTP res: ${sendOtpResponse.statusCode}");
//    var route = MaterialPageRoute(
//        builder: (context) => ForgotPassword(_resetEmailController.text));
//    Navigator.push(context, route);
    if (sendOtpResponse.statusCode == 200) {
      Navigator.pushNamed(context, RoutePaths.forgotPassword,
          arguments: ForgotPassword((_resetEmailController.text)));
    } else {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
    return null;
  }

// Send OTP code
  Future<String> sendOtp() async {
    final sendOtpResponse = await http.post(Uri.parse(APIData.forgotPasswordApi), body: {
      "email": _resetEmailController.text,
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      // "Content-Type": "application/json",
      "Accept": "application/json"
    });
    print(sendOtpResponse.statusCode);
    print(sendOtpResponse.body);
    if (sendOtpResponse.statusCode == 200) {
      _otpVisibility();
    } else if (sendOtpResponse.statusCode == 401) {
      _emailVisibility();
      Fluttertoast.showToast(msg: "Email address doesn't exist.");
    } else {
      Fluttertoast.showToast(msg: "Error in sending OTP");
      _emailVisibility();
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      hiddenOTP = true;
      hiddenEmail = false;
    });
  }

// Toggle for visibility
  void _otpVisibility() {
    setState(() {
      hiddenOTP = !hiddenOTP;
    });
  }

  void _emailVisibility() {
    setState(() {
      hiddenEmail = !hiddenEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: Form(
        key: formKey1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 24.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.grey,
              height: 4.0,
            ),
            hiddenEmail ? SizedBox.shrink() : emailField(),
//                SizedBox(
//                  height: 5.0,
//                ),
            hiddenOTP ? SizedBox.shrink() : otpField(),
            SizedBox(
              height: 5.0,
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  //                        color: greenPrime,
                  // gradient: LinearGradient(
                  //   colors: [
                  //     // Colors are easy thanks to Flutter's Colors class.
                  //     Color.fromRGBO(72, 163, 198, 0.4).withOpacity(0.4),
                  //     Color.fromRGBO(72, 163, 198, 0.3).withOpacity(0.5),
                  //     Color.fromRGBO(72, 163, 198, 0.2).withOpacity(0.6),
                  //     Color.fromRGBO(72, 163, 198, 0.1).withOpacity(0.7),
                  //   ],
                  // ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                ),
                child: Text(
                  hiddenOTP == true ? "Send OTP" : "Reset Password",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                if (hiddenOTP == true) {
                  final form = formKey1.currentState;
                  form.save();
                  if (form.validate() == true) {
                    sendOtp();
                    _emailVisibility();
                  }
                } else {
                  verifyOtp();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

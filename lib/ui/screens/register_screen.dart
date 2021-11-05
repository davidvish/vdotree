import 'dart:convert';

import 'package:IQRA/ui/screens/RegisterOtp.dart';

//import 'package:IQRA/ui/screens/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/common/styles.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:IQRA/providers/login_provider.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/ui/shared/logo.dart';
import 'package:IQRA/ui/widgets/register_here.dart';
import 'package:intl/locale.dart';
import 'package:provider/provider.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  bool _showPassword = false;
  bool _isLoading = false;
  String sigtssd='91';
// Sign up button
  otpsignup() async {
    setState(() {
      _isLoading = true;
    });
    var response1 = await http.post(Uri.parse(APIData.registerotpsend), body: {
      "name": _nameController.text,
      "email": _emailController.text,
      //otp
      "code": sigtssd,
      "mobile": _mobileController.text,
      "password": _passController.text,
      "confirm_password": _passController.text
    }, headers: {
      // HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json",
      // "Content-Type": "application/json"
    });
    print(response1.body);
    setState(() {
      _isLoading = false;
    });
    var response = jsonDecode(response1.body);
    if (response["type"] == "success") {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return RegisterOtp(
          mobile: _mobileController.text,
          code: sigtssd,
          name: _nameController.text,
          email: _emailController.text,
          password: _passController.text,
        );
      }));
      print(_passController.text);
    } else {
      print(response["email"]);
      if (response["email"].toString() ==
          "[The email has already been taken.]") {
        print("The email has already been taken");
        Fluttertoast.showToast(
          msg: "The Email has Already Been Taken.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        print("The email except");
        Fluttertoast.showToast(
          msg: "The Mobile has Already Been Taken.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  void _signUp() async {
    // setState(() {
    //   _isLoading = true;
    // });
    otpsignup();
    // setState(() {
    //   _isLoading = false;
    // });
    // final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    // final form = _formKey.currentState;
    // form.save();
    // if (form.validate() == true) {
    //   otpsignup();
    // try {
    // await loginProvider.register(
    //     _nameController.text,
    //     _emailController.text,
    //     _passController.text,
    //     _mobileController.text,
    //     context);
    // if (loginProvider.loginStatus == true) {
    //   final userDetails =
    //       Provider.of<UserProfileProvider>(context, listen: false)
    //           .userProfileModel;
    //   // Navigator.push(context,
    //   //     MaterialPageRoute(builder: (BuildContext context) {
    //   //   return RegisterOtp(mobile:_mobileController.text);
    //   // }));

    //   if (userDetails.active == 1 || userDetails.active == "1") {
    //     if (userDetails.payment == "Free") {
    //       Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
    //     } else {
    //       Navigator.pushNamed(context, RoutePaths.multiScreen);
    //     }
    //   } else {
    //     Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
    //   }
    // }
    // if (loginProvider.emailVerify == false) {
    //   setState(() {
    //     _isLoading = false;
    //     _nameController.text = '';
    //     _emailController.text = '';
    //     _passController.text = '';
    //     _mobileController.text = "";
    //   });
    //   showAlertDialog(context, loginProvider.emailVerifyMsg);
    // } else {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Fluttertoast.showToast(
    //     msg: "Registration Failed..!",
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     gravity: ToastGravity.BOTTOM,
    //   );
    // }
    // // } catch (error) {
    // // setState(() {
    // //   _isLoading = false;
    // // });
    // // await showDialog(
    // //   context: context,
    // //   builder: (ctx) => AlertDialog(
    // //     backgroundColor: Colors.white,
    // //     shape: RoundedRectangleBorder(
    // //         borderRadius: BorderRadius.circular(15.0)),
    // //     title: Text(
    // //       'An error occurred!',
    // //       style: TextStyle(
    // //           color: Colors.black.withOpacity(0.7),
    // //           fontWeight: FontWeight.bold),
    // //     ),
    // //     content: Text(
    // //       'Something went wrong',
    // //       style: TextStyle(
    // //         color: Colors.black.withOpacity(0.6),
    // //       ),
    // //     ),
    // //     actions: <Widget>[
    // //       FlatButton(
    // //         color: Colors.blueAccent,
    // //         child: Text('OK'),
    // //         onPressed: () {
    // //           Navigator.pop(context);
    // //         },
    // //       )
    // //     ],
    // //   ),
    // // );
    // //   }
    // //   setState(() {
    //     _isLoading = false;
    //   });
    // }
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

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(
        "Sign Up Successful!",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: primaryBlue, fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
      content: Text("$msg1 Verify your email to continue.",
          style: TextStyle(
            color: Theme.of(context).backgroundColor,
            fontSize: 16.0,
          )),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget msgTitle() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Register ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: primaryBlue,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "to watch latest ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "movies TV, series,",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: primaryBlue,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "comedy shows ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: primaryBlue,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  "and ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  " entertainment videos",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: primaryBlue,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget nameField() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      child: TextFormField(
        controller: _nameController,
        validator: (value) {
          if (value.length < 2) {
            if (value.length == 0) {
              return 'Enter name';
            } else {
              return 'Enter minimum 2 characters';
            }
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.white,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: 'Name',
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget emailField() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      child: TextFormField(
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
            color: Colors.white,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: 'Email',
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget country() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 4, top: 0, bottom: 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        //child: TextField(
        //controller: _countryController,
        //  decoration: InputDecoration(
        // prefix:
        //Container(
        child: CountryCodePicker(

          searchDecoration: const InputDecoration(
        labelText: "country",
            labelStyle: TextStyle()
          ),
          //  backgroundColor: Colors.yellowAccent,
          dialogBackgroundColor: Colors.black,
          onChanged: (code){
              setState(() {
              sigtssd=code.dialCode;
                 });

          },
          initialSelection: "IN",
          showCountryOnly: true,
          // showOnlyCountryWhenClosed: true,
          favorite: ["+91" "IN"],
         // countryFilter: ['IT', 'IN'],
          // comparator: (a, b) => b.name.compareTo(a.name),
          // //Get the country information relevant to the initial selection
          onInit: (code) {

              sigtssd=code.dialCode;
          },
          enabled: true,
          // hideMainText: false,
          //
          // flagWidth: 25,
          showFlagMain: true,
          showFlag: true,
          //
          hideSearch: false,
          showFlagDialog: true,
          //
          // alignLeft: true,
        ),
        // ),
        //  enabledBorder: UnderlineInputBorder(
        //    borderSide: BorderSide(color: Colors.white),
      ),
    );
    //hintText: '91',
    // counterText: ,
    // labelText: 'Phone Number',
    //       //  labelStyle: TextStyle(color: Colors.white),
    //     ),
    //   ),
    // );
    //);
  }

  Widget mobileField() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        child: TextFormField(
          maxLength: 10,
          controller: _mobileController,
          validator: (value) {
            if (value.length == 0) {
              return 'Mobile can not be empty';
            } else {
              if (value.length != 10) {
                return 'Invalid Mobile Number';
              } else {
                return null;
              }
            }
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            //prefix: Text('+91   '),
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.white,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            //hintText: '91',
            // counterText: ,
            labelText: 'Phone Number',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget passwordField() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: TextFormField(
        controller: _passController,
        obscureText: !this._showPassword,
        validator: (value) {
          if (value.isEmpty) {
            print(value);
            return 'Please enter your password';
          } else if (value.length < 6) {
            return 'Enter minimum 6 digits';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color:
                  this._showPassword ? Colors.yellowAccent[700] : Colors.white,
            ),
            onPressed: () {
              setState(() => this._showPassword = !this._showPassword);
            },
          ),
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
  final LinearGradient gradient = LinearGradient(colors: [primaryBlue,Colors.deepOrange,Colors.purple]);

  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<AppConfig>(context, listen: false);
    return SafeArea(
      // child: MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //    // supportedLocales: [
      //    //   Locale('en','US'),
      //    // ],
      //    localizationsDelegates:
      //    [
      //      CountryLocalizations.delegate
      //    ],
      //    home: Scaffold(
      child: Scaffold(
        appBar: customAppBar(context, "Sign Up"),
        key: scaffoldKey,
        body: Container(
          color: Colors.black,
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 90,
                        width: 150,
                        child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return gradient.createShader(rect);
                  },
                  child: Text(
                    'VDOTREE',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
                        // Image.asset("assets/logo.png"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // logoImage(context, myModel, 0.9, 63.0, 200.0),
                    msgTitle(),
                    nameField(),
                    emailField(),
                    // SizedBox(
                    //   width: 0,
                    // ),
                    Row(children: [
                      country(),
                      mobileField(),
                    ]),
                    passwordField(),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // height: 50.0,
                            width: MediaQuery.of(context).size.width * .60,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              color: primaryBlue,
                              child: _isLoading == true
                                  ? CircularProgressIndicator(
                                      // color: primaryBlue,
                                      backgroundColor: Colors.black,
                                    )
                                  : Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
                                    ),
                              // onPressed: (){},
                              onPressed: () {
                                if (_nameController.text.isNotEmpty) {
                                  if (_emailController.text.isNotEmpty) {
                                    if (_emailController.text.contains("@")) {
                                      if (_mobileController.text.isNotEmpty) {
                                        if (_mobileController.text.length ==
                                            10) {
                                          // if (_countryController.text.isEmpty) {
                                            if (_passController
                                                .text.isNotEmpty) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());
                                              _signUp();
                                            } else {
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Please Enter Your Password",
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                            }
                                          // }
                                          // else {
                                          //   Fluttertoast.showToast(
                                          //     msg:
                                          //         "Please Select your country code",
                                          //     backgroundColor: Colors.red,
                                          //     textColor: Colors.white,
                                          //     gravity: ToastGravity.BOTTOM,
                                          //   );
                                          // }
                                        } else {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Please Enter a Valid Mobile Number",
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Please Enter Your Mobile Number",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Please Enter a Valid Email",
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Please Enter Your Email",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Please Enter Your Name",
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              loginHereText(context),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}

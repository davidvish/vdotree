import 'dart:async';
import 'dart:convert';
import 'package:IQRA/ui/screens/ForgotPassword.dart';
import 'package:IQRA/ui/screens/OtpLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/common/styles.dart';
import 'package:IQRA/models/login_model.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:IQRA/providers/faq_provider.dart';
import 'package:IQRA/providers/login_provider.dart';
import 'package:IQRA/providers/main_data_provider.dart';
import 'package:IQRA/providers/menu_provider.dart';
import 'package:IQRA/providers/movie_tv_provider.dart';
import 'package:IQRA/providers/slider_provider.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:IQRA/services/firebase_auth.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/ui/shared/logo.dart';
import 'package:IQRA/ui/widgets/register_here.dart';
import 'package:IQRA/ui/widgets/reset_alert_container.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  //  AuthService authService = AuthService();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _isHidden = true;
  String msg = '';
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isLoggedIn = false;
  var profileData;
  var newpass;
  var facebookLogin = FacebookLogin();
  bool isShowing = false;
  LoginModel loginModel;

  // Initialize login with facebook
  void initiateFacebookLogin() async {
    var facebookLoginResult;
    var facebookLoginResult2 = await facebookLogin.isLoggedIn;
    print(facebookLoginResult2);
    if (facebookLoginResult2 == true) {
      facebookLoginResult = await facebookLogin.currentAccessToken;
      print("ok");
      print(facebookLogin);
      var graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.token}');

      var profile = json.decode(graphResponse.body);
      setState(() {
        isShowing = true;
      });
      var name = profile['name'];
      var email = profile['email'];
      var code = profile['id'];
      var password = "password";
      goToDialog();
      socialLogin(APIData.fbLoginApi, email, password, code, name, "code");

      onLoginStatusChanged(true, profileData: profile);
    } else {
      facebookLoginResult = await facebookLogin.logIn(['email']);

      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          onLoginStatusChanged(false);
          break;
        case FacebookLoginStatus.cancelledByUser:
          onLoginStatusChanged(false);
          break;
        case FacebookLoginStatus.loggedIn:
          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

          var profile = json.decode(graphResponse.body);
          var name = profile['name'];
          var email = profile['email'];
          var code = profile['id'];
          var password = "password";
          socialLogin(APIData.fbLoginApi, email, password, code, name, "code");
          onLoginStatusChanged(true, profileData: profile);
          break;
      }
    }
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  Future<String> socialLogin(url, email, password, code, name, uid) async {
  final accessTokenResponsenew = await http.post(APIData.userPassApi, body: {
      "email": email,
    });
    print(json.decode(accessTokenResponsenew.body));
    final accessTokenResponse = await http.post(url, body: {
      "email": email,
      "password": json.decode(accessTokenResponsenew.body),
      "$uid": code,
      "name": name,
    });
    if (accessTokenResponse.statusCode == 200) {
      loginModel = LoginModel.fromJson(json.decode(accessTokenResponse.body));
      var refreshToken = loginModel.refreshToken;
      var mToken = loginModel.accessToken;
      await storage.write(key: "login", value: "true");
      await storage.write(key: "authToken", value: mToken);
      await storage.write(key: "refreshToken", value: refreshToken);
      setState(() {
        authToken = mToken;
      });
      fetchAppData(context);
    } else {
      setState(() {
        isShowing = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error in login");
    }
    return null;
  }

  // Future<void> getUserPass(url, email) async {
  //   final accessTokenResponse = await http.post(url, body: {
  //     "email": email,
  //   });
  //   // print(accessTokenResponse.statusCode);
  //   // print(accessTokenResponse.body);
  //   // if (accessTokenResponse.statusCode == 200) {
  //   //   loginModel = LoginModel.fromJson(json.decode(accessTokenResponse.body));
  //   //   var refreshToken = loginModel.refreshToken;
  //   //   var mToken = loginModel.accessToken;
  //   //   await storage.write(key: "login", value: "true");
  //   //   await storage.write(key: "authToken", value: mToken);
  //   //   await storage.write(key: "refreshToken", value: refreshToken);
  //   //   setState(() {
  //   //     authToken = mToken;
  //   //   });
  //   //   fetchAppData(context);
  //   // } else {
  //   //   setState(() {
  //   //     isShowing = false;
  //   //   });
  //   //   Navigator.pop(context);
  //   //   Fluttertoast.showToast(msg: "Error in login");
  //   // }
  //   setState(() {
  //     newpass = accessTokenResponse.body;
  //   });
  //   // return accessTokenResponse.body;
  // }

  Future<void> fetchAppData(ctx) async {
    MenuProvider menuProvider = Provider.of<MenuProvider>(ctx, listen: false);
    UserProfileProvider userProfileProvider =
        Provider.of<UserProfileProvider>(ctx, listen: false);
    MainProvider mainProvider = Provider.of<MainProvider>(ctx, listen: false);
    SliderProvider sliderProvider =
        Provider.of<SliderProvider>(ctx, listen: false);
    MovieTVProvider movieTVProvider =
        Provider.of<MovieTVProvider>(ctx, listen: false);
    FAQProvider faqProvider = Provider.of<FAQProvider>(ctx, listen: false);
    await menuProvider.getMenus(ctx);
    await sliderProvider.getSlider();
    await userProfileProvider.getUserProfile(ctx);
    await faqProvider.fetchFAQ(ctx);
    await mainProvider.getMainApiData(ctx);
    await movieTVProvider.getMoviesTVData(ctx);
    setState(() {
      isShowing = false;
    });
    setState(() {
      isShowing = false;
    });
    Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
  }

  beforelogin() async {
    setState(() {
      _isLoading = true;
    });
    var response1 = await http.post(APIData.loginotpsend, body: {
      "email": _emailController.text,
      // "otp": otp.text,
      "password": _passwordController.text
    }, headers: {
      // HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json",
      // "Content-Type": "application/json"
    });
    setState(() {
      _isLoading = false;
    });
    print(response1.body);

    var response = jsonDecode(response1.body);
    if (response == "Blocked User") {
      Fluttertoast.showToast(
        msg: "Blocked User",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
    if (response == "unaurthorized") {
      Fluttertoast.showToast(
        msg: "The user credentials were incorrect.!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
    if (response["type"] == "success") {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return OtpLogin(
          email: _emailController.text,
          pass: _passwordController.text,
        );
      }));
    } else {
      Fluttertoast.showToast(
        msg: "The user credentials were incorrect..",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _saveForm() async {
    beforelogin();
    // final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    // final isValid = _formKey.currentState.validate();
    // if (!isValid) {
    //   return;
    // }
    // _formKey.currentState.save();
    // setState(() {
    //   _isLoading = true;
    // });
    // try {
    //   await loginProvider.login(
    //       _emailController.text, _passwordController.text, context);
    //   if (loginProvider.loginStatus == true) {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (BuildContext context) {
    //       return OtpLogin(email: _emailController.text,pass: _passwordController.text,);
    //     }));
    //     // final userDetails =
    //     //     Provider.of<UserProfileProvider>(context, listen: false)
    //     //         .userProfileModel;
    //     //   if (userDetails.payment == "Free") {
    //     //     Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
    //     //   } else if (userDetails.active == 1 || userDetails.active == "1") {
    //     //     Navigator.pushNamed(context, RoutePaths.multiScreen);
    //     //   } else {
    //     //     Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
    //     //   }
    //   } else if (loginProvider.emailVerify == false) {
    //     setState(() {
    //       setState(() {
    //         _isLoading = false;
    //         _emailController.text = '';
    //         _passwordController.text = '';
    //       });
    //     });
    // showAlertDialog(context, loginProvider.emailVerifyMsg);
    //   } else {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     Fluttertoast.showToast(
    //       msg: "The user credentials were incorrect..!",
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       gravity: ToastGravity.BOTTOM,
    //     );
    //   }
    // } catch (error) {
    //   print(error);
    //   await showDialog(
    //     context: context,
    //     builder: (ctx) => AlertDialog(
    //       backgroundColor: Colors.white,
    //       shape:
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    //       title: Text(
    //         'An error occurred!',
    //         style: TextStyle(
    //             color: Colors.black.withOpacity(0.7),
    //             fontWeight: FontWeight.bold),
    //       ),
    //       content: Text(
    //         'Something went wrong',
    //         style: TextStyle(
    //           color: Colors.blacdk.withOpacity(0.6),
    //         ),
    //       ),
    //       actions: <Widget>[
    //         FlatButton(
    //           color: Colors.blueAccent,
    //           child: Text('OK'),
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //         )
    //       ],
    //     ),
    //   );
    // }
    // setState(() {
    //   _isLoading = false;
    // });
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
        "Verify Email!",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: primaryBlue, fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
      content: Text("$msg1 Verify email sent on your register email.",
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
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(primaryBlue),
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

  resetPasswordAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: ResetAlertBoxContainer(),
          );
        });
  }

// Toggle for visibility
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
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
                "Login to watch latest ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "movies TV series, comedy, ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: primaryBlue,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "comedy shows",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: primaryBlue,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                " and ",
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
        ],
      ),
    );
  }

  Widget emailField() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
      child: TextFormField(
        style: TextStyle(fontSize: 16.0, color: Colors.white),
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
          labelStyle: TextStyle(color: Colors.white,fontSize: 15),
        ),
      ),
    );
  }

  Widget passwordField() {
    return Padding(
      padding:
          EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0, top: 20.0),
      child: TextFormField(
        style: TextStyle(
            fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.w400),
        controller: _passwordController,
        validator: (value) {
          if (value.length < 6) {
            if (value.length == 0) {
              return 'Password can not be empty';
            } else {
              return 'Password too short';
            }
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.text,
        obscureText: _isHidden == true ? true : false,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
              onPressed: _toggleVisibility,
              icon: _isHidden
                  ? Container(
                      height: 17,
                      // color: Colors.red,
                      child: FittedBox(
                          child: Icon(
                        Icons.visibility_off_rounded,
                        color: Colors.white,
                        // color: primaryBlue,
                      )),
                    )
                  : Icon(
                      Icons.remove_red_eye,
                      size: 17,
                      color: Colors.white,
                    )),
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
  final LinearGradient gradient = LinearGradient(colors: [primaryBlue,Colors.deepOrange,Colors.purple]);

  @override
  Widget build(BuildContext context) {
    var myModel = Provider.of<AppConfig>(context).appModel;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.yellow, accentColor: Colors.yellow),
      home: Scaffold(
          appBar: customAppBar(context, "Log In"),
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
                          // color:Colors.red,
                          height: 90,
                          width: 150,
                          child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return gradient.createShader(rect);
                  },
                  child: Text(
                    'VDOTREE',
                    style: TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.bold),
                  ))
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // logoImage(context, myModel, 0.9, 63.0, 200.0),
                      msgTitle(),
                      emailField(),
                      passwordField(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ForgotPassword();
                                }));
                              },
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              // flex: 1,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0)),
                                color: primaryBlue,
                                child: _isLoading == true
                                    ? Container(
                                        // height: 50.0,
                                        child: CircularProgressIndicator(
                                          // color: primaryBlue,
                                          backgroundColor: Colors.black,
                                        ),
                                      )
                                    : Text(
                                        'Sign In',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                onPressed: () {
                                  if (_emailController.text.isNotEmpty) {
                                    if (_emailController.text.contains("@")) {
                                      if (_passwordController.text.isNotEmpty) {
                                        print("ok");
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        _saveForm();
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Please Enter a Password",
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
                                      msg: "Please Enter your Email",
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
                      SizedBox(
                        height: 20.0,
                      ),
                     myModel.config.googleLogin == 1 ||
                              "${myModel.config.googleLogin}" == "1"
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      // flex: 1,
                                      height: 50.0,
                                      width: MediaQuery.of(context).size.width *
                                          .60,
                                      child: ButtonTheme(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        height: 50.0,
                                        child: RaisedButton.icon(
                                            icon: Image.asset(
                                              "assets/google_logo.png",
                                              height: 30,
                                              width: 30,
                                            ),
                                            label: Text(
                                              "Google Sign In",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            color: primaryBlue,
                                            onPressed: () {
                                              print(myModel.config.googleLogin);
                                              signInWithGoogle().then((result) {
                                                if (result != null) {
                                                  setState(() {
                                                    isShowing = true;
                                                  });
                                                  var email = result.email;
                                                  var password = "password";
                                                  var code = result.uid;
                                                  var name = result.displayName;
                                                  goToDialog();
                                                  print("anam");

                                                  socialLogin(
                                                      APIData.googleLoginApi,
                                                      email,
                                                      password,
                                                      code,
                                                      name,
                                                      "uid");
                                                }
                                              });
                                            }),
                                      )),
                                ],
                              ))
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 20.0,
                      ),
                      myModel.config.fbLogin == 1 ||
                              "${myModel.config.fbLogin}" == "1"
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // flex: 1,
                                    height: 50.0,
                                    width:
                                        MediaQuery.of(context).size.width * .60,
                                    child: ButtonTheme(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      height: 50.0,
                                      child: RaisedButton.icon(
                                          icon: Icon(
                                            FontAwesomeIcons.facebook,
                                            color: Colors.black,
                                            size: 28,
                                          ),
                                          label: Text(
                                            "Facebook Sign In",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,fontWeight: FontWeight.bold),
                                          ),
                                          color: primaryBlue,
                                          onPressed: () {
                                            initiateFacebookLogin();
                                          }),
                                    ),
                                  ),
                                ],
                              ))
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                registerHereText(context),
              ],
            ),
          )),
    );
  }
}

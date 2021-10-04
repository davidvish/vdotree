import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:IQRA/ui/shared/logo.dart';
import 'package:provider/provider.dart';
import 'bottom_navigations_bar.dart';
import 'package:IQRA/common/styles.dart';

DateTime currentBackPressTime;

class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  bool _visible = false;
  bool isLoggedIn = false;
  var profileData;
  var facebookLogin = FacebookLogin();

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  Widget welcomeTitle() {
    return Consumer<AppConfig>(builder: (context, myModel, child) {
      return myModel != null
          ? Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to" + ' ' + 'VDOTREE',
                    // "${myModel.appModel.config.title}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "AvenirNext",
                        color: Colors.white),
                  ),
                ],
              ),
            )
          : Text("");
    });
  }

//  Register button
  Widget registerButton() {
    return ListTile(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width * .70,
          child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: primaryBlue,
              // height: 50.0,
              height: 55.0,
              // color: Colors.white,
              textColor: Colors.black,
              child: new Text(
                "Register",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              // onPressed: () {},
              onPressed: () =>
                  Navigator.pushNamed(context, RoutePaths.register)),
        ),
      ],
    ));
  }

//  Setting background design of login button
  Widget loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width * .70,
          child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: primaryBlue,
              // height: 50.0,
              textColor: Colors.white,
              child: new Text(
                "Login",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              onPressed: () => Navigator.pushNamed(context, RoutePaths.login)),
        ),
      ],
    );
  }

  Widget loginListTile() {
    return ListTile(
        title: Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     // Where the linear gradient begins and ends
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomRight,
      //     // Add one stop for each color. Stops should increase from 0 to 1
      //     stops: [0.1, 0.5, 0.7, 0.9],
      //     // colors: [
      //     //   // Colors are easy thanks to Flutter's Colors class.
      //     //   Color.fromRGBO(72, 163, 198, 0.4).withOpacity(0.4),
      //     //   Color.fromRGBO(72, 163, 198, 0.3).withOpacity(0.5),
      //     //   Color.fromRGBO(72, 163, 198, 0.2).withOpacity(0.6),
      //     //   Color.fromRGBO(72, 163, 198, 0.1).withOpacity(0.7),
      //     // ],
      //   ),
      // ),
      child: loginButton(),
    ));
  }

// If you get HTML tag in copy right text
  Widget html() {
    return Consumer<AppConfig>(builder: (context, myModel, child) {
      return HtmlWidget(
        "${myModel.appModel.config.copyright}",
      );
      // return Html(
      //   data: myModel == null ? "" : "${myModel.appModel.config.copyright}",
      //   style: {
      //     "p": Style(alignment: Alignment.center),
      //   },
      // );
    });
  }

// Copyright text
  Widget copyRightTextContainer(myModel) {
    return 
    
    
    Container(
     
      margin: EdgeInsets.only(bottom: 5.0),
      child: new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 100,
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
//    For setting copyright text on the login page
                  myModel == null
                      ? SizedBox.shrink()
                      :
                      // Text("${myModel.config.copyright}"),
// If you get HTML tag in copy right text
                      html(),
                ],
              )
            ],
          )),
    );
  }

// Background image filter
  Widget imageBackDropFilter() {
    return BackdropFilter(
      filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
      child: new Container(
        decoration: new BoxDecoration(color: Colors.black.withOpacity(0.0)),
      ),
    );
  }

// ListView contains buttons and logo
  Widget listView(myModel) {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 70.0,
        ),
        // AnimatedOpacity(
        //   opacity: _visible == true ? 1.0 : 0.0,
        //   duration: Duration(milliseconds: 500),
        //   child: logoImage(context, myModel, 0.9, 100.0, 250.0),
        // ),
        // SizedBox(
        //   height: 20.0,
        // ),
        // co
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: 100.0,
            width: 100,
            child: Image.asset("assets/logo.png"),
          ),
        ),
        welcomeTitle(),
        SizedBox(
          height: 5.0,
        ),

        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign in",
                textAlign: TextAlign.center,
                style: TextStyle(
                  //color: primaryBlue,
                  color: Colors.white,
                  fontSize: 17
                ),
              ),
              Text(
                "  to continue",
                textAlign: TextAlign.center,
                //style: TextStyle(color: Colors.grey),
                style: TextStyle(
                    //color:primaryBlue,
                    color: Colors.white,
                    fontSize: 17
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100.0,
        ),
        loginListTile(),
        SizedBox(
          height: 20.0,
        ),
        registerButton(),
      ],
    );
  }

//Overall this page in Stack
  Widget stack(myModel) {
    final logo = Provider.of<AppConfig>(context, listen: false).appModel;
    return Stack(
      children: <Widget>[
        Container(
         
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/login.jpg'),fit: BoxFit.cover,)),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          // color: Colors.black,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX:1,sigmaY: 1,),
         child: Container(color: Colors.black26)),
//         Container(
//           decoration: BoxDecoration(
// //   For setting background color of loading screen.

//             color: Colors.black,
//             image: new DecorationImage(
//               fit: BoxFit.cover,
//               colorFilter: new ColorFilter.mode(
//                   Colors.black.withOpacity(0.4), BlendMode.dstATop),
// /*
//   For setting logo image that is accessed from the server using API.
//   You can change logo by server
// */
//               image: NetworkImage(
//                 '${APIData.loginImageUri}${logo.loginImg.image}',
//               ),
//             ),
//           ),
//           child: imageBackDropFilter(),
//         ),
        listView(myModel),
        copyRightTextContainer(myModel),
      ],
    );
  }

// WillPopScope to handle app exit
  Widget willPopScope(myModel) {
    return WillPopScope(
        child: Stack(          
          children: <Widget> [
            Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/login.jpg'))),),
           Container(
             
              child: Center(
            child: stack(myModel),
          )),
          ],
        ),
        onWillPop: onWillPopS);
  }

  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _visible = true;
      });
    });
  }

// build method
  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<AppConfig>(context).appModel;
    return Scaffold(
      body: myModel == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : willPopScope(myModel),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/common/styles.dart';

Widget registerHereText(context) {
  return ListTile(
      title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: InkWell(
            child: new RichText(
              text: new TextSpan(children: [
                new TextSpan(
                  text: "If you don't have an account? ",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: 'Sign Up ',
                  style: new TextStyle(
                      color: primaryBlue,
                      fontSize: 17.5,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600
                      ),
                )
              ]),
            ),
            // onTap: () {},
            onTap: () => Navigator.pushNamed(context, RoutePaths.register),
          ),
        ),
      ]));
}

Widget loginHereText(context) {
  return ListTile(
      title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: InkWell(
            child: new RichText(
              text: new TextSpan(children: [
                new TextSpan(
                  text: "Already have an account? ",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: 'Sign In ',
                  style: new TextStyle(
                    color: primaryBlue,
                    fontSize: 17.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600
                  ),
                )
              ]),
            ),
            onTap: () => Navigator.pushNamed(context, RoutePaths.login),
          ),
        ),
      ]));
}

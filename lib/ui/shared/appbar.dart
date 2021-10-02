import 'package:flutter/material.dart';
import 'package:IQRA/common/styles.dart';

Widget customAppBar(context, title) {
  return AppBar(
    leading: BackButton(
      color: primaryBlue,
      onPressed: (){
        Navigator.of(context).pop();
      }
    ),
    title: Text(
      title,
      style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: primaryBlue,
          letterSpacing: 0.9),
    ),
    centerTitle: true,
    backgroundColor: Colors.black,
  );
}

Widget customAppBarn(context, title) {
  return AppBar(
    elevation: 10,
    leading: BackButton(
      color: Colors.grey[900],
    ),
    // leading: BackButton(
    //   color: primaryBlue,
    // ),
    title: Text(
      title,
      style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.9),
    ),
    centerTitle: true,
    backgroundColor: Colors.grey[900],
  );
}

Widget customAppBarm(context, title) {
  return AppBar(
    leading: BackButton(
      color: primaryBlue,
    ),
    title: Text(
      title,
      style: TextStyle(fontSize: 20.0, color: primaryBlue, letterSpacing: 0.9),
    ),
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.black,
  );
}

Widget customAppBar1(context, title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontSize: 20.0, color: primaryBlue, letterSpacing: 0.9),
    ),
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.black,
  );
}

Widget customAppBar2(context, title, iconButton) {
  return AppBar(
    iconTheme: IconThemeData(color: primaryBlue),
    leading: BackButton(
      color: primaryBlue,
    ),
    title: Text(
      title,
      style: TextStyle(fontSize: 20.0, color: primaryBlue, letterSpacing: 0.9),
    ),
    centerTitle: true,
    backgroundColor: Colors.black,
    actions: [
      iconButton,
    ],
    actionsIconTheme: IconThemeData(color: primaryBlue),
  );
}

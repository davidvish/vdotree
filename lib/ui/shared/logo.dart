import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:provider/provider.dart';

//    Logo image on login page
Widget logoImage(context, myModel, scale, height, width) {
  var logo = Provider.of<AppConfig>(context).appModel.config.logo;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 15.0, left: 20.0),
        child: Container(
          child: Image.network(
            '${APIData.logoImageUri}$logo',
            scale: scale,
            height: height,
            width: width,
          ),
        ),
      )
    ],
  );
}

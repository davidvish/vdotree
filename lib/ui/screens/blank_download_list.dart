import 'package:IQRA/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/common/route_paths.dart';

class BlankDownloadList extends StatefulWidget {
  @override
  _BlankDownloadListState createState() => _BlankDownloadListState();
}

class _BlankDownloadListState extends State<BlankDownloadList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.download,
                size: 80,
                // color: Theme.of(context).cardColor.withOpacity(0.7),
                color: Colors.white60,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Download movies & TV shows to your Device so you can easily watch them later.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white.withOpacity(1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
              },
              child: Text(
                "Find Something to watch".toUpperCase(),
                // style: TextStyle(color: Colors.white70),

                style: TextStyle(
                  fontSize: 15.0,
                  // fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ))
        ],
      ),
    );
  }
}

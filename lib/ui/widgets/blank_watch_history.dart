import 'package:IQRA/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BlankWatchHistory extends StatefulWidget {
  @override
  _BlankWatchHistoryState createState() => _BlankWatchHistoryState();
}

class _BlankWatchHistoryState extends State<BlankWatchHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.solidPlayCircle,
            size: 80,
            color: Colors.white60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              "No Watch History Found",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Let's watch the most recent motion pictures,"
                    " elite TV appears at simply least cost.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white.withOpacity(1),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

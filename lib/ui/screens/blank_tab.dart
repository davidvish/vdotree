import 'package:IQRA/common/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//farman
class BlankTab extends StatefulWidget {
  @override
  _BlankTabState createState() => _BlankTabState();
}

class _BlankTabState extends State<BlankTab> {
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
                FontAwesomeIcons.solidCheckCircle,
                size: 80,
                color: Theme.of(context).cardColor.withOpacity(0.5),
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
                    "Coming Soon",
                    // "Add movies & TV shows to your list so you can easily find them later.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
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
              color: Theme.of(context).primaryColorLight.withOpacity(0.8),
              onPressed: () {
                Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);

              },
              child: Text(
                "Find Something to watch".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}

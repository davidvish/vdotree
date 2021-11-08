import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BlankWishList extends StatefulWidget {
  @override
  _BlankWishListState createState() => _BlankWishListState();
}

class _BlankWishListState extends State<BlankWishList> {
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
                // FontAwesomeIcons.solidCheckCircle,
                Icons.add_task,
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
                    // "Nothing Selected",
                    "Add Your Favorite Movies & Shows and Watch Later.",
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

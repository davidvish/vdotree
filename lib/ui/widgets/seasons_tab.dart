import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class SeasonsTab extends StatelessWidget {
  SeasonsTab(this.seasonN, this.cSeasonIndex, this.index);
  final seasonN;
  final index;
  final cSeasonIndex;
  @override
  Widget build(BuildContext context) {
    // print(seasonN);
    // print(cSeasonIndex);
    return Container(
      // color: Colors.grey[400],
      // height: 50.0,
      // color: Colors.black,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: new Text(
        'Season $seasonN',
        style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 15.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.9,
            color: (cSeasonIndex == index) ? Colors.black : Colors.white),
      ),
    );
  }
}

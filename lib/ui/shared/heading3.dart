import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/ui/screens/live_video_grid.dart';
import 'package:IQRA/ui/widgets/grid_movie_tv.dart';

class Heading3 extends StatefulWidget {
  final String heading;
  final String type;
  Heading3(this.heading, this.type);

  @override
  _Heading3State createState() => _Heading3State();
}

class _Heading3State extends State<Heading3> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        "${widget.heading}",
        style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: Colors.white),
      ),
    );
  }
}

class Heading4 extends StatefulWidget {
  final String heading;
  final String type;
  Heading4(this.heading, this.type);

  @override
  _Heading4State createState() => _Heading4State();
}

class _Heading4State extends State<Heading4> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        "${widget.heading}",
        style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: Colors.red),
      ),
    );
  }
}

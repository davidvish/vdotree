import 'package:IQRA/ui/widgets/featured_grid_movie_tv.dart';
import 'package:IQRA/ui/widgets/last_watched_movies.dart';
import 'package:IQRA/ui/widgets/recently_added_movies.dart';
import 'package:IQRA/ui/widgets/recently_added_tv_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/common/styles.dart';
import 'package:IQRA/ui/screens/live_video_grid.dart';
import 'package:IQRA/ui/widgets/grid_movie_tv.dart';

class Heading1 extends StatefulWidget {
  final String heading;
  final String type;
  Heading1(this.heading, this.type);

  @override
  _Heading1State createState() => _Heading1State();
}

class _Heading1State extends State<Heading1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.heading,
            style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              child: Text(
                "View All",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: primaryBlue),
              ),
              onTap: () {
                if (widget.type == "Top") {
                  Navigator.pushNamed(context, RoutePaths.topVideos);
                } else if (widget.type == "TV") {
                  Navigator.pushNamed(context, RoutePaths.gridVideos,
                      arguments: GridMovieTV("T"));
                } else if (widget.type == "Mov") {
                  Navigator.pushNamed(context, RoutePaths.gridVideos,
                      arguments: GridMovieTV("M"));
                } else if (widget.type == "ReMov") {
                  Navigator.pushNamed(context, RoutePaths.recentGridMovieVideos,
                      arguments: RecentlyAddedGridMovieTV("M"));
                } else if (widget.type == "ReTvSe") {
                  Navigator.pushNamed(
                      context, RoutePaths.recentGridTvSeriesVideos,
                      arguments: RecentlyAddedGridTVSeries("M"));
                } else if (widget.type == "FeMov") {
                  Navigator.pushNamed(context, RoutePaths.featuredGridVideos,
                      arguments: FeaturedGridMovieTV("M"));
                } else if (widget.type == "HeMov") {
                  Navigator.pushNamed(context, RoutePaths.watchHistoryMovieData,
                      arguments: LastWatchedGridMovieTV("M"));
                }  else if (widget.type == "Actor") {
                  Navigator.pushNamed(context, RoutePaths.actorsGrid);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class Heading2 extends StatefulWidget {
  final String heading;
  final String type;
  Heading2(this.heading, this.type);

  @override
  _Heading2State createState() => _Heading2State();
}

class _Heading2State extends State<Heading2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "${widget.heading}",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.red),
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                CupertinoIcons.dot_radiowaves_right,
                color: Colors.red,
                size: 20.0,
              )
            ],
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              child: Text(
                "View All",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: primaryBlue),
              ),
              onTap: () {
                if (widget.type == "Live") {
                  Navigator.pushNamed(context, RoutePaths.liveGrid);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

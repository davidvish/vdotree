import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/models/episode.dart';
import 'package:IQRA/providers/movie_tv_provider.dart';
import 'package:IQRA/ui/screens/video_detail_screen.dart';
import 'package:provider/provider.dart';

class TopVideoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var topMovieTV =
        Provider.of<MovieTVProvider>(context, listen: false).topVideoList;
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(left: 15.0),
        scrollDirection: Axis.horizontal,
        itemCount: topMovieTV.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.amber, spreadRadius: 3),
                ],
              ),
              margin: EdgeInsets.only(right: 15.0),
              child: Material(
                borderRadius: new BorderRadius.circular(5.0),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(5.0),
                  child: topMovieTV[index].thumbnail == null
                      ? Image.asset(
                          "assets/placeholder_box.jpg",
                          height: 260,
                          width: 190.0,
                          fit: BoxFit.cover,
                        )
                      : FadeInImage.assetNetwork(
                          image: topMovieTV[index].type == DatumType.T
                              ? "${APIData.tvImageUriTv}${topMovieTV[index].thumbnail}"
                              : "${APIData.movieImageUri}${topMovieTV[index].thumbnail}",
                          placeholder: "assets/placeholder_box.jpg",
                          height: 260,
                          width: 190.0,
                          imageScale: 1.0,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.videoDetail,
                  arguments: VideoDetailScreen(topMovieTV[index]));
            },
          );
        });
  }
}

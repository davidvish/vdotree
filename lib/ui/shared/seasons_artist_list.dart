import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/models/datum.dart';
import 'package:IQRA/models/genre_model.dart';
import 'package:IQRA/ui/screens/actor_screen.dart';
import 'package:IQRA/ui/screens/video_detail_screen.dart';

class SeasonsArtistList extends StatefulWidget {
  SeasonsArtistList(this.videoDetail);

  final Datum videoDetail;

  @override
  _SeasonsArtistListState createState() => _SeasonsArtistListState();
}

class _SeasonsArtistListState extends State<SeasonsArtistList> {
  List<Actor> actorsList = [];
  @override
  Widget build(BuildContext context) {
    widget.videoDetail.seasons[cSeasonIndex].actorList
        .removeWhere((value) => value == null);
    actorsList = widget.videoDetail.seasons[cSeasonIndex].actorList;
    return widget.videoDetail.seasons[cSeasonIndex].actorId == ""
        ? SizedBox.shrink()
        : Container(
            height: 80,
            color: Colors.black,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(left: 15.0),
                itemCount: actorsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 80.0,
                          width: 80.0,
                          margin: EdgeInsets.only(right: 15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border:
                                  Border.all(width: 0.5, color: Colors.white)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/placeholder_box.jpg",
                              image:
                                  "${APIData.actorsImages}${actorsList[index].image}",
                              fit: BoxFit.cover,
                              height: 80.0,
                              width: 80.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.pushNamed(
                        context, RoutePaths.actorScreen,
                        arguments: ActorScreen(actorsList[index])),
                  );
                }),
          );
  }
}

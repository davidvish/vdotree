import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/models/datum.dart';
import 'package:IQRA/models/genre_model.dart';
import 'package:IQRA/ui/screens/actor_screen.dart';

class ArtistList extends StatefulWidget {
  final Datum videoDetail;
  ArtistList(this.videoDetail);

  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  List<Actor> actorsList;

  @override
  Widget build(BuildContext context) {
    widget.videoDetail.actors.removeWhere((value) => value == null);
    actorsList = widget.videoDetail.actors;
    return actorsList.length == 0
        ? SizedBox()
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
                        // Text("saad"),
                        Container(
                          color: Colors.black,
                          height: 80.0,
                          width: 80.0,
                          margin: EdgeInsets.only(right: 15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border:
                                  Border.all(width: 0.5, color: Colors.white)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: actorsList[index].image == null
                                ? Image.asset(
                                    "assets/placeholder_box.jpg",
                                    fit: BoxFit.cover,
                                    height: 80.0,
                                    width: 80.0,
                                  )
                                : FadeInImage.assetNetwork(
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

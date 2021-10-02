import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/menu_data_provider.dart';
import 'package:IQRA/ui/screens/video_detail_screen.dart';
import 'package:provider/provider.dart';

class WatchHistoryMoviesList extends StatefulWidget {
  bool recent;
  WatchHistoryMoviesList(recent) {
    this.recent = recent;
  }
  @override
  _WatchHistoryMoviesListState createState() => _WatchHistoryMoviesListState();
}

class _WatchHistoryMoviesListState extends State<WatchHistoryMoviesList> {
  @override
  Widget build(BuildContext context) {
    var menuByCat =
        Provider.of<MenuDataProvider>(context, listen: false).menuCatMoviesList;
    var watchMovieHistoryMenuData =
        Provider.of<MenuDataProvider>(context, listen: false)
            .watchHistoryMovieData;
    // print(menuData[0].id);
    var arr = [];
    var newarr = [];
    for (var i = 0; i < watchMovieHistoryMenuData.length; i++) {
      arr.add(watchMovieHistoryMenuData[i].id);
    }

    for (var i = 0; i < menuByCat.length; i++) {
      if (arr.contains(menuByCat[i].id)) {
        // newarr.add(menuByCat[i]);
        newarr.insert(0, menuByCat[i]);
      }
    }

    // print(newarr[0]['id']);

    return newarr.length == 0
        ? SizedBox.shrink()
        : Container(
            height: 170,
            margin: EdgeInsets.only(top: 15.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(left: 15.0),
                scrollDirection: Axis.horizontal,
                itemCount: newarr.length,
                itemBuilder: (BuildContext context, int index) {
                  // if (arr.contains(menuByCat[index].id) == true) {
                  // print(arr.contains(menuByCat[index].id));
                  return InkWell(
                    borderRadius: new BorderRadius.circular(5.0),
                    child: Container(
                      margin: EdgeInsets.only(right: 15.0),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: new BorderRadius.circular(5.0),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(5.0),
                          child: newarr[index].thumbnail == null
                              ? Image.asset(
                                  "assets/placeholder_box.jpg",
                                  height: 170,
                                  width: 120.0,
                                  fit: BoxFit.cover,
                                )
                              : FadeInImage.assetNetwork(
                                  image: APIData.movieImageUri +
                                      "${newarr[index].thumbnail}",
                                  placeholder: "assets/placeholder_box.jpg",
                                  height: 170,
                                  width: 120.0,
                                  imageScale: 1.0,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RoutePaths.videoDetail,
                          arguments: VideoDetailScreen(newarr[index]));
                    },
                  );
                  // }
                }),
          );
  }
}

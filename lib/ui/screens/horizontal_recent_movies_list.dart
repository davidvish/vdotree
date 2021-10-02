import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/menu_data_provider.dart';
import 'package:IQRA/ui/screens/video_detail_screen.dart';
import 'package:provider/provider.dart';

class RecentMoviesList extends StatefulWidget {
  bool recent;
  RecentMoviesList(recent) {
    this.recent = recent;
  }
  @override
  _RecentMoviesListState createState() => _RecentMoviesListState();
}

class _RecentMoviesListState extends State<RecentMoviesList> {
  @override
  Widget build(BuildContext context) {
    var menuByCat =
        Provider.of<MenuDataProvider>(context, listen: false).menuCatMoviesList;
    var recentData =
        Provider.of<MenuDataProvider>(context, listen: false).recentData;
    // print(menuData[0].id);
    var arr = [];
    var newarr = [];
    for (var i = 0; i < recentData.length; i++) {
      arr.add(recentData[i].id);
    }

    for (var i = 0; i < menuByCat.length; i++) {
      if (arr.contains(menuByCat[i].id)) {
        // newarr.add(menuByCat[i]);
        newarr.insert(0, menuByCat[i]);
      }
    }

    // print(newarr.length);

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

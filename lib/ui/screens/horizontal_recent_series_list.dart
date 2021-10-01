import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/menu_data_provider.dart';
import 'package:IQRA/ui/screens/video_detail_screen.dart';
import 'package:provider/provider.dart';

class RecentSeriesList extends StatefulWidget {
  bool recent;
  RecentSeriesList(recent) {
    this.recent = recent;
  }
  @override
  _RecentSeriesListState createState() => _RecentSeriesListState();
}

class _RecentSeriesListState extends State<RecentSeriesList> {
  @override
  Widget build(BuildContext context) {
    var menuCatTvSeriesList =
        Provider.of<MenuDataProvider>(context, listen: false)
            .menuCatTvSeriesList;
    var recentAddedSeriesData =
        Provider.of<MenuDataProvider>(context, listen: false)
            .recentAddedSeriesData;
    // print(menuData[0].id);
    var arr = [];
    var newarr = [];
    for (var i = 0; i < recentAddedSeriesData.length; i++) {
      arr.add(recentAddedSeriesData[i].id);
    }

    for (var i = 0; i < menuCatTvSeriesList.length; i++) {
      if (arr.contains(menuCatTvSeriesList[i].id)) {
        // newarr.add(menuCatTvSeriesList[i]);
        newarr.insert(0, menuCatTvSeriesList[i]);
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
                                  image: APIData.tvImageUriTv +
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

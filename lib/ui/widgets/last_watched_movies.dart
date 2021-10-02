// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:IQRA/providers/menu_data_provider.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/ui/shared/grid_video_container.dart';
import 'package:provider/provider.dart';

class LastWatchedGridMovieTV extends StatelessWidget {
  final String type;
  LastWatchedGridMovieTV(this.type);

  List<Widget> videoList;
  @override
  Widget build(BuildContext context) {
    var menuByCat =
        Provider.of<MenuDataProvider>(context, listen: false).menuCatMoviesList;
    var watchHistoryMovieData =
        Provider.of<MenuDataProvider>(context, listen: false)
            .watchHistoryMovieData;
    // print(menuData[0].id);
    var arr = [];
    var newarr = [];
    for (var i = 0; i < watchHistoryMovieData.length; i++) {
      arr.add(watchHistoryMovieData[i].id);
    }

    for (var i = 0; i < menuByCat.length; i++) {
      if (arr.contains(menuByCat[i].id)) {
        newarr.add(menuByCat[i]);
      }
    }
    var tvSeriesList =
        Provider.of<MenuDataProvider>(context).menuCatTvSeriesList;
    videoList = List.generate(type == "M" ? newarr.length : tvSeriesList.length,
        (index) {
      return GridVideoContainer(context, newarr[index]);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppBar(
          context, type == "M" ? "Last Watched Movies" : "TV Series"),
      body: Container(
        color: Colors.black,
        child: GridView.count(
            padding: EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 18 / 28,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 8.0,
            children: videoList),
      ),
    );
  }
}

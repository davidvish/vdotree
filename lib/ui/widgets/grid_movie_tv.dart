// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:IQRA/providers/menu_data_provider.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/ui/shared/grid_video_container.dart';
import 'package:provider/provider.dart';

class GridMovieTV extends StatelessWidget {
  final String type;
  GridMovieTV(this.type);

  List<Widget> videoList;
  @override
  Widget build(BuildContext context) {
    var moviesList = Provider.of<MenuDataProvider>(context).menuCatMoviesList;
    var tvSeriesList =
        Provider.of<MenuDataProvider>(context).menuCatTvSeriesList;
    videoList = List.generate(
        type == "M" ? moviesList.length : tvSeriesList.length, (index) {
      return type == "M"
          ? GridVideoContainer(context, moviesList[index])
          : GridVideoContainer(context, tvSeriesList[index]);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppBar(context, type == "M" ? "Movies" : "TV Series"),
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

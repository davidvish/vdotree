import 'package:IQRA/ui/screens/blank_tab.dart';
import 'package:flutter/material.dart';
import 'package:IQRA/models/datum.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/ui/shared/grid_video_container.dart';
import 'package:IQRA/ui/screens/blank_wishlist.dart';

// ignore: must_be_immutable
class VideoGridScreen extends StatelessWidget {
  final int id;
  final String title;
  final List<Datum> genreDataList;

  VideoGridScreen(this.id, this.title, this.genreDataList);

  List<Widget> videoList;

  @override
  Widget build(BuildContext context) {
    videoList = List.generate(genreDataList == null ? 0 : genreDataList.length,
        (index) {
      return GridVideoContainer(context, genreDataList[index]);
    });
    videoList.removeWhere((value) => value == null);

    return Scaffold(
      appBar: customAppBar(context, title),
      body: Scaffold(
        backgroundColor: Colors.black,
        body: (genreDataList.length == 0)
            // ? BlankWishList()
            ? BlankTab()
            : Container(
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
      ),
    );
  }
}

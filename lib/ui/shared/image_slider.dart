import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/models/datum.dart';
import 'package:IQRA/models/episode.dart';
import 'package:IQRA/providers/movie_tv_provider.dart';
import 'package:IQRA/providers/slider_provider.dart';
import 'package:IQRA/ui/screens/video_detail_screen.dart';
import 'package:provider/provider.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<Datum> showsMoviesList;

  Widget imageSlider() {
    final slider = Provider.of<SliderProvider>(context, listen: false);
    final movieTvList =
        Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
    return Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width * 1,
        color: Colors.black,
        child: slider.sliderModel.slider.length == 0
            ? SizedBox.shrink()
            : Swiper(
                itemWidth: MediaQuery.of(context).size.width * 1,
                scrollDirection: Axis.horizontal,
                loop: true,
                autoplay: true,
                duration: 500,
                autoplayDelay: 10000,
                // autoplayDisableOnInteraction: true,
                itemCount: slider.sliderModel == null
                    ? 0
                    : slider.sliderModel.slider.length,
                itemBuilder: (BuildContext context, int index) {
                  if (slider.sliderModel.slider.isEmpty ?? true) {
                    return null;
                  } else {
                    if (slider.sliderModel.slider[index].movieId == null) {
//                      if ("${APIData.silderImageUri}" + "shows/" + "${slider.sliderModel.slider[index].slideImage}" == "${APIData.silderImageUri}" + "shows/" + "null")
                      if ("${slider.sliderModel.slider[index].slideImage}" ==
                          null) {
                        return null;
                      } else {
                        print(APIData.appSlider);
                        return InkWell(
                          customBorder: CircleBorder(),
                          // customBorder: roun,
                          borderRadius: BorderRadius.circular(25.0),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: new Image.network(
//                              "${APIData.silderImageUri}" +
//                                "shows/" + "${slider.sliderModel.slider[index].slideImage}",
                                "${APIData.appSlider}" +
                                    "movies/" +
                                    "${slider.sliderModel.slider[index].slideImage}",
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width * 1,
                              ),
                            ),
                          ),
                          onTap: () {
                            for (int i = 0; i < movieTvList.length; i++) {
                              if (movieTvList[i].type == DatumType.T) {
                                if (movieTvList[i].id ==
                                    slider
                                        .sliderModel.slider[index].tvSeriesId) {
                                  Navigator.pushNamed(
                                      context, RoutePaths.videoDetail,
                                      arguments:
                                          VideoDetailScreen(movieTvList[i]));
                                }
                              }
                            }
                          },
                        );
                      }
                    } else {
//                      if ("${APIData.silderImageUri}" +
//                              "movies/" +
//                              "${slider.sliderModel.slider[index].slideImage}" ==
//                          "${APIData.silderImageUri}" + "movies/" + "null")
                      if ("${APIData.appSlider}" == null) {
                        return null;
                      } else {
                        // print(slider.sliderModel.slider[index].slideImage);
                        return InkWell(
                          customBorder: CircleBorder(),
                          // customBorder: roun,
                          borderRadius: BorderRadius.circular(25.0),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: new Image.network(
                                // print(object);
//                              "${APIData.silderImageUri}" +
//                                  "movies/" +
//                                  "${slider.sliderModel.slider[index].slideImage}",
                                "${APIData.appSlider}" +
                                    "movies/" +
                                    "${slider.sliderModel.slider[index].slideImage}",
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width * 1,
                              ),
                            ),
                          ),
                          onTap: () {
                            for (int i = 0; i < movieTvList.length; i++) {
                              if (movieTvList[i].type == DatumType.M) {
                                if (movieTvList[i].id ==
                                    slider.sliderModel.slider[index].movieId) {
                                  Navigator.pushNamed(
                                      context, RoutePaths.videoDetail,
                                      arguments:
                                          VideoDetailScreen(movieTvList[i]));
                                }
                              }
                            }
                          },
                        );
                      }
                    }
                  }
                },
                // viewportFraction: 0.93,
                // pagination: new SwiperPagination(
                //   margin: EdgeInsets.only(
                //     bottom: 30.0,
                //   ),
                //   builder: new DotSwiperPaginationBuilder(
                //     color: Colors.white,
                //     activeColor: activeDotColor,
                //   ),
                // ),
              ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final slider =
        Provider.of<SliderProvider>(context, listen: false).sliderModel;
    return slider.slider == null
        ? SizedBox.shrink()
        : Container(
            width: MediaQuery.of(context).size.width * 1,
            height: Constants.sliderHeight,
            child: imageSlider(),
          );
  }
}

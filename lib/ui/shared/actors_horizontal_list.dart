import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/models/comment.dart';
import 'package:IQRA/models/datum.dart';
import 'package:IQRA/models/episode.dart';
import 'package:IQRA/models/seasons.dart';
import 'package:IQRA/providers/main_data_provider.dart';
import 'package:IQRA/providers/movie_tv_provider.dart';
import 'package:IQRA/ui/screens/actors_movies_grid.dart';
import 'package:IQRA/ui/screens/video_grid_screen.dart';
import 'package:provider/provider.dart';

class ActorsHorizontalList extends StatefulWidget {
  @override
  _ActorsHorizontalListState createState() => _ActorsHorizontalListState();
}

class _ActorsHorizontalListState extends State<ActorsHorizontalList> {
  List<Datum> actorsDataList = [];

  getActorsData(id, movieTvList, actorsList) {
    actorsDataList = [];
    for (int p = 0; p < movieTvList.length; p++) {
      for (int j = 0; j < movieTvList[p].actors.length; j++) {
        if (movieTvList[p].actors == null || movieTvList[p].actors[j] == null) {
          break;
        } else {
          if (id == movieTvList[p].actors[j].id) {
            var genreData = movieTvList[p].genreId == null
                ? null
                : movieTvList[p].genreId.split(",").toList();
            actorsDataList.add(Datum(
              id: movieTvList[p].id,
              actorId: movieTvList[p].actorId,
              title: movieTvList[p].title,
              trailerUrl: movieTvList[p].trailerUrl,
              status: movieTvList[p].status,
              keyword: movieTvList[p].keyword,
              description: movieTvList[p].description,
              duration: movieTvList[p].duration,
              thumbnail: movieTvList[p].thumbnail,
              poster: movieTvList[p].poster,
              directorId: movieTvList[p].directorId,
              detail: movieTvList[p].detail,
              rating: movieTvList[p].rating,
              maturityRating: movieTvList[p].maturityRating,
              publishYear: movieTvList[p].publishYear,
              released: movieTvList[p].released,
              uploadVideo: movieTvList[p].uploadVideo,
              featured: movieTvList[p].featured,
              series: movieTvList[p].series,
              aLanguage: movieTvList[p].aLanguage,
              live: movieTvList[p].live,
              createdBy: movieTvList[p].createdBy,
              createdAt: movieTvList[p].createdAt,
              updatedAt: movieTvList[p].updatedAt,
              userRating: movieTvList[p].userRating,
              movieSeries: movieTvList[p].movieSeries,
              videoLink: movieTvList[p].videoLink,
              genre: List.generate(genreData == null ? 0 : genreData.length,
                  (int genreIndex) {
                return "${genreData[genreIndex]}";
              }),
              genres: List.generate(actorsList.length, (int gIndex) {
                var genreId2 = actorsList[gIndex].id.toString();
                var genreNameList = List.generate(
                    genreData == null ? 0 : genreData.length, (int nameIndex) {
                  return "${genreData[nameIndex]}";
                });
                var isAv2 = 0;
                for (var y in genreNameList) {
                  if (genreId2 == y) {
                    isAv2 = 1;
                    break;
                  }
                }
                if (isAv2 == 1) {
                  if (actorsList[gIndex].name == null) {
                    return null;
                  } else {
                    return "${actorsList[gIndex].name}";
                  }
                }
                return null;
              }),
              comments: List.generate(
                  movieTvList[p].comments == null
                      ? 0
                      : movieTvList[p].comments.length, (cIndex) {
                return Comment(
                  id: movieTvList[p].comments[cIndex].id,
                  name: movieTvList[p].comments[cIndex].name,
                  email: movieTvList[p].comments[cIndex].email,
                  movieId: movieTvList[p].comments[cIndex].movieId,
                  tvSeriesId: movieTvList[p].comments[cIndex].tvSeriesId,
                  comment: movieTvList[p].comments[cIndex].comment,
                  createdAt: movieTvList[p].comments[cIndex].createdAt,
                  updatedAt: movieTvList[p].comments[cIndex].updatedAt,
                );
              }),
              episodeRuntime: movieTvList[p].episodeRuntime,
              genreId: movieTvList[p].genreId,
              type: movieTvList[p].type,
              seasons: List.generate(
                  movieTvList[p].seasons == null
                      ? 0
                      : movieTvList[p].seasons.length, (sIndex) {
                return Season(
                  id: movieTvList[p].seasons[sIndex].id,
                  thumbnail: movieTvList[p].seasons[sIndex].thumbnail,
                  poster: movieTvList[p].seasons[sIndex].poster,
                  publishYear: movieTvList[p].seasons[sIndex].publishYear,
                  episodes: List.generate(
                      movieTvList[p].seasons[sIndex].episodes == null
                          ? 0
                          : movieTvList[p].seasons[sIndex].episodes.length,
                      (eIndex) {
                    return Episode(
                      id: movieTvList[p].seasons[sIndex].episodes[eIndex].id,
                      thumbnail: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .thumbnail,
                      title:
                          movieTvList[p].seasons[sIndex].episodes[eIndex].title,
                      detail: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .detail,
                      duration: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .duration,
                      createdAt: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .createdAt,
                      updatedAt: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .updatedAt,
                      episodeNo: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .episodeNo,
                      aLanguage: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .aLanguage,
                      released: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .released,
                      seasonsId: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .seasonsId,
                      videoLink: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .videoLink,
                    );
                  }),
                  actorId: movieTvList[p].seasons[sIndex].actorId,
                  aLanguage: movieTvList[p].seasons[sIndex].aLanguage,
                  createdAt: movieTvList[p].seasons[sIndex].createdAt,
                  updatedAt: movieTvList[p].seasons[sIndex].updatedAt,
                  featured: movieTvList[p].seasons[sIndex].featured,
                  tmdb: movieTvList[p].seasons[sIndex].tmdb,
                  tmdbId: movieTvList[p].seasons[sIndex].tmdbId,
                  subtitle: movieTvList[p].seasons[sIndex].subtitle,
                  subtitleList: movieTvList[p].seasons[sIndex].subtitleList,
                );
              }),
            ));
          } else {
            print("no");
          }
        }
      }
    }
//    for(int p = 0; p<movieTvList.length; p++){
//      for(int s = 0; s<movieTvList[p].actors.length; s++){
//        print("s: ${movieTvList[p].actors[s].name}");
//        if("${movieTvList[p].actors[s].id}" == "$id"){
//          var genreData = movieTvList[p].genreId == null ? null : movieTvList[p].genreId.split(",").toList();
//          actorsDataList.add(Datum(
//            id: movieTvList[p].id,
//            actorId: movieTvList[p].actorId,
//            title: movieTvList[p].title,
//            trailerUrl: movieTvList[p].trailerUrl,
//            status: movieTvList[p].status,
//            keyword: movieTvList[p].keyword,
//            description: movieTvList[p].description,
//            duration: movieTvList[p].duration,
//            thumbnail: movieTvList[p].thumbnail,
//            poster: movieTvList[p].poster,
//            directorId: movieTvList[p].directorId,
//            detail: movieTvList[p].detail,
//            rating: movieTvList[p].rating,
//            maturityRating: movieTvList[p].maturityRating,
//            publishYear: movieTvList[p].publishYear,
//            released: movieTvList[p].released,
//            uploadVideo: movieTvList[p].uploadVideo,
//            featured: movieTvList[p].featured,
//            series: movieTvList[p].series,
//            aLanguage: movieTvList[p].aLanguage,
//            live: movieTvList[p].live,
//            createdBy: movieTvList[p].createdBy,
//            createdAt: movieTvList[p].createdAt,
//            updatedAt: movieTvList[p].updatedAt,
//            userRating: movieTvList[p].userRating,
//            movieSeries: movieTvList[p].movieSeries,
//            videoLink: movieTvList[p].videoLink,
//            genre: List.generate(genreData == null ? 0 : genreData.length,
//                    (int genreIndex) {
//                  return "${genreData[genreIndex]}";
//                }),
//            genres: List.generate(actorsList.length,
//                    (int gIndex) {
//                  var genreId2 = actorsList[gIndex].id.toString();
//                  var genreNameList = List.generate(genreData == null ? 0 : genreData.length,
//                          (int nameIndex) {
//                        return "${genreData[nameIndex]}";
//                      });
//                  var isAv2 = 0;
//                  for (var y in genreNameList) {
//                    if (genreId2 == y) {
//                      isAv2 = 1;
//                      break;
//                    }
//                  }
//                  if (isAv2 == 1) {
//                    if (actorsList[gIndex].name == null) {
//                      return null;
//                    } else {
//                      return "${actorsList[gIndex].name}";
//                    }
//                  }
//                  return null;
//                }),
//            comments: List.generate(movieTvList[p].comments == null ? 0 : movieTvList[p].comments.length, (cIndex) {
//              return Comment(
//                id: movieTvList[p].comments[cIndex].id,
//                name: movieTvList[p].comments[cIndex].name,
//                email: movieTvList[p].comments[cIndex].email,
//                movieId: movieTvList[p].comments[cIndex].movieId,
//                tvSeriesId: movieTvList[p].comments[cIndex].tvSeriesId,
//                comment: movieTvList[p].comments[cIndex].comment,
//                createdAt: movieTvList[p].comments[cIndex].createdAt,
//                updatedAt: movieTvList[p].comments[cIndex].updatedAt,
//              );
//            }),
//            episodeRuntime: movieTvList[p].episodeRuntime,
//            genreId: movieTvList[p].genreId,
//            type: movieTvList[p].type,
//            seasons: List.generate(movieTvList[p].seasons == null ? 0 : movieTvList[p].seasons.length, (sIndex) {
//              return Season(
//                id: movieTvList[p].seasons[sIndex].id,
//                thumbnail: movieTvList[p].seasons[sIndex].thumbnail,
//                poster: movieTvList[p].seasons[sIndex].poster,
//                publishYear: movieTvList[p].seasons[sIndex].publishYear,
//                episodes: List.generate(
//                    movieTvList[p].seasons[sIndex].episodes == null ? 0 : movieTvList[p].seasons[sIndex].episodes.length,
//                        (eIndex) {
//                      return Episode(
//                        id: movieTvList[p].seasons[sIndex].episodes[eIndex].id,
//                        thumbnail: movieTvList[p].seasons[sIndex].episodes[eIndex].thumbnail,
//                        title: movieTvList[p].seasons[sIndex].episodes[eIndex].title,
//                        detail: movieTvList[p].seasons[sIndex].episodes[eIndex].detail,
//                        duration: movieTvList[p].seasons[sIndex].episodes[eIndex].duration,
//                        createdAt: movieTvList[p].seasons[sIndex].episodes[eIndex].createdAt,
//                        updatedAt: movieTvList[p].seasons[sIndex].episodes[eIndex].updatedAt,
//                        episodeNo: movieTvList[p].seasons[sIndex].episodes[eIndex].episodeNo,
//                        aLanguage: movieTvList[p].seasons[sIndex].episodes[eIndex].aLanguage,
//                        released: movieTvList[p].seasons[sIndex].episodes[eIndex].released,
//                        seasonsId: movieTvList[p].seasons[sIndex].episodes[eIndex].seasonsId,
//                        videoLink: movieTvList[p].seasons[sIndex].episodes[eIndex].videoLink,
//                      );
//                    }),
//
//                actorId: movieTvList[p].seasons[sIndex].actorId,
//                aLanguage: movieTvList[p].seasons[sIndex].aLanguage,
//                createdAt: movieTvList[p].seasons[sIndex].createdAt,
//                updatedAt: movieTvList[p].seasons[sIndex].updatedAt,
//                featured: movieTvList[p].seasons[sIndex].featured,
//                tmdb: movieTvList[p].seasons[sIndex].tmdb,
//                tmdbId: movieTvList[p].seasons[sIndex].tmdbId,
//                subtitle: movieTvList[p].seasons[sIndex].subtitle,
//                subtitleList: movieTvList[p].seasons[sIndex].subtitleList,
//              );
//            }),
//          ));
//        }
//      }
//    }
  }

  @override
  Widget build(BuildContext context) {
    var actorsList =
        Provider.of<MainProvider>(context, listen: false).actorList;
    var movieTvList = Provider.of<MovieTVProvider>(context).movieTvList;
    return Container(
      height: 90,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 15.0),
          itemCount: actorsList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: Container(
                height: 90,
                width: 90,
                margin: EdgeInsets.only(right: 15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45.0),
                    border: Border.all(width: 1.0, color: Colors.white)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45.0),
                  child: FadeInImage.assetNetwork(
                    image: "${APIData.actorsImages}${actorsList[index].image}",
                    placeholder: "assets/placeholder_box.jpg",
                    fit: BoxFit.cover,
                    height: 90.0,
                    width: 90.0,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.actorMoviesGrid,
                    arguments: ActorMoviesGrid(actorsList[index]));
              },
            );
          }),
    );
  }
}

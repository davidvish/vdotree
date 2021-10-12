import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/common/styles.dart';
import 'package:IQRA/models/comment.dart';
import 'package:IQRA/models/datum.dart';
import 'package:IQRA/models/episode.dart';
import 'package:IQRA/models/genre_model.dart';
import 'package:IQRA/models/seasons.dart';
import 'package:IQRA/providers/main_data_provider.dart';
import 'package:IQRA/providers/movie_tv_provider.dart';
import 'package:IQRA/providers/wishlist_provider.dart';
import 'package:IQRA/ui/screens/blank_wishlist.dart';
import 'package:IQRA/ui/screens/video_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

List<Datum> tvWishList = [];
List<Datum> moviesWishList = [];

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  ScrollController _scrollViewController;
  bool _visible = false;

  fetchWishList() async {
    tvWishList = [];
    moviesWishList = [];
    final moviesTvList =
        Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
    final genreList =
        Provider.of<MainProvider>(context, listen: false).genreList;
    final audioList =
        Provider.of<MainProvider>(context, listen: false).audioList;
    final actorList =
        Provider.of<MainProvider>(context, listen: false).actorList;
    final directorList =
        Provider.of<MainProvider>(context, listen: false).directorList;
    final myWishList = Provider.of<WishListProvider>(context, listen: false);
    await myWishList.getWishList(context);
    final mWishList = Provider.of<WishListProvider>(context, listen: false)
        .wishListModel
        .wishlist;

    for (int i = 0; i < moviesTvList.length; i++) {
      for (int j = 0; j < mWishList.length; j++) {
        if (moviesTvList[i].type == DatumType.M) {
          if (moviesTvList[i].id == mWishList[j].movieId) {
            var genreData = moviesTvList[i].genreId == null
                ? null
                : moviesTvList[i].genreId.split(",").toList();
            var actors = moviesTvList[i].actorId == null
                ? null
                : moviesTvList[i].actorId.split(",").toList();
            var directors = moviesTvList[i].directorId == null
                ? null
                : moviesTvList[i].directorId.split(",").toList();
            var audios = moviesTvList[i].aLanguage == null
                ? null
                : moviesTvList[i].aLanguage.split(",").toList();
            moviesWishList.add(Datum(
              id: moviesTvList[i].id,
              actorId: moviesTvList[i].actorId,
              title: moviesTvList[i].title,
              trailerUrl: moviesTvList[i].trailerUrl,
              status: moviesTvList[i].status,
              keyword: moviesTvList[i].keyword,
              description: moviesTvList[i].description,
              duration: moviesTvList[i].duration,
              thumbnail: moviesTvList[i].thumbnail,
              poster: moviesTvList[i].poster,
              directorId: moviesTvList[i].directorId,
              detail: moviesTvList[i].detail,
              rating: moviesTvList[i].rating,
              maturityRating: moviesTvList[i].maturityRating,
              publishYear: moviesTvList[i].publishYear,
              released: moviesTvList[i].released,
              uploadVideo: moviesTvList[i].uploadVideo,
              featured: moviesTvList[i].featured,
              series: moviesTvList[i].series,
              aLanguage: moviesTvList[i].aLanguage,
              live: moviesTvList[i].live,
              createdBy: moviesTvList[i].createdBy,
              createdAt: moviesTvList[i].createdAt,
              updatedAt: moviesTvList[i].updatedAt,
              userRating: moviesTvList[i].userRating,
              movieSeries: moviesTvList[i].movieSeries,
              videoLink: moviesTvList[i].videoLink,
              genre: List.generate(genreData == null ? 0 : genreData.length,
                  (int genreIndex) {
                return "${genreData[genreIndex]}";
              }),
              genres: List.generate(genreList.length, (int gIndex) {
                var genreId2 = genreList[gIndex].id.toString();
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
                  if (genreList[gIndex].name == null) {
                    return null;
                  } else {
                    return "${genreList[gIndex].name}";
                  }
                }
                return null;
              }),
              actor: List.generate(actors == null ? 0 : actors.length,
                  (int aIndex) {
                return "${actors[aIndex]}";
              }),
              actors: List.generate(actorList.length, (actIndex) {
                var actorsId = actorList[actIndex].id.toString();
                var actorsIdList = List.generate(
                    actors == null ? 0 : actors.length, (int idIndex) {
                  return "${actors[idIndex]}";
                });
                var isAv2 = 0;
                for (var y in actorsIdList) {
                  if (actorsId == y) {
                    isAv2 = 1;
                    break;
                  }
                }
                if (isAv2 == 1) {
                  if (actorList[actIndex].name == null) {
                    return null;
                  } else {
                    return Actor(
                      id: actorList[actIndex].id,
                      name: actorList[actIndex].name,
                      image: actorList[actIndex].image,
                      biography: actorList[actIndex].biography,
                      placeOfBirth: actorList[actIndex].placeOfBirth,
                      dob: actorList[actIndex].dob,
                      createdAt: actorList[actIndex].createdAt,
                      updatedAt: actorList[actIndex].updatedAt,
                    );
                  }
                }
                return null;
              }),
              directors: List.generate(directorList.length, (actIndex) {
                var directorsId = directorList[actIndex].id.toString();
                var actorsIdList = List.generate(
                    directors == null ? 0 : directors.length, (int idIndex) {
                  return "${directors[idIndex]}";
                });
                var isAv2 = 0;
                for (var y in actorsIdList) {
                  if (directorsId == y) {
                    isAv2 = 1;
                    break;
                  }
                }
                if (isAv2 == 1) {
                  if (directorList[actIndex].name == null) {
                    return null;
                  } else {
                    return Director(
                      id: directorList[actIndex].id,
                      name: directorList[actIndex].name,
                      image: directorList[actIndex].image,
                      biography: directorList[actIndex].biography,
                      placeOfBirth: directorList[actIndex].placeOfBirth,
                      dob: directorList[actIndex].dob,
                      createdAt: directorList[actIndex].createdAt,
                      updatedAt: directorList[actIndex].updatedAt,
                    );
                  }
                }
                return null;
              }),
              audios: List.generate(audioList.length, (actIndex) {
                var actorsId = audioList[actIndex].id.toString();
                var audioIdList = List.generate(
                    audios == null ? 0 : audios.length, (int idIndex) {
                  return "${audios[idIndex]}";
                });
                var isAv2 = 0;
                for (var y in audioIdList) {
                  if (actorsId == y) {
                    isAv2 = 1;
                    break;
                  }
                }
                if (isAv2 == 1) {
                  if (audioList[actIndex].language == null) {
                    return null;
                  } else {
                    return "${audioList[actIndex].language}";
                  }
                }
                return null;
              }),
              comments: List.generate(
                  moviesTvList[i].comments == null
                      ? 0
                      : moviesTvList[i].comments.length, (cIndex) {
                return Comment(
                  id: moviesTvList[i].comments[cIndex].id,
                  name: moviesTvList[i].comments[cIndex].name,
                  email: moviesTvList[i].comments[cIndex].email,
                  movieId: moviesTvList[i].comments[cIndex].movieId,
                  tvSeriesId: moviesTvList[i].comments[cIndex].tvSeriesId,
                  comment: moviesTvList[i].comments[cIndex].comment,
                  subcomments: moviesTvList[i].comments[cIndex].subcomments,
                  createdAt: moviesTvList[i].comments[cIndex].createdAt,
                  updatedAt: moviesTvList[i].comments[cIndex].updatedAt,
                );
              }),
              episodeRuntime: moviesTvList[i].episodeRuntime,
              genreId: moviesTvList[i].genreId,
              type: moviesTvList[i].type,
              tmdbId: moviesTvList[i].tmdbId,
              tmdb: moviesTvList[i].tmdb,
              fetchBy: moviesTvList[i].fetchBy,
            ));
          }
        } else {
          var seasonData = moviesTvList[i].seasons;
          for (int k = 0; k < seasonData.length; k++) {
            if (seasonData[k].id == mWishList[j].seasonId) {
              var genreData = moviesTvList[i].genreId == null
                  ? null
                  : moviesTvList[i].genreId.split(",").toList();
              var actors, audios, directors;
              if (moviesTvList[i].type == DatumType.T) {
                actors = moviesTvList[i].actorId == null
                    ? null
                    : moviesTvList[i].actorId.split(",").toList();
                audios = moviesTvList[i].aLanguage == null
                    ? null
                    : moviesTvList[i].aLanguage.split(",").toList();
                directors = moviesTvList[i].directorId == null
                    ? null
                    : moviesTvList[i].directorId.split(",").toList();
              }
              tvWishList.add(Datum(
                id: moviesTvList[i].id,
                actorId: moviesTvList[i].actorId,
                title: moviesTvList[i].title,
                trailerUrl: moviesTvList[i].trailerUrl,
                status: moviesTvList[i].status,
                keyword: moviesTvList[i].keyword,
                description: moviesTvList[i].description,
                duration: moviesTvList[i].duration,
                thumbnail: moviesTvList[i].thumbnail,
                poster: moviesTvList[i].poster,
                directorId: moviesTvList[i].directorId,
                detail: moviesTvList[i].detail,
                rating: moviesTvList[i].rating,
                maturityRating: moviesTvList[i].maturityRating,
                publishYear: moviesTvList[i].publishYear,
                released: moviesTvList[i].released,
                uploadVideo: moviesTvList[i].uploadVideo,
                featured: moviesTvList[i].featured,
                series: moviesTvList[i].series,
                aLanguage: moviesTvList[i].aLanguage,
                live: moviesTvList[i].live,
                createdBy: moviesTvList[i].createdBy,
                createdAt: moviesTvList[i].createdAt,
                updatedAt: moviesTvList[i].updatedAt,
                userRating: moviesTvList[i].userRating,
                movieSeries: moviesTvList[i].movieSeries,
                videoLink: moviesTvList[i].videoLink,
                genre: List.generate(genreData == null ? 0 : genreData.length,
                    (int genreIndex) {
                  return "${genreData[genreIndex]}";
                }),
                genres: List.generate(genreList.length, (int gIndex) {
                  var genreId2 = genreList[gIndex].id.toString();
                  var genreNameList =
                      List.generate(genreData == null ? 0 : genreData.length,
                          (int nameIndex) {
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
                    if (genreList[gIndex].name == null) {
                      return null;
                    } else {
                      return "${genreList[gIndex].name}";
                    }
                  }
                  return null;
                }),
                comments: List.generate(
                    moviesTvList[i].comments == null
                        ? 0
                        : moviesTvList[i].comments.length, (cIndex) {
                  return Comment(
                    id: moviesTvList[i].comments[cIndex].id,
                    name: moviesTvList[i].comments[cIndex].name,
                    email: moviesTvList[i].comments[cIndex].email,
                    movieId: moviesTvList[i].comments[cIndex].movieId,
                    tvSeriesId: moviesTvList[i].comments[cIndex].tvSeriesId,
                    comment: moviesTvList[i].comments[cIndex].comment,
                    subcomments: moviesTvList[i].comments[cIndex].subcomments,
                    createdAt: moviesTvList[i].comments[cIndex].createdAt,
                    updatedAt: moviesTvList[i].comments[cIndex].updatedAt,
                  );
                }),
                episodeRuntime: moviesTvList[i].episodeRuntime,
                genreId: moviesTvList[i].genreId,
                type: moviesTvList[i].type,
                seasons: List.generate(
                    moviesTvList[i].seasons == null
                        ? 0
                        : moviesTvList[i].seasons.length, (sIndex) {
                  var seasonActors =
                      moviesTvList[i].seasons[sIndex].actorId == null ||
                              moviesTvList[i].seasons[sIndex].actorId == ""
                          ? null
                          : moviesTvList[i].seasons[sIndex].actorId;
                  var audios =
                      moviesTvList[i].seasons[sIndex].aLanguage == null ||
                              moviesTvList[i].seasons[sIndex].aLanguage == ""
                          ? null
                          : moviesTvList[i].seasons[sIndex].actorId;
                  return Season(
                    id: moviesTvList[i].seasons[sIndex].id,
                    seasonNo: moviesTvList[i].seasons[sIndex].seasonNo,
                    tvSeriesId: moviesTvList[i].seasons[sIndex].tvSeriesId,
                    thumbnail: moviesTvList[i].seasons[sIndex].thumbnail,
                    poster: moviesTvList[i].seasons[sIndex].poster,
                    publishYear: moviesTvList[i].seasons[sIndex].publishYear,
                    episodes: List.generate(
                        moviesTvList[i].seasons[sIndex].episodes == null
                            ? 0
                            : moviesTvList[i].seasons[sIndex].episodes.length,
                        (eIndex) {
                      return Episode(
                        id: moviesTvList[i].seasons[sIndex].episodes[eIndex].id,
                        thumbnail: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .thumbnail,
                        title: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .title,
                        detail: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .detail,
                        duration: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .duration,
                        createdAt: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .createdAt,
                        updatedAt: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .updatedAt,
                        episodeNo: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .episodeNo,
                        aLanguage: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .aLanguage,
                        released: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .released,
                        seasonsId: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .seasonsId,
                        videoLink: moviesTvList[i]
                            .seasons[sIndex]
                            .episodes[eIndex]
                            .videoLink,
                      );
                    }),
                    actor: List.generate(
                        seasonActors == null ? 0 : seasonActors.length,
                        (int aIndex) {
                      return "${seasonActors[aIndex]}";
                    }),
                    actorList: List.generate(actorList.length, (actIndex) {
                      var actorsId = actorList[actIndex].id.toString();
                      var actorsIdList = List.generate(
                          seasonActors == null ? 0 : seasonActors.length,
                          (int idIndex) {
                        return "${seasonActors[idIndex]}";
                      });
                      var isAv2 = 0;
                      for (var y in actorsIdList) {
                        if (actorsId == y) {
                          isAv2 = 1;
                          break;
                        }
                      }
                      if (isAv2 == 1) {
                        if (actorList[actIndex].name == null) {
                          return null;
                        } else {
                          return Actor(
                            id: actorList[actIndex].id,
                            name: actorList[actIndex].name,
                            image: actorList[actIndex].image,
                            biography: actorList[actIndex].biography,
                            placeOfBirth: actorList[actIndex].placeOfBirth,
                            dob: actorList[actIndex].dob,
                            createdAt: actorList[actIndex].createdAt,
                            updatedAt: actorList[actIndex].updatedAt,
                          );
                        }
                      }
                      return null;
                    }),
                    audiosList: List.generate(audioList.length, (actIndex) {
                      var actorsId = audioList[actIndex].id.toString();
                      var audioIdList = List.generate(
                          audios == null ? 0 : audios.length, (int idIndex) {
                        return "${audios[idIndex]}";
                      });
                      var isAv2 = 0;
                      for (var y in audioIdList) {
                        if (actorsId == y) {
                          isAv2 = 1;
                          break;
                        }
                      }
                      if (isAv2 == 1) {
                        if (audioList[actIndex].language == null) {
                          return null;
                        } else {
                          return "${audioList[actIndex].language}";
                        }
                      }
                      return null;
                    }),
                    actorId: moviesTvList[i].seasons[sIndex].actorId,
                    aLanguage: moviesTvList[i].seasons[sIndex].aLanguage,
                    createdAt: moviesTvList[i].seasons[sIndex].createdAt,
                    updatedAt: moviesTvList[i].seasons[sIndex].updatedAt,
                    featured: moviesTvList[i].seasons[sIndex].featured,
                    tmdb: moviesTvList[i].seasons[sIndex].tmdb,
                    tmdbId: moviesTvList[i].seasons[sIndex].tmdbId,
                    subtitle: moviesTvList[i].seasons[sIndex].subtitle,
                    subtitleList: moviesTvList[i].seasons[sIndex].subtitleList,
                  );
                }),
                actor: List.generate(actors == null ? 0 : actors.length,
                    (int aIndex) {
                  return "${actors[aIndex]}";
                }),
                actors: List.generate(actorList.length, (actIndex) {
                  var actorsId = actorList[actIndex].id.toString();
                  var actorsIdList = List.generate(
                      actors == null ? 0 : actors.length, (int idIndex) {
                    return "${actors[idIndex]}";
                  });
                  var isAv2 = 0;
                  for (var y in actorsIdList) {
                    if (actorsId == y) {
                      isAv2 = 1;
                      break;
                    }
                  }
                  if (isAv2 == 1) {
                    if (actorList[actIndex].name == null) {
                      return null;
                    } else {
                      return Actor(
                        id: actorList[actIndex].id,
                        name: actorList[actIndex].name,
                        image: actorList[actIndex].image,
                        biography: actorList[actIndex].biography,
                        placeOfBirth: actorList[actIndex].placeOfBirth,
                        dob: actorList[actIndex].dob,
                        createdAt: actorList[actIndex].createdAt,
                        updatedAt: actorList[actIndex].updatedAt,
                      );
                    }
                  }
                  return null;
                }),
                tmdbId: moviesTvList[i].tmdbId,
                tmdb: moviesTvList[i].tmdb,
                fetchBy: moviesTvList[i].fetchBy,
                directors: List.generate(directorList.length, (actIndex) {
                  var directorsId = directorList[actIndex].id.toString();
                  var actorsIdList = List.generate(
                      directors == null ? 0 : directors.length, (int idIndex) {
                    return "${directors[idIndex]}";
                  });
                  var isAv2 = 0;
                  for (var y in actorsIdList) {
                    if (directorsId == y) {
                      isAv2 = 1;
                      break;
                    }
                  }
                  if (isAv2 == 1) {
                    if (directorList[actIndex].name == null) {
                      return null;
                    } else {
                      return Director(
                        id: directorList[actIndex].id,
                        name: directorList[actIndex].name,
                        image: directorList[actIndex].image,
                        biography: directorList[actIndex].biography,
                        placeOfBirth: directorList[actIndex].placeOfBirth,
                        dob: directorList[actIndex].dob,
                        createdAt: directorList[actIndex].createdAt,
                        updatedAt: directorList[actIndex].updatedAt,
                      );
                    }
                  }
                  return null;
                }),
                audios: List.generate(audioList.length, (actIndex) {
                  var actorsId = audioList[actIndex].id.toString();
                  var audioIdList = List.generate(
                      audios == null ? 0 : audios.length, (int idIndex) {
                    return "${audios[idIndex]}";
                  });
                  var isAv2 = 0;
                  for (var y in audioIdList) {
                    if (actorsId == y) {
                      isAv2 = 1;
                      break;
                    }
                  }
                  if (isAv2 == 1) {
                    if (audioList[actIndex].language == null) {
                      return null;
                    } else {
                      return "${audioList[actIndex].language}";
                    }
                  }
                  return null;
                }),
              ));
            }
          }
        }
      }
    }
    setState(() {
      _visible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _visible = false;
    });
    _scrollViewController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      fetchWishList();
    });
  }

  @override
  Widget build(BuildContext context) {
        var w = MediaQuery.of(context).size.width * 0.04;

    return SafeArea(
        child: Scaffold(
          backgroundColor:Colors.black,
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(
                  "Wishlist",
                  style: TextStyle(
                      fontSize: 20.0, color: primaryBlue, letterSpacing: 0.9),
                ),
                centerTitle: true,
                backgroundColor: Colors.black,
                floating: true,
                pinned: true,
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(68),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: w, right: w, top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        // color: Colors.red,
                        // border: Border.all(
                        //     color: Theme.of(context)
                        //         .primaryColor
                        //         .withOpacity(0.2)),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: TabBar(
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color:primaryBlue),
                          color: Colors.black),
                      indicatorSize: TabBarIndicatorSize.tab,
                      // indicatorColor: Theme.of(context).primaryColor,
                      isScrollable: false,
                      tabs: [
                        new Tab(
                          child: Container(
                            // margin: EdgeInsets.only(left: w, right: w),
                            child: Text("Movies"),
                          ),
                        ),
                        new Tab(
                          child: Container(
                            // padding: EdgeInsets.only(left: w, right: w),
                            child: Text("TV Series"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              MoviesWishList(_visible),
              TVSeriesWishList(_visible),
            ],
          ),
        ),
      ),
    ));
  }
}

class MoviesWishList extends StatefulWidget {
  MoviesWishList(this._visible);
  final bool _visible;

  @override
  _MoviesWishListState createState() => _MoviesWishListState();
}

class _MoviesWishListState extends State<MoviesWishList> {
  Future<String> removeWishList(vType, id) async {
    final response = await http.get("${APIData.removeWatchlistMovie}$id",
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    if (response.statusCode == 200) {
      moviesWishList
          .removeWhere((element) => element.type == vType && element.id == id);
      setState(() {});
    }
    return null;
  }

  // PlaceHolder image displayed on the watchlist item.
  Widget placeHolderImage(movies) {
    return Expanded(
      flex: 4,
      child: Container(
        child: new ClipRRect(
          borderRadius: new BorderRadius.circular(8.0),
          child: new FadeInImage.assetNetwork(
            image: "${APIData.movieImageUri}${movies.thumbnail}",
            placeholder: "assets/placeholder_box.jpg",
            height: 155.0,
            // width: 220.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget watchlistItemDetails(BuildContext context, movies, genres) {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Text(
            movies.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 16.0,
              color: primaryBlue,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 4.0),
          // movies.duration == null
          //     ? SizedBox.shrink()
          //     : Text('Duration : ${movies.duration} min',
          //         textAlign: TextAlign.start,
          //         style: TextStyle(
          //             color: Colors.white.withOpacity(0.8), fontSize: 14.0)),
          SizedBox(
            height: 10,
          ),
          Text(
            '$genres',
            style: TextStyle(
                color: Color.fromRGBO(72, 163, 198, 1.0),
                fontSize: 12.0,
                fontWeight: FontWeight.w800),
            textAlign: TextAlign.left,
            maxLines: 1,
          ),
          // SizedBox(height: 4.0),
          SizedBox(
            height: 10,
          ),
          movies.duration == null
              ? Text('RUNTIME: NA',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ))
              : Text(
                  'RUNTIME: ${movies.duration} min',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          movies.released == null
              ? Text('RELEASE DATE: NA',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w800))
              : Text(
                  'RELEASE DATE: ${DateFormat('d-MM-y').format(movies.released)}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     Container(
          //       margin: EdgeInsets.only(right: 5.0),
          //       child: Column(
          //         children: <Widget>[
          //           SizedBox(
          //             height: 20.0,
          //           ),
          //           Text(
          //             'RELEASE DATE:',
          //             style: TextStyle(
          //                 color: Colors.white70,
          //                 fontSize: 10.0,
          //                 fontWeight: FontWeight.w800),
          //           ),
          //           SizedBox(height: 4.0),
          //           Text(
          //             DateFormat('d-MM-y').format(movies.released),
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 12.0,
          //               fontWeight: FontWeight.w800,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Expanded(
          //       flex: 3,
          //       child: Column(
          //         children: <Widget>[
          //           SizedBox(
          //             height: 20.0,
          //           ),
          //           Text(
          //             'RUNTIME:',
          //             style: TextStyle(
          //               color: Colors.white70,
          //               fontSize: 10.0,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           SizedBox(height: 4.0),
          //           Text(
          //             movies.duration,
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 12.0,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: double.parse("${movies.rating / 2}"),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              SizedBox(
                width: 55.0,
              ),
              IconButton(
                  icon: Icon(
                    CupertinoIcons.delete_simple,
                    color: Colors.white,
                  ),
                  onPressed: () {
                     removeWishList(movies.type, movies.id);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      // backgroundColor: Colors.grey,
                      content: Text('Deleted from wishlist',),
                    duration: Duration(seconds: 1),
                    ));
                   
                  })
            ],
          )
        ],
      ),
    );
  }

  //  Watchlist item all details like image, name,
  Widget watchlistItemContainer(movies, genres) {
    return Container(
      color: Colors.transparent,
      margin: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.videoDetail,
              arguments: VideoDetailScreen(movies));
        },
        child: Container(
          decoration: new BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              placeHolderImage(movies),
              SizedBox(
                width: 10.0,
                height: 0.0,
              ),
              watchlistItemDetails(context, movies, genres),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget._visible == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : moviesWishList.length == 0
            ? BlankWishList()
            : Container(
              height: MediaQuery.of(context).size.height,
                color: Colors.black,
                child: Container(
                  color: Colors.black,
                  child: ListView.builder(
                      itemCount: moviesWishList.length,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      itemBuilder: (BuildContext context, int index) {
                        moviesWishList[index]
                            .genres
                            .removeWhere((value) => value == null);
                        String genres = moviesWishList[index].genres.toString();
                        genres = genres.replaceAll("[", "").replaceAll("]", "");
                        return watchlistItemContainer(
                            moviesWishList[index], genres);
                      }),
                ),
              );
  }
}

class TVSeriesWishList extends StatefulWidget {
  TVSeriesWishList(this._visible);
  final bool _visible;

  @override
  _TVSeriesWishListState createState() => _TVSeriesWishListState();
}

class _TVSeriesWishListState extends State<TVSeriesWishList> {
   removeWishList(vType, id) async {
    final response = await http.get("${APIData.removeWatchlistSeason}$id",
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
        print(' RFCTFCFC $id');
        print(response.body);
    if (response.statusCode == 200) {
      tvWishList
          .removeWhere((element) => element.type == vType && element.id == id);
      setState(() {});
      print('ID SOLVE $id');
    }
    return null;
  }

  // PlaceHolder image displayed on the watchlist item.
  Widget placeHolderImage(tvSeries) {
    return Expanded(
      flex: 4,
      child: Container(
        child: new ClipRRect(
          borderRadius: new BorderRadius.circular(8.0),
          child: new FadeInImage.assetNetwork(
            image: "${APIData.tvImageUriTv}${tvSeries.thumbnail}",
            placeholder: "assets/placeholder_box.jpg",
            height: 155.0,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget watchlistItemDetails(tvSeries, genres) {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Text(
            tvSeries.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 16.0,
              color: primaryBlue,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 4.0),
          // tvSeries.duration == null
          //     ? Text('Duration : NA',
          //         textAlign: TextAlign.start,
          //         style: TextStyle(
          //             color: Colors.white.withOpacity(0.8), fontSize: 14.0))
          //     : Text('Duration : ${tvSeries.duration} min',
          //         textAlign: TextAlign.start,
          //         style: TextStyle(
          //             color: Colors.white.withOpacity(0.8), fontSize: 14.0)),
          SizedBox(
            height: 10,
          ),
          Text(
            '$genres',
            style: TextStyle(
                color: Color.fromRGBO(72, 163, 198, 1.0),
                fontSize: 12.0,
                fontWeight: FontWeight.w800),
            textAlign: TextAlign.left,
            maxLines: 1,
          ),
          SizedBox(height: 0.0),
          SizedBox(height: 10.0),
          tvSeries.seasons == null
              ? Text('SEASONS: NA',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold))
              : Text(
                  " SEASONS: ${ tvSeries.seasons.toList().length.toString()}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          // tvSeries.released == null
          //     ? Text('RELEASE DATE: NA',
          //         style: TextStyle(
          //             color: Colors.white70,
          //             fontSize: 10.0,
          //             fontWeight: FontWeight.w800))
          //     : Text(
          //         'RELEASE DATE: ${DateFormat('d-MM-y').format(tvSeries.released)}',
          //         style: TextStyle(
          //           color: Colors.white70,
          //           fontSize: 10.0,
          //           fontWeight: FontWeight.w800,
          //         ),
          //       ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     Container(
          //       margin: EdgeInsets.only(right: 5.0),
          //       child: Column(
          //         children: <Widget>[
          //           SizedBox(
          //             height: 20.0,
          //           ),
          //           Text(
          //             'RELEASE DATE:',
          //             style: TextStyle(
          //                 color: Colors.white70,
          //                 fontSize: 10.0,
          //                 fontWeight: FontWeight.w800),
          //           ),
          //           SizedBox(height: 4.0),
          //           Text(
          //             tvSeries.released == null
          //                 ? "NA"
          //                 : DateFormat('d-MM-y').format(tvSeries.released),
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 12.0,
          //               fontWeight: FontWeight.w800,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Expanded(
          //       flex: 3,
          //       child: Column(
          //         children: <Widget>[
          //           SizedBox(
          //             height: 20.0,
          //           ),
          //           Text(
          //             'RUNTIME:',
          //             style: TextStyle(
          //               color: Colors.white70,
          //               fontSize: 10.0,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           SizedBox(height: 4.0),
          //           Text(
          //             tvSeries.duration == null ? "NA" : tvSeries.duration,
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 12.0,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: double.parse("${tvSeries.rating / 2}"),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              SizedBox(
                width: 75.0,
              ),
              IconButton(
                  icon: Icon(
                    CupertinoIcons.delete_simple,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    removeWishList(tvSeries.type, tvSeries.id);
                     Scaffold.of(context).showSnackBar(SnackBar(
                      // backgroundColor: Colors.grey,
                      content: Text('Deleted from wishlist',),
                    duration: Duration(seconds: 1),
                    ));
                  })
            ],
          )
        ],
      ),
    );
  }

  //  Watchlist item all details like image, name,
  Widget watchlistItemContainer(tvSeries, genres) {
    return Container(
      color: Colors.black,
      margin: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.videoDetail,
              arguments: VideoDetailScreen(tvSeries));
        },
        child: Container(
          decoration: new BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              placeHolderImage(tvSeries),
              SizedBox(
                width: 10.0,
                height: 0.0,
              ),
              watchlistItemDetails(tvSeries, genres),
            ],
          ),
        ),
      ),
    );
    
    
  }

  @override
  Widget build(BuildContext context) {
    
    return widget._visible == false
        ? Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : tvWishList.length == 0
            ? BlankWishList()
            : Container(
              height: MediaQuery.of(context).size.height,
                color: Colors.black,
                child: ListView.builder(
                    itemCount: tvWishList.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    itemBuilder: (BuildContext context, int index) {
                      tvWishList[index]
                          .genres
                          .removeWhere((value) => value == null);
                      String genres = tvWishList[index].genres.toString();
                      genres = genres.replaceAll("[", "").replaceAll("]", "");
                      return watchlistItemContainer(tvWishList[index], genres);
                    }),
                    
              );
              
  }
}

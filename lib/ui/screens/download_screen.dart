import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:IQRA/models/datum.dart';
import 'package:IQRA/providers/movie_tv_provider.dart';
import 'package:IQRA/ui/screens/blank_download_list.dart';
import 'package:IQRA/ui/screens/video_detail_screen.dart';
import 'package:IQRA/ui/screens/wishlist_screen.dart';
import 'package:IQRA/ui/widgets/permisson_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/styles.dart';
import 'package:IQRA/models/user_profile_model.dart';
import 'package:IQRA/player/m_player.dart';
import 'package:IQRA/player/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/ui/screens/splash_screen.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/common/global.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:IQRA/services/repository/database_creator.dart';
import 'package:IQRA/services/player/downloaded_video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '/ui/widgets/permisson_handler.dart';
const debug = true;

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key key}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>
    with SingleTickerProviderStateMixin {
  static const _channel = const MethodChannel('vn.hunghd/downloader');
bool _permissionReady;
List<Datum> moviesDownload = [];

void downloadvideos(){
  dynamic index;
   final moviesTvList =
        Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
  return
moviesDownload.add(Datum(thumbnail:moviesTvList[index].thumbnail ));

}
  var videos = [];

  getUrlVideo() async {
    
    videos = await cdb.query(DatabaseCreator.todoTable);
    final tasks = await FlutterDownloader.loadTasks();


    int count = 0;
    _tasks = [];
    _items = [];
    _tasks.addAll(videos.map((video) => _TaskInfo(
        id: video['vtype'] == 'M' ? video['movie_id'] : video['tvseries_id'],
        name: video['name'],
        link: video['info'],
        type: video['vtype'],
        seasonId: video['vtype'] == 'M' ? null : video['season_id'],
        episodeId: video['vtype'] == 'M' ? null : video['episode_id'],
        thumbnail: video['thumb'],
        )));

    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i],thumbnail: _tasks[i].thumbnail));
      count++;
    }

    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _isLoading;
  String _localPath;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
     PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
    super.initState();
_checkPermission().then((value) => _permissionReady == value);
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists)
        this.setState(
            () => fileContent = json.decode(jsonFile.readAsStringSync()));
    });

    _isLoading = true;
    _permissionReady = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<String> getUpdates() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.pushNamed(context, RoutePaths.splashScreen,
            arguments: SplashScreen(
              token: authToken,
            ));
      } else {
        return null;
      }
    } on SocketException catch (e3) {
      Fluttertoast.showToast(msg: "Connect to internet");
      return null;
    } on Exception catch (e4) {
      print("Exception $e4");
      return null;
    }
  }

  Widget placeHolderImage() {
    return
     Container(
      margin: EdgeInsets.only(right: 10),
      height: 100,
      width: 150,
      child: new ClipRRect(
        borderRadius: new BorderRadius.circular(8.0),
         child:
         
         FadeInImage.assetNetwork(
            image: "${APIData.movieImageUri}",
            // ${movies.thumbnail}",
            placeholder: "assets/placeholder_box.jpg",
            height: 155.0,
            // width: 220.0,
            fit: BoxFit.cover,
          ),
        //  Image.asset(
        //   "assets/avenger.jpg",
        //   scale: 1.7,
        //   fit: BoxFit.cover,
        // ),
        // width: 220.0,
      ),
    );
  }

  //  Future<bool> _checkPermission() async {
  //   if (platform == TargetPlatform.android) {
  //     PermissionStatus permission = await PermissionHandler()
  //         .checkPermissionStatus(PermissionGroup.storage);
  //     if (permission != PermissionStatus.granted) {
  //       Map<PermissionGroup, PermissionStatus> permissions =
  //           await PermissionHandler()
  //               .requestPermissions([PermissionGroup.storage]);
  //       if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
  //         return true;
  //       }
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     return true;
  //   }
  //   return false;
  // }
//  Future<bool> _checkPermission() async {
//     if (Platform.isAndroid) {
//       final status = await PermissionHandler().storage.status;
//       if (status != PermissionStatus.granted) {
//         final result = await Permission.storage.request();
//         if (result == PermissionStatus.granted) {
//           return true;
//         }
//       } else {
//         return true;
//       }
//     } else {
//       return true;
//     }
//     return false;
//   }
// Future<bool> _status(){
// Future<PermissionStatus> permissionStatus =  PermissionHandler()
//           .checkPermissionStatus(PermissionGroup.storage);
//         if(permissionStatus != PermissionStatus.granted){
//         Future<Map<PermissionGroup, PermissionStatus>> permissions =
//              PermissionHandler()
//                 .requestPermissions([PermissionGroup.storage]);
//         }
// }
  Future<PermissionStatus> permissionStatus =  PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
         
//Future<Map<PermissionGroup, PermissionStatus>> permissions =
//              PermissionHandler()
//                 .requestPermissions([PermissionGroup.storage]);
                
                Widget _buildNoPermissionWarning() => Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Please grant accessing storage permission to continue -_-',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              FlatButton(
                  onPressed: () {
 PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);

                    // _checkPermission().then((hasGranted) {
                    //   setState(() {
                    //     _permissionReady = hasGranted;
                    //   });
                    // });
                  },
                  child: Text(
                    'Retry',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ))
            ],
          ),
        ),
      );
      TargetPlatform platform;
       Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

   Future<PermissionStatus> permissionStatus1 =  PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  
  @override
  Widget build(BuildContext context) {
     final moviesTvList =
        Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
    getUrlVideo();
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: customAppBar1(context, "Downloaded Videos"),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Colors.white,
      //     child: Icon(
      //       Icons.refresh,
      //       color: Colors.black,
      //       size: 25.0,
      //     ),
      //     onPressed: () {
      //       // getUpdates();
      //     }),
      body: 
      _items.length == 0 ? BlankDownloadList() :
      // permissionReady ?
      Builder(builder: (context) {
        return Container(
            child: _isLoading
                ? new Center(
                    child: new CircularProgressIndicator(),
                  )
                  
                : new Container(
                    color: Colors.black,
                    child: new ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      children: _items.map((item) {
                  //  print("MyId1: ${_items}");
                   print("MyId2: ${item.name}");
                        return item.task == null
                            ? new Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 18.0),
                                ),
                              )
                            : new Container(
                                padding: const EdgeInsets.only(
                                    left: 0.0, right: 8.0, top: 15.0),
                                child: InkWell(
                                  onTap: item.task.status ==
                                          DownloadTaskStatus.complete
                                      ? () {
                                          _openDownloadedFile(item.task);
                                        }
                                      : null,
                                  child: new Stack(
                                    children: <Widget>[
                                      // placeHolderImage(),
                                      new Container(
                                        width: double.infinity,
                                        height: 64.0,
                                        child: new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            new Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 20, bottom: 10),
                                                child: new Text(
                                                  item.name,
                                                
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                      color: primaryBlue),
                                                  maxLines: 1,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            // new Padding(
                                            //   padding: const EdgeInsets.only(
                                            //       left: 8.0),
                                            //   child: _buildActionForTask(
                                            //       item.task),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 45, left: 20),
                                        child: item.task.progress == 100
                                            ? Text(
                                                'Completed',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      72, 163, 198, 1.0),
                                                ),
                                              )
                                            : Text(
                                                'Progress: ${item.task.progress} %'),
                                                
                                      ),
                                      item.task.status ==
                                              DownloadTaskStatus.complete
                                          ? Padding(
                                            padding: const EdgeInsets.only(left: 5),
                                            child: Container(
                                              decoration: BoxDecoration(border: Border.all(color: primaryBlue),borderRadius: BorderRadius.circular(5)),
                                              width:double.infinity,
                                              height: 82,
                                              alignment: Alignment.bottomRight,
                                                // margin: EdgeInsets.only(
                                                //     top: 35, left: 320),
                                                child: _buildActionForTask(
                                                    item.task),
                                              ),
                                          )
                                          : Padding(

                                            padding: const EdgeInsets.only(left: 5),
                                            child: Container(
                                               decoration: BoxDecoration(border: Border.all(color: primaryBlue),borderRadius: BorderRadius.circular(5)),

                                               width:double.infinity,
                                              height: 82,
                                              alignment: Alignment(1,0.3),

                                                // margin: EdgeInsets.only(
                                                //     top: 35, left: 350),
                                                child: _buildActionForTask(
                                                      item.task),
                                                
                                              ),
                                          ),
                                      item.task.status ==
                                                  DownloadTaskStatus.running ||
                                              item.task.status ==
                                                  DownloadTaskStatus.paused
                                          ? new Positioned(
                                              left: 20.0,
                                              right: 8.0,
                                              bottom: 10.0,
                                              child:
                                                  new LinearProgressIndicator(
                                                value: item.task.progress / 100,
                                              ),
                                            )
                                          : new Container()
                                    ].where((child) => child != null).toList(),
                                  ),
                                ),
                              );
                      }).toList(),
                    ),
                  ));
      }
      ) 
//       :  Container(
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Text(
//                   'Please grant accessing storage permission to continue -_-',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
//                 ),
//               ),
//               SizedBox(
//                 height: 32.0,
//               ),
//               FlatButton(
//                   onPressed: () {
//  PermissionHandler()
//                 .requestPermissions([PermissionGroup.storage]);

//                     _checkPermission().then((hasGranted) {
//                       setState(() {
//                         _permissionReady = hasGranted;
//                       });
//                     });
//                   },
//                   child: Text(
//                     'Retry',
//                     style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20.0),
//                   ))
//             ],
//           ),
//         ),
//       )
      );
     
  }

  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return new RawMaterialButton(
        onPressed: () {
          _requestDownload(task);
        },
        child: new Icon(Icons.file_download),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return new RawMaterialButton(
        onPressed: () {
          _pauseDownload(task);
        },
        child: new Icon(
          Icons.pause_circle_outline,
          color: Colors.red,
          size: 40,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return new RawMaterialButton(
        onPressed: () {
          _resumeDownload(task);
        },
        child: new Icon(
          Icons.play_circle_outline,
          size: 40,
          color: Color.fromRGBO(72, 163, 198, 1.0),
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            CupertinoIcons.play_circle_fill,
            color: Color.fromRGBO(72, 163, 198, 1.0),
            size: 35.0,
          ),
          RawMaterialButton(
            onPressed: () {
_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Deleted From Downloads'),
duration: Duration(seconds: 1),
));
              _delete(task);
              print(_delete);
              // deleteFile(File(_localPath));
            },
            child: Icon(
              CupertinoIcons.delete_simple,
              color: Colors.red,
              size: 28.0,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return new Text('Canceled', style: new TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
           IconButton(onPressed: (){
             _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Deleted From Downloads'),
duration: Duration(seconds: 1),
));
              _delete(task);
              print(_delete);
           }, icon: Icon( CupertinoIcons.delete_simple,color: Colors.red,) ),

          new Text('Failed', style: new TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              _retryDownload(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else {
      return null;
    }
  }

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    var fileNamenew = task.link.split('/').last;
    print(task.link);
    print("$localPath/$fileNamenew");
    // "$localPath/$fileNamenew"
    // var router = new MaterialPageRoute(
    //   builder: (BuildContext context) =>
    //       PlayerMovie(id: widget.videoDetail.id, type: widget.videoDetail.type),
    // );
    // Navigator.of(context).push(router);

    var router = new MaterialPageRoute(
        builder: (BuildContext context) => DownloadedVideoPlayer(
              taskId: task.taskId,
              name: task.name,
              fileName: fileNamenew,
              downloadStatus: 0,
            
            ));
    Navigator.of(context).push(router);
    return null;
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();

    var raw = await task.type == 'M'
        ? cdb.delete(
            DatabaseCreator.todoTable,
            where: "movie_id = ? AND vtype = ?",
            whereArgs: [task.id, task.type],
          )
        : cdb.delete(DatabaseCreator.todoTable,
            where:
                "tvseries_id = ? AND vtype = ? AND season_id = ? AND episode_id = ?",
            whereArgs: [task.id, task.type, task.seasonId, task.episodeId]);
    // setState(() {});
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    _tasks.addAll(videos
        .map((video) => _TaskInfo(name: video['name'], link: video['info'],thumbnail: video['thumb'])));

    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i],thumbnail: _tasks[i].thumbnail));
      count++;
    }

    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });
 _permissionReady = await _checkPermission();
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }
Future<void> deleteFile(File file) async {
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    // Error in getting access to the file.
  }
}

  Future<String> _findLocalPath() async {
    // final platform = Theme.of(context).platform;
    final directory = 
    //  platform == TargetPlatform.android ?
         await getExternalStorageDirectory() ;
        // : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

class _TaskInfo {
  final String id;
  final String name;
  final String link;
  final String type;
  final String seasonId;
  final String episodeId;
  final String thumbnail;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo(
      {this.id,
      this.name,
      this.link,
      this.type,
      this.seasonId,
      this.episodeId,
      this.thumbnail});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;
  final String thumbnail;

  _ItemHolder({this.name, this.task,this.thumbnail});
}

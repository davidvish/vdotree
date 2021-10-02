import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:IQRA/custom_player/src/chewie_player.dart';
import 'package:IQRA/custom_player/src/chewie_progress_colors.dart';
import 'package:IQRA/custom_player/src/material_progress_bar.dart';
import 'package:IQRA/custom_player/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class MyNewControls extends StatefulWidget {
  const MyNewControls(
      {Key key, this.title, this.downloadStatus, this.chewieController})
      : super(key: key);
  final title;
  final downloadStatus;
  final ChewieController chewieController;
  @override
  State<StatefulWidget> createState() {
    return _MyNewControlsState();
  }
}

class _MyNewControlsState extends State<MyNewControls> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = true;
  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;
  bool bufffer = false;
  final barHeight = 48.0;
  final marginSize = 5.0;
  var position = const Duration();
  Duration duration;
  VideoPlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(_latestVolume);
  }

  @override
  Widget build(BuildContext context) {
    if (_latestValue != null && _latestValue.hasError) {
      return widget.chewieController.errorBuilder != null
          ? widget.chewieController.errorBuilder(
              context,
              widget.chewieController.videoPlayerController.value
                  .errorDescription,
            )
          : Center(
              child: Icon(
                Icons.error,
                color: Colors.white,
                size: 42,
              ),
            );
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: GestureDetector(
        onTap: () => _cancelAndRestartTimer(),
        child: AbsorbPointer(
            absorbing: _hideStuff,
            child: Container(
              color:
                  _hideStuff ? Colors.transparent : Colors.black.withAlpha(30),
              child: Column(
                children: <Widget>[
                  _buildTopBar(context),
                  _latestValue != null &&
                              !_latestValue.isPlaying &&
                              _latestValue.duration == null ||
                          controller.value.isBuffering
                      ? const Expanded(
                          child: const Center(
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : _buildHitArea(),
                  _buildBottomBar(context),
                ],
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = widget.chewieController;

    // chewieController = ChewieController.of(context);
    controller = widget.chewieController.videoPlayerController;

    if (_oldController != widget.chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
  ) {
//    final iconColor = Theme.of(context).textTheme.button.color;

    return AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Stack(
          children: <Widget>[
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.0, 0.3, 0.6, 1.0],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.35),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
              child: Row(
                children: <Widget>[
                  _buildPlayPause(controller),
                  widget.chewieController.isLive
                      ? Expanded(child: const Text('LIVE'))
                      : _buildPosition(),
                  widget.chewieController.isLive
                      ? const SizedBox()
                      : _buildProgressBar(),
                  widget.chewieController.isLive
                      ? Expanded(child: const Text('LIVE'))
                      : _buildDuration(),
                  widget.chewieController.allowMuting
                      ? _buildMuteButton(controller)
                      : Container(),
                  widget.chewieController.allowFullScreen
                      ? _buildExpandButton()
                      : Container(),
                ],
              ),
            ),
          ],
        ));
  }

  AnimatedOpacity _buildTopBar(
    BuildContext context,
  ) {
    return AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Stack(
          children: <Widget>[
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.0, 0.3, 0.6, 1.0],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.35),
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
              child: Row(
                children: <Widget>[
                  _buildCloseBack(),
                  _buildTitle(),
//                  Text("fgkek"),
                ],
              ),
            ),
          ],
        ));
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: EdgeInsets.only(right: 12.0),
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: Icon(
              widget.chewieController.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildHitArea() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (controller.value.isPlaying) {
            if (_displayTapped) {
              setState(() {
                _hideStuff = true;
              });
            } else
              _cancelAndRestartTimer();
          } else {
//            _playPause();

            setState(() {
              _hideStuff = true;
            });
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: AnimatedOpacity(
              opacity: _hideStuff ? 0.0 : 1.0,
//              opacity:
//                  _latestValue != null && !_latestValue.isPlaying && !_dragging
//                      ? 1.0
//                      : 0.0,
              duration: Duration(milliseconds: 300),
              child: GestureDetector(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
//                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(48.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: _buildSkipBack(Colors.white, barHeight),
                      ),
                    ),

                    SizedBox(
                      width: 15.0,
                    ),

//                    _buildPlay(controller),

                    Container(
                      decoration: BoxDecoration(
//                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(48.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: _buildPlay(controller),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
//                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(48.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: _buildSkipForward(Colors.white, barHeight),
                      ),
                    ),
//                    _buildSkipForward(Colors.black87, barHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildSkipBack(Color iconColor, double barHeight) {
    return GestureDetector(
      onTap: _skipBack,
      child: Container(
//        height: barHeight,
          color: Colors.transparent,
//        margin: EdgeInsets.only(left: 10.0),
//        padding: EdgeInsets.only(
//          left: 6.0,
//          right: 6.0,
//        ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Icon(
                  Icons.timer_10,
                  size: 11.0,
                  color: iconColor,
                ),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.skewY(0.0)
                  ..rotateX(math.pi)
                  ..rotateZ(math.pi),
                child: Icon(
                  OpenIconicIcons.reload,
                  color: iconColor,
                  size: 25.0,
                ),
              ),
            ],
          )),
    );
  }

  void _skipBack() {
    _cancelAndRestartTimer();
    final beginning = Duration(seconds: 0).inMilliseconds;
    final skip =
        (controller.value.position - Duration(seconds: 10)).inMilliseconds;
    controller.seekTo(Duration(milliseconds: math.max(skip, beginning)));
  }

  GestureDetector _buildSkipForward(Color iconColor, double barHeight) {
    return GestureDetector(
      onTap: _skipForward,
      child: Container(
//        height: barHeight,
          color: Colors.transparent,
//        padding: EdgeInsets.only(
//          left: 6.0,
//          right: 8.0,
//        ),
//        margin: EdgeInsets.only(
//          right: 8.0,
//        ),
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Icon(
                Icons.timer_10,
                size: 11.0,
                color: iconColor,
              ),
            ),
            Icon(
              OpenIconicIcons.reload,
              color: iconColor,
              size: 25.0,
            ),
          ])),
    );
  }

  GestureDetector _buildPlay(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 3.0, right: 4.0),
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }

  void _skipForward() {
    _cancelAndRestartTimer();
    final end = controller.value.duration.inMilliseconds;
    final skip =
        (controller.value.position + Duration(seconds: 10)).inMilliseconds;
    controller.seekTo(Duration(milliseconds: math.min(skip, end)));
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();
        _latestVolume = controller.value.volume;
        if (_latestVolume == 0) {
          controller.setVolume(0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            child: Container(
              height: barHeight,
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Icon(
                (controller.value.volume > 0)
                    ? Icons.volume_up
                    : Icons.volume_off,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 3.0, right: 4.0),
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }

  GestureDetector _buildCloseBack() {
    return GestureDetector(
      onTap: _closePlayer,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 3.0, right: 4.0),
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  void _closePlayer() {
    bool isFinished = controller.value.position >= controller.value.duration;
    setState(() {
      if (controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.initialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(Duration(seconds: 0));
          }
          controller.play();
        }
      }
    });
    Navigator.pop(context);
  }

  Widget _buildPosition() {
    final position = controller.value.position;
    final duration = controller.value.duration;

    return Padding(
      padding: EdgeInsets.only(right: 24.0),
      child: Text(
        '${formatDuration(position)}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
    );
  }

  Widget _buildDuration() {
    final duration = const Duration();
    // final duration = controller.value.duration;

    return Padding(
      padding: EdgeInsets.only(right: 24.0),
      child:
       Text(
        '${formatDuration(duration)}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(right: 24.0),
      child: playerTitle == null
          ? SizedBox.shrink()
          : Text(
              '$playerTitle',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<Null> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if ((controller.value != null && controller.value.isPlaying) ||
        widget.chewieController.autoPlay) {
      _startHideTimer();
    }

    if (widget.chewieController.showControlsOnInitialize) {
      _initTimer = Timer(Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      widget.chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    bool isFinished = false;

    setState(() {
      if (controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.initialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(Duration(seconds: 0));
          }
          controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: MaterialVideoProgressBar(
          controller,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: widget.chewieController.materialProgressColors ??
              ChewieProgressColors(
                  playedColor: Theme.of(context).accentColor,
                  handleColor: Theme.of(context).accentColor,
                  bufferedColor: Theme.of(context).backgroundColor,
                  backgroundColor: Theme.of(context).disabledColor),
        ),
      ),
    );
  }
}

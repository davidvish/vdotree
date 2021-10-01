import 'dart:ui';
import 'package:IQRA/custom_player/src/chewie_player.dart';
import 'package:IQRA/custom_player/src/cupertino_controls.dart';
import 'package:IQRA/custom_player/src/material_controls.dart';
import 'package:IQRA/custom_player/src/my_new_controls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SaifPlayerWithNewControls extends StatefulWidget {
  SaifPlayerWithNewControls(
      {Key key, this.title, this.downloadStatus, this.controller})
      : super(key: key);
  final title;
  final downloadStatus;
  final ChewieController controller;
  @override
  State<StatefulWidget> createState() {
    return _SaifPlayerWithNewControlsState();
  }
}

class _SaifPlayerWithNewControlsState extends State<SaifPlayerWithNewControls> {
  bool zoom = false;
  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final ChewieController chewieController = ChewieController.of(context);
    var r = widget.controller.videoPlayerController.value.aspectRatio;
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio:
              widget.controller.aspectRatio ?? _calculateAspectRatio(context),
          child: _buildSaifPlayerWithNewControls(
              r, w, h, currentOrientation, chewieController, context),
        ),
      ),
    );
  }

  GestureDetector _buildSaifPlayerWithNewControls(r, w, h, currentOrientation,
      ChewieController chewieController, BuildContext context) {
    print(currentOrientation);
    return GestureDetector(
      onDoubleTap: () {
        print(zoom);
        if (zoom == true) {
          setState(() {
            zoom = false;
          });
        } else {
          setState(() {
            zoom = true;
          });
        }
      },
      child: Container(
        child: Stack(
          children: <Widget>[
            widget.controller.placeholder ?? Container(),
            Center(
              child: AspectRatio(
                aspectRatio: zoom == true
                    ? currentOrientation == Orientation.portrait
                        ? widget.controller.aspectRatio ??
                            _calculateAspectRatio(context)
                        : w / h
                    : r,
                // chewieController.aspectRatio ??
                //     _calculateAspectRatio(context),
                child: VideoPlayer(widget.controller.videoPlayerController),
              ),
            ),
            widget.controller.overlay ?? Container(),
            _buildControls(context, widget.controller),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    ChewieController chewieController,
  ) {
    return MyNewControls(
        title: widget.title,
        downloadStatus: widget.downloadStatus,
        chewieController: chewieController);
  }

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }
}

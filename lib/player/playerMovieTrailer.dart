import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlayerMovieTrailer extends StatefulWidget {
  PlayerMovieTrailer({this.id, this.type});
  final int id;
  final type;
  @override
  _PlayerMovieTrailerState createState() => _PlayerMovieTrailerState();
}

class _PlayerMovieTrailerState extends State<PlayerMovieTrailer>
    with WidgetsBindingObserver {
  WebViewController _controller1;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight
    // ]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        print("1000");
        _controller1?.reload();
//        Navigator.pop(context);
        break;
      case AppLifecycleState.paused:
        print("1001");
        _controller1?.reload();
//        Navigator.pop(context);
        break;
      case AppLifecycleState.resumed:
        print("1003");
//        Navigator.pop(context);
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height,
          child:
           WebView(
            initialUrl: APIData.trailerPlayer +
                '${userDetails.user.id}/${userDetails.code}/${widget.id}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller1 = webViewController;
            },
          ),
        ),
        Positioned(
          top: 26.0,
          left: 4.0,
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                _controller1?.reload();
                Navigator.pop(context);
              }),
        )
      ],
    ));
  }
}

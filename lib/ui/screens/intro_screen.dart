import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:provider/provider.dart';
import 'login_home.dart';
import 'package:IQRA/common/styles.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();
  Function goToTab;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
 final blocks = context.read<AppConfig>().slides;
 List.generate(1, (i) {
    slides.add(
      new Slide(
        title: "Welcome! Join VDOTREE",
        description:
            "Join VDOTREE to watch the most recent motion picture , elite TV appears and grant winning VDOTREE membership at simply least cost.",
        styleTitle: TextStyle(
          color: Color(0xff3da4ab),
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          // fontFamily: 'RobotoMono'
        ),
        pathImage: "${APIData.landingPageImageUri}${blocks[i].image}",
      ),
    );});
     List.generate(1, (int i) {
    slides.add(
      new Slide(
        title: "Dont't Miss TvShows",
        description:
            "With your VDOTREE membership,you app approch select US and all TV shows,grant winning VDOTREE  Original Series and Kids and children shows.",
        styleTitle: TextStyle(
          color: Color(0xff3da4ab),
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          // fontFamily: 'RobotoMono'
        ),
        pathImage:  "${APIData.landingPageImageUri}${blocks[2].image}",
      ),

    );});
       List.generate(1, (i) {
    slides.add(
      new Slide(
        title: "Membership for Movies & TV shows",
        description:
            "Notwithstanding boundless gushing,your VDOTREE membership incorporates elite Bollywood,Hollywood films,US and all TV shows,grant winning VDOTREE Series and Kids......",
        styleTitle: TextStyle(
          color: Color(0xff3da4ab),
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          // fontFamily: 'RobotoMono'
        ),
        // backgroundImage: "assets/images/intro3.jpg",

        pathImage:  "${APIData.landingPageImageUri}${blocks[1].image}",
      ),
    );});
    //  slides.add(
    //   new Slide(
    //     title: "COFFEE SHOP",
    //     styleTitle: TextStyle(
    //       color: Color(0xff3da4ab),
    //       fontSize: 30.0,
    //       fontWeight: FontWeight.bold,
    //       // fontFamily: 'RobotoMono'
    //     ),
    //     // backgroundImage: "assets/images/intro3.jpg",

    //     pathImage: "assets/intro4.png",
    //   ),
    // );
  }
  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     isLoading = true;
  //   });
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     final blocks = context.read<AppConfig>().slides;
  //     List.generate(
  //         blocks == null ? 0 : blocks.length,
  //         (int i) {
  //       return slides.add(
  //         new Slide(
  //           title: "${blocks[i].heading}",
  //           styleTitle: TextStyle(
  //               color: Color.fromRGBO(72, 163, 198, 1.0),
  //               fontSize: 30.0,
  //               fontWeight: FontWeight.bold,
  //               fontFamily: 'RobotoMono'),
  //           description: "${blocks[i].detail}",
  //           styleDescription: TextStyle(
  //               color: Colors.white,
  //               fontSize: 20.0,
  //               fontStyle: FontStyle.italic,
  //               fontFamily: 'Raleway'),
  //           pathImage:
  //               "${APIData.landingPageImageUri}${blocks[i].image}",
  //         ),
  //       );
  //     });
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }

//  WillPopScope to handle back press.
  Future<bool> onWillPopS() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
//      flutterToast.showToast(child: Text("Press again to exit."));
      return Future.value(false);
    }
    return SystemNavigator.pop();
  }

//  After done pressed on intro slider
  void onDonePress() {
    // Back to the first tab
    Navigator.pushNamed(context, RoutePaths.loginHome);
  }

//  Counting index and changing UI page dynamically.
  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

//  Next button
  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: primaryBlue,
      size: 35.0,
    );
  }

//  Done button or last page of intro slider
  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: primaryBlue,
    );
  }

//  Skip button to go directly on last page of intro slider
  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: primaryBlue,
    );
  }

  // int i;
  // List<Widget> renderListCustomTabs() {
  //   List<Widget> tabs = new List();
  //   for (i = 0; i < slides.length; i++) {
  //     Slide currentSlide = slides[i];
  //     tabs.add(Container(
  //       width: double.infinity,
  //       height: double.infinity,
  //       child: Container(
  //         // margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
  //         child: ListView(
  //           children: <Widget>[
  //             Container(
  //                 width: MediaQuery.of(context).size.width * 1,
  //                 height: MediaQuery.of(context).size.height * 1,
  //                 color: Colors.black,
  //               child: GestureDetector(
  //                   child: Image.asset(
  //                 currentSlide.pathImage,
  //                 width: MediaQuery.of(context).size.width * 1,
  //                 height: MediaQuery.of(context).size.height * 1,
  //                 fit: BoxFit.fill,
  //               )),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ));
  //   }
  //   return tabs;
  // }
//  Custom tabs
  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          // margin: EdgeInsets.only(bottom: 00.0, top: 0.0),
          child: Center(
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  // width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * .92,
                  decoration: new BoxDecoration(
                    color:
                        Theme.of(context).primaryColorLight.withOpacity(0.48),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(0.0),
                        bottomLeft: Radius.circular(0.0)),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black87.withOpacity(0.6),
                        blurRadius: 20.0,
                        offset: new Offset(0.0, 5.0),
                      ),
                    ],
                  

                    image: new DecorationImage(
                      
                      // image: AssetImage(
                      //   currentSlide.pathImage,
                        

                      //   // width: MediaQuery.of(context).size.width * 1,
                      //   //                 height: MediaQuery.of(context).size.height * 1,
                      //   //                 fit: BoxFit.fill,
                      // ),
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.8), BlendMode.dstATop),
                      image: currentSlide.pathImage == null ? AssetImage('ewq')  :new NetworkImage(currentSlide.pathImage),
                    ),
                  ),
                ),
                Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black,Colors.transparent])),),
                                Container(
                  alignment: Alignment.center,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Container(
                          child: Text(
                            currentSlide.title,
                            style: TextStyle(
                                fontSize: 30,
                                color: primaryBlue,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          child: Text(
                            currentSlide.description,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            // overflow: TextOverflow.ellipsis,
                          ),
                          margin: EdgeInsets.only(top: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return tabs;
  }
Image asset = Image.asset('');
// Intro slider
  Widget introSlider() {
    return IntroSlider(
      // List slides
      slides: this.slides,
      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color.fromRGBO(72, 163, 198, 0.3),
      highlightColorSkipBtn: Color.fromRGBO(72, 163, 198, 1.0),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,

      colorDoneBtn: Color.fromRGBO(72, 163, 198, 0.3),
      highlightColorDoneBtn: Color.fromRGBO(72, 163, 198, 1.0),

      // Dot indicator
      colorDot: primaryBlue,
      sizeDot: 10.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Colors.black,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Show or hide status bar
      // shouldHideStatusBar: false,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : introSlider(),
      ),
      onWillPop: onWillPopS,
    );
  }
}

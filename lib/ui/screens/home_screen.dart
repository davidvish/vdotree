import 'package:IQRA/common/styles.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:IQRA/providers/menu_provider.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:IQRA/ui/shared/back_press.dart';
import 'package:IQRA/ui/screens/video_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:IQRA/common/apipath.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollViewController;
  TabController tabController;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  TargetPlatform platform;
  bool notificationPermission;

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      PermissionStatus permission = await Permission.notification.status;
      if (permission != PermissionStatus.granted) {
        Permission.notification.request();
        if (await Permission.notification.status == PermissionStatus.granted) {
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

  getPermission() async {
    notificationPermission = await _checkPermission();
  }

  @override
  void initState() {
    super.initState();
    getPermission();
    _firebaseMessaging.getToken().then((value) => print("Token: $value"));
    // _firebaseMessaging.configure(
    //     onMessage: (Map<String, dynamic> message) async {},
    //     onResume: (Map<String, dynamic> message) async {},
    //     onLaunch: (Map<String, dynamic> message) async {
    //       Navigator.pushNamed(context, RoutePaths.notifications);
    //     });
    _scrollViewController = new ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final menus = Provider.of<MenuProvider>(context, listen: false);
      tabController = TabController(
        vsync: this,
        length: menus.menuList.length, 
        initialIndex: 0,
      );
    });
  }

  //  When menu length is 0.
  Widget safeAreaMenuNull() {
    return SafeArea(
      child: Scaffold(body: scaffoldBodyMenuNull()),
    );
  }

  //  Scaffold body when menu length is 0.
  Widget scaffoldBodyMenuNull() {
    return Center(
      child: Text("No data Available"),
    );
  }

  //  Sliver app bar

  final LinearGradient gradient = LinearGradient(colors: [primaryBlue,Colors.deepOrange,Colors.purple]);
  Widget _sliverAppBar(innerBoxIsScrolled, myModel, menus) {
    var logo =
        Provider.of<AppConfig>(context, listen: false).appModel.config.logo;
           bool type = false;
    return Container(
     
      child:
       SliverAppBar(
        elevation: 10.0,
        
        // title: Padding(
        //   padding: const EdgeInsets.only(top: 10),
        //   child: Container(
        //     height: 50,
        //     child: Image.asset("assets/logo.png"),
        //     // child: Image.network(
        //     //   '${APIData.logoImageUri}$logo',
        //     //   scale: 1.4,
        //     // ),
        //   ),
        // ),
        backgroundColor: Colors.black38,
        pinned: true,
        // floating: true,
        forceElevated: innerBoxIsScrolled,
        automaticallyImplyLeading: false,
        
        // actions: [
        //   Container(
        //     // color: Colors.red,
        //     child: IconButton(
        //         icon: Icon(
        //           Icons.notifications,
        //           size: 20,
        //         ),
        //         splashRadius: 22,
        //         onPressed: () {
        //           Navigator.pushNamed(context, RoutePaths.notifications);
        //         }),
        //   )
        // ],

//   Tabs used on home page
        title:
        
        
         Row(
           children: <Widget> [
              Expanded(
            flex: type == true ? 1 : 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 20,
                margin: type == true
                    ? EdgeInsets.only(left: 15.0, right: 15.0)
                    : EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Container(
                      
                      child: ShaderMask(
                        shaderCallback: (Rect rect){
                          return gradient.createShader(rect);
                        },
                        child: Text('VDOTREE',style: TextStyle(fontSize: 15.5),)))
                // child: Image.network(
                //   '${APIData.logoImageUri}$logo',
                //   scale: type == true ? 1.8 : 1.9,
                //   errorBuilder: (context, error, stackTrace) {
                //     return Image.asset(
                //       "assets/logo.png",
                    
                //     );
                //   },
                // ),
              ),
            ),
          ),
             Expanded(
               flex: type == true ? 4 : 5,

               child: Align(
                 alignment: Alignment.centerLeft,
             
                 child: TabBar(
                  
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: primaryBlue,
               //        controller: tabController,
                  isScrollable: true,
                  tabs: List<Tab>.generate(
                    menus.menuList.length,
                    (int index) {
                      return Tab(
                      
                        child: new Container(
                          
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Row(
                            children: <Widget> [
               
               // Image.asset("assets/logo.png"),
                              new Text(
                                // "saad",
                                '${menus.menuList[index].name}',
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.9,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    
                    },
                  ),
                       ),
               ),
             ),
            //  IconButton(onPressed: (){
            //    Navigator.pushNamed(context, RoutePaths.notifications);
            //  }, icon: Icon(Icons.notifications))
           ],
         ),
      ),
    );
  }

//  Scaffold body
  Widget _scaffoldBody(myModel, menus) {
    return NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          _sliverAppBar(innerBoxIsScrolled, myModel, menus),
        ];
      },
      body: TabBarView(
        children: List<Widget>.generate(menus.menuList.length, (int index) {
          menuId = menus.menuList[index].id;
          return VideosPage(
            menuId: menuId,
          );
        }),
      ),
    );
  }

  //  When menu length is not 0
  Widget safeArea(myModel, menus) {
    return SafeArea(
      child: WillPopScope(
          child: DefaultTabController(
            length: menus.menuList == null ? 0 : menus.menuList.length,
            child: Scaffold(
              key: _scaffoldKey,
              body: _scaffoldBody(myModel, menus),
            ),
          ),
          onWillPop: OnBackPress.onWillPopS),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<UserProfileProvider>(context, listen: false);
    final menus = Provider.of<MenuProvider>(context, listen: false);
    final myModel = Provider.of<AppConfig>(context, listen: false);
    return safeArea(myModel, menus);
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    tabController.dispose();
    super.dispose();
  }
}

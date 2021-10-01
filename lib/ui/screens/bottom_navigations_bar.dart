import 'package:IQRA/ui/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/styles.dart';
import 'home_screen.dart';
import 'menu_screen.dart';
import 'download_screen.dart';
import 'search_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({this.pageInd});
  final pageInd;

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(),
    WishListScreen(),
    DownloadScreen(),
    // NewScreen(),
    MenuScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageInd != null ? widget.pageInd : 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            // selectedIconTheme: Colors.yellow[700],
            unselectedIconTheme: Theme.of(context).iconTheme,
            selectedItemColor: (_selectedIndex == 0)
                ? Color.fromRGBO(14, 121, 191, 1)
                : (_selectedIndex == 1)
                    ? Color.fromRGBO(62, 240, 112, 1)
                    : (_selectedIndex == 2)
                        ? Color.fromRGBO(255, 2, 2, 1)
                        : (_selectedIndex == 3)
                            ? Color.fromRGBO(253, 243, 8, 1)
                            : Color.fromRGBO(255, 206, 0, 1),
            unselectedItemColor: Theme.of(context).hintColor,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  title: Text("Home"), icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  title: Text("Search"), icon: Icon(Icons.search)),
              BottomNavigationBarItem(
                  title: Text("Wishlist"), icon: Icon(Icons.favorite_border)),
              BottomNavigationBarItem(
                  title: Text("Download"), icon: Icon(Icons.file_download)),
              BottomNavigationBarItem(
                  title: Text('Menu'), icon: Icon(Icons.menu)),
            ],
            currentIndex: _selectedIndex,
            unselectedLabelStyle: TextStyle(color: Colors.white),
            onTap: _onItemTapped,
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          )),
      onWillPop: onWillPopS,
    );
  }
}

// Handle back press to exit
Future<bool> onWillPopS() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: "Press again to exit.");
    return Future.value(false);
  }
  return SystemNavigator.pop();
}

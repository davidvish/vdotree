import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/common/styles.dart';
import 'package:IQRA/providers/notifications_provider.dart';
import 'package:IQRA/ui/screens/notification_detail_screen.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        NotificationsProvider notificationsProvider =
            Provider.of<NotificationsProvider>(context, listen: false);
        await notificationsProvider.fetchNotifications();
        if (mounted) {
          setState(() {
            _visible = true;
          });
        }
      } catch (err) {
        return null;
      }
    });
  }

  Widget notificationIconContainer() {
    return Container(
      child: Icon(
        Icons.notifications,
        size: 100.0,
        color: Colors.white60,
      ),
    );
  }

//  Message when any notification is not available
  Widget message() {
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      child: Text(
        "You don't have any notification.",
        style: TextStyle(height: 1.5, color: Colors.white60, fontSize: 18.0),
      ),
    );
  }

//  When don't have any notification.
  Widget blankNotification() {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
          ),
          notificationIconContainer(),
          SizedBox(
            height: 25.0,
          ),
          message(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var notifications =
        Provider.of<NotificationsProvider>(context).notificationsList;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppBar(context, "Notifications"),
      body: _visible == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : notifications.length == 0
              ? blankNotification()
              : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          // color: Colors.black,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    height: 80,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius:
                                            BorderRadius.circular(60)),
                                    child: Icon(
                                      Icons.notifications,
                                      size: 25,
                                      color: primaryBlue,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${notifications[index].title}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700),
                                ),
                                subtitle: Text(
                                  "${notifications[index].data.data}",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey[400]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePaths.notificationDetail,
                                      arguments: NotificationDetailScreen(
                                          notifications[index].title,
                                          notifications[index].data.data));
                                },
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                color: Colors.grey[800],
                                height: 2,
                              ),
                            ],
                          ),
                        );
                      }),
                ),
    );
  }
}

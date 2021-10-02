import 'package:flutter/material.dart';
import 'package:IQRA/ui/shared/appbar.dart';

class NotificationDetailScreen extends StatefulWidget {
  NotificationDetailScreen(
    this.title,
    this.message,
  );
  final String title;
  final String message;
  @override
  _NotificationDetailScreenState createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Notification"),
      body: SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Container(
            color: Colors.black,
            child: Column(
              children: [
                Text(
                  "${widget.title}",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "${widget.message}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

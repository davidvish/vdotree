import 'package:IQRA/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

// Share tab
class SharePage extends StatelessWidget {
  SharePage(this.shareType, this.shareId);
  final shareType;
  final shareId;

  Widget shareText() {
    return Text(
      "Share",
      style: TextStyle(
          fontFamily: 'Lato',
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
          color: Colors.white
          // color: Colors.white
          ),
    );
  }

  Widget shareTabColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.share,
          size: 25.0,
          color: Colors.white,
        ),
        new Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 10.0),
        ),
        shareText(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .31,
        height: 50,
        child: Material(
          child: new FlatButton(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: primaryBlue)),
            onPressed: () {
              Share.share('$shareType' + '$shareId');
            },
            child: shareTabColumn(),
          ),
          color: Colors.transparent,
        ));
  }
}

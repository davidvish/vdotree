import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:IQRA/models/user_profile_model.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/ui/shared/blank_history.dart';
import 'package:IQRA/ui/shared/seperator2.dart';
import 'package:provider/provider.dart';

class OtherHistoryScreen extends StatefulWidget {
  @override
  _OtherHistoryScreenState createState() => _OtherHistoryScreenState();
}

class _OtherHistoryScreenState extends State<OtherHistoryScreen> {

  List<Paypal> itemList;


@override
  void dispose() {
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]
  );
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._historyList();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  

//  Subscription start date and end date
  Widget subscriptionFromTo(planDetails) {
    print("SS: ${planDetails.subscriptionTo == null}");
    return Container(
      child: planDetails.subscriptionTo == null
          ? Text('')
          : Text(
              DateFormat('d MMM, y').format(planDetails.subscriptionFrom),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
    );
  }

//    Payment amount
  Widget amount(planDetails) {
    return planDetails.plan == null
        ? Container(
            child: Text(
              'Free',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600),
            ),
          )
        : Container(
            child: planDetails.plan.currency != null
                ? Text(
                    "${planDetails.plan.currency}" +
                        ' ' +
                        "${planDetails.price}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  )
                : Text(
                    "${planDetails.plan.currency}" +
                        ' ' +
                        planDetails.price.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
          );
  }

//   Payment created date
  Widget createdDate(planDetails) {
    return Expanded(
      flex: 2,
      child: Text(
        "${planDetails.createdAt}",
        style: TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }

//    Row transaction id
  Widget transactionId(planDetails) {
    return Expanded(
      child: Text(
        'Transaction ID: ' + planDetails.paymentId,
        style: TextStyle(color: Colors.white, fontSize: 14.0, height: 1.3),
      ),
    );
  }

//    Row plan name
  Widget planNameRow(planDetails) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0),
        ),
        Expanded(
            child: planDetails.plan == null
                ? Text(
                    'Free Trial',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 0, 1.0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                  )
                : Text(
                    planDetails.plan.name.toString().toUpperCase(),
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 0, 1.0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                  )),
      ],
    );
  }

//    Row separator
  Widget rowSeparator() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
          child: Container(
              margin: new EdgeInsets.symmetric(vertical: 0.0),
              height: 2.0,
              width: 364.0,
              color: Colors.black),
        ),
      ],
    );
  }

//    Row created date
  Widget rowCreatedDate(planDetails) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Transaction Date",
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              DateFormat.yMd().add_jm().format(planDetails.createdAt),
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionMethod(planDetails) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Transaction Method",
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${planDetails.method}",
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionAmount(planDetails) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Amount",
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
          Expanded(
            flex: 2,
            child: amount(planDetails),
          ),
        ],
      ),
    );
  }

  Widget paymentDetails(planDetails) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 50,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  "Price",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 50, top: 15, bottom: 10),
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: amount(planDetails),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 50,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10, top: 20),
                child: Text(
                  "Started On",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, top: 15, bottom: 10),
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: subscriptionFromTo(planDetails),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 50,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  "Ended On",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, top: 15, bottom: 10),
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    DateFormat("d MMM, y").format(planDetails.subscriptionTo),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//    Row transaction id
  Widget rowTransactionId(i) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
          ),
          transactionId(i),
        ],
      ),
    );
  }

// Theme.of(context).cardColor
//   Cards that display history
  Widget historyCard(planDetails) {
    return Card(
      color: Colors.white10,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 14.0 / 6.5,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                ),
                planNameRow(planDetails),
                rowTransactionId(planDetails),
                rowSeparator(),
                // rowCreatedDate(planDetails),
                // transactionMethod(planDetails),
                // transactionAmount(planDetails),
                paymentDetails(planDetails),
              ],
            ),
          ),
        ],
      ),
    );
  }

//  Scaffold body content
  Widget scaffoldBody(paypalHistory) {
    return Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: paypalHistory.length == 0
              ? BlankHistoryContainer()
              : Column(
                  children: _buildCards(itemList.length),
                ),
        ));
  }



//  Build method
  @override
  Widget build(BuildContext context) {
    itemList = _historyList();
    var paypalHistory = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel
        .paypal;
    return SafeArea(
      child: paypalHistory.length == 0
          ? BlankHistoryContainer()
          : Scaffold(
              appBar: customAppBar(context, "Payment History"),
              body: scaffoldBody(paypalHistory),
            ),
    );
  }

//  Cards that shows history
  List<Card> _buildCards(int count) {
    var paypalHistory = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel
        .paypal;
    for (var i = 0; i < paypalHistory.length; i++) {
      List<Card> cards = List.generate(
        count,
        (i) => historyCard(paypalHistory[i]),
      );
      return cards;
    }
    return null;
  }

//  List of payment history excepting stripe payment
  List<Paypal> _historyList() {
    var paypalHistory = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel
        .paypal;
    return List<Paypal>.generate(paypalHistory.length, (int index) {
      return Paypal(
        id: paypalHistory[index].id,
        userId: paypalHistory[index].userId,
        paymentId: paypalHistory[index].paymentId,
        userName: paypalHistory[index].userName,
        packageId: paypalHistory[index].packageId,
        price: paypalHistory[index].price,
        status: paypalHistory[index].status,
        method: paypalHistory[index].method,
        subscriptionFrom: paypalHistory[index].subscriptionFrom,
        subscriptionTo: paypalHistory[index].subscriptionTo,
        createdAt: paypalHistory[index].createdAt,
        updatedAt: paypalHistory[index].updatedAt,
        plan: paypalHistory[index].plan,
      );
    });
  }
}

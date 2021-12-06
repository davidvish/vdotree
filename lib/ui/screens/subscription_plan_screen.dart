import 'dart:io';

import 'package:IQRA/common/route_paths.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IQRA/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:IQRA/ui/screens/select_payment_screen.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

class SubPlanScreen extends StatefulWidget {
  @override
  _SubPlanScreenState createState() => _SubPlanScreenState();
}

class _SubPlanScreenState extends State<SubPlanScreen> {
//  List used to show all the plans using home API
  List<Widget> _buildCards(int count) {
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    List<Widget> cards = List.generate(count, (int index) {
      dynamic planAm = planDetails[index].amount;
      print(index);
      switch (planAm.runtimeType) {
        case int:
          {
            dailyAmount =
                planDetails[index].amount / planDetails[index].intervalCount;
            dailyAmountAp = dailyAmount.toStringAsFixed(2);
          }
          break;
        case String:
          {
            dailyAmount = double.parse(planDetails[index].amount.toString()) /
                double.parse(planDetails[index].intervalCount.toString());
            dailyAmountAp = dailyAmount.toStringAsFixed(2);
          }
          break;
        case double:
          {
            dailyAmount = double.parse(planDetails[index].amount.toString()) /
                double.parse(planDetails[index].intervalCount.toString());
            dailyAmountAp = dailyAmount.toStringAsFixed(2);
          }
          break;
      }

//      Used to check soft delete status so that only active plan can be showed
      dynamic mPlanStatus = planDetails[index].status;
      print(planDetails[index].deleteStatus);
      if (mPlanStatus.runtimeType == int) {
        if (planDetails[index].status == 1) {
          return planDetails[index].deleteStatus == 0
              ? SizedBox.shrink()
              : Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 1,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: 100,
                      children: List.generate(count, (index) {
                        return Container(child: newWidget(index)
                            //  OrientationBuilder(builder: (_,orientation){
                            //   return orientation == Orientation.portrait? newWidget(index):buildLanscapeProxy();
                            // })
                            // LayoutBuilder(builder: (_,constraint){
                            //   if(constraint.maxWidth < 720){
                            //      return

                            //     buildLanscapeProxy();
                            //   }else{
                            //      return newWidget(index);

                            //   }
                            // },)
                            );
                      })
                      // margin: EdgeInsets.only(top: 10.0),
                      // child: newWidget(index),
                      // subscriptionCards(index, dailyAmountAp),
                      ),
                );
        } else {
          return SizedBox.shrink();
        }
      } else {
        if ("${planDetails[index].status}" == "1") {
          return "${planDetails[index].deleteStatus}" == "0"
              ? SizedBox.shrink()
              : subscriptionCards(index, dailyAmountAp);
        } else {
          return SizedBox.shrink();
        }
      }
    });
    return cards;
  }

  Widget subscribeButton(index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              height: 40.0,
              width: 150.0,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(20.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    Color.fromRGBO(72, 163, 198, 0.4).withOpacity(0.4),
                    Color.fromRGBO(72, 163, 198, 0.3).withOpacity(0.5),
                    Color.fromRGBO(72, 163, 198, 0.2).withOpacity(0.6),
                    Color.fromRGBO(72, 163, 198, 0.1).withOpacity(0.7),
                  ],
                ),
              ),
              child: new MaterialButton(
                  height: 50.0,
                  splashColor: Color.fromRGBO(72, 163, 198, 0.9),
                  child: Text(
                    "Subscribe",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    //   Working after clicking on subscribe button
                    var router = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new SelectPaymentScreen(index));
                    Navigator.of(context).push(router);
                  }),
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

//  Amount with currency
  Widget amountCurrencyText(index) {
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${planDetails[index].amount}",
                style: TextStyle(color: Colors.white, fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 3.0,
              ),
              Text('${planDetails[index].currency}'),
            ],
          )),
        ]);
  }

//  Daily amount
  Widget dailyAmountIntervalText(dailyAmountAp, index) {
    var dailyAmount = Provider.of<AppConfig>(context, listen: false).planList;
    return Row(children: <Widget>[
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 100.0),
          child: Text(
            "$dailyAmountAp / ${dailyAmount[index].interval}",
            style: TextStyle(color: Colors.white, fontSize: 8.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ]);
  }

//  Plan Name
  Widget planNameText(index) {
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    return Container(
      height: 35.0,
      color: Color.fromRGBO(20, 20, 20, 1.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              '${planDetails[index].name}',
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget datatableDetails(String text1, String text2) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
            width: 0.5,
          ),
        ),
      ),
      width: 120,
      child: Align(
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: text1,
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              TextSpan(
                text: text2,
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromRGBO(255, 255, 0, 1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var index1;

  Widget newWidget(index) {
// LayoutBuilder(builder: (BuildContext context,constraint){
//   return
// });

    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // color:Colors.red,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "CHOOSE THE PLAN THAT'S RIGHT FOR YOU",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 7, bottom: 25),
                          child: Text(
                            "Downgrade or upgrade at any time",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //     alignment: Alignment.centerRight,
                  //     // color: Colors.red,
                  //     child: OrientationButton()),
                ],
              )
              // SizedBox(width: 0.5,)
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .55,
          width: MediaQuery.of(context).size.width * 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 0.0),
            itemCount: planDetails.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: SingleChildScrollView(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            index1 = index;
                            print(index1);
                          });
                        },
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  index1 = index;
                                  print(index1);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: (index1 != index)
                                          ? Colors.white10
                                          : primaryBlue,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${planDetails[index].name}'
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: (index1 != index)
                                              ? Colors.grey
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  width: 120,
                                  height: 50,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                'Monthly Price \n'
                                        '${planDetails[index].currency} ' +
                                    "${planDetails[index].amount}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontSize: 14,
                                    color: (index1 == index)
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .30,
                                child: Divider(
                                  color: (index1 == index)
                                      ? Colors.white
                                      : Colors.grey,
                                  // height: 4,
                                  thickness: 2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Multple Devices \n'
                                '${planDetails[index].screens}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontSize: 14,
                                    color: (index1 == index)
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .30,
                                child: Divider(
                                  color: (index1 == index)
                                      ? Colors.white
                                      : Colors.grey,
                                  // height: 4,
                                  thickness: 2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: planDetails[index].downloadlimit == null
                                  ? Text(
                                      'Total Downloads \n'
                                      'N/A',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          wordSpacing: 1,
                                          letterSpacing: 1,
                                          fontSize: 14,
                                          color: (index1 == index)
                                              ? Colors.white
                                              : Colors.grey),
                                    )
                                  : Text(
                                      'Total Downloads \n'
                                      '${planDetails[index].downloadlimit}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          wordSpacing: 1,
                                          letterSpacing: 1,
                                          fontSize: 14,
                                          color: (index1 == index)
                                              ? Colors.white
                                              : Colors.grey),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .30,
                                child: Divider(
                                  color: (index1 == index)
                                      ? Colors.white
                                      : Colors.grey,
                                  // height: 4,
                                  thickness: 2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                'Trial Days \n'
                                '${planDetails[index].trialPeriodDays}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontSize: 14,
                                    color: (index1 == index)
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .30,
                                child: Divider(
                                  color: (index1 == index)
                                      ? Colors.white
                                      : Colors.grey,
                                  // height: 4,
                                  thickness: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                if (index1 != null) {
                  var router = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new SelectPaymentScreen(index1));
                  Navigator.of(context).push(router);
                } else {
                  Fluttertoast.showToast(
                    msg: "Please Select a Plan",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                width: MediaQuery.of(context).size.width * .8,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CONTINUE TO PAY",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

//  Subscription cards
  Widget subscriptionCards(index, dailyAmountAp) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0 / 5.0,
            child: Column(
              children: <Widget>[
                planNameText(index),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                amountCurrencyText(index),
                dailyAmountIntervalText(dailyAmountAp, index),
              ],
            ),
          ),
          subscribeButton(index),
        ],
      ),
    );
  }

// Scaffold body
  Widget scaffoldBody() {
    var planDetails = Provider.of<AppConfig>(context).planList;
    return planDetails.length == 0
        ? noPlanColumn()
        : Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: planDetails.length == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      noPlanIcon(),
                      SizedBox(
                        height: 25.0,
                      ),
                      noPlanContainer(),
                    ],
                  )
                : SingleChildScrollView(
                    child: Container(
                      //  height: 700,
                      child: Column(
                        children: _buildCards(planDetails.length),
                      ),
                    ),
                  ),
          );
  }

  //  Empty watchlist container message
  Widget noPlanContainer() {
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      child: Text(
        "No subscription plans available.",
        style: TextStyle(height: 1.5, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

//  Empty watchlist icon
  Widget noPlanIcon() {
    return Image.asset(
      "assets/no_plan.png",
      height: 140,
      width: 160,
    );
  }

//  Empty plan column
  Widget noPlanColumn() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          noPlanIcon(),
          SizedBox(
            height: 25.0,
          ),
          noPlanContainer(),
        ],
      ),
    );
  }

// Widget buildPotrait(){
//   return
//   scaffoldBody();
// }

  Widget buildLanscapeProxy() {
    final deviceSize = MediaQuery.of(context).orientation;
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "CHOOSE THE PLAN THAT'S RIGHT FOR YOU",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 7, bottom: 25),
          child: Text(
            "Downgrade or upgrade at any time",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        ),
        Container(
          color: Colors.red,
          height: MediaQuery.of(context).size.height * .55,
          width: MediaQuery.of(context).size.width * 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 0.0),
            itemCount: planDetails.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              index1 = index;
                              print(index1);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: (index1 != index)
                                      ? Colors.white10
                                      : primaryBlue,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${planDetails[index].name}'.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: (index1 != index)
                                          ? Colors.grey
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              width: 120,
                              height: 50,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Monthly Price \n'
                                    '${planDetails[index].currency} ' +
                                "${planDetails[index].amount}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontSize: 14,
                                color: (index1 == index)
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .30,
                            child: Divider(
                              color: (index1 == index)
                                  ? Colors.white
                                  : Colors.grey,
                              // height: 4,
                              thickness: 2,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Multple Devices \n'
                            '${planDetails[index].screens}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontSize: 14,
                                color: (index1 == index)
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .30,
                            child: Divider(
                              color: (index1 == index)
                                  ? Colors.white
                                  : Colors.grey,
                              // height: 4,
                              thickness: 2,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Total Downloads \n'
                            '${planDetails[index].downloadlimit}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontSize: 14,
                                color: (index1 == index)
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .30,
                            child: Divider(
                              color: (index1 == index)
                                  ? Colors.white
                                  : Colors.grey,
                              // height: 4,
                              thickness: 2,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Trial Days \n'
                            '${planDetails[index].trialPeriodDays}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontSize: 14,
                                color: (index1 == index)
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .30,
                            child: Divider(
                              color: (index1 == index)
                                  ? Colors.white
                                  : Colors.grey,
                              // height: 4,
                              thickness: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                if (index1 != null) {
                  var router = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new SelectPaymentScreen(index1));
                  Navigator.of(context).push(router);
                } else {
                  Fluttertoast.showToast(
                    msg: "Please Select a Plan",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                width: MediaQuery.of(context).size.width * .8,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CONTINUE TO PAY",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget OrientationButton(){
  //   return OrientationBuilder(builder: (_,orientation){
  //     return
  //     orientation == Orientation.portrait? PotraitpayButton(): LandSacpepayButton();
  //   });
  // }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

//  Build Method
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (Platform.isIOS) {
      _launchURL();
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Re-Launch the app after purchase"),
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RoutePaths.splashScreen);
                }, child: Text("Re-Launch"))
              ],
            )
          ),
        ),
      );
    } else {
      return SafeArea(
          child: Scaffold(
              backgroundColor: Colors.black,
              appBar: customAppBarm(context, "SUBSCRIPTION PLAN"),
              body: scaffoldBody()
              //   OrientationBuilder(builder: (context,orientation)=> orientation == Orientation.portrait ? buildPotrait(): buildLanscape()
              // )
              ));
    }
  }

  void _launchURL() async {
    var token = await storage.read(key: "authToken");
    if (!await launch("https://vdotree.com/ios/payment/page/$token"))
      throw 'Could not launch ';
  }
}

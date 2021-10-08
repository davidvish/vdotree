import 'package:IQRA/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:IQRA/common/apipath.dart';
import 'dart:async';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:IQRA/providers/payment_key_provider.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:IQRA/ui/gateways/bank_payment.dart';
import 'package:IQRA/ui/gateways/in_app_payment.dart';
import 'package:IQRA/ui/gateways/paypal/PaypalPayment.dart';
import 'package:IQRA/ui/gateways/paystack_payment.dart';
import 'package:IQRA/ui/gateways/paytm_payment.dart';
import 'package:IQRA/ui/gateways/razor_payment.dart';
import 'package:IQRA/ui/gateways/stripe_payment.dart';
import 'package:IQRA/ui/screens/apply_coupon_screen.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:IQRA/common/styles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/app_config.dart';
import 'package:IQRA/providers/payment_key_provider.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:IQRA/ui/screens/splash_screen.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/ui/shared/success_ticket.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

List listPaymentGateways = new List();
String couponMSG = '';
var validCoupon, percentOFF;
bool isCouponApplied = true;
var mFlag = 0;
String couponCode = '';
var genCoupon;

class SelectPaymentScreen extends StatefulWidget {
  SelectPaymentScreen(this.planIndex);

  final planIndex;

  @override
  _SelectPaymentScreenState createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen>
    with TickerProviderStateMixin, RouteAware {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  ScrollController _scrollViewController;
  TabController _paymentTabController;
  var dailyAmount;
  int initialDragTimeStamp;
  int currentDragTimeStamp;
  int timeDelta;
  double initialPositionY;
  double currentPositionY;
  double positionYDelta;
  bool _validate = false;
  bool isDataAvailable = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      isBack = true;
      loading = true;
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    isCouponApplied = true;
    mFlag = 0;
    validCoupon = false;
    couponCode = '';
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      PaymentKeyProvider paymentKeyProvider =
          Provider.of<PaymentKeyProvider>(context, listen: false);
      await paymentKeyProvider.fetchPaymentKeys();
      listPaymentGateways = new List();
      var stripePayment = Provider.of<AppConfig>(context, listen: false)
          .appModel
          .config
          .stripePayment;
      var btreePayment = Provider.of<AppConfig>(context, listen: false)
          .appModel
          .config
          .braintree;
      var paystackPayment = Provider.of<AppConfig>(context, listen: false)
          .appModel
          .config
          .paystack;
      var bankPayment = Provider.of<AppConfig>(context, listen: false)
          .appModel
          .config
          .bankdetails;
      var razorPayPaymentStatus = Provider.of<AppConfig>(context, listen: false)
          .appModel
          .config
          .razorpayPayment;
      var paytmPaymentStatus = Provider.of<AppConfig>(context, listen: false)
          .appModel
          .config
          .paytmPayment;
      var payPal = Provider.of<AppConfig>(context, listen: false)
          .appModel
          .config
          .paypalPayment;

      listPaymentGateways.add(PaymentGateInfo(title: 'inapp', status: 1));
      if (stripePayment == 1 || "$stripePayment" == "1") {
        listPaymentGateways.add(PaymentGateInfo(title: 'stripe', status: 1));
      }
      if (btreePayment == 1 || "$btreePayment" == "1") {
        listPaymentGateways.add(PaymentGateInfo(title: 'btree', status: 1));
      }
      if (paystackPayment == 1 || "$paystackPayment" == "1") {
        listPaymentGateways.add(PaymentGateInfo(title: 'paystack', status: 1));
      }
      if (bankPayment == 1 || "$bankPayment" == "1") {
        listPaymentGateways
            .add(PaymentGateInfo(title: 'bankPayment', status: 1));
      }
      if (razorPayPaymentStatus == 1 || "$razorPayPaymentStatus" == "1") {
        listPaymentGateways
            .add(PaymentGateInfo(title: 'razorPayment', status: 1));
      }
      if (paytmPaymentStatus == 1 || "$paytmPaymentStatus" == "1") {
        listPaymentGateways
            .add(PaymentGateInfo(title: 'paytmPayment', status: 1));
      }
      if (payPal == 1 || "$payPal" == "1") {
        listPaymentGateways
            .add(PaymentGateInfo(title: 'paypalPayment', status: 1));
      }
      setState(() {
        loading = false;
      });
      _paymentTabController = TabController(
          vsync: this,
          length: listPaymentGateways != null ? listPaymentGateways.length : 0,
          initialIndex: 0);
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
  }

//  Apply coupon forward icon
  Widget applyCouponIcon() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(left: 0.0),
        child: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white70,
        ),
      ),
    );
  }

//  Gift icon
  Widget giftIcon() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Icon(
        Icons.card_giftcard,
        color: Color.fromRGBO(125, 183, 91, 1.0),
      ),
    );
  }

//  Payment method tas
  Widget paymentMethodTabs() {
    return PreferredSize(
      child: SliverAppBar(
        title: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _paymentTabController,
          indicatorColor: activeDotColor,
          isScrollable: true,
          tabs: List<Tab>.generate(
            listPaymentGateways == null ? 0 : listPaymentGateways.length,
            (int index) {
              if (listPaymentGateways[index].title == 'stripe') {
                return Tab(
                  child: tabLabelText('Stripe'),
                );
              }
              if (listPaymentGateways[index].title == 'btree') {
                return Tab(
                  child: tabLabelText('Braintree'),
                );
              }

              if (listPaymentGateways[index].title == 'paystack') {
                return Tab(
                  child: tabLabelText('Paystack'),
                );
              }
              if (listPaymentGateways[index].title == 'bankPayment') {
                return Tab(
                  child: tabLabelText('Bank Payment'),
                );
              }
              if (listPaymentGateways[index].title == 'razorPayment') {
                return Tab(
                  child: tabLabelText('RazorPay'),
                );
              }
              if (listPaymentGateways[index].title == 'paytmPayment') {
                return Tab(
                  child: tabLabelText('Paytm'),
                );
              }
              if (listPaymentGateways[index].title == 'paypalPayment') {
                return Tab(
                  child: tabLabelText('PayPal'),
                );
              }
              if (listPaymentGateways[index].title == 'inapp') {
                return Tab(
                  child: tabLabelText('In App'),
                );
              }
              return null;
            },
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColorLight,
        pinned: true,
        floating: true,
      ),
      preferredSize: Size.fromHeight(0.0),
    );
  }

//  App bar material design
  Widget appbarMaterialDesign() {
    return Material(
      child: Container(
        height: 70.0,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            bottom: BorderSide(width: 3.0, color: Colors.black),
          ),
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomRight,
          //   stops: [0.1, 0.5, 0.7, 0.9],
          //   colors: [
          //     Color.fromRGBO(72, 163, 198, 1.0).withOpacity(0.3),
          //     Color.fromRGBO(72, 163, 198, 1.0).withOpacity(0.2),
          //     Color.fromRGBO(72, 163, 198, 1.0).withOpacity(0.1),
          //     Color.fromRGBO(72, 163, 198, 1.0).withOpacity(0.0),
          //   ],
          // ),
        ),
      ),
    );
  }

//  Select payment text
  Widget selectPaymentText() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              Expanded(
                child: Text(
                  'CHOOSE YOUR PAYMENT METHOD',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.white30,
          ),
        ],
      ),
    );
  }

//  Plan name and user name
  Widget planAndUserName(indexPer) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    var name =
        Provider.of<UserProfileProvider>(context).userProfileModel.user.name;
    return Padding(
      padding: EdgeInsets.only(
        top: 150,
      ),
      child: Column(
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.sp,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  "Package Name",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 0, bottom: 10, right: 10),
                child: Text(
                  "${planDetails[widget.planIndex].name}",
                  style: TextStyle(
                      color: primaryBlue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.white30,
          )
        ],
      ),
    );
  }

  Widget packageDetail(double topPadding, String text1, String text2) {
    var planDetails = Provider.of<AppConfig>(context).planList;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 20, bottom: 10),
                  child: Text(
                    text1,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16),
                  )),
              Container(
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  child: Text(
                    text2,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(255, 255, 0, 1.0)),
                  )),
            ],
          ),
          Divider(
            color: Colors.white30,
          )
        ],
      ),
    );
  }

  Widget packageDetail1(double topPadding, String text1, String text2) {
    var planDetails = Provider.of<AppConfig>(context).planList;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 20, bottom: 10),
                  child: Text(
                    text1,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16),
                  )),
              Container(
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  child: Text(
                    "${planDetails[widget.planIndex].screens}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(255, 255, 0, 1.0)),
                  )),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.white30,
          )
        ],
      ),
    );
  }

  Widget packageDetail2(double topPadding, String text1, String text2) {
    var planDetails = Provider.of<AppConfig>(context).planList;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 20, bottom: 10),
                  child: Text(
                    "Downloads",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16),
                  )),
              Container(
                  //saad bhati
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  child:
                  planDetails[widget.planIndex].downloadlimit == null ?
                   Text(
                    "N/A",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(255, 255, 0, 1.0)),
                  )
                  :
                   Text(
                    "${planDetails[widget.planIndex].downloadlimit}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(255, 255, 0, 1.0)),
                  )),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.white30,
          )
        ],
      ),
    );
  }

//  Minimum duration
  Widget minDuration(indexPer) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    return Padding(
      padding: const EdgeInsets.only(top: 205),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  'Min duration ',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16.0, height: 1.3),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10, bottom: 10),
                child: Text(
                  '${planDetails[indexPer].intervalCount}' +
                      ' ${planDetails[indexPer].interval}',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 0, 1.0),
                      fontSize: 16.0,
                      height: 1.5),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.white30,
          )
        ],
      ),
    );
  }

//  After applying coupon
  Widget couponProcessing(afterDiscountAmount, indexPer) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              discountText(),
              Expanded(
                  flex: 1,
                  child: validCoupon == true
                      ? Text(
                          percentOFF.toString() + " %",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12.0, height: 1.3),
                        )
                      : Text(
                          "0 %",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12.0, height: 1.3),
                        )),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              afterDiscountText(),
              Expanded(
                flex: 1,
                child: validCoupon == true
                    ? Text(
                        afterDiscountAmount.toString() +
                            " ${planDetails[widget.planIndex].currency}",
                        style: TextStyle(
                            color: Colors.white, fontSize: 10.0, height: 1.3),
                      )
                    : amountText(indexPer),
              ),
            ],
          )
        ],
      ),
    );
  }

//  Plan amount
  Widget planAmountText(indexPer, dailyAmountAp) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    return Padding(
      padding: const EdgeInsets.only(top: 490),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  'Amount',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 0, bottom: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      " ${planDetails[widget.planIndex].currency}"
                              .toUpperCase() +
                          " " +
                          "${planDetails[widget.planIndex].amount} ",
                      style: TextStyle(
                          color: Color.fromRGBO(255, 255, 0, 1.0),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "/ ${planDetails[widget.planIndex].interval}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          letterSpacing: 0.8,
                          height: 1.3,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 0, bottom: 10, right: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Text(
          //         '/ ${planDetails[widget.planIndex].interval}',
          //         style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 12.0,
          //             letterSpacing: 0.8,
          //             height: 1.3,
          //             fontWeight: FontWeight.w500),
          //       ),
          //     ],
          //   ),
          // ),
          Divider(
            color: Colors.white30,
          )
        ],
      ),
    );
  }

//  Logo row
  Widget logoRow() {
    var logo =
        Provider.of<AppConfig>(context, listen: false).appModel.config.logo;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 21, left: 120),
            child: Text(
              'PAYMENT METHOD',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 255, 0, 1.0)),
            )
            // Image.network(
            //   '${APIData.logoImageUri}$logo',
            //   scale: 1.7,
            // ),
            ),
      ],
    );
  }

//  Discount percent
  Widget discountText() {
    return Expanded(
      flex: 5,
      child: Text(
        "Discount",
        style: TextStyle(color: Colors.white, fontSize: 12.0, height: 1.3),
      ),
    );
  }

//  Amount after discount
  Widget afterDiscountText() {
    return Expanded(
      flex: 5,
      child: Text(
        "After Discount Amount:",
        style: TextStyle(color: Colors.white, fontSize: 12.0, height: 1.3),
      ),
    );
  }

//  Amount
  Widget amountText(indexPer) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    return Text(
      "${planDetails[indexPer].amount}" + " ${planDetails[indexPer].currency}",
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        height: 1.3,
      ),
    );
  }

//  Tab label text
  Widget tabLabelText(label) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: new Text(
        label,
        style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 13.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.9,
            color: Colors.white),
      ),
    );
  }

// Swipe down row
  Widget swipeDownRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 100.0,
        ),
        swipeIconContainer(),
        SizedBox(
          width: 10.0,
        ),
        swipeDownText(),
      ],
    );
  }

// Swipe icon container
  Widget swipeIconContainer() {
    return Container(
      height: 25.0,
      width: 25.0,
      decoration: BoxDecoration(
          border:
              Border.all(width: 2.0, color: Color.fromRGBO(125, 183, 91, 1.0)),
          shape: BoxShape.circle,
          color: Theme.of(context).backgroundColor),
      child: Icon(Icons.keyboard_arrow_down,
          size: 21.0, color: Colors.white.withOpacity(0.7)),
    );
  }

//  Swipe down text
  Widget swipeDownText() {
    return Text(
      "Swipe down wallet to pay",
      style: TextStyle(fontSize: 16.0, color: Colors.white.withOpacity(0.7)),
    );
  }

  //  Bank payment wallet
  Widget bankPaymentWallet(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            swipeDownRow(),
            Dismissible(
                direction: DismissDirection.down,
                key: Key("$indexPer"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    if (genCoupon == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BankPayment()));
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BankPayment()));
                    }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                  }
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/bankwallets.png"),
                )),
          ],
        ),
      ),
    );
  }

  //  Razorpay payment wallet
  Widget razorPaymentWallet(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            swipeDownRow(),
            Dismissible(
                direction: DismissDirection.down,
                key: Key("$indexPer"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    if (genCoupon == null) {
                      Navigator.pushNamed(context, RoutePaths.razorpay,
                          arguments: RazorPayment(indexPer, null));
                    } else {
                      Navigator.pushNamed(context, RoutePaths.razorpay,
                          arguments: RazorPayment(indexPer, genCoupon));
                    }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                  }
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/razorpay.png"),
                )),
          ],
        ),
      ),
    );
  }

  //  Paytm payment wallet
  Widget paytmPaymentWallet(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            swipeDownRow(),
            Dismissible(
                direction: DismissDirection.down,
                key: Key("$indexPer"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    if (genCoupon == null) {
                      Navigator.pushNamed(context, RoutePaths.paytm,
                          arguments: PaytmPayment(indexPer, null));
                    } else {
                      Navigator.pushNamed(context, RoutePaths.paytm,
                          arguments: PaytmPayment(indexPer, genCoupon));
                    }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                  }
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/paytm.png"),
                )),
          ],
        ),
      ),
    );
  }

//  Paystack payment wallet
  Widget paystackPaymentWallet(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            swipeDownRow(),
            Dismissible(
                direction: DismissDirection.down,
                key: Key("$indexPer"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    if (genCoupon == null) {
                      Navigator.pushNamed(context, RoutePaths.paystack,
                          arguments: PaystackPayment(indexPer, null));
                    } else {
                      Navigator.pushNamed(context, RoutePaths.paystack,
                          arguments: PaystackPayment(indexPer, genCoupon));
                    }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                  }
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/paystackwallets.png"),
                )),
          ],
        ),
      ),
    );
  }

//  Stripe payment wallet
  Widget stripePaymentWallet(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            swipeDownRow(),
            Dismissible(
                direction: DismissDirection.down,
                key: Key('$indexPer'),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    Fluttertoast.showToast(msg: couponMSG);
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }

                  if (validCoupon != false || couponCode == '') {
                    if (genCoupon == null) {
                      Navigator.pushNamed(context, RoutePaths.stripe,
                          arguments: StripePayment(indexPer, couponCode));
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "This coupon can't be applicable for Stripe payment");
                      return false;
                    }
                  }
                  Future.delayed(Duration(seconds: 1)).then((_) {
                    validCoupon == false
                        ? Fluttertoast.showToast(msg: couponMSG)
                        : SizedBox.shrink();
                  });
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/stripe.png"),
                )),
          ],
        ),
      ),
    );
  }

//  Braintree payment wallet
  Widget braintreePayment(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 100.0,
                ),
                Container(
                  height: 25.0,
                  width: 25.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.0, color: Color.fromRGBO(125, 183, 91, 1.0)),
                    shape: BoxShape.circle,
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Icon(Icons.keyboard_arrow_down,
                      size: 21.0, color: Colors.white.withOpacity(0.7)),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Swipe down wallet to pay",
                  style: TextStyle(
                      fontSize: 16.0, color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
            Dismissible(
                direction: DismissDirection.down,
                key: Key('$indexPer'),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    // if (genCoupon == null) {
                    //   Navigator.pushNamed(context, RoutePaths.braintree,
                    //       arguments: BraintreePaymentScreen(indexPer, null));
                    // } else {
                    //   Navigator.pushNamed(context, RoutePaths.braintree,
                    //       arguments:
                    //           BraintreePaymentScreen(indexPer, genCoupon));
                    // }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                  }
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/braintreewallet.png"),
                )),
          ],
        ),
      ),
    );
  }

  //  paypal payment wallet
  Widget paypalPayment(indexPer) {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    var appConfig = Provider.of<AppConfig>(context, listen: false).appModel;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 100.0,
                ),
                Container(
                  height: 25.0,
                  width: 25.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.0, color: Color.fromRGBO(125, 183, 91, 1.0)),
                    shape: BoxShape.circle,
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Icon(Icons.keyboard_arrow_down,
                      size: 21.0, color: Colors.white.withOpacity(0.7)),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Swipe down wallet to pay",
                  style: TextStyle(
                      fontSize: 16.0, color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
            Dismissible(
                direction: DismissDirection.down,
                key: Key('$indexPer'),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    if (genCoupon == null) {
                      onPayWithPayPal(appConfig, userDetails, indexPer, null);
                    } else {
                      onPayWithPayPal(
                          appConfig, userDetails, indexPer, genCoupon);
                    }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                  }
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/paypal.png"),
                )),
          ],
        ),
      ),
    );
  }

  void onPayWithPayPal(appConfig, userDetails, indexPer, amount) {
    Navigator.pushNamed(
      context,
      RoutePaths.paypal,
      arguments: PaypalPayment(
        onFinish: (number) async {},
        currency: "${appConfig.config.currencyCode}",
        userFirstName: userDetails.user.name,
        userLastName: "",
        userEmail: userDetails.user.email,
        payAmount:
            amount == null ? "${appConfig.plans[indexPer].amount}" : "$amount",
        planIndex: appConfig.plans[widget.planIndex].id,
      ),
    );
  }

  //  inapp payment wallet
  Widget inappPayment(indexPer) {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    var appConfig = Provider.of<AppConfig>(context, listen: false).appModel;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 100.0,
                ),
                Container(
                  height: 25.0,
                  width: 25.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.0, color: Color.fromRGBO(125, 183, 91, 1.0)),
                    shape: BoxShape.circle,
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Icon(Icons.keyboard_arrow_down,
                      size: 21.0, color: Colors.white.withOpacity(0.7)),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Swipe down wallet to pay",
                  style: TextStyle(
                      fontSize: 16.0, color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
            Dismissible(
                direction: DismissDirection.down,
                key: Key('$indexPer'),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    if (genCoupon == null) {
                      Navigator.pushNamed(context, RoutePaths.inApp,
                          arguments: InApp(indexPer));
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "Coupon can't be applied for this payment gateway");
                      return false;
                    }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                  }
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/inapp.png"),
                )),
          ],
        ),
      ),
    );
  }

  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  bool isBack = false;
  bool isShowing = false;
  var razorResponse;
  var msgResponse;
  var razorSubscriptionResponse;
  String createdDatePaystack = '';
  String createdTimePaystack = '';
  var ind;
  int price;
  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     isBack = true;
  //   });
  //   _razorpay = Razorpay();
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  // }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    var razorPayKey = Provider.of<PaymentKeyProvider>(context, listen: false)
        .paymentKeyModel
        .razorkey;
    double cost;
    dynamic amountdata = planDetails[widget.planIndex].amount == null
        ? planDetails[widget.planIndex].amount
        : planDetails[widget.planIndex].amount;
    switch (amountdata.runtimeType) {
      case int:
        {
          setState(() {
            price = amountdata;
          });
        }
        break;
      case String:
        {
          setState(() {
            cost = amountdata == null ? 0 : double.parse(amountdata);
            price = cost.round();
          });
        }
        break;
      case double:
        {
          setState(() {
            cost = amountdata == null ? 0 : amountdata;
            price = cost.round();
          });
        }
    }
    print(razorPayKey);
    var options = {
      'key': razorPayKey,
      'amount': '${price * 100}',
      'name': APIData.appName,
      'description': planDetails[widget.planIndex].name,
      'external': {
        'wallets': ['paytm']
      },
      'prefill': {'email': '${userDetails.user.email}'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  goToDialog2() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                backgroundColor: Colors.white,
                title: Text(
                  "Saving Payment Info",
                  style: TextStyle(color: Theme.of(context).backgroundColor),
                ),
                content: Container(
                  height: 70.0,
                  width: 150.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              onWillPop: () async => isBack));
    } else {
      Navigator.pop(context);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId);
    setState(() {
      isShowing = true;
      isBack = false;
    });
    sendRazorDetails(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }

  goToDialog(subdate, time) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => new GestureDetector(
              child: Container(
                color: Colors.white.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SuccessTicket(
                      msgResponse: "$msgResponse",
                      subDate: "$subdate",
                      time: "$time",
                      planAmount: "$price",
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.yellow,
                      child: Icon(

                        Icons.clear,

                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RoutePaths.splashScreen,
                            arguments: SplashScreen(
                              token: authToken,
                            ));
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  Future<String> sendRazorDetails(payId) async {
    goToDialog2();
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    var am = planDetails[widget.planIndex].amount;
    var plan1 = planDetails[widget.planIndex].id;
    print(authToken);
    final sendResponse = await http.post(APIData.sendRazorDetails,
        body: jsonEncode(
          {
            "reference": "$payId",
            "amount": "$am",
            "plan_id": "$plan1",
            "status": "1",
            "method": "RazorPay",
          },
        ),
        //  {
        //   "reference": "$payId",
        //   "amount": "$am",
        //   "plan_id": "$plan1",
        //   "status": "1",
        //   "method": "RazorPay",
        // },
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $authToken",
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
    print("bhati");
    print(sendResponse.statusCode);
    print(sendResponse.body);
    razorResponse = json.decode(sendResponse.body);
    msgResponse = razorResponse['message'];
    razorSubscriptionResponse = razorResponse['subscription'];
    var date = razorSubscriptionResponse['created_at'];
    var time = razorSubscriptionResponse['created_at'];
    createdDatePaystack = DateFormat('d MMM y').format(DateTime.parse(date));
    createdTimePaystack = DateFormat('HH:mm a').format(DateTime.parse(time));

    if (sendResponse.statusCode == 200) {
      setState(() {
        isShowing = false;
      });
      goToDialog(createdDatePaystack, createdTimePaystack);
    } else {
      Fluttertoast.showToast(msg: "Your transaction failed contact to Admin.");
      setState(() {
        isShowing = false;
      });
    }
    return null;
  }

//  Sliver List
  Widget _sliverList(dailyAmountAp, afterDiscountAmount, planDetails) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int j) {
      return Container(
          child: Column(children: <Widget>[
        new Container(
          height: 700,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  appbarMaterialDesign(),
                  selectPaymentText(),
                  planAndUserName(widget.planIndex),
                  minDuration(widget.planIndex),
                  packageDetail2(270, 'Video Quality', 'Best'),
                  packageDetail1(325, 'Devices', '20'),
                  packageDetail(380, 'Cancel at any time', 'Yes'),
                  packageDetail(435, 'Joining Date',
                      new DateFormat.yMMMd().format(new DateTime.now())),
                  planAmountText(widget.planIndex, dailyAmountAp),
                  Padding(
                    padding: EdgeInsets.only(top: 600, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            openCheckout();
                            // Navigator.pushNamed(context, RoutePaths.razorpay,
                            //     arguments:
                            //         RazorPayment(widget.planIndex, null));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .8,
                            height: 50,
                            decoration: BoxDecoration(
                                color: primaryBlue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Pay With Razorpay",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Positioned(
                    top: 8.0,
                    left: 4.0,
                    child: new BackButton(color: Colors.white),
                  ),
                  logoRow(),
                ],
              ),
            ],
          ),
        ),
      ]));
    },
            addAutomaticKeepAlives: true,
            // addRepaintBoundaries: true,
            // addSemanticIndexes: true,
            childCount: 1));
  }

//  Scaffold body
  Widget _scaffoldBody(dailyAmountAp, afterDiscountAmount, planDetails) {
    // return NestedScrollView(
    //   physics: BouncingScrollPhysics(),
    
    //   controller: _scrollViewController,
    //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //     return <Widget>[
          SingleChildScrollView(child: _sliverList(dailyAmountAp, afterDiscountAmount, planDetails));
          // paymentMethodTabs(),
    //     ];
    //   },
    //   body: Text("."),

    //   //
    //   //  _nestedScrollViewBody(),
    // );
  }

//  NestedScrollView body
  Widget _nestedScrollViewBody() {
    return listPaymentGateways.length == 0
        ? Center(
            child: Text("No payment method available"),
          )
        : TabBarView(
            controller: _paymentTabController,
            physics: PageScrollPhysics(),
            children: List<Widget>.generate(
                listPaymentGateways == null ? 0 : listPaymentGateways.length,
                (int index) {
              if (listPaymentGateways[index].title == 'btree') {
                return InkWell(
                  child: braintreePayment(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'stripe') {
                return InkWell(
                  child: stripePaymentWallet(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'paystack') {
                return InkWell(
                  child: paystackPaymentWallet(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'bankPayment') {
                return InkWell(
                  child: bankPaymentWallet(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'razorPayment') {
                return InkWell(
                  child: razorPaymentWallet(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'paytmPayment') {
                return InkWell(
                  child: paytmPaymentWallet(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'paypalPayment') {
                return InkWell(
                  child: paypalPayment(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'inapp') {
                return InkWell(
                  child: inappPayment(widget.planIndex),
                );
              }
              return null;
            }));
  }

//  Build method
  @override
  Widget build(BuildContext context) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    var dailyAmount1;
    var intervalCount;
    dynamic planAm = planDetails[widget.planIndex].amount;
    switch (planAm.runtimeType) {
      case int:
        dailyAmount1 = planAm;
        break;
      case String:
        dailyAmount1 = double.parse(planAm);
        break;
      case double:
        dailyAmount1 = double.parse(planAm);
        break;
    }
    dynamic interCount = planDetails[widget.planIndex].intervalCount;
    switch (interCount.runtimeType) {
      case int:
        intervalCount = interCount;
        break;
      case String:
        intervalCount = int.parse(interCount);
        break;
    }
    var dailyAmount = dailyAmount1 / intervalCount;
    String dailyAmountAp = dailyAmount.toStringAsFixed(2);
    var amountOff = validCoupon == true
        ? (percentOFF / 100) * planDetails[widget.planIndex].amount
        : 0;
    var afterDiscountAmount = validCoupon == true
        ? planDetails[widget.planIndex].amount - amountOff
        : 0;

    return SafeArea(
      child: WillPopScope(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              
              backgroundColor: Colors.black,
              key: _scaffoldKey,
              body: loading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : CustomScrollView(
                    slivers: [_sliverList(
                        dailyAmountAp, afterDiscountAmount, planDetails),
                  ],)
                   
            ),
          ),
          onWillPop: () async {
            return true;
          }),
    );
  }
}

class PaymentGateInfo {
  String title;
  int status;

  PaymentGateInfo({this.title, this.status});
}

import 'dart:convert';
import 'dart:io';
import 'package:IQRA/common/styles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/ui/screens/select_payment_screen.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:IQRA/providers/coupon_provider.dart';
import 'package:provider/provider.dart';
import 'package:IQRA/models/coupon_model.dart';

class ApplyCouponScreen extends StatefulWidget {
  ApplyCouponScreen(this.amount);
  final amount;
  @override
  _ApplyCouponScreenState createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _couponController = new TextEditingController();
  bool _validate = false;
  bool isDataAvailable = false;
  bool _visible = false;

  Future<String> _applyCoupon() async {
    final applyCouponResponse = await http.post(
        Uri.encodeFull(
            "https://api.stripe.com/v1/coupons/${_couponController.text}"),
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    var applyCouponDetails = json.decode(applyCouponResponse.body);
    if (applyCouponResponse.statusCode == 200) {
      validCoupon = applyCouponDetails['valid'];
      percentOFF = applyCouponDetails['percent_off'];
      Future.delayed(Duration(seconds: 1)).then((_) => Navigator.pop(context));

      if (validCoupon == true) {
        mFlag = 1;
        setState(() {
          couponMSG = 'Coupon Applied';
          isCouponApplied = false;
          isDataAvailable = false;
        });
      } else {
        setState(() {
          couponMSG = 'Coupon has been expired';
          isCouponApplied = false;
          isDataAvailable = false;
        });
      }
    } else {
      validCoupon = false;
      setState(() {
        couponMSG = 'Invalid Coupon Code';
        isCouponApplied = false;
        isDataAvailable = false;
      });
      Future.delayed(Duration(seconds: 1)).then((_) => Navigator.pop(context));
      setState(() {
        isDataAvailable = false;
      });
    }
    return null;
  }

  Future<String> _verifyCoupon(couponCode) async {
    var couponProvider =
        Provider.of<CouponProvider>(context, listen: false).couponModel;
    final applyCouponResponse = await http.get(
      APIData.applyGeneralCoupon + "?coupon_code=$couponCode",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $authToken",
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      //  body: {
      //   "coupon_code": couponCode,
      // }
    );
    print(applyCouponResponse.body);
    print("saad");
    var applyCouponDetails = json.decode(applyCouponResponse.body);
    if (applyCouponResponse.statusCode == 200) {
      for (int i = 0; i < couponProvider.coupon.length; i++) {
        if (couponProvider.coupon[i].couponCode == couponCode) {
          if (couponProvider.coupon[i].inStripe == "1" ||
              couponProvider.coupon[i].inStripe == 1) {
            _applyCoupon();
          } else {
            mFlag = 1;
            setState(() {
              validCoupon = true;
              percentOFF = couponProvider.coupon[i].percentOff;
              couponMSG = 'Coupon Applied';
              isCouponApplied = false;
              isDataAvailable = false;
            });
            Future.delayed(Duration(seconds: 1))
                .then((_) => Navigator.pop(context));
          }
        }
      }
    } else if (applyCouponResponse.statusCode == 401) {
      validCoupon = false;
      setState(() {
        couponMSG = 'Coupon has been expired';
        isCouponApplied = false;
        isDataAvailable = false;
      });
      Future.delayed(Duration(seconds: 1)).then((_) => Navigator.pop(context));
      setState(() {
        isDataAvailable = false;
      });
    }
    return null;
  }

  Widget getCouponList(List<Coupon> cList) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < cList.length; i++) {
      list.add(Container(
        color: Colors.black,
        height: 50,
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Avilable Coupans"),
            cList[i].percentOff == null
                ? Text(
                    "${cList[i].couponCode} ${cList[i].amountOff}"
                    "${cList[i].currency} off",
                    style: TextStyle(fontSize: 14.0),
                  )
                : Text(
                    "${cList[i].couponCode} ${cList[i].percentOff}"
                    " ${cList[i].currency} % off",
                    style: TextStyle(fontSize: 14.0),
                  )
          ],
        ),
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CouponProvider couponProvider =
          Provider.of<CouponProvider>(context, listen: false);
      await couponProvider.getCoupons(context);
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var couponList = Provider.of<CouponProvider>(context).couponModel;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppBar(context, "Available Coupons"),
      body: _visible == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        Container(
                          height: 100.0,
                          child: Form(
                            key: _formKey,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 60.0,
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _couponController,
                                      decoration: InputDecoration(
                                        hintText: "Enter Coupon Code",
                                        errorText:
                                            _validate ? "Enter Coupon" : null,
                                      ),
                                      validator: (val) {
                                        if (val.length == 0) {
                                          return 'Please Enter Coupon Code';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (val) =>
                                          _couponController.text = val,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 60.0,
                                    padding: const EdgeInsets.all(8.0),
                                    child: isDataAvailable
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : RaisedButton(
                                            color: primaryBlue,
                                            child: Text(
                                              "Apply",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              final form =
                                                  _formKey.currentState;
                                              form.save();
                                              if (form.validate() == true) {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                setState(() {
                                                  couponCode =
                                                      _couponController.text;
                                                });
                                                _verifyCoupon(couponCode);
                                                isDataAvailable = true;
                                              }
                                            },
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          height: 20.0,
                        ),
                        getCouponList(couponList.coupon),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:IQRA/common/styles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/common/route_paths.dart';
import 'package:IQRA/providers/user_profile_provider.dart';
import 'package:IQRA/ui/screens/splash_screen.dart';
import 'package:IQRA/ui/shared/appbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  Dio dio = new Dio();
  FormData formdata = FormData();
  TextEditingController _editNameController = new TextEditingController();
  TextEditingController _editDOBController;
  // new TextEditingController(text: "saad");
  TextEditingController _editMobileController = new TextEditingController();
  DateTime _dateTime = new DateTime.now();
  String pickedDate;
  var sEmail;
  var sPass;
  var files;
  String status = '';
  String base64Image;
  DateTime dateTimeMY = DateTime.now();
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  var currentPassword, newPassword, newDob, newMobile, newName;
  bool isShowIndicator = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

//  Show a dialog after updating password
  Future<void> _profileUpdated(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          child: Center(
            child: Container(
              decoration: BoxDecoration(),
              child: AlertDialog(
                backgroundColor: Colors.black,
                contentPadding: const EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)
                    ),
                    side: BorderSide(
                        color: Colors.blue, width: 1, style: BorderStyle.solid)
                ),

                title: Text(
                  'Profile Saved!',
                 // 'Your profile updated.',
                 textAlign: TextAlign.center,
                 // style: TextStyle(color: Color.fromRGBO(34, 34, 34, 1.0)),
                  style: TextStyle(color: Colors.yellow),
                ),
                content: Container(
                  height: 100.0,
                  // color: Colors.red,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Icon(FontAwesomeIcons.checkCircle,
                          size: 60.0, color: activeDotColor),
                      SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        'Profile has been updated.',
                        style:
                        //TextStyle(color: Color.fromRGBO(34, 34, 34, 1.0)),
                        TextStyle(color: Colors.yellow),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Ok',
                      style: TextStyle(fontSize: 16.0, color: activeDotColor),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, RoutePaths.splashScreen,
                          arguments: SplashScreen(
                            token: authToken,
                          ));
                    },
                  ),
                ],
              ),
            ),
          ),
          onWillPop: () async => false,
        );
      },
    );
  }

//  This future process the profile update and save details to the server.
  Future<String> updateProfile() async {
    newDob = DateFormat("y-MM-dd").format(_dateTime);
    newMobile = _editMobileController.text;
    newName = _editNameController.text;
    String imagefileName = tmpFile != null ? tmpFile.path.split('/').last : '';
    print(imagefileName);
    try {
      if (imagefileName != '') {
        formdata = FormData.fromMap({
          "email": sEmail,
          "current_password": sPass,
          "new_password": sPass,
          "dob": newDob,
          "mobile": newMobile,
          "name": newName,
          // "image": tmpFile.path
          "image": await MultipartFile.fromFile(tmpFile.path,
              filename: imagefileName),
        });
        print("saad");
        print(tmpFile.path);
        print(imagefileName);
      } else {
        formdata = FormData.fromMap({
          "email": sEmail,
          "current_password": sPass,
          "new_password": sPass,
          "dob": newDob,
          "mobile": newMobile,
          "name": newName,
        });
      }

      await dio
          .post(APIData.userProfileUpdate,
          data: formdata,
          options: Options(
              method: 'POST',
              headers: {
                HttpHeaders.authorizationHeader: "Bearer $authToken",
              },
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }))
          .then((response) {
        print(Image);

        setState(() {
          isShowIndicator = false;
        });
        print(response);
        _profileUpdated(context);
      }).catchError((error) {
        setState(() {
          isShowIndicator = false;
        });
        Fluttertoast.showToast(msg: error.toString());
        print(error.toString());
      });
    } catch (e) {
      setState(() {
        isShowIndicator = false;
      });
      print(e);
    }
    return null;
  }

//  For selecting image from camera
  chooseImageFromCamera() async {
    //files = await ImagePicker().getImage(source: ImageSource.camera);

    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);
    files = File(pickedFile.path);

    setState(()  {
    });
  }

//  For selecting image from gallery
  chooseImageFromGallery() async {
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    files = File(pickedFile.path);

    setState(()  {
    });
  }

//  This Future picks date using material date picker
  Future<Null> _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateTimeMY,
      firstDate: new DateTime(1970),
      lastDate: new DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        print("ok");
        print(picked);
        
        _dateTime = picked;
        
         _editDOBController.text = pickedDate;
        print(' COntroller  ${_editDOBController}');
      });
      // ignore: unrelated_type_equality_checks

      setState(() {
        print("ok");
        String formattedDate =
        _dateTime != null ? DateFormat.yMMMd().format(_dateTime) : "";
        print("ok");
        pickedDate = formattedDate;
        _editDOBController = (pickedDate != null)
            ? TextEditingController(text: pickedDate)
            : TextEditingController(text: "Date of Birth");
        print(pickedDate);
        
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('picked', picked.toString());
preferences.setString('saveDate',_editDOBController.text);
    }else{
      print('else now date');
    }
  }
getSharedData()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    pickedDate = preferences.getString('saveDate');
    _editDOBController.text = preferences.getString('saveDate');
    _dateTime = DateTime.parse(preferences.getString('picked'));
        dateTimeMY =  DateTime.parse(preferences.getString('picked')) ?? DateTime.now();
  });
}
  @override
  void initState() {
    // TODO: implement initState
    getSharedData();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
          .userProfileModel;
      setState(() {
        print(userDetails.user.dob);
        if (userDetails.user.dob != null) {
          _editDOBController =
              TextEditingController(text: userDetails.user.dob);
        }
        if (userDetails.user.dob == null) {
          _editDOBController = TextEditingController(text: "Date of Birth");
        }
      });
      print(userDetails.user.dob);
      print('edittedPost ${_editDOBController.text}');
      newName = _editNameController.text;
      newDob = _editDOBController.text;
      newMobile = _editMobileController.text;
      _editNameController.text =
      "${userDetails.user.name}" == null ? '' : "${userDetails.user.name}";
      userDetails.user.dob == null
          ? 'Date of Birth'
          : "${userDetails.user.dob}";
      _editMobileController.text = "${userDetails.user.mobile}" == "null"
          ? ''
          : "${userDetails.user.mobile}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      appBar: customAppBar(context, "Edit Profile"),
      body: scaffoldBody(),
    );
  }

//  Scaffold body
  Widget scaffoldBody() {
    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                showImage(),
                browseImageButton(),
              ],
            ),
            form(),
          ],
        ));
  }

//  Browse button container
  Widget browseImageButton() {
    return Container(
      height: 45.0,
      width: 45.0,
      margin: EdgeInsets.fromLTRB(125.0, 170.0, 0.0, 0.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryBlue,
      ),
      child: IconButton(
        icon: Icon(
          Icons.add_a_photo,
          color: Colors.black,
        ),
        onPressed: _onButtonPressed,
      ),
    );
  }

//  Form that containing text fields to update profile
  Widget form() {
    return Container(
      padding:
      EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0, bottom: 20.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            buildNameTextField("Name"),
            SizedBox(
              height: 20.0,
            ),
            buildDOBTextField("Date of Birth"),
            SizedBox(
              height: 20.0,
            ),
            // buildMobileTextField("Mobile Number"),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(height: 10.0),
            updateButtonContainer(),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

//  Name TextField to update name
  Widget buildNameTextField(String hintText) {
    return TextFormField(
      maxLength: 24,
      controller: _editNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5.0),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.account_box),
      ),
      validator: (val) {
        if (val.length == 0) {
          return 'Name can not be empty';
        } else {
          if (val.length < 4) {
            return 'Name required at least 5 characters.';
          } else {
            return null;
          }
        }
      },
      onSaved: (val) => _editNameController.text = val,
    );
  }

//  TextField Date of birth field
  Widget buildDOBTextField(String hintText) {
    return TextField(
      controller: _editDOBController,
      focusNode: AlwaysDisabledFocusNode(),
      onTap: _selectDate,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5.0),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.calendar_today),
      ),
    );
  }

//  TextField to update mobile number
  Widget buildMobileTextField(String hintText) {
    return TextField(
      controller: _editMobileController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5.0),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.phone),
      ),
    );
  }

//  Update button container
  Widget updateButtonContainer() {
    return InkWell(
      child: Container(
        height: 56.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: new BorderRadius.circular(5.0),
          // Box decoration takes a gradient
          // gradient: LinearGradient(
          //   // Where the linear gradient begins and ends
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomRight,
          //   // Add one stop for each color. Stops should increase from 0 to 1
          //   stops: [0.1, 0.5, 0.7, 0.9],
          //   colors: [
          //     // Colors are easy thanks to Flutter's Colors class.
          //     Color.fromRGBO(72, 163, 198, 0.4).withOpacity(0.4),
          //     Color.fromRGBO(72, 163, 198, 0.3).withOpacity(0.5),
          //     Color.fromRGBO(72, 163, 198, 0.2).withOpacity(0.6),
          //     Color.fromRGBO(72, 163, 198, 0.1).withOpacity(0.7),
          //   ],
          // ),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 10.0,
              offset: new Offset(1.0, 10.0),
            ),
          ],
        ),
        child: Center(
          child: isShowIndicator == true
              ? CircularProgressIndicator(
            backgroundColor: Colors.black,
          )
              : Text(
            "Update Profile",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
      onTap: () {
//     To remove keypad on tapping button
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          isShowIndicator = true;
        });
        final form = formKey.currentState;
        form.save();
        if (form.validate() == true) {
          updateProfile();
        } else {
          setState(() {
            isShowIndicator = false;
          });
        }
      },
    );
  }

//  Preview of selected image
  Widget showImage() {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    return FutureBuilder<String>(
      future: filesget(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data && files != null) {
          tmpFile = files;
          base64Image = base64Encode(files.readAsBytesSync());
          return Container(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.all(Radius.circular(150.0)),
                  ),
                  child: Container(
                      margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      height: 190.0,
                      width: 180.0,
                      // decoration: new BoxDecoration(
                      //     color: Colors.white.withOpacity(0.2),
                      //     border: new Border.all(
                      //         color: Colors.white.withOpacity(0.0),
                      //         width: 10.0),
                      //     borderRadius: new BorderRadius.only(
                      //         bottomLeft: Radius.circular(25.0),
                      //         bottomRight: Radius.circular(25.0))),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          new BorderRadius.all(Radius.circular(150.0)),
                        ),
                        margin: EdgeInsets.all(0.0),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: new BorderRadius.only(
                        //       bottomLeft: Radius.circular(25.0),
                        //       bottomRight: Radius.circular(25.0)),
                        // ),
                        child: ClipRRect(
                          borderRadius:
                          new BorderRadius.all(Radius.circular(150)),
                          child: tmpFile == null
                              ? "${userDetails.user.image}" == null ||
                              "${userDetails.user.image}" == "null"
                              ? Image.asset(
                            "assets/avatar.png",
                            fit: BoxFit.cover,
                            scale: 1.7,
                          )
                              : Image.network(
                            "${APIData.profileImageUri}" +
                                "${userDetails.user.image}",
                            fit: BoxFit.cover,
                            scale: 1.7,
                          )
                              : Image.file(
                            tmpFile,
                            fit: BoxFit.cover,
                            scale: 1.7,
                          ),
                        ),
                      ))));
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Container(
              height: 210.0,
              width: 210.0,
              child: Row(
                // shape: RoundedRectangleBorder(
                //   borderRadius: new BorderRadius.only(
                //       bottomLeft: Radius.circular(25.0),
                //       bottomRight: Radius.circular(25.0)),
                // ),
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        height: 190.0,
                        width: 180.0,
                        child: Card(
                          margin: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            new BorderRadius.all(Radius.circular(150.0)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                            new BorderRadius.all(Radius.circular(150.0)),
                            child: tmpFile == null
                                ? "${userDetails.user.image}" == null ||
                                "${userDetails.user.image}" == "null"
                                ? Image.asset(
                              "assets/avatar.png",
                              fit: BoxFit.cover,
                              scale: 1.7,
                            )
                                : Image.network(
                              "${APIData.profileImageUri}" +
                                  "${userDetails.user.image}",
                              fit: BoxFit.cover,
                              scale: 1.7,
                            )
                                : Image.file(
                              tmpFile,
                              fit: BoxFit.cover,
                              scale: 1.7,
                            ),
                          ),
                        ))
                  ]));
        }
      },
    );
  }

//  Creating bottom sheet for selecting profile picture
  Widget bottomSheet() {
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
              onTap: () {
                chooseImageFromCamera();
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.camera,
                      color: Color.fromRGBO(34, 34, 34, 1.0),
                      size: 35,
                    ),
                    Container(
                      width: 250.0,
//                  height: 15.0,
                      child: ListTile(
                        title: Text(
                          'Camera',
                          style:
                          TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),
                        ),
                        subtitle: Text(
                          "Click profile picture from camera.",
                          style:
                          TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),
                        ),
                      ),
                    )
                  ],
                ),
              )),
          InkWell(
              onTap: () {
                chooseImageFromGallery();
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.photo,
                      color: Color.fromRGBO(34, 34, 34, 1.0),
                      size: 35,
                    ),
                    Container(
                      width: 260.0,
                      child: ListTile(
                        title: Text(
                          'Gallery',
                          style:
                          TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),
                        ),
                        subtitle: Text(
                          "Choose profile picture from gallery.",
                          style:
                          TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0),
        ),
      ),
    );
  }

//  Show bottom sheet
  void _onButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 190.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            child: new Container(
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(34, 34, 34, 1.0),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: bottomSheet()),
          );
        });
  }

  Future<String> filesget() {
    return Future.delayed(Duration(seconds: 2), () {
      return "I am data";
      // throw Exception("Custom Error");
    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

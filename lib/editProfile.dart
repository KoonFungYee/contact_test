import 'dart:io';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:contact/contact.dart';
import 'package:contact/offlineDB.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

class EditProfile extends StatefulWidget {
  final String dataID;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String dob;
  final String phoneNo;
  const EditProfile(
      {Key key,
      this.dataID,
      this.firstName,
      this.lastName,
      this.gender,
      this.email,
      this.dob,
      this.phoneNo})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  double font13 = ScreenUtil().setSp(29.9, allowFontScalingSelf: false);
  double font14 = ScreenUtil().setSp(32.2, allowFontScalingSelf: false);
  double font18 = ScreenUtil().setSp(41.4, allowFontScalingSelf: false);
  double font20 = ScreenUtil().setSp(46, allowFontScalingSelf: false);
  var _phonecontroller = MaskedTextController(mask: '000000000000');
  final TextEditingController _firstnamecontroller = TextEditingController();
  final TextEditingController _lastnamecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _dobcontroller = TextEditingController();
  final ScrollController controller = ScrollController();
  List genderList = ["-", "Male", "Female"];
  double _scaleFactor = 1.0;
  File _image;
  String gender;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (widget.dataID != null) {
      gender = widget.gender;
      _firstnamecontroller.text = widget.firstName;
      _lastnamecontroller.text = widget.lastName;
      _emailcontroller.text = widget.email;
      _phonecontroller.text = widget.phoneNo;
      _dobcontroller.text = widget.dob;
    } else {
      gender = "-";
      _firstnamecontroller.text = '';
      _lastnamecontroller.text = '';
      _emailcontroller.text = '';
      _phonecontroller.text = '';
      _dobcontroller.text = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(235, 235, 255, 1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(ScreenUtil().setHeight(85)),
          child: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: _onBackPressAppBar,
              icon: Icon(
                Icons.arrow_back_ios,
                size: ScreenUtil().setWidth(30),
                color: Colors.grey,
              ),
            ),
            elevation: 1,
            centerTitle: true,
            title: Text(
              "Edit Contact",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: font18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: controller,
          child: Container(
            margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: _camera,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: ScreenUtil().setHeight(20),
                            left: ScreenUtil().setWidth(20),
                            child: Container(
                              padding: EdgeInsets.all(200.0),
                              width: ScreenUtil().setWidth(200),
                              height: ScreenUtil().setHeight(200),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            height: ScreenUtil().setHeight(240),
                            width: ScreenUtil().setWidth(240),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(105, 105, 105, 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: ScreenUtil().setHeight(180),
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            margin: EdgeInsets.all(ScreenUtil().setWidth(95)),
                            height: ScreenUtil().setWidth(60),
                            width: ScreenUtil().setWidth(60),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: ScreenUtil().setWidth(50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "First Name",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: font14,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(4),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontSize: font14,
                          ),
                          controller: _firstnamecontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: ScreenUtil().setHeight(10),
                                bottom: ScreenUtil().setHeight(20),
                                top: ScreenUtil().setHeight(-15),
                                right: ScreenUtil().setHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Last Name",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: font14,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(4),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontSize: font14,
                          ),
                          controller: _lastnamecontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: ScreenUtil().setHeight(10),
                                bottom: ScreenUtil().setHeight(20),
                                top: ScreenUtil().setHeight(-15),
                                right: ScreenUtil().setHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Email",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: font14,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(4),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontSize: font14,
                          ),
                          controller: _emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: ScreenUtil().setHeight(10),
                                bottom: ScreenUtil().setHeight(20),
                                top: ScreenUtil().setHeight(-15),
                                right: ScreenUtil().setHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: font14,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(4),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontSize: font14,
                          ),
                          controller: _phonecontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: ScreenUtil().setHeight(10),
                                bottom: ScreenUtil().setHeight(20),
                                top: ScreenUtil().setHeight(-15),
                                right: ScreenUtil().setHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Date of birth",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: font14,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(4),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontSize: font14,
                          ),
                          controller: _dobcontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: ScreenUtil().setHeight(10),
                                bottom: ScreenUtil().setHeight(20),
                                top: ScreenUtil().setHeight(-15),
                                right: ScreenUtil().setHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Gender",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: font14,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(4),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _showBottomSheet();
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                            0,
                            0,
                            0,
                            ScreenUtil().setHeight(20),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.grey.shade400,
                                style: BorderStyle.solid),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: ScreenUtil().setHeight(60),
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setHeight(10),
                                      ScreenUtil().setHeight(16),
                                      0,
                                      0),
                                  child: Text(
                                    gender,
                                    style: TextStyle(
                                      fontSize: font14,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: ScreenUtil().setHeight(10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                BouncingWidget(
                  scaleFactor: _scaleFactor,
                  onPressed: _save,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: ScreenUtil().setHeight(80),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color.fromRGBO(34, 175, 240, 1),
                    ),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: font14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    Database db = await OfflineDB.instance.database;
    if (widget.dataID != null) {
      await db.rawInsert('UPDATE offline SET firstname = "' +
          _firstnamecontroller.text +
          '", lastname = "' +
          _lastnamecontroller.text +
          '", email = "' +
          _emailcontroller.text +
          '", gender = "' +
          gender +
          '", dob = "' +
          _dobcontroller.text +
          '", phone = "' +
          _phonecontroller.text +
          '", WHERE dataid = "' +
          widget.dataID.toString() +
          '"');
    } else {
      await db.rawInsert(
          'INSERT INTO offline (dataid, firstname, lastname, email, gender, dob, phone, favorite) VALUES("' +
              DateTime.now().millisecondsSinceEpoch.toString() +
              '","' +
              _firstnamecontroller.text +
              '","' +
              _lastnamecontroller.text +
              '","' +
              _emailcontroller.text +
              '","' +
              gender +
              '","' +
              _dobcontroller.text +
              '","' +
              _phonecontroller.text +
              '","' +
              'no' +
              '")');
    }

    Navigator.push(
      context,
      AwesomePageRoute(
        transitionDuration: Duration(milliseconds: 600),
        exitPage: widget,
        enterPage: Contact(),
        transition: DefaultTransition(),
      ),
    );
  }

  void _showBottomSheet() {
    FocusScope.of(context).requestFocus(new FocusNode());
    int position;
    switch (gender.toLowerCase()) {
      case 'male':
        position = 1;
        break;
      case 'female':
        position = 2;
        break;
      default:
        position = 0;
    }
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 1, color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(
                            ScreenUtil().setHeight(20),
                          ),
                          child: Text(
                            "Select",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: font14,
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.all(
                              ScreenUtil().setHeight(20),
                            ),
                            child: Text(
                              "Done",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: font14,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                      child: Container(
                    color: Colors.white,
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 28,
                      scrollController:
                          FixedExtentScrollController(initialItem: position),
                      onSelectedItemChanged: (int index) {
                        if (this.mounted) {
                          setState(() {
                            gender = genderList[index];
                          });
                        }
                      },
                      children: _text(),
                    ),
                  ))
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _text() {
    List widgetList = <Widget>[];
    List list = genderList;
    for (var each in list) {
      Widget widget1 = Text(
        each,
        style: TextStyle(
          fontSize: font14,
        ),
      );
      widgetList.add(widget1);
    }
    return widgetList;
  }

  void _camera() async {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              "Action",
              style: TextStyle(
                fontSize: font13,
              ),
            ),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: font20,
                ),
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(context).pop();
                  _image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  // _saveProfilePicture();
                },
                child: Text(
                  "Browse Gallery",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: font20,
                  ),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(context).pop();
                  _image =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  // _saveProfilePicture();
                },
                child: Text(
                  "Take Photo",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: font20,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(context);
    return Future.value(false);
  }
}

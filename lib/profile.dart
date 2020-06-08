import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:contact/editProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final String dataID;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String dob;
  final String phoneNo;
  const Profile(
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
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double font14 = ScreenUtil().setSp(32.2, allowFontScalingSelf: false);
  double font18 = ScreenUtil().setSp(41.4, allowFontScalingSelf: false);
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
            actions: <Widget>[popupMenuButton()],
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
                    Container(
                      width: ScreenUtil().setWidth(250),
                      height: ScreenUtil().setHeight(250),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: ScreenUtil().setHeight(200),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        child: Text(widget.firstName + " " + widget.lastName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: font18),))
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Flexible(child: Text(widget.email))],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Divider(),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[Text('Gender: ')],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: Text(" " + widget.gender),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[Text('Date of birth: ')],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: Text(" " + widget.dob),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[Text('Mobile: ')],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: Text(" +" + widget.phoneNo),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Divider(),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.mobile) {
                          FlutterOpenWhatsapp.sendSingleMessage(
                              widget.phoneNo, "");
                        } else {
                          _toast("No Internet Connection");
                        }
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setHeight(120),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.whatsapp,
                          size: ScreenUtil().setHeight(80),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.mobile) {
                          launch('mailto:' + widget.phoneNo);
                        } else {
                          _toast("No Internet Connection");
                        }
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setHeight(120),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mail,
                          size: ScreenUtil().setHeight(80),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.mobile) {
                          launch('sms:' + widget.phoneNo);
                        } else {
                          _toast("No Internet Connection");
                        }
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setHeight(120),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.sms,
                          size: ScreenUtil().setHeight(80),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.mobile) {
                          launch('tel:' + widget.phoneNo);
                        } else {
                          _toast("No Internet Connection");
                        }
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setHeight(120),
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.call,
                          size: ScreenUtil().setHeight(80),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toast(String message) {
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.slideFromBottomFade,
      reverseAnimation: StyledToastAnimation.slideToBottom,
      position: StyledToastPosition.bottom,
      duration: Duration(milliseconds: 3500),
    );
  }

  Widget popupMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        size: ScreenUtil().setWidth(40),
        color: Colors.grey,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "edit",
          child: Text(
            "Edit",
            style: TextStyle(
              fontSize: font14,
            ),
          ),
        ),
      ],
      onSelected: (selectedItem) {
        switch (selectedItem) {
          case "edit":
            {
              Navigator.of(context).push(
                AwesomePageRoute(
                  transitionDuration: Duration(milliseconds: 600),
                  exitPage: widget,
                  enterPage: EditProfile(
                    dataID: widget.dataID,
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    gender: widget.gender,
                    dob: widget.dob,
                    phoneNo: widget.phoneNo,
                  ),
                  transition: CubeTransition(),
                ),
              );
            }
            break;
        }
      },
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(context);
    return Future.value(false);
  }
}

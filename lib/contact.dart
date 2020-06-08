import 'dart:convert';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:contact/data.dart';
import 'package:contact/editProfile.dart';
import 'package:contact/favorites.dart';
import 'package:contact/offlineDB.dart';
import 'package:contact/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_slidable_list_view/flutter_slidable_list_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sqflite/sqflite.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  String dataURL = 'https://mock-rest-api-server.herokuapp.com/api/v1/user';
  double font14 = ScreenUtil().setSp(32.2, allowFontScalingSelf: false);
  bool first, save, offline, ready, allSelected, favoriteSelected;
  String favorite = 'no';
  List<Info> contact = [];
  List<Info> allContact = [];
  List offlineList = [];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    first = save = offline = ready = false;
    _check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(235, 235, 255, 1),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              ScreenUtil().setHeight(1),
            ),
            child: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          body: Container(
            margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setHeight(20),
                            left: ScreenUtil().setHeight(20),
                          ),
                          height: ScreenUtil().setHeight(75),
                          child: TextField(
                            onChanged: _search,
                            style: TextStyle(
                              fontSize: font14,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 3),
                              hintText: "Search",
                              suffix: IconButton(
                                iconSize: ScreenUtil().setHeight(40),
                                icon: Icon(Icons.keyboard_hide),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                },
                              ),
                              suffixIcon: Icon(
                                Icons.search,
                                size: ScreenUtil().setHeight(50),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: (ready == false)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              JumpingText('Loading...'),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              SpinKitRing(
                                lineWidth: 3,
                                color: Colors.blue,
                                size: 30.0,
                                duration: Duration(milliseconds: 600),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
                          child: SlideListView(
                            itemBuilder: (bc, index) {
                              return GestureDetector(
                                child: Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Icon(Icons.person),
                                      foregroundColor: Colors.white,
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            contact[index].firstName +
                                                " " +
                                                contact[index].lastName,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        (first == true)
                                            ? InkWell(
                                                onTap: () {
                                                  _addFavorite(index);
                                                },
                                                child: Icon(Icons.star_border))
                                            : (contact[index].favorite == 'no')
                                                ? InkWell(
                                                    onTap: () {
                                                      _addFavorite(index);
                                                    },
                                                    child:
                                                        Icon(Icons.star_border))
                                                : Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                  ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      contact[index].email,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    AwesomePageRoute(
                                      transitionDuration:
                                          Duration(milliseconds: 600),
                                      exitPage: widget,
                                      enterPage: Profile(
                                        dataID: contact[index].dataID,
                                        firstName: contact[index].firstName,
                                        lastName: contact[index].lastName,
                                        email: contact[index].email,
                                        gender: contact[index].gender,
                                        dob: contact[index].dob,
                                        phoneNo: contact[index].phoneNo,
                                      ),
                                      transition: StackTransition(),
                                    ),
                                  );
                                },
                                behavior: HitTestBehavior.translucent,
                              );
                            },
                            actionWidgetDelegate: ActionWidgetDelegate(2,
                                (actionIndex, listIndex) {
                              if (actionIndex == 0) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(Icons.edit),
                                    Text('Edit')
                                  ],
                                );
                              } else {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(Icons.close),
                                    Text('Delete')
                                  ],
                                );
                              }
                            }, (int indexInList, int index,
                                    BaseSlideItem item) {
                              if (index == 0) {
                                _redirect(indexInList);
                              } else {
                                item.remove();
                                _delete(indexInList);
                              }
                            }, [Colors.greenAccent, Colors.redAccent]),
                            dataList: contact,
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(80),
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                          child: Text(
                        'All',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    InkWell(
                      onTap: () {
                        if (save == false) {
                          Navigator.of(context).pushReplacement(PageTransition(
                            duration: Duration(milliseconds: 1),
                            type: PageTransitionType.transferUp,
                            child: Favorites(),
                          ));
                        } else {
                          _toast('Data is saving, please try again later');
                        }
                      },
                      child: Container(
                        height: ScreenUtil().setHeight(80),
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                            child: Text(
                          'Favorites',
                          style: TextStyle(color: Colors.black),
                        )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.of(context).push(
                AwesomePageRoute(
                  transitionDuration: Duration(milliseconds: 600),
                  exitPage: widget,
                  enterPage: EditProfile(),
                  transition: CubeTransition(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _redirect(int index) {
    Navigator.of(context).push(
      AwesomePageRoute(
        transitionDuration: Duration(milliseconds: 600),
        exitPage: widget,
        enterPage: EditProfile(
          dataID: contact[index].dataID,
          firstName: contact[index].firstName,
          lastName: contact[index].lastName,
          email: contact[index].email,
          gender: contact[index].gender,
          dob: contact[index].dob,
          phoneNo: contact[index].phoneNo,
        ),
        transition: CubeTransition(),
      ),
    );
  }

  Future<void> _search(String value) async {
    Database db = await OfflineDB.instance.database;
    List list = await db.rawQuery(
        "SELECT * FROM offline WHERE firstname LIKE '%" +
            value +
            "%' OR lastname LIKE '%" +
            value +
            "%' OR email LIKE '%" +
            value +
            "%'");
    
    contact.clear();
      for (var data in list) {
        Info info = Info(
          dataID: data['dataid'],
          firstName: data['firstname'],
          lastName: data['lastname'],
          email: data['email'],
          gender: data['gender'],
          dob: data['dob'],
          phoneNo: data['phone'],
          favorite: data['favorite'],
        );
        contact.add(info);
      }
      if (this.mounted) {
        setState(() {
          ready = true;
        });
      }
  }

  Future<void> _addFavorite(int index) async {
    Database db = await OfflineDB.instance.database;
    await db.rawInsert("UPDATE offline SET favorite = 'yes' WHERE dataid = '" +
        contact[index].dataID +
        "'");
    if (this.mounted) {
      setState(() {
        contact[index].favorite = 'yes';
        ready = true;
      });
    }
  }

  Future<void> _delete(int index) async {
    String dataid;
    if (offline == true) {
      dataid = offlineList[index]['dataid'];
    } else {
      dataid = contact[index].dataID;
    }
    Database db = await OfflineDB.instance.database;
    await db.rawInsert("DELETE FROM offline WHERE dataid = '" + dataid + "'");
  }

  void _check() async {
    Database offlineDB = await OfflineDB.instance.database;
    offlineList = await offlineDB.query(OfflineDB.table);
    if (offlineList.length == 0) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        contact.clear();
        http.get(dataURL).then((res) {
          var jsonData = json.decode(res.body);
          List list = jsonData['data'];
          for (var data in list) {
            Info info = Info(
              dataID: data['id'],
              firstName: data['first_name'],
              lastName: data['last_name'],
              email: data['email'],
              gender: data['gender'],
              dob: data['date_of_birth'],
              phoneNo: data['phone_no'],
            );
            contact.add(info);
          }
          if (this.mounted) {
            setState(() {
              first = true;
              ready = true;
            });
          }
          setData();
        }).catchError((err) {
          print("Get data error: " + (err).toString());
        });
      } else {
        _toast("No Internet Connection");
      }
    } else {
      contact.clear();
      for (var data in offlineList) {
        Info info = Info(
          dataID: data['dataid'],
          firstName: data['firstname'],
          lastName: data['lastname'],
          email: data['email'],
          gender: data['gender'],
          dob: data['dob'],
          phoneNo: data['phone'],
          favorite: data['favorite'],
        );
        contact.add(info);
      }
      if (this.mounted) {
        setState(() {
          ready = true;
        });
      }
    }
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

  Future<void> setData() async {
    if (this.mounted) {
      setState(() {
        save = true;
      });
    }
    Database db = await OfflineDB.instance.database;
    for (int index = 0; index < contact.length; index++) {
      await db.rawInsert(
          'INSERT INTO offline (dataid, firstname, lastname, email, gender, dob, phone, favorite) VALUES("' +
              contact[index].dataID +
              '","' +
              contact[index].firstName +
              '","' +
              contact[index].lastName +
              '","' +
              contact[index].email +
              '","' +
              contact[index].gender +
              '","' +
              contact[index].dob +
              '","' +
              contact[index].phoneNo +
              '","' +
              favorite +
              '")');
    }
    if (this.mounted) {
      setState(() {
        save = false;
      });
    }
  }

  Future<void> offlineMode() async {
    Database offlineDB = await OfflineDB.instance.database;
    offlineList = await offlineDB.query(OfflineDB.table);
    if (this.mounted) {
      setState(() {
        ready = true;
        offline = true;
      });
    }
  }

  Future<bool> _onBackPressAppBar() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                "Are you sure you want to close application?",
                style: TextStyle(
                  fontSize: font14,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("YES"),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                )
              ],
            ));
    return Future.value(false);
  }
}

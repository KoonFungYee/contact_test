import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:contact/contact.dart';
import 'package:contact/data.dart';
import 'package:contact/editProfile.dart';
import 'package:contact/offlineDB.dart';
import 'package:contact/profile.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_slidable_list_view/flutter_slidable_list_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sqflite/sqflite.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  double font14 = ScreenUtil().setSp(32.2, allowFontScalingSelf: false);
  bool nodata, ready, allSelected, favoriteSelected;
  List favoriteList = [];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    nodata = ready = false;
    initial();
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
                      : Center(
                          child: (nodata == true)
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: EmptyListWidget(
                                      packageImage: PackageImage.Image_2,
                                      // title: 'No Data',
                                      subTitle: 'No Data',
                                      titleTextStyle: Theme.of(context)
                                          .typography
                                          .dense
                                          .display1
                                          .copyWith(color: Color(0xff9da9c7)),
                                      subtitleTextStyle: Theme.of(context)
                                          .typography
                                          .dense
                                          .body2
                                          .copyWith(color: Color(0xffabb8d6))),
                                )
                              : Container(
                                  margin: EdgeInsets.all(
                                      ScreenUtil().setHeight(10)),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Text(
                                                    favoriteList[index]
                                                            .firstName +
                                                        " " +
                                                        favoriteList[index]
                                                            .lastName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                              favoriteList[index].email,
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
                                                dataID:
                                                    favoriteList[index].dataID,
                                                firstName: favoriteList[index]
                                                    .firstName,
                                                lastName: favoriteList[index]
                                                    .lastName,
                                                email:
                                                    favoriteList[index].email,
                                                gender:
                                                    favoriteList[index].gender,
                                                dob: favoriteList[index].dob,
                                                phoneNo:
                                                    favoriteList[index].phoneNo,
                                              ),
                                              transition: StackTransition(),
                                            ),
                                          );
                                        },
                                        behavior: HitTestBehavior.translucent,
                                      );
                                    },
                                    actionWidgetDelegate: ActionWidgetDelegate(
                                        2, (actionIndex, listIndex) {
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
                                    dataList: favoriteList,
                                  ),
                                ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(PageTransition(
                          duration: Duration(milliseconds: 1),
                          type: PageTransitionType.transferUp,
                          child: Contact(),
                        ));
                      },
                      child: Container(
                        height: ScreenUtil().setHeight(80),
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                            child: Text(
                          'All',
                          style: TextStyle(color: Colors.black),
                        )),
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(80),
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                          child: Text(
                        'Favorites',
                        style: TextStyle(color: Colors.white),
                      )),
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

  Future<void> _search(String value) async {
    Database db = await OfflineDB.instance.database;
    List list = await db.rawQuery(
        "SELECT * FROM offline WHERE favorite = 'yes' AND firstname LIKE '%" +
            value +
            "%' OR lastname LIKE '%" +
            value +
            "%' OR email LIKE '%" +
            value +
            "%'");
    
    favoriteList.clear();
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
        favoriteList.add(info);
      }
      if (this.mounted) {
        setState(() {
          ready = true;
        });
      }
  }

  void _redirect(int index) {
    Navigator.of(context).push(
      AwesomePageRoute(
        transitionDuration: Duration(milliseconds: 600),
        exitPage: widget,
        enterPage: EditProfile(
          dataID: favoriteList[index].dataID,
          firstName: favoriteList[index].firstName,
          lastName: favoriteList[index].lastName,
          email: favoriteList[index].email,
          gender: favoriteList[index].gender,
          dob: favoriteList[index].dob,
          phoneNo: favoriteList[index].phoneNo,
        ),
        transition: CubeTransition(),
      ),
    );
  }

  Future<void> _delete(int index) async {
    Database db = await OfflineDB.instance.database;
    await db.rawInsert("UPDATE offline SET favorite = 'no' WHERE dataid = '" +
        favoriteList[index].dataID +
        "'");
  }

  Future<void> initial() async {
    Database db = await OfflineDB.instance.database;
    List list =
        await db.rawQuery("SELECT * FROM offline WHERE favorite = 'yes'");
    if (list.length == 0) {
      if (this.mounted) {
        setState(() {
          nodata = true;
          ready = true;
        });
      }
    } else {
      for (var data in list) {
        Info info = Info(
          dataID: data['dataid'],
          firstName: data['firstname'],
          lastName: data['lastname'],
          email: data['email'],
          gender: data['gender'],
          dob: data['dob'],
          phoneNo: data['phone'],
        );
        favoriteList.add(info);
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

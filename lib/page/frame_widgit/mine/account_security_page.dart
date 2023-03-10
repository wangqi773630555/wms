import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/config/config.dart';
import '../../../common/local/local_storage.dart';
import '../../../common/utils/barcolor_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/utils/navigator_utils.dart';

var mYcontext;

/**
 * 账号与安全
 */
class AccountSecurityPage extends StatefulWidget {
  static final String sName = Config.Account_security;

  AccountSecurityPage() : super();

  _AccountSecurityPageState createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  var userId='',username='',nickname='',mobile='',email='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(BarColor.light);
    initParams();
  }

  initParams() async {
    userId = await LocalStorage.get(Config.USERID) ?? '';
    username = await LocalStorage.get(Config.USER_NAME) ?? '';
    nickname = await LocalStorage.get(Config.NICK_NAME) ?? '';
    mobile = await LocalStorage.get(Config.MOBILE) ?? '';
    email = await LocalStorage.get(Config.EMAIL) ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mYcontext = context;
    return Scaffold(
      body: getRootView(),
    );
  }

  Widget getRootView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _toolBar(),
          //标题下面滑动视图
          Expanded(
              child: MediaQuery.removePadding(
                  //由于直接使用listview会在顶部留下空白区域，所以使用MediaQuery.removePadding去除空白
                  context: mYcontext,
                  removeTop: true, //去除顶部的空白
                  child: ListView(
                    children: [
                      //dddd
                      initItem('工号',userId),
                      Divider(height: 1),
                      initItem('账号',username),
                      Divider(height: 1),
                      initItem('姓名',nickname),
                      Divider(height: 1),
                      initItem('手机',mobile),
                      Divider(height: 1),
                      initItem('邮箱',email.replaceAll('null', '')),
                      Divider(height: 1),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      initButton('修改密码'),
                      Divider(height: 1),
                    ],
                  )))
        ],
      ),
    );
  }

  Widget _toolBar() {
    return Container(
      //背景色，注意不能和decoration的color同时使用
      color: Colors.black,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 22, 0, 0)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(mYcontext);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft),
              ),
              Text(
                '账号与安全',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Expanded(
                child: Text(''),
                flex: 1,
              ),
            ],
          )
        ],
      ),
    );
  }

  /**
   * 通用item
   */
  Widget initItem(String title, String content) {
    Widget item = Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(5)),
          Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              )),
          Expanded(
              flex: 3,
              child: Text(
                content,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              )),
        ],
      ),
    );
    return item;
  }

  /**
   * 修改密码
   */
  Widget initButton(String title) {
    Widget item = TextButton(
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(Size(0, 0)),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(5)),
            Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                )),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onPressed: () {
        NavigatorUtils.goChangePassword(mYcontext);
      },
    );
    return item;
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/net/LogUtil.dart';

import '../../../common/config/config.dart';
import '../../../common/config/scanConfig.dart';
import '../../../common/dao/user_dao.dart';
import '../../../common/local/local_storage.dart';
import '../../../common/utils/barcolor_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/utils/scanevent_utils.dart';

class AllCardsPage extends StatefulWidget {
  static final String sName = Config.All_cards;

  AllCardsPage() : super();

  _AllCardsPageState createState() => _AllCardsPageState();
}

class _AllCardsPageState extends State<AllCardsPage> {
  List menuList = [];
  var mYcontext;
  var workId = '';
  var resIds = '';
  List myMenuList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(BarColor.light);
    menuList.clear();
    myMenuList.clear();
    getAppUserList();
    Future.delayed(const Duration(milliseconds: 300), () async {
      authorizeResources();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mYcontext = context;
    return Scaffold(
      /** * 切换底部导航栏的时候动态修改body内容 */
      body: getRootView(),
    );
  }

  Widget getRootView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
        color: Color.fromARGB(255, 226, 236, 252),
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
                      Padding(padding: EdgeInsets.all(3)),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: ListView(
                          // 设置滚动的方式
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), // 禁止滚动
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          children: _createListViewItem(),
                        ),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

//一级列表
  List<Widget> _createListViewItem() {
    List<Widget> _list = [];

    for (int i = 0; i < menuList.length; i++) {
      bool iconVisible = true;
      for (int j = 0; j < myMenuList.length; j++) {
        if (myMenuList[j]['resId'] == menuList[i]['resId']) {
          iconVisible = false;
        }
      }
      Map<String, dynamic> attribute;
      var att = '暂无描述';
      if (menuList[i]['attributes'] != null &&
          menuList[i]['attributes'] != '') {
        attribute = jsonDecode(menuList[i]['attributes']);
        att = attribute['appDesc'] == '' ? '暂无描述' : attribute['appDesc'];
      }
      Widget item = Container(
        //设置控
        padding: EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        //设置整体浮动
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(120, 205, 213, 226),
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ],
        ),
        //背景色，注意不能和decoration的color同时使用
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuList[i]['resId'] == null ? "" : menuList[i]['resId'],
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                Text(
                  menuList[i]['resName'],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Divider(
                  color: Colors.black,
                ),
                Text(
                  att,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
            Expanded(child: Text('')),
            Visibility(
                child: IconButton(
                  onPressed: () {
                    saveApp(
                        i,
                        menuList[i]['resId'],
                        menuList[i]['sort'],
                        menuList[i]['resName'],
                        menuList[i]['resType'],
                        menuList[i]['icon'],
                        menuList[i]['disabled'],
                        menuList[i]['route'],
                        menuList[i]['attributes'].toString());
                  },
                  icon: Icon(Icons.add_box),
                  iconSize: 40,
                  color: Colors.black,
                ),
                visible: iconVisible),
          ],
        ),
      );
      _list.add(item);
    }
    return _list;
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
                '选择卡片',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
            ],
          )
        ],
      ),
    );
  }

  //获取全部卡片
  authorizeResources() {
    UserDao.getAuthorizeResources('').then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        List menu = data?['permissions'];
        menuList.addAll(menu);
        setState(() {});
      }
    });
  }

  //获取我的应用
  getAppUserList() {
    UserDao.getAppUserList(2).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        myMenuList = data;
        setState(() {});
      }
    });
  }

  //添加应用
  saveApp(i, resId, sort, resName, resType, icon, disabled, route, attributes) {
    UserDao.saveApp(
            resId, sort, resName, resType, icon, disabled, route, attributes)
        .then((res) {
      if (res != null && res.result) {
        getAppUserList();
        //刷新首页及我的卡片页面
        ScanEventUtils.send(ScanConfig.MAIN_REFRESH, '');
        Config.REFRESH = 1;
      }
    });
  }
}

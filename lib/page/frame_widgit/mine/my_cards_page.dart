import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/net/LogUtil.dart';

import '../../../common/config/config.dart';
import '../../../common/config/scanConfig.dart';
import '../../../common/dao/user_dao.dart';
import '../../../common/event/scan_event.dart';
import '../../../common/local/local_storage.dart';
import '../../../common/utils/barcolor_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/utils/navigator_utils.dart';
import '../../../common/utils/scanevent_utils.dart';

class MyCardsPage extends StatefulWidget {
  static final String sName = Config.My_cards;

  MyCardsPage() : super();

  _MyCardsPageState createState() => _MyCardsPageState();
}

class _MyCardsPageState extends State<MyCardsPage> {
  List menuList = [];
  var mYcontext;
  var workId = '';
  StreamSubscription? stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(BarColor.light);
    stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
      if (event.page == ScanConfig.MAIN_REFRESH) {
        LogUtil.d("刷新我的卡片");
        getAppUserList();
      }
    });
    menuList.clear();
    getAppUserList();
  }
  @override
  void dispose() async {
    super.dispose();
    if (stream != null) {
      stream?.cancel();
      stream = null;
    }
    print('dispose_load_details');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mYcontext = context;
    return Scaffold(
        appBar: AppBar(
          title: Text('我的卡片'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                NavigatorUtils.goPage(context,Config.All_cards);
              },
              icon: const Icon(Icons.add),
              iconSize: 30,
              color: Colors.white,
            ),
          ],
        ),
        body: getRootView());
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
          //_toolBar(),
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
                Divider(color: Colors.black,),
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
            IconButton(onPressed: () {
              removeApp(menuList[i]['resId']);
            },
                icon: Icon(Icons.delete_forever_outlined),
              iconSize: 40,
              color: Colors.red,

            )
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
                '我的卡片',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      NavigatorUtils.goPage(context,Config.All_cards);
                    },
                    icon: const Icon(Icons.add),
                    iconSize: 30,
                    color: Colors.white,
                  ),
                ),
                flex: 1,
              ),
            ],
          )
        ],
      ),
    );
  }

  //获取我的应用
  getAppUserList() {
    UserDao.getAppUserList(2).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        menuList = data;
        setState(() {});

      }
    });
  }

  //移除应用
  removeApp(resId) {
    UserDao.removeApp(resId).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        getAppUserList();
        ScanEventUtils.send(ScanConfig.MAIN_REFRESH, '');
        Config.REFRESH=1;
      }
    });
  }

}

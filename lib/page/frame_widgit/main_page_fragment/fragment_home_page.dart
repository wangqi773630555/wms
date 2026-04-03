import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wanma_print/common/net/LogUtil.dart';
import '../../../common/config/config.dart';
import '../../../common/config/scanConfig.dart';
import '../../../common/dao/user_dao.dart';
import '../../../common/event/scan_event.dart';
import '../../../common/local/local_storage.dart';
import '../../../common/utils/navigator_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/utils/scanevent_utils.dart';
import '../../../main.dart';
import '../../common_widgit/line/divider_dotted.dart';
import 'package:cached_network_image/cached_network_image.dart';

var mYcontext;
List<dynamic> gridList = [];
List<dynamic> cardList = [];
bool isFirst = true;

class FragmentHomePage extends StatefulWidget {
  FragmentHomePage() : super();

  _FragmentHomePageState createState() => _FragmentHomePageState();
}

class _FragmentHomePageState extends State<FragmentHomePage> with RouteAware {
  StreamSubscription? stream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (isFirst || gridList.isEmpty||gridList.length==1) {
      getAppUserList();
      //getAppUserListForCards();
      stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
        if (event.page == ScanConfig.MAIN_REFRESH) {
          LogUtil.d("刷新首页菜单");
          isFirst = true;
          getAppUserList();
          //getAppUserListForCards();
        }
      });
    }
    isFirst = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mYcontext = context;
    // secondList.clear();
    //secondList.add("第1条数据\n");
    //secondList.add("第2条数据\n");

    //firstList.clear();
    //firstList.add("任务列表1");

    return getRootView();
  }

  Widget getRootView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter, //渐变开始于上面的中间开始
              end: Alignment.bottomCenter, //渐变结束于下面的中间
              colors: [Color(0xFFE0EAFE), Color(0x10E0EAFE)])),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 26, 0, 0)),
          Container(
            padding: EdgeInsets.all(5),
            //背景色，注意不能和decoration的color同时使用
            child: Text(
              '首页',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          //标题下面滑动视图
          Expanded(
              child: MediaQuery.removePadding(
                  //由于直接使用listview会在顶部留下空白区域，所以使用MediaQuery.removePadding去除空白
                  context: mYcontext,
                  removeTop: true, //去除顶部的空白
                  child: ListView(
                    children: [
                      _createBanner(),
                      Container(
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
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: GridView(
                          // 设置滚动的方式
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          // 禁止滚动
                          padding: EdgeInsets.all(0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                          ),
                          children: _createGridViewItem(),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ListView(
                          // 设置滚动的方式
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), // 禁止滚动
                          padding: EdgeInsets.all(0),
                          children: _createListViewItem(),
                        ),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

//创建banner
  Widget _createBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(5)),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          "images/home/banner.png",
          width: double.maxFinite,
        ),
      ),
      /*child: Image.asset(
        'images/home/banner.png',
        fit: BoxFit.cover,
      ),*/
      /* color: Colors.teal,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      height: 120,*/
    );
  }

//grid列表
  List<Widget> _createGridViewItem() {
    List<Widget> _list = [];
    if (gridList == null) {
      return _list;
    }
    for (int i = 0; i < gridList.length; i++) {
      Widget item = Container(
        //color: Colors.primaries[i],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageWrapper(gridList[i]['icon']),
            Padding(padding: EdgeInsets.all(4)),
            Text(
              gridList[i]['resName'],
              style: TextStyle(
                  color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
            )
          ],
        ),
      );
      _list.add(TextButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(Size(0, 0)),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        child: item,
        onPressed: () {
          if (i == gridList.length - 1) {
            NavigatorUtils.goMainTabMore(mYcontext);
            //打开
            //NavigatorUtils.goPage(context, "scan_sign_in");
            //下架
            //NavigatorUtils.goPage(context, "shelves_down");
            //移库
            //NavigatorUtils.goPage(context, "warehouse_move");
            //调库
            //NavigatorUtils.goPage(context, "warehouse_adjust");
            //当前任务
            //NavigatorUtils.goPage(context, "current_task");
            //查询检验任务
            //NavigatorUtils.goPage(context, "task_list");

          } else if (gridList[i]['route'] == 'materialDetail') {
            //扫码收货
            NavigatorUtils.goMaterialDetail(context, '');
          } else if(gridList[i]['route']=='scanSignin'){
            NavigatorUtils.goPage(
              context,
              'scan_sign_in',
            );
          } else {
            NavigatorUtils.goPage(
              context,
              gridList[i]['route'],
            );
          }
        },
      ));
    }
    return _list;
  }

  //一级列表
  List<Widget> _createListViewItem() {
    List<Widget> _list = [];
    for (int i = 0; i < cardList.length; i++) {
      Widget item = Container(
        //设置控
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardList[i]['resName'],
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
            _createGridViewItemCard(i),
          ],
        ),
      );
      _list.add(item);
    }
    return _list;
  }

  //二级grid列表
  Widget _createGridViewItemCard(int index) {
    List<Widget> _list = [];
    List childrenList = cardList[index]['appInfo'] ?? [];

    for (int i = 0; i < childrenList.length; i++) {
      Widget item = Container(
        //color: Colors.primaries[i],
        child: Stack(alignment: AlignmentDirectional.topCenter, children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _imageWrapper(childrenList[i]['icon']),
              Padding(padding: EdgeInsets.all(4)),
              Text(
                childrenList[i]['resName'],
                style: TextStyle(
                    color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
              )
            ],
          ),
        ]),
      );
      _list.add(TextButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(Size(0, 0)),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        child: item,
        onPressed: () {
          if (childrenList[i]['route'] == 'materialDetail') {
            //扫码收货
            NavigatorUtils.goMaterialDetail(context, '');
          } else {
            NavigatorUtils.goPage(
              context,
              childrenList[i]['route'],
            );
          }
        },
      ));
    }
    return GridView(
      // 设置滚动的方式
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // 禁止滚动
      padding: EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      children: _list,
    );
  }

  Widget _imageWrapper(String imageUrl) {
    if (imageUrl != '') {
      return SizedBox(
        width: 30,
        height: 30,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          //  placeholder: (context, url) => Image.asset('images/home/gengduo.png'),
          errorWidget: (context, url, error) =>
              Image.asset('images/home/gengduo.png'),
        ),
      );
    } else {
      return SizedBox(
        width: 30,
        height: 30,
        child: Image.asset('images/home/gengduo.png'),
      );
    }
  }

  /**
   * 获取首页应用
   */
  getAppUserList() {
    UserDao.getAppUserList(1).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        gridList.clear();
        if (data != null) {
          gridList = data;
        }
        Map map = Map();
        map['resName'] = '更多';
        map['icon'] = '';
        map['route'] = 'maintabmore';
        gridList.add(map);
        setState(() {
          isFirst = false;
        });
      }else{
        gridList.clear();
        Map map = Map();
        map['resName'] = '更多';
        map['icon'] = '';
        map['route'] = 'maintabmore';
        gridList.add(map);
        setState(() {
          isFirst = false;
        });
      }
    });
  }

  /**
   * 获取首页应用
   */
  getAppUserListForCards() {
    UserDao.getAppUserList(2).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        cardList.clear();
        if (data != null) {
          cardList = data;
        }
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    LogUtil.d("resume${Config.REFRESH}");
    if (Config.REFRESH == 1) {
      Config.REFRESH = 0;
      getAppUserList();
      //getAppUserListForCards();
    }
    super.didPopNext();
  }
}

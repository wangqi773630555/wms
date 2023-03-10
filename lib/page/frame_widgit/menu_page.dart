import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/config/config.dart';
import '../../common/config/scanConfig.dart';
import '../../common/dao/user_dao.dart';
import '../../common/utils/barcolor_util.dart';
import '../../common/utils/navigator_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../common/utils/scanevent_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MenuPage extends StatefulWidget {
  static final String sName = Config.Main_tab_more;

  MenuPage() : super();

  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool visible = false;
  List menuList = [];
  var mYcontext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(BarColor.light);
    menuList.clear();
    authorizeResources();
    getAppUserList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mYcontext = context;
    return Scaffold(
      /*appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text("")
      ),*/
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
      Widget item = Container(
        //设置控
        padding: EdgeInsets.all(10),
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
              menuList[i]['resName'],
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
            _createGridViewItem(i),
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
                '我的应用',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        visible = !visible;
                      });
                    },
                    child: Text(
                      visible ? '取消' : '编辑',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
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

//二级grid列表
  Widget _createGridViewItem(int index) {




    List<Widget> _list = [];
    List childrenList = menuList[index]['children'] ?? [];

    for (int i = 0; i < childrenList.length; i++) {
      //判断是否已添加
      bool showAdd = true;
      if(index!=0){
        List myChildrenList = menuList[0]['children'] ?? [];
        for(int k = 0;k<myChildrenList.length;k++){
            if(myChildrenList[k]['resId']==childrenList[i]['resId']){
              showAdd = false;
              break;
            }
        }
      }

      Widget item = Container(
        //color: Colors.primaries[i],
        child: Stack(alignment: AlignmentDirectional.topCenter, children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: visible, // 设置是否可见：true:可见 false:不可见
                child: Padding(padding: EdgeInsets.all(8)),
              ),
             /* Image.asset(
                'images/home/gengduo.png',
                fit: BoxFit.contain,
                width: 30,
                height: 30,
              ),*/
              _imageWrapper(childrenList[i]['icon']),
              Padding(padding: EdgeInsets.all(4)),
              Text(
                childrenList[i]['resName'],
                style: TextStyle(
                    color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
              )
            ],
          ),
          Visibility(
            visible: visible&&showAdd, // 设置是否可见：true:可见 false:不可见
            child: Container(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    if (index == 0) {
                      //Fluttertoast.showToast(msg: '移除');
                      removeApp(childrenList[i]['resId']);
                    } else {
                      //Fluttertoast.showToast(msg: '添加');
                      saveApp(
                          childrenList[i]['resId'],
                          childrenList[i]['sort'],
                          childrenList[i]['resName'],
                          childrenList[i]['resType'],
                          childrenList[i]['icon']);
                    }
                  },
                  icon: index == 0
                      ? Icon(Icons.remove_circle_outline, color: Colors.grey)
                      : Icon(Icons.add_circle_outline, color: Colors.blue)),
            ),
          ),
        ]),
      );
      _list.add(GestureDetector(
        child: item,
        onTap: () {
          // NavigatorUtils.goMainTabMore(mYcontext);
          Fluttertoast.showToast(msg: '进入功能页面');
          NavigatorUtils.goPage(context, childrenList[i]['route'],);
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
    return SizedBox(
      width: 30,
      height: 30,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Image.asset('images/home/gengduo.png'),
        errorWidget: (context, url, error) =>
            Image.asset('images/home/gengduo.png'),
      ),
    );
}

  authorizeResources() {
    setState(() {
      Map map = Map();
      map['resName'] = '我的应用';
      menuList.add(map);
    });
    UserDao.getAuthorizeResources('').then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        List menu = data?['menus'];

        menuList.addAll(menu);
        setState(() {});
      }
    });
  }
  //获取我的应用
  getAppUserList() {
    UserDao.getAppUserList().then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        menuList[0]['children'] = data;
        setState(() {});

      }
    });
  }

  //添加应用
  saveApp(resId, sort, resName, resType, icon) {
    UserDao.saveApp(resId, sort, resName, resType, icon).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        getAppUserList();
        ScanEventUtils.send(ScanConfig.MAIN_REFRESH, '');
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
      }
    });
  }


}

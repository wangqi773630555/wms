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
import '../../common_widgit/line/divider_dotted.dart';
import 'package:cached_network_image/cached_network_image.dart';


var mYcontext;
List<String> secondList = [];
List<String> firstList = [];
List<dynamic> gridList = [];
bool isFirst = true;

class FragmentHomePage extends StatefulWidget {
  FragmentHomePage() : super();

  _FragmentHomePageState createState() => _FragmentHomePageState();
}

class _FragmentHomePageState extends State<FragmentHomePage> {

  StreamSubscription? stream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   /* gridList.clear();
    Map map = Map();
    map['resName'] = '更多';
    map['icon'] = 'images/home/gengduo.png';
    map['route'] = 'maintabmore';
    gridList.add(map);*/
    if(isFirst) {
      getAppUserList();
      stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
        if (event.page == ScanConfig.MAIN_REFRESH) {
          LogUtil.d("刷新首页菜单");
          isFirst = true;
          getAppUserList();
        }
      });
    }
    isFirst = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mYcontext = context;
    secondList.clear();
    secondList.add("第1条数据\n");
    secondList.add("第2条数据\n");
    secondList.add("第3条数据\n");
    secondList.add("第4条数据\n");
    secondList.add("第5条数据\n");
    secondList.add("第6条数据\n");
    secondList.add("第7条数据\n");

    firstList.clear();
    firstList.add("任务列表1");
    firstList.add("任务列表2");
    firstList.add("任务列表3");


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
      child: Image.asset(
        'images/home/icon_banner.png',
        fit: BoxFit.cover,
      ),
      /* color: Colors.teal,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      height: 120,*/
    );
  }

//grid列表
  List<Widget> _createGridViewItem() {
    List<Widget> _list = [];
    if(gridList==null){
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
      _list.add(GestureDetector(
        child: item,
        onTap: () {
          if (i == gridList.length - 1) {
            NavigatorUtils.goMainTabMore(mYcontext);
          }else{
            NavigatorUtils.goPage(context, gridList[i]['route'],);
          }
        },
      ));
    }
    return _list;
  }

//一级列表
  List<Widget> _createListViewItem() {
    List<Widget> _list = [];
    for (int i = 0; i < firstList.length; i++) {
      Widget item = Container(
        //设置控
        padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  firstList[i],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(child: Text("")),
                TextButton(
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
                        Text(
                          '去处理',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.normal),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(msg: '暂未开通');
                  },
                ),
              ],
            ),
            _createSecondListViewItem(secondList),
          ],
        ),
      );
      _list.add(item);
    }
    return _list;
  }

//二级列表
  Widget _createSecondListViewItem(List<String> list) {
    List<Widget> _list = [];
    for (int i = 0; i < list.length; i++) {
      _list.add(_createItem());
    }
    return Column(
      children: _list,
    );
  }

  Widget _createItem(){
    Widget item = Container(
      padding: EdgeInsets.only(right: 10),
      child: Column(children: [
        MySeparator(color: Colors.grey),
        /*每行数据*/
        Padding(padding: EdgeInsets.all(3)),
        Row(children: [
          Text(
            '检验号:',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13,fontWeight: FontWeight.bold),
          ),
          Text(
            '2819739000:',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
          Expanded(child: Text('')),
          Container(
            padding: EdgeInsets.fromLTRB(10, 4, 10,4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 218, 249, 215),
                ),
              ],
            ),
            child: Text('巡检',style: TextStyle(color: Color.fromARGB(255, 45, 202, 3),fontSize: 11),),
          ),
        ],),
        Padding(padding: EdgeInsets.all(3)),
        /*每行数据*/
        Row(children: [
          Text(
            '供应商',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
          Expanded(child: Text('')),
          Text(
            '浙江万马天屹有限公司',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
        ],),
        Padding(padding: EdgeInsets.all(3)),
        /*每行数据*/
        Row(children: [
          Text(
            '供应商编码',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
          Expanded(child: Text('')),
          Text(
            '01822338889',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
        ],),
        Padding(padding: EdgeInsets.all(3)),
        /*每行数据*/
        Row(children: [
          Text(
            '内向交货单号',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
          Expanded(child: Text('')),
          Text(
            '283839',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
        ],),
        Padding(padding: EdgeInsets.all(3)),
        /*每行数据*/
        Row(children: [
          Text(
            '送货日期',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
          Expanded(child: Text('')),
          Text(
            '2022-10-10',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
        ],),
        Padding(padding: EdgeInsets.all(3)),
        /*每行数据*/
        Row(children: [
          Text(
            '订单号',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
          Expanded(child: Text('')),
          Text(
            '2893302002',
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 51), fontSize: 13),
          ),
        ],),
        Padding(padding: EdgeInsets.all(3)),

      ],),

    );
    return item;
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

  /**
   * 获取首页应用
   */
  getAppUserList(){
    UserDao.getAppUserList().then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        gridList.clear();
        if(data!=null){
          gridList = data;
        }
        Map map = Map();
        map['resName'] = '更多';
        map['icon'] = 'images/home/gengduo.png';
        map['route'] = 'maintabmore';
        gridList.add(map);
        setState(() {
        });

      }
    });
  }




}

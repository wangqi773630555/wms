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

class ChangeWorkPage extends StatefulWidget {
  static final String sName = Config.Change_work;

  ChangeWorkPage() : super();

  _ChangeWorkPageState createState() => _ChangeWorkPageState();
}

class _ChangeWorkPageState extends State<ChangeWorkPage> {
  List workList = [];
  var mYcontext;
  var workId='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(BarColor.light);
    workList.clear();
    getWorks();
  }

  getWorks() async {
    workId = await LocalStorage.get(Config.WORK_ID);
    LogUtil.d(workId);
    var data = await LocalStorage.get(Config.PRE_AUTHORIZE_DATA);
    setState(() {
      workList = json.decode(data);
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
    for (int i = 0; i < workList.length; i++) {
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
        child:Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workList[i]['orgName'],
                style:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 14),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),

              Row(children: [
                Visibility(child: Text(
                  '[默认]',
                  style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 16),
                ),visible: workList[i]['isMain']==1,),
                Visibility(child: Text(
                  '[当前]',
                  style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 16),
                ),visible: workList[i]['id']==workId,),

                Text(
                    workList[i]['positionName'],
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                ),
              ],),

              Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
              Text(
                workList[i]['deptName'],
                style:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 14),
              ),
            ],
          ),
          Expanded(child: Text('')),
          Visibility(child:  ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            onPressed: () => {
              authorizeResources(workList[i]['deptName'], workList[i]['positionName'],workList[i]['id'],workList[i]['orgName']),
            },
            child: Text('切换\n工作'),
          ),visible: workList[i]['id']!=workId,)

        ],),
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
                '切换工作',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Expanded(
                child: Container(
                ),
                flex: 1,
              ),
            ],
          )
        ],
      ),
    );
  }


  /**
   * 授权
   */
  authorizeResources(deptName,positionName,id,orgName) {
    UserDao.getAuthorizeResources(id).then((res) {
      if (res != null && res.result) {
        LocalStorage.save(Config.DEPT_NAME, deptName);
        LocalStorage.save(Config.POSITION_NAME, positionName);
        LocalStorage.save(Config.WORK_ID, id);
        LocalStorage.save(Config.ORG_NAME, orgName);
        workId = id;
        ScanEventUtils.send(ScanConfig.MAIN_REFRESH, '');
        setState(() {
          Fluttertoast.showToast(msg: '切换成功');
        });
      }
    });
  }



}

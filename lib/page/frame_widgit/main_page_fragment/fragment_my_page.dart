import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../FlutterPlugins.dart';
import '../../../common/config/config.dart';
import '../../../common/dao/user_dao.dart';
import '../../../common/local/local_storage.dart';
import '../../../common/net/LogUtil.dart';
import '../../../common/utils/navigator_utils.dart';

import '../../../main.dart';
import 'package:package_info_plus/package_info_plus.dart';



class FragmentMyPage extends StatefulWidget {
  FragmentMyPage() : super();

  _FragmentMyPageState createState() => _FragmentMyPageState();
}

class _FragmentMyPageState extends State<FragmentMyPage> with RouteAware{
  String version='';
  String buildNumber ='';
  var mYcontext;
  var nickName="",orgName="",positionName="";
  //1 有更新 0无更新
  var androidHasNewVerson ='0';
  var iosHasNewVerson ='0';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initParams();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      if(Theme.of(context).platform == TargetPlatform.android){
        //获取Android versionName
        version = packageInfo.version;
        LogUtil.d('android'+version);
      }else{
        version = packageInfo.buildNumber;
        LogUtil.d('ios'+version);
      }
      setState(() {

      });
    });
    getAppVersion();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mYcontext = context;
    return getRootView();
  }


  initParams() async {
    nickName = await LocalStorage.get(Config.NICK_NAME) ?? '';
    orgName = await LocalStorage.get(Config.ORG_NAME) ?? '';
    positionName = await LocalStorage.get(Config.POSITION_NAME) ?? '';
    setState(() {

    });
  }

  Widget getRootView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
          //color: Color(0xFFE0EAFE),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
         // Padding(padding: EdgeInsets.fromLTRB(0,26, 0, 0)),
          Container(
            width: double.infinity,
            color: Color(0xFFE0EAFE),
            padding: EdgeInsets.fromLTRB(5, 30, 5, 5),
            //背景色，注意不能和decoration的color同时使用
            child: Text(
              '我的',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: MediaQuery.removePadding(
              //由于直接使用listview会在顶部留下空白区域，所以使用MediaQuery.removePadding去除空白
              context: mYcontext,
              removeTop: true, //去除顶部的空白
              child: ListView(
                children: [
                  initHead(),
                  Divider(
                    height: 1,
                    color: Color.fromARGB(50, 0, 0, 0),
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  initItem('images/mine/app.png', '我的应用'),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  initItem('images/mine/card.png', '我的卡片'),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  initPointItem('images/mine/message.png', '通知消息', 10),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  initItem('images/mine/safe.png', '账户与安全'),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  initItem('images/mine/help.png', '帮助与反馈'),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  initItem('images/mine/print.png', '纸张校验'),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  initAboutItem('images/mine/about.png', '关于', '版本号'+version),
                  Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    height: 1,
                  ),
                  loginOut(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget initHead() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(15, 20, 10, 0),
      //color: Color(0xFFE0EAFE),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter, //渐变开始于上面的中间开始
              end: Alignment.bottomCenter, //渐变结束于下面的中间
              colors: [Color(0xFFE0EAFE), Color(0x10E0EAFE)])),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 20, 10),
            height: 55,
            width: 55,
            child: CircleAvatar(
              backgroundImage: AssetImage('images/logo.png'),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(orgName,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.left),
                  Padding(padding: EdgeInsets.all(5)),
                  Text(positionName,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.left),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        //store.state.userInfo!.userName ?? '',
                        nickName,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      Expanded(child: Text('')),
                      Container(
                        child: TextButton(
                          child: Text(
                            '切换工作 >',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                           // Fluttertoast.showToast(msg: '暂未开通');
                            NavigatorUtils.goChangeWork(mYcontext);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 通用item
   */
  Widget initItem(String path, String title) {
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
            Image.asset(
              path,
              fit: BoxFit.cover,
              width: 20,
              height: 20,
            ),
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
        if(title=='我的应用'){
          NavigatorUtils.goMainTabMore(mYcontext);
        }else if(title=='我的卡片'){
          NavigatorUtils.goPage(context,Config.My_cards);
        }else if(title=='账户与安全'){
          NavigatorUtils.goAccountSecurity(mYcontext);
        }else if(title=='帮助与反馈'){
          Fluttertoast.showToast(msg: '暂未开通');
        }else if(title=='纸张校正'){
          FlutterPlugins.walk().then((value) => {});
        }
      },
    );
    return item;
  }

  /**
   * 待消息红点的item
   */
  Widget initPointItem(String path, String title, int count) {
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
            Image.asset(
              path,
              fit: BoxFit.cover,
              width: 20,
              height: 20,
            ),
            Padding(padding: EdgeInsets.all(5)),
            Expanded(
                child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            )),
            Visibility(child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(150),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),visible: false,),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onPressed: () {
        if(title=='通知消息'){
          Fluttertoast.showToast(msg: '暂未开通');
        }
      },
    );
    return item;
  }

  /**
   * 关于item
   */
  Widget initAboutItem(String path, String title, String version) {
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
            Image.asset(
              path,
              fit: BoxFit.cover,
              width: 20,
              height: 20,
            ),
            Padding(padding: EdgeInsets.all(5)),
            Expanded(
                child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            )),
            Text(
              version,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Visibility(child:  Container(
              width: 30,
              height: 16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(150),
              ),
              child: Text(
                '新',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            visible: androidHasNewVerson=='1'||iosHasNewVerson=='1',
            ),

            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onPressed: () {
        if(title=='关于'){
          getAppVersionForUpdate();
        }
      },
    );
    return item;
  }

  getAppVersion(){
    var androidVersionCode;
    var androidFile;
    UserDao.getAppVersion().then((res) {
      if (res != null && res.result) {
        List data = res.data['data'];
        for(int i=0;i<data.length;i++){
          if(data[i]['type'].toString()=='1'){
            //android
            androidVersionCode = data[i]['version'];
            androidFile = data[i]['file'];
            FlutterPlugins.update('$androidVersionCode;$androidFile').then((value) => {setState(() {})});
          }else if(data[i]['type'].toString()=='2'){
            //ios
            //Todo 处理Ios版本更新逻辑

          }
        }

      }
    });
  }

  Widget loginOut() {
    return Container(
      margin: EdgeInsets.all(10),
      child: OutlinedButton(
        onPressed: () {
          NavigatorUtils.exitToLogin(context);
        },
        child: Text(
          '退出登录',
          style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.normal),
        ),
      ),
    );
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
    LogUtil.d('onResumeMy');
    initParams();
    super.didPopNext();
  }

  getAppVersionForUpdate(){
    var androidVersionCode='';
    var iosVersionCode='';
    UserDao.getAppVersion().then((res) {
      if (res != null && res.result) {
        List data = res.data['data'];
        for(int i=0;i<data.length;i++){
          if(data[i]['type'].toString()=='1'){
            //android
            androidVersionCode = data[i]['version'];
            FlutterPlugins.getVersion(androidVersionCode.toString()).then((value) => {setState(() {
              androidHasNewVerson = value.toString();
              LogUtil.d(androidHasNewVerson+'版本');
            })});
          }else if(data[i]['type'].toString()=='2'){
            //ios
            iosVersionCode = data[i]['version'];

            //Todo 获取Ios版本并和接口返回的version对比 需要更新时 为iosHasNewVerson赋值为‘1’，不组要更新时为iosHasNewVerson赋值为‘0’

          }
        }

      }
    });


  }
}

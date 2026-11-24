import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:wanma_print/common/dao/user_dao.dart';
import 'package:wanma_print/common/redux/wm_state.dart';
import 'package:wanma_print/common/style/wm_style.dart';
import 'package:wanma_print/common/utils/common_utils.dart';
import 'dart:async';
import 'package:wanma_print/common/utils/navigator_utils.dart';

import '../FlutterPlugins.dart';

class WelcomePage extends StatefulWidget {
  static final String sName = '/';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;

  @override
  void initState() {
    //版本更新
   /* var versionCode = 1;
    var url = 'http://appdownload.wanmagroup.com:8900/androidWeb/download/TST/wanma_equipment.apk';
    FlutterPlugins.update('$versionCode;$url').then((value) => {setState(() {})});*/
    getAppVersion();
  }

  getAppVersion(){
    var androidVersionCode;
    var iosVersionCode;
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
            iosVersionCode = data[i]['version'];
            //Todo 处理Ios版本更新逻辑

          }
        }

      }
    });
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (hadInit) return;
    hadInit = true;
    //防止多次进入
    Store<WMState> store = StoreProvider.of(context);
    Future.delayed(const Duration(seconds: 2), () {
      UserDao.initUserInfo(store).then((res) {
        if (res != null && res.result) {
          NavigatorUtils.goHome(context);
        } else {
          NavigatorUtils.goLogin(context);
        }
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<WMState>(
      builder: (context, store) {
        return Container(
          color: Color(WMColors.white),
          child: Image.asset('images/launch_image.png'),
        );
      },
    );
  }
}

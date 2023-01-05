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
   // CommonUtils.checkPermissionStorage();

    //版本更新
   /* var versionCode = 2;
    var url = 'http://appdownload.wanmagroup.com:8900/androidWeb/download/TST/wanma_equipment.apk';
    FlutterPlugins.update('$versionCode;$url').then((value) => {setState(() {})});*/
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

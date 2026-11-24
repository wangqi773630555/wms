import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:wanma_print/common/dao/user_dao.dart';
import 'package:wanma_print/common/redux/wm_state.dart';
import 'package:wanma_print/common/style/wm_style.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';

import '../FlutterPlugins.dart';

class WelcomePage extends StatefulWidget {
  static final String sName = '/';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;
  bool _navigated = false;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    // 版本更新检查只在 Android 做：iOS 的版本更新逻辑是空 Todo，
    // 启动阶段发网络请求 + 调原生插件在 iOS 上容易抛异常、拖住启动流程。
    if (Platform.isAndroid) {
      try {
        getAppVersion();
      } catch (e) {
        debugPrint('SPLASH getAppVersion error: $e');
      }
    }
  }

  getAppVersion() {
    var androidVersionCode;
    var androidFile;
    UserDao.getAppVersion().then((res) {
      if (res != null && res.result) {
        List data = res.data['data'];
        for (int i = 0; i < data.length; i++) {
          if (data[i]['type'].toString() == '1') {
            //android
            androidVersionCode = data[i]['version'];
            androidFile = data[i]['file'];
            FlutterPlugins.update('$androidVersionCode;$androidFile')
                .then((_) {
              if (mounted) setState(() {});
            }).catchError((e) {
              debugPrint('SPLASH update error: $e');
            });
          }
        }
      }
    }).catchError((e) {
      debugPrint('SPLASH getAppVersion network error: $e');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hadInit) return;
    hadInit = true;

    Store<WMState> store = StoreProvider.of<WMState>(context);

    // 兜底：无论初始化发生什么，8 秒后一定离开启动页。
    _fallbackTimer = Timer(const Duration(seconds: 8), () {
      debugPrint('SPLASH fallback timeout -> goLogin');
      _goTo(goHome: false);
    });

    Future.delayed(const Duration(seconds: 2), () async {
      try {
        final res = await UserDao.initUserInfo(store)
            .timeout(const Duration(seconds: 6));
        debugPrint('SPLASH initUserInfo done: result=${res?.result}');
        _goTo(goHome: res != null && res.result);
      } catch (e, stack) {
        debugPrint('SPLASH initUserInfo error: $e');
        debugPrintStack(stackTrace: stack);
        _goTo(goHome: false);
      } finally {
        _fallbackTimer?.cancel();
      }
    });
  }

  void _goTo({required bool goHome}) {
    if (_navigated) return;
    if (!mounted) return;
    _navigated = true;
    if (goHome) {
      NavigatorUtils.goHome(context);
    } else {
      NavigatorUtils.goLogin(context);
    }
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
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

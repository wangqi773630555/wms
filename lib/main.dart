import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import 'package:wanma_print/common/event/http_error_event.dart';
import 'package:wanma_print/common/model/User.dart';
import 'package:wanma_print/common/net/code.dart';
import 'package:wanma_print/common/redux/wm_state.dart';
import 'package:wanma_print/common/style/wm_style.dart';
import 'package:wanma_print/common/utils/common_utils.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';
import 'package:wanma_print/page/load%20material/load_details.dart';
import 'package:wanma_print/page/load%20material/load_list.dart';
import 'package:wanma_print/page/load%20material/load_process.dart';
import 'package:wanma_print/page/print_page.dart';
import 'package:wanma_print/page/receipt_management/material_detail.dart';
import 'package:wanma_print/page/receipt_management/material_receipt.dart';
import 'package:wanma_print/page/app.dart';

import 'package:wanma_print/page/login_page.dart';
import 'package:wanma_print/page/receipt_management/material_receipt_detail.dart';

import 'package:wanma_print/page/welcome_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() async {
  //处理未捕获异常
  FlutterError.onError = (FlutterErrorDetails details) async {
    //转发到当前zone
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  //自定义错误提示页面
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Text(
          'Custom Error Widget',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /// 创建Store，引用 WMState 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = Store<WMState>(appReducer,

      ///初始化数据
      initialState: WMState(
        userInfo: User.empty(),
        themeData: CommonUtils.getThemeData(WMColors.primarySwatch),
      ));

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 通过 StoreProvider 应用 store
    return StoreProvider(
      store: store,
      child: StoreBuilder<WMState>(builder: (context, store) {
        return MaterialApp(
          title: '万马线缆',
          theme: store.state.themeData,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            const Locale.fromSubtags(languageCode: 'zh', scriptCode: "Hans"),
            const Locale.fromSubtags(languageCode: 'en'),
            const Locale.fromSubtags(languageCode: "zh", scriptCode: "Hant"),
          ],
          routes: {
            WelcomePage.sName: (context) => WelcomePage(),
            LoginPage.sName: (context) => CommonLayer(
                  child: LoginPage(),
                ),
            App.sName: (context) => CommonLayer(
                  child: App(),
                ),
            // NewRepairOrder.sName: (context) => CommonLayer(
            //       child: NewRepairOrder(),
            //     ),
//==========

            MaterialReceipt.sName: (context) => CommonLayer(
                  child: MaterialReceipt(),
                ),

            MaterialDetail.sName: (context) => CommonLayer(
                  child: MaterialDetail(),
                ),
            MaterialReceiptDetail.sName: (context) => CommonLayer(
                  child: MaterialReceiptDetail(),
                ),
            ToPrint.sName: (context) => CommonLayer(
                  child: ToPrint(),
                ),
            //上料列表
            MaterialLoadList.sName: (context) => CommonLayer(
                  child: MaterialLoadList(),
                ),
            //上料工序选择
            MaterialLoadProcess.sName: (context) => CommonLayer(
              child: MaterialLoadProcess(),
            ),
            //设备上料
            MaterialLoadDetails.sName: (context) => CommonLayer(
              child: MaterialLoadDetails(),
            ),
//===================
            // NewReportOrder.sName: (context) => CommonLayer(
            //       child: NewReportOrder(),
            //     ),
            // InstallEqp.sName: (context) => CommonLayer(
            //       child: InstallEqp(),
            //     ),
            // RemoveEqp.sName: (context) => CommonLayer(
            //       child: RemoveEqp(
            //           (ModalRoute.of(context)!.settings.arguments
            //               as Map)['pidName'],
            //           (ModalRoute.of(context)!.settings.arguments
            //               as Map)['locationName']),
            //     ),
            // ReportDetail.sName: (context) => CommonLayer(
            //       child: ReportDetail(),
            //     ),
            // RepairDetail.sName: (context) => CommonLayer(
            //       child: RepairDetail(),
            //     ),
            // EquipmentList.sName: (context) => CommonLayer(
            //       child: EquipmentList(),
            //     ),
            // RepairList.sName: (context) => CommonLayer(
            //       child: RepairList(),
            //     ),
            // ReportList.sName: (context) => CommonLayer(
            //       child: ReportList(),
            //     ),
            //新增start
            //设备树列表
            // EquipmentTreeList.sName: (context) => CommonLayer(
            //       child: EquipmentTreeList(),
            // ),
            //新增end
          },

//                home: CommonLayer(
//                  child: LoginPage(),
//                ),
        );
      }),
    );
  }
}

class CommonLayer extends StatefulWidget {
  final Widget? child;

  CommonLayer({this.child});

  @override
  _CommonLayerState createState() => _CommonLayerState();
}

class _CommonLayerState extends State<CommonLayer> {
  StreamSubscription? stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //stream控制eventbus的使用
    stream = Code.eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream?.cancel();
      stream = null;
    }
  }

  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        Fluttertoast.showToast(msg: '网络错误');
        break;
      case Code.NETWORK_TIMEOUT:
        Fluttertoast.showToast(msg: '请求超时');
        break;
//      case 200:
//        Fluttertoast.showToast(msg: message);
//        break;
      case 401:
        Fluttertoast.showToast(msg: '未授权 \\ 授权登录失败 \\ 登录过期');
        NavigatorUtils.exitToLogin(context);
        break;
      case 403:
        Fluttertoast.showToast(msg: '403错误');
        break;
      case 404:
        Fluttertoast.showToast(msg: '404错误');
        break;
      default:
        Fluttertoast.showToast(msg: '其他异常 ' + message);
        if (message.contains('密码过期')) {
          // NavigatorUtils.goUpdatePwd(context);
        }
        break;
    }
  }
}

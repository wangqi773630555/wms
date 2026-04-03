import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:wanma_print/page/dianlan_widgit/current_task.dart';
import 'package:wanma_print/page/dianlan_widgit/scan_sign_in.dart';
import 'package:wanma_print/page/dianlan_widgit/scan_sign_in_list.dart';
import 'package:wanma_print/page/dianlan_widgit/search_material.dart';
import 'package:wanma_print/page/dianlan_widgit/search_material_filtrate.dart';
import 'package:wanma_print/page/dianlan_widgit/semi_finished_check.dart';
import 'package:wanma_print/page/dianlan_widgit/semi_list.dart';
import 'package:wanma_print/page/dianlan_widgit/shelves_down.dart';
import 'package:wanma_print/page/dianlan_widgit/shelves_up.dart';
import 'package:wanma_print/page/dianlan_widgit/task_examine_notarize.dart';
import 'package:wanma_print/page/dianlan_widgit/task_finish_notarize.dart';
import 'package:wanma_print/page/dianlan_widgit/task_return_notarize.dart';
import 'package:wanma_print/page/dianlan_widgit/task_wait_notarize.dart';
import 'package:wanma_print/page/dianlan_widgit/warehouse_adjust.dart';
import 'package:wanma_print/page/dianlan_widgit/warehouse_move.dart';
import 'package:wanma_print/page/frame_widgit/main_page.dart';
import 'package:wanma_print/page/frame_widgit/mine/account_security_page.dart';
import 'package:wanma_print/page/frame_widgit/mine/all_cards_page.dart';
import 'package:wanma_print/page/frame_widgit/mine/change_password_page.dart';
import 'package:wanma_print/page/frame_widgit/mine/change_work_page.dart';
import 'package:wanma_print/page/frame_widgit/mine/my_cards_page.dart';
import 'package:wanma_print/page/print_page.dart';
import 'package:wanma_print/page/app.dart';

import 'package:wanma_print/page/login_page.dart';
import 'package:wanma_print/page/tianyi_widgit/load%20material/load_details.dart';
import 'package:wanma_print/page/tianyi_widgit/load%20material/load_list.dart';
import 'package:wanma_print/page/tianyi_widgit/load%20material/load_process.dart';
import 'package:wanma_print/page/tianyi_widgit/process_management/process_management.dart';
import 'package:wanma_print/page/tianyi_widgit/process_management/process_management_detail.dart';
import 'package:wanma_print/page/tianyi_widgit/process_management/process_select_work.dart';
import 'package:wanma_print/page/tianyi_widgit/production_report/cabling.dart';
import 'package:wanma_print/page/tianyi_widgit/production_report/form_circle.dart';
import 'package:wanma_print/page/tianyi_widgit/production_report/production_report.dart';
import 'package:wanma_print/page/tianyi_widgit/production_report/select_work.dart';
import 'package:wanma_print/page/tianyi_widgit/production_report/series_connection.dart';
import 'package:wanma_print/page/tianyi_widgit/production_report/sheath.dart';
import 'package:wanma_print/page/tianyi_widgit/production_report/twisted_pair.dart';
import 'package:wanma_print/page/tianyi_widgit/receipt_management/material_detail.dart';
import 'package:wanma_print/page/tianyi_widgit/receipt_management/material_receipt.dart';
import 'package:wanma_print/page/tianyi_widgit/receipt_management/material_receipt_detail.dart';
import 'package:wanma_print/page/tianyi_widgit/upper_mould.dart';
// import 'package:wanma_print/page/task/task_list.dart';

import 'package:wanma_print/page/welcome_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:wanma_print/page/xinnengyuan_widgit/checkout_list.dart';
import 'package:wanma_print/page/xinnengyuan_widgit/photo_list.dart';
import 'package:wanma_print/page/xinnengyuan_widgit/task_list.dart';

import 'common/utils/barcolor_util.dart';
import 'page/frame_widgit/menu_page.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

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
  SystemChrome.setSystemUIOverlayStyle(BarColor.dark);
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
          navigatorObservers: [routeObserver],
          title: '万马智造',
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
            ProductionReport.sName: (context) => CommonLayer(
                  child: ProductionReport(),
                ),
            SelectWork.sName: (context) => CommonLayer(
                  child: SelectWork(),
                ),
            Cabling.sName: (context) => CommonLayer(
                  child: Cabling(),
                ),
            FromCircle.sName: (context) => CommonLayer(
                  child: FromCircle(),
                ),
            SeriesConnection.sName: (context) => CommonLayer(
                  child: SeriesConnection(),
                ),
            Sheath.sName: (context) => CommonLayer(
                  child: Sheath(),
                ),
            TwistedPair.sName: (context) => CommonLayer(
                  child: TwistedPair(),
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
            //新首页
            MainPage.sName: (context) => CommonLayer(
                  child: MainPage(),
                ),
            MenuPage.sName: (context) => CommonLayer(
                  child: MenuPage(),
                ),
            AccountSecurityPage.sName: (context) => CommonLayer(
                  child: AccountSecurityPage(),
                ),
            ChangePasswordPage.sName: (context) => CommonLayer(
                  child: ChangePasswordPage(),
                ),
            ChangeWorkPage.sName: (context) => CommonLayer(
                  child: ChangeWorkPage(),
                ),
            //上架
            ShelvesUp.sName: (context) => CommonLayer(
                  child: ShelvesUp(),
                ),
            //物料搜索
            SearchMaterial.sName: (context) => CommonLayer(
                  child: SearchMaterial(),
                ),
            //下架
            ShelvesDown.sName: (context) => CommonLayer(
                  child: ShelvesDown(),
                ),
            //物料选择（用于筛选目的库位）
            SearchMaterialFiltrate.sName: (context) => CommonLayer(
                  child: SearchMaterialFiltrate(),
                ),
            //移库
            WarehouseMove.sName: (context) => CommonLayer(
                  child: WarehouseMove(),
                ),
            //调库
            WarehouseAdjust.sName: (context) => CommonLayer(
                  child: WarehouseAdjust(),
                ),
            //当前任务
            CurrentTask.sName: (context) => CommonLayer(
                  child: CurrentTask(),
                ),
            //回库确认
            TaskReturnNotarize.sName: (context) => CommonLayer(
                  child: TaskReturnNotarize(),
                ),
            //任务确认
            TaskWaitNotarize.sName: (context) => CommonLayer(
                  child: TaskWaitNotarize(),
                ),
            //任务结束
            TaskFinishNotarize.sName: (context) => CommonLayer(
                  child: TaskFinishNotarize(),
                ),
            //任务查看
            TaskExamineNotarize.sName: (context) => CommonLayer(
                  child: TaskExamineNotarize(),
                ),
            //上模管理
            UpperMould.sName: (context) => CommonLayer(
                  child: UpperMould(),
                ),
            //我的卡片
            MyCardsPage.sName: (context) => CommonLayer(
                  child: MyCardsPage(),
                ),
            //选择卡片
            AllCardsPage.sName: (context) => CommonLayer(
                  child: AllCardsPage(),
                ),
            //工艺管理
            ProcessManagement.sName: (context) => CommonLayer(
                  child: ProcessManagement(),
                ),
            ProcessManageMentDetail.sName: ((context) => CommonLayer(
                  child: ProcessManageMentDetail(),
                )),
            ProcessSelectWork.sName: ((context) => CommonLayer(
                  child: ProcessSelectWork(),
                )),
            ScanSignIn.sName: ((context) => CommonLayer(
                  child: ScanSignIn(),
                )),
            ScanSignInList.sName: ((context) => CommonLayer(
                  child: ScanSignInList(),
                )),
            //查询检验任务
            TaskList.sName: ((context) => CommonLayer(
                  child: TaskList(),
                )),
            //检验单列表
            CheckOutList.sName: ((context) => CommonLayer(
              child: CheckOutList(),
            )),
            //照片列表
            PhotoList.sName: ((context) => CommonLayer(
              child: PhotoList(),
            )),
            //半制品盘库
            SemiFinishedCheck.sName: ((context) => CommonLayer(
              child: SemiFinishedCheck(),
            )),
            //盘库列表
            SemiList.sName: ((context) => CommonLayer(
              child: SemiList(),
            )),


          },
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

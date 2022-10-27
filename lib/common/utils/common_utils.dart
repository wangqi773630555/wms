import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wanma_print/common/config/config.dart';
import 'package:wanma_print/common/style/wm_style.dart';
import 'package:wanma_print/common/redux/theme_data_reducer.dart';
import 'package:wanma_print/common/local/local_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

class CommonUtils {
  static getThemeData(MaterialColor color) {
    return ThemeData(primarySwatch: color, platform: TargetPlatform.android);
  }

  ///store发送action，更新主题
  static pushTheme(Store store, int index) {
    ThemeData themeData;
    List<MaterialColor> colors = getThemeListColor();
    themeData = getThemeData(colors[index]);
    store.dispatch(RefreshThemeDataAction(themeData));
  }

  static List<MaterialColor> getThemeListColor() {
    return [
      WMColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  //加载中
  static Future showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: WillPopScope(
              child: Center(
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: SpinKitCubeGrid(color: Color(WMColors.white)),
                      ),
                      Container(
                        height: 10.0,
                      ),
                      Container(
                        child: Text(
                          '加载中...',
                          style: WMConstant.normalTextWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onWillPop: () => Future.value(true),
            ),
          );
        });
  }

  ///更新提示弹窗
  static showUpdateDialog(context, flag) {
    _getContent() {
      switch (flag) {
        case 1:
          return Text('您目前版本已不支持，请下载最新版本app！');
          break;
        case 2:
          return Text('新增修改模块功能！');
          break;
        case 3:
          return Text('修复运行时bug！');
          break;
        default:
          return Text('');
          break;
      }
    }

    _launchAPK() async {
      String url = Config.APK_ADDRESS;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw ('下载异常！');
      }
    }

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('版本更新'),
            content: _getContent(),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (flag == 1) {
                    // SystemNavigator.pop();
                    exit(0);
                  }
                },
                child: new Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  _launchAPK();
                  Navigator.pop(context);
                },
                child: new Text('确认'),
              ),
            ],
          );
        });
  }

  ///版本更新
  static checkVersion(context, bool showTip) async {
    String? serverVersion = await LocalStorage.get(Config.SERVER_VERSION);
    final PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    String version = _packageInfo.version;
    if (Config.DEBUG) {
      print('serverVersion: $serverVersion');
      print('buildNumber: ${_packageInfo.buildNumber}');
      print('version: ${_packageInfo.version}');
    }

    if (serverVersion == "") {
      return;
    }
    List? serverVersionList = serverVersion?.split('.');
    List versionList = version.split('.');
    if (double.parse(serverVersionList?[0]) > double.parse(versionList[0])) {
      //修改功能过多，重大版本更新，强制更新
      showUpdateDialog(context, 1);
    } else if (double.parse(serverVersionList?[1]) >
        double.parse(versionList[1])) {
      //修改或者新增功能，可以取消更新
      showUpdateDialog(context, 2);
    } else if (double.parse(serverVersionList?[2]) >
        double.parse(versionList[2])) {
      //修改运行bug，可以取消更新
      showUpdateDialog(context, 3);
    } else {
      if (showTip) Fluttertoast.showToast(msg: 'app当前是最新版本，无需更新');
    }
  }

  ///白色字体
  static whiteText(content) {
    return Text(
      content,
      style: WMConstant.middleTextWhite,
    );
  }

  ///日期格式化
  static dateFormat(DateTime date) {
    return formatDate(date, [yyyy, '-', mm, '-', dd]);
  }

  ///单个底部菜单
  static renderTab(icon, text, {size, color}) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: size,
            color: color,
          ),
          Padding(padding: EdgeInsets.all(2.0)),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          )
        ],
      ),
    );
  }

  /// dataList 数据源
  /// menuItems
  /// desc 页面展示的字段
  /// id 传给后台的字段
  static renderDropdownMenuItem(dataList,
      List<DropdownMenuItem<String>> menuItems, String desc, String id) {
    DropdownMenuItem<String> item;
    for (int i = 0; i < dataList.length; i++) {
      item = DropdownMenuItem(
        child: Text(dataList[i]['$desc']),
        value: dataList[i]['$id']?.toString(),
      );
      menuItems.add(item);
    }
  }

  static showDateAndTime(context, title, showDate, dateCallback) {
    String _format = 'yyyy-M月-d日  H时:m分:s秒';
    return Row(
      children: [
        Expanded(flex: 1, child: Text('$title')),
        Padding(padding: EdgeInsets.all(10)),
        Expanded(
            flex: 3,
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(showDate),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                DatePicker.showDatePicker(
                  context,
                  initialDateTime: DateTime.parse(showDate),
                  minDateTime: DateTime.parse('2010-01-01 00:00:00'),
                  maxDateTime: DateTime.parse('2050-12-31 23:59:59'),
                  pickerMode: DateTimePickerMode.datetime,
                  dateFormat: _format,
                  onConfirm: (dateTime, List<int> index) {
                    showDate = formatDate(dateTime,
                        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
                    dateCallback(showDate);
                  },
                );
              },
            )),
      ],
    );
  }

  static showTipDialog(context, String content,
      {bool cancel = true, callback, contextCallback}) {
    showDialog(
        context: context,
        barrierDismissible: cancel,
        builder: (context) => AlertDialog(
              title: Text('提示'),
              content: Text('$content'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      if (callback != null) {
                        callback();
                      }
                      if (contextCallback != null) {
                        contextCallback(context);
                      }
                    },
                    child: Text('确定')),
              ],
            ));
  }

  static showCustomAlertDialog(context, content, callback, {title = '提示'}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text('$content'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (callback != null) {
                    callback();
                  }
                },
                child: new Text('确认'),
              ),
            ],
          );
        });
  }

  static showCustomBottomSheet(context, callback) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        builder: (BuildContext context) {
          return callback(context);
        });
  }

  static String listToString(List<dynamic> list) {
    String result = '';
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        if (i == 0) {
          result = list[i].toString();
        } else {
          result = '$result,${list[i]}';
        }
      }
    }
    return result.toString();
  }

  static List stringToList(String result) {
    return result != '' ? result.split(',') : [];
  }

  //检查存储权限
  static Future<bool> checkPermissionStorage() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  //检查拍照权限
  static Future<bool> checkPermissionCamera() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (status.isGranted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  //设备信息状态  分为新建、已提交、已确认、已拒绝
  static String getStatusDesc(status) {
    switch (status) {
      case 1:
        return '新建';
      case 2:
        return '已提交';
      case 3:
        return '已确认';
      case 4:
        return '已驳回';
      default:
        return '';
    }
  }

  //设备状态  分为正常在用、报废在用、闲置、报废
  static String getEqpStatusDesc(eqpStatus) {
    switch (eqpStatus) {
      case 1:
        return '在用';
      case 2:
        return '报废';
      case 3:
        return '闲置';
      case 4:
        return '报废在用';
      default:
        return '';
    }
  }

  //报修单状态  分为新建、已确认、已分配、已安排工单、已完结
  static String getReportStatusDesc(status) {
    switch (status) {
      case 0:
        return '新建';
      case 1:
        return '已确认';
      case 2:
        return '已分配';
      case 3:
        return '已安排工单';
      case 4:
        return '已完结';
      default:
        return '';
    }
  }

  //维修单状态  分为新建、已取消、已下达、已完结
  static String getRepairStatusDesc(status) {
    switch (status) {
      case 0:
        return '新建';
      case 1:
        return '已取消';
      case 2:
        return '已下达';
      case 3:
        return '已完结';
      default:
        return '';
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/json/json_string.dart';
import 'package:wanma_print/widget/grid_item.dart';
import 'package:wanma_print/widget/layout_log_print.dart';

import '../common/config/scanConfig.dart';
import '../common/utils/navigator_utils.dart';
import '../common/utils/scanevent_utils.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutLogPrint(
      tag: 'home_page',
      child: ItemMenu(),
    );
  }
}

Future _getAppMenu() async {
  var data = await json.decode(JsonString.homeData);
  print('======$data');
  return data;
}

class ItemMenu extends StatefulWidget {
  @override
  _ItemMenuState createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu>
    with AutomaticKeepAliveClientMixin<ItemMenu> {
  late Future _futureStr;
  static const _platform = MethodChannel('toFlutterChannelName');

  @override
  void initState() {
    super.initState();
    _futureStr = _getAppMenu();
    _platform.setMethodCallHandler(flutterMethod);
  }

  //接收二维码
  Future<dynamic> flutterMethod(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'flutterMethod':
        debugPrint('Android传递给flutter的参数是：' + methodCall.arguments);
        switch (ScanConfig.scanPage) {
          case ScanConfig.PAGE_PRINT:
            ScanEventUtils.send(
                ScanConfig.PAGE_PRINT, methodCall.arguments.toString());
            break;
          case ScanConfig.PAGE_LOAD:
            ScanEventUtils.send(
                ScanConfig.PAGE_LOAD, methodCall.arguments.toString());
            break;
          case ScanConfig.PAGE_LOAD_PART:
            ScanEventUtils.send(
                ScanConfig.PAGE_LOAD_PART, methodCall.arguments.toString());
            break;
          default:
            NavigatorUtils.goMaterialDetail(
                context, methodCall.arguments.toString());
            break;
        }

        break;
      default:
        debugPrint('Android调用了flutterMethod失败！！！\t\t' + methodCall.method);
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: FutureBuilder(
          future: _futureStr,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: '加载中...',
                  ),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text(
                    '${snapshot.error}',
                    style: TextStyle(color: Colors.red),
                  );
                } else if (snapshot.hasData) {
                  var obj = snapshot.data! as Map;
                  if (obj['code'] == 0) {
                    return AreaItem(obj['result']);
                  } else {
                    return Container(
                      height: 300,
                      child: Text('code!=0'),
                    );
                  }
                } else {
                  return Container(
                    height: 300,
                    child: Text('data == null'),
                  );
                }
                break;
              default:
                return Container(
                  height: 300,
                  child: Text('default'),
                );
            }
          },
        ),
        onRefresh: () => _handleRefresh());
  }

  Future _handleRefresh() async {
    setState(() {
      // _futureStr = _getAppMenu();
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class AreaItem extends StatelessWidget {
  final List data;

  AreaItem(this.data);
  final items = <Widget>[];
  final icons = <IconData>[
    Icons.list_alt,
    Icons.qr_code,
    Icons.print,
    Icons.featured_play_list_outlined,
    Icons.upload,
    Icons.home_repair_service_outlined
  ];

  _getItem() {
    for (int i = 0; i < data.length; i++) {
      // data[5]['functionName'] = 'materialReceipt';
      print('======${data[i]['functionName']}');
      var item =
          // Container(
          //     width: 80,
          //     height: 80,
          //     child: Container(
          //       child: Column(
          //         children: [
          //           Container(
          //             height: 80,
          //             width: 80,

          //           ),
          //           Text(data[i]['title'])
          //         ],
          //       ),
          //     )

          GridItemWidget(
        text: data[i]['title'],
        functionName: data[i]['functionName'],
        // functionName: _functionNameList[i],
        mid: data[i]['id'].toString(),
        icon: icons[i],
        // ),
      );
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final double Wwidth = MediaQuery.of(context).size.width;
    final double Hheight = MediaQuery.of(context).size.height;
    return Container(
      child: GridView(
        // padding: const EdgeInsets.all(10.0),childAspectRatio
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.5,
          crossAxisCount: (Wwidth ~/ 140),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: _getItem(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import 'package:wanma_print/common/utils/scanevent_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/config/config.dart';
import '../../../common/config/scanConfig.dart';
import '../../../common/event/scan_event.dart';
import '../../../common/utils/navigator_utils.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'dart:async';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../common_widgit/refresh/custom_refresh_footer.dart';
import '../../common_widgit/refresh/custom_refresh_header.dart';

class ProcessManagement extends StatefulWidget {
  static final String sName = Config.PROCESS_MANAGEMENT;
  const ProcessManagement({Key? key}) : super(key: key);
  @override
  State<ProcessManagement> createState() => _UpperMouldState();
}

class _UpperMouldState extends State<ProcessManagement> {
  TextEditingController _searController = TextEditingController();
  late double _wwidth;
  late double _hheight;
  List productionList = [];
  ScanResult? scanResult;
  bool circle = false;
  StreamSubscription? stream;
  var _pageSize = 10;
  var _pageNum = 1;
  var _totalNum;
  late EasyRefreshController _easyfreshController;
  @override
  void initState() {
    super.initState();
    _easyfreshController = EasyRefreshController();
    getData(_pageNum, _pageSize);
    scanAction2();
    ScanConfig.scanPage = ScanConfig.PRODUCTION_REPORT;
  }

  scanAction2() async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) async {
        if (event.page == ScanConfig.PRODUCTION_REPORT) {
          await NavigatorUtils.goSelectWork(context, event.scanResult)
              .then((res) {
            setState(() {
              _pageNum = 1;
              productionList.clear();
              getData(_pageNum, _pageSize);
            });
          });
        }
      });
      //延时执行的代码

      setState(() {
        //延时更新状态
      });
    });
  }

  scanAction(txt) async {
    await _scan();
    Future.delayed(const Duration(milliseconds: 500), () async {
      bool f = false;
      if (scanResult?.rawContent != "" && scanResult?.rawContent != null) {
        await NavigatorUtils.goProgressSelectWork(
                context, scanResult?.rawContent)
            .then((res) {
          setState(() {
            productionList.clear();
            _pageNum = 1;
            getData(_pageNum, _pageSize);
          });
        });
      }
      setState(() {});
    });
  }

  Future<void> _scan() async {
    scanResult = null;
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': '取消',
            'flash_on': '打开闪光灯',
            'flash_off': '关闭闪光灯',
          },
        ),
      );

      scanResult = result;
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
            type: ResultType.Error,
            format: BarcodeFormat.unknown,
            rawContent: '00000000');
      });
    }
  }

  getData(pageNum, pageSize) {
    DataDao.getCtProcessIndexData(_pageNum, _pageSize).then((res) {
      circle = true;
      if (res.data != null && res.data != '') {
        List modelList = res.data['data']['list'];
        productionList.addAll(modelList);
        _totalNum = res.data['data']['totalPage'];
        print(productionList);
      }
      setState(() {});
    });
  }

  void dispose() async {
    super.dispose();
    _searController.dispose();
    ScanConfig.scanPage = "";
    if (stream != null) {
      stream?.cancel();
      stream = null;
    }
  }

  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    _hheight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('工艺管理'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: circle == false
                ? Container(
                    margin: EdgeInsets.only(top: 100),
                    child: Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: '加载中...',
                      ),
                    ))
                : Container(
                    width: _wwidth,
                    height: _hheight,
                    child: Column(children: [
                      _searchRow(),
                      Container(
                        height: _hheight - 180,
                        width: _wwidth - 20,
                        child: _listWidget(),
                      )
                    ]),
                  )));
  }

  Widget cardList() {
    return Container(
        width: _wwidth,
        height: _hheight - 130,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _cellForRow(context, index);
          },
          itemCount: productionList.length,
        ));
  }

  Widget _searchRow() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      color: Colors.white,
      child: _searchWidget(),
    );
  }

  Widget _searchWidget() {
    return TextField(
      textAlign: TextAlign.center,
      controller: _searController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        hintStyle:
            TextStyle(color: Color.fromARGB(179, 153, 149, 149), fontSize: 14),
        hintText: '请输入订单号',
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.qr_code_scanner_rounded),
          color: Colors.blue,
          onPressed: () {
            scanAction('');
          },
        ),
        fillColor: Colors.white,
      ),
      onSubmitted: (text) async {
        if (text != '') {
          await NavigatorUtils.goProgressSelectWork(context, text)
              .then((result) {
            setState(() {
              productionList.clear();
              _pageNum = 1;
              getData(_pageNum, _pageSize);
            });
          });
        }
      },
    );
  }

  Widget _listWidget() {
    return EasyRefresh.custom(
      controller: _easyfreshController,
      enableControlFinishRefresh: false,
      enableControlFinishLoad: true,
      header: CustomRefreshHeader(
          Colors.white, Colors.grey, Color.fromARGB(255, 244, 158, 54)),
      footer: CustomRefreshFooter(Colors.grey, Colors.grey),
      onRefresh: () async {
        // 控制器关闭刷新功能
        productionList.clear();
        _pageNum = 1;
        await getData(_pageNum, _pageSize);
        setState(() {});
        _easyfreshController.resetLoadState();
      },
      onLoad: () async {
        setState(() {
          if (_pageNum < _totalNum) {
            _pageNum++;
            getData(_pageNum, _pageSize);
          }
        });

        Future.delayed(Duration(milliseconds: 200), () {
          _easyfreshController.finishLoad(noMore: (_pageNum >= _totalNum));
        });
      },
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return _cellForRow(context, index);
          }, childCount: productionList.length),
        ),
      ],
    );
  }

  Widget _cellForRow(conttext, index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                width: _wwidth - 80,
                child: Row(
                  children: [
                    Text(
                      '订单号:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SelectableText(
                      productionList[index]['id'].toString(),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                productionList[index]['recipe_title'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )
            ],
          ),
          Divider(),
          Container(
            child: Column(
              children: [
                textCells('产品名称', productionList[index]['part_name'] ?? ""),
                Divider(
                  height: 10,
                  color: Colors.white,
                ),
                textCells(
                    '产品描述', productionList[index]['part_description'] ?? ''),
              ],
            ),
          ),
          Divider(),
          ButtonTheme(
            child: ButtonBar(
              children: <Widget>[
                _buttonStyle('查看工艺参数', Colors.white, Colors.blue, 120, 0,
                    Colors.grey, 40, () async {
                  print(productionList[index]['part_id']);
                  switch (productionList[index]['recipe_title']) {
                    case '串联':
                      await NavigatorUtils.goProgressManagementDetail(
                              context,
                              '串联',
                              productionList[index]['id'],
                              productionList[index]['recipe_id'],
                              productionList[index]['part_id'],
                              true)
                          .then((result) {
                        setState(() {
                          productionList.clear();
                          _pageNum = 1;
                          getData(_pageNum, _pageSize);
                        });
                      });
                      ;
                      break;

                    case '护套':
                      await NavigatorUtils.goProgressManagementDetail(
                              context,
                              '护套',
                              productionList[index]['id'],
                              productionList[index]['recipe_id'],
                              productionList[index]['part_id'],
                              true)
                          .then((result) {
                        print('=1=======');
                        setState(() {
                          productionList.clear();
                          _pageNum = 1;
                          getData(_pageNum, _pageSize);
                        });
                      });
                      ;
                      break;

                    default:
                      break;
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  textCells(String label, dynamic value) {
    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            width: 100,
            child: Text(label),
          ),
          Container(
            width: _wwidth - 180,
            margin: EdgeInsets.only(right: 20),
            child: Text(
              value,
              style: TextStyle(),
              maxLines: 8,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonStyle(titles, Color bgColore, Color textColor, double ww,
      double rightWW, Color borderCorlor, double h, Function() f) {
    return Container(
      alignment: Alignment.center,
      width: ww,
      height: h,
      margin: EdgeInsets.only(
        right: rightWW,
      ),
      child: TextButton(
        child: Text(
          titles,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        onPressed: f,
      ),
    );
  }
}

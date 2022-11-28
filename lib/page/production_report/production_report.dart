import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/dao/data_dao.dart';

import '../../common/config/config.dart';
import '../../common/utils/navigator_utils.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class ProductionReport extends StatefulWidget {
  static final String sName = Config.PRO_REPORT;
  const ProductionReport({Key? key}) : super(key: key);

  @override
  State<ProductionReport> createState() => _ProductionReportState();
}

class _ProductionReportState extends State<ProductionReport> {
  TextEditingController _searController = TextEditingController();
  late double _wwidth;
  late double _hheight;
  List productionList = [];
  ScanResult? scanResult;
  bool circle = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  scanAction(txt) async {
    await _scan();

    Future.delayed(const Duration(milliseconds: 500), () async {
      bool f = false;
      if (scanResult?.rawContent != "" && scanResult?.rawContent != null) {
        await NavigatorUtils.goSelectWork(context, scanResult?.rawContent)
            .then((res) {
          // print('fanhui');
          setState(() {
            getData();
          });
        });
      }
      //延时执行的代码

      setState(() {
        //延时更新状态
      });
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
      // showAlert(scanResult!.rawContent);

    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
            type: ResultType.Error,
            format: BarcodeFormat.unknown,
            rawContent: '00000000');
      });
    }
  }

  getData() {
    DataDao.getProductionList().then((res) {
      circle = true;
      if (res.data != null && res.data != '') {
        productionList = res.data['data'];
        print(productionList);
      }
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('产量报工'),
          centerTitle: true,
          // actions: [
          //   TextButton(
          //       onPressed: () {

          //       },
          //       child: Text(''))
          // ],
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
                    child: Column(children: [_searchRow(), cardList()]),
                  )));
  }

  Widget cardList() {
    return Container(
        // color: Colors.red,
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
        hintText: '请输入发货单号',
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.qr_code_scanner_rounded),
          color: Colors.blue,
          onPressed: () {
            scanAction('');
            print('........');
          },
        ),
        fillColor: Colors.white,
      ),
      onSubmitted: (text) async {
        // var result = await NavigatorUtils.goMaterialDetail(context, text);
        if (text != '') {
          await NavigatorUtils.goSelectWork(context, text).then((result) {
            print('========');
            setState(() {
              getData();
            });
          });
        }

        // print('**result******++++$result');
        // setState(() {
        //   // getInintData();
        // });
        // NavigatorUtils.goMaterialDetail(context, text);
      },
    );
  }

  Widget _cellForRow(conttext, index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                width: _wwidth - 60,
                child: Row(
                  children: [
                    Text(
                      '订单号:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      // showCursor: true,
                    ),
                    SelectableText(
                      productionList[index]['order_id'].toString(),
                      // _modelList[index]['deliver_no'],
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
              // _statusStyle(_modelList[index]['status_text']),
            ],
          ),
          Divider(),
          Container(
            child: Column(
              children: [
                textCells('产品名称', productionList[index]['part_name'] ?? ""),
                textCells(
                    '产品描述', productionList[index]['part_description'] ?? ''),
                textCells('报工长度', productionList[index]['qty'].toString()),
                textCells('报工人', productionList[index]['user_name']),
                textCells('报工时间', productionList[index]['add_time']),
              ],
            ),
          ),
          Divider(),
          // _modelList[index]['status_text'] == '已取消'
          //     ? Container()
          //     :
          ButtonTheme(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                // _buttonStyle(, bgColore, textColor, ww, rightWW)
                (
                    // _modelList[index]['status_text'] == '已取消' ||
                    //       _modelList[index]['status_text'] == '已过帐' ||
                    //       _modelList[index]['status_text'] == '部分过账')
                    //   ? Container()
                    //   :
                    _buttonStyle('查看详情', Colors.white, Colors.blue, 100, 0,
                        Colors.grey, 40, () async {
                  print(productionList[index]['recipe_title']);
                  switch (productionList[index]['recipe_title']) {
                    case '串联':
                      await NavigatorUtils.goSeriesConnection(context, '', '',
                              productionList[index]['id'], true)
                          .then((result) {
                        print('=1=======');
                        setState(() {
                          getData();
                        });
                      });
                      ;
                      break;
                    case '成圈':
                      NavigatorUtils.goFormCircle(context, '', '',
                              productionList[index]['id'], true)
                          .then((result) {
                        print('====2====');
                        setState(() {
                          getData();
                        });
                      });
                      break;

                    case '护套':
                      NavigatorUtils.goSheath(context, '', '',
                              productionList[index]['id'], true)
                          .then((result) {
                        print('===3=====');
                        setState(() {
                          getData();
                        });
                      });
                      break;
                    case '成缆':
                      print('00000');
                      NavigatorUtils.goCabling(context, '', '',
                              productionList[index]['id'], true)
                          .then((result) {
                        print('========');
                        setState(() {
                          getData();
                        });
                      });
                      break;
                    case '对绞':
                      NavigatorUtils.goTwistedPair(context, '', '',
                              productionList[index]['id'], true)
                          .then((result) {
                        print('========');
                        setState(() {
                          getData();
                        });
                      });
                      break;
                    default:
                      break;
                  }
                })),
                // _buttonStyle(
                //     '打印流程卡',
                //     Color.fromARGB(255, 209, 232, 251),
                //     Color.fromARGB(255, 15, 86, 144),
                //     100,
                //     10,
                //     Colors.white,
                //     40, () async {
                //   // await NavigatorUtils.goMaterialDetail(
                //   //         context, _modelList[index]['deliver_no'])
                //   //     .then((result) {
                //   //   getInintData();
                //   //   print('111111111111111');
                //   // });
                // })
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
            // color: Colors.red,
            width: 100,
            child: Text(label),
          ),
          Container(
            width: _wwidth - 150,
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 20),
            child: Text(
              value,
              style: TextStyle(),
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
        // left:
      ),
      child: TextButton(
        child: Text(
          titles,
          style: TextStyle(color: textColor, fontSize: 16),
          // textAlign: TextAlign.justify,
        ),
        onPressed: f,
      ),
      // decoration: BoxDecoration(
      //   color: bgColore,
      //   border: Border.all(width: 1, color: borderCorlor),
      //   borderRadius: new BorderRadius.circular((18.0)),
      //   boxShadow: [
      //     BoxShadow(
      //         color: bgColore,
      //         offset: Offset(0.5, 0.5),
      //         blurRadius: 1.0,
      //         spreadRadius: 1.0),
      //   ],
      // ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import 'package:wanma_print/page/production_report/select_work.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../common/config/config.dart';
import '../../common/utils/common_utils.dart';
import 'common_widget/production_header.dart';

import '../../common/dao/data_dao.dart';

import 'package:barcode_scan2/barcode_scan2.dart';

// import 'dialogs/material_search_page.dart';
class SeriesConnection extends StatelessWidget {
  static final String sName = Config.SERIES_CONNECTION;
  const SeriesConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('串联报工'),
          centerTitle: true,
        ),
        body: SeriesConnections(args));
  }
}

class SeriesConnections extends StatefulWidget {
  final idsList;
  const SeriesConnections(this.idsList, {Key? key}) : super(key: key);

  @override
  State<SeriesConnections> createState() => _SeriesConnectionStates();
}

class _SeriesConnectionStates extends State<SeriesConnections> {
  TextEditingController vc1 = TextEditingController();
  TextEditingController vc2 = TextEditingController();
  TextEditingController vc3 = TextEditingController();
  TextEditingController vc4 = TextEditingController();
  TextEditingController vc5 = TextEditingController();
  TextEditingController vc6 = TextEditingController();
  TextEditingController vc7 = TextEditingController();

  var extraField1 = ''; //danwei
  var extraField2 = '';
  var extraField3 = '';
  var extraField4 = '';
  var extraField5 = '';
  var radioValue;
  var people = '';
  var time = '';
  var lsbh = '';
  late TextEditingController vc;
  late double _wwidth;
  late double _hheight;
  Map modeMap = {};
  List productionList = [];
  List eqpIdList = [];
  var eqpIdValue;
  List colorList = [];
  List radioList = [];
  var colorValue;
  bool circle = false;
  ScanResult? scanResult;
  List<DropdownMenuItem<String>> _eqpIdItems = [];
  List<DropdownMenuItem<String>> _colorItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData(widget.idsList[3], widget.idsList[2]);
  }

  getData(flag, ids) {
    DataDao.getProductions(widget.idsList[1], widget.idsList[0], ids, flag)
        .then((res) {
      print('1111111111111');
      circle = true;
      if (res.data != null && res.data != '') {
        modeMap = res.data['data'];
        productionList = modeMap['render_list'];
        if (productionList.length > 0) {
          for (var element in productionList) {
            if (element['key'] == 'eqp_id') {
              eqpIdList = element['list'];
              _eqpIdItems = [];
              CommonUtils.renderDropdownMenuItem(
                  eqpIdList, _eqpIdItems, "value", "key");
              if (element['value'] != null && element['value'] != '') {
                eqpIdValue = element['value'].toString();
              }

              print('eqpIdList:$eqpIdList');
              // print('_eqpIdItems:$_eqpIdItems');
            }
            if (element['key'] == 'color') {
              colorList = element['list'];
              _colorItems = [];
              CommonUtils.renderDropdownMenuItem(
                  colorList, _colorItems, "value", "key");
              if (element['value'] != null && element['value'] != '') {
                colorValue = element['value'].toString();
              }
            }

            if (element['key'] == 'qty') {
              vc1.text = (element['value'] ?? '').toString();
              extraField1 = element['extraField'] ?? "";
            }
            if (element['title'] == '班次') {
              radioList = element['list'];
              if (element['value'] != null) {
                radioValue = int.parse(element['value']);
              }
            }
            if (element['title'] == '导体线径') {
              vc2.text = (element['value'] ?? '').toString();
              extraField2 = element['extraField'] ?? '';
            }
            if (element['title'] == '芯线线径') {
              vc3.text = (element['value'] ?? '').toString();
              extraField3 = element['extraField'] ?? '';
            }
            if (element['title'] == '盘号') {
              vc4.text = (element['value'] ?? '').toString();
            }
            if (element['title'] == '火花点数') {
              vc5.text = (element['value'] ?? '').toString();
            }
            if (element['title'] == '同心度') {
              vc6.text = (element['value'] ?? '').toString();
              extraField4 = element['extraField'] ?? '';
            }
            if (element['title'] == '导体伸率') {
              vc7.text = (element['value'] ?? '').toString();
              extraField5 = element['extraField'] ?? '';
            }
            if (element['title'] == '报工人') {
              // if (element['value'] != null) {
              people = element['value'] ?? '';
              // }
            }
            if (element['title'] == '流水编号') {
              // if (element['value'] != null) {
              lsbh = element['value'] ?? '';
              // }
            }
            if (element['title'] == '报工时间') {
              // if (element['value'] != null) {
              time = element['value'] ?? '';
            }
          }
        }
      }
      setState(() {});
    });
  }

  save() {
    if (radioValue == null || radioValue == '') {
      Fluttertoast.showToast(msg: '部分内容未填写');
      return;
    }
    if (eqpIdValue == null || eqpIdValue == '') {
      Fluttertoast.showToast(msg: '部分内容未填写');
      return;
    }
    if (colorValue == null || colorValue == '') {
      Fluttertoast.showToast(msg: '部分内容未填写');
      return;
    }
    if (vc1.text == '') {
      Fluttertoast.showToast(msg: '部分内容未填写');
      return;
    }
    if (vc2.text == '') {
      Fluttertoast.showToast(msg: '部分内容未填写');
      return;
    }
    if (vc3.text == '') {
      Fluttertoast.showToast(msg: '部分内容未填写');
      return;
    }
    if (vc4.text == '') {
      Fluttertoast.showToast(msg: '部分内容未填写');
      return;
    }
    if (vc5.text == '') {
      Fluttertoast.showToast(msg: '部分内容未填写');
      return;
    }
    if (vc6.text == '') {
      Fluttertoast.showToast(msg: '部分内容未填写');
      return;
    }
    if (vc7.text == '') {
      Fluttertoast.showToast(msg: '部分内容未填写');
      return;
    }
    // circle = false;
    var paras = {
      "shift_type": (radioValue ?? '').toString(),
      "eqp_id": int.parse(eqpIdValue),
      "color": colorValue,
      "qty": double.parse(vc1.text),
      "conductor_radius": double.parse(vc2.text),
      "line_radius": double.parse(vc3.text),
      "carrier_id": vc4.text,
      "spark_num": double.parse(vc5.text),
      "concentricity": double.parse(vc6.text),
      "conductor_elongation": double.parse(vc7.text)
    };
    // print(paras.keys.length);
    // print(vc1.text);
    // print(vc2.text);
    // print(vc3.text);
    // print(vc4.text);
    // print(vc5.text);
    // print(vc6.text);
    // print(vc7.text);
    // print(radioValue);
    // print(eqpIdValue);
    // print(colorValue);
    // print(paras);

    DataDao.getProductionSave(widget.idsList[1], widget.idsList[0],
            widget.idsList[2], widget.idsList[3], paras)
        .then((res) {
      // print(widget.idsList);

      if (res.data['id'] != null && res.data['id'] != '') {
        Fluttertoast.showToast(msg: '提交成功');
        // getData(true, res.data['id']);
        Navigator.popUntil(context, (route) {
          print(route.settings.name);
          if (route.settings.name == 'ProductionReport') {
            return true;
          }
          return false;
        });
      }
    });
  }

  scanAction() async {
    await _scan();

    Future.delayed(const Duration(milliseconds: 500), () {
      bool f = false;
      if (scanResult?.rawContent != "" && scanResult?.rawContent != null) {
        for (var element in eqpIdList) {
          if (element['key'] == int.parse(scanResult!.rawContent)) {
            print('+++++${element['key']}====${scanResult!.rawContent}');
            f = true;
            setState(() {
              eqpIdValue = scanResult!.rawContent;
            });
          }
        }

        if (f == false) {
          print('+++++2');
          Fluttertoast.showToast(
            msg: "${scanResult!.rawContent}不存在",
          );
          // setState(() {
          //   eqpIdValue = '';
          // });
        }
        // setState(() {});
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

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
        child: circle == false
            ? Container(
                margin: EdgeInsets.only(top: 100),
                child: Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: '加载中...',
                  ),
                ))
            : Container(
                color: Colors.white,
                child: Column(children: [
                  ProductionHeader(
                      _wwidth,
                      _hheight,
                      false,
                      (modeMap['order_id'] ?? '').toString(),
                      modeMap['bstkd'] ?? '',
                      modeMap['part_name'] ?? "",
                      modeMap['part_description'] ?? "",
                      '${modeMap['order_no'].toString()}${modeMap['order_unit'] ?? ''}',
                      modeMap['init_order_id'] ?? '',
                      (modeMap['result_qty'] ?? '').toString(),
                      modeMap['recipe_title'] ?? ''),

                  // productionList[0]['render']=='LABEL'?
                  textRow('流水编号', lsbh),
                  selectRow('生产机台', true, _eqpIdItems),
                  radioWidget(),
                  selectRow('色谱', false, _colorItems),
                  cellForRow('长度', vc1, false, extraField1, 'double'),
                  cellForRow('导体线径', vc2, false, extraField2, 'double'),
                  cellForRow('芯线线径', vc3, false, extraField3, 'double'),
                  cellForRow('盘号', vc4, false, '', 'char'),
                  cellForRow('火花点数', vc5, false, '', 'double'),
                  cellForRow('同心度', vc6, false, extraField4, 'double'),
                  cellForRow('导体伸率', vc7, false, extraField5, 'double'),
                  textRow('报工人', people),
                  textRow('报工时间', time),

                  TextButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(240, 35)),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 14, 141, 226)),
                        overlayColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 117, 190, 239)),
                      ),
                      onPressed: () {
                        save();
                      },
                      child: Text(
                        widget.idsList[3] == true ? '保存修改' : '确认申报',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ))
                ]),
              ));
  }

  Widget textRow(name, value) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15),
      child: Row(
        children: [
          Container(
            // padding: EdgeInsets.only(left: 15),
            width: 80,
            child: Text(name),
          ),
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Text(value),
          )
        ],
      ),
    );
  }

  Widget radioWidget() {
    return Container(
      height: 35,
      margin: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Container(
            width: 65,
            child: Text('班组'),
          ),
          Radio(
              value: radioList.length > 0 ? int.parse(radioList[0]['key']) : 1,
              groupValue: radioValue,
              onChanged: (newValue) {
                setState(() {
                  radioValue = newValue;
                });
              }),
          Text('早班'),
          Radio(
              value: radioList.length > 0 ? int.parse(radioList[1]['key']) : 2,
              groupValue: radioValue,
              onChanged: (newValue) {
                setState(() {
                  radioValue = newValue;
                });
              }),
          Text('晚班'),
        ],
      ),
    );
  }

  Widget selectRow(txt, isScan, items) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(txt),
          ),
          Container(
            width: _wwidth - 80 - 70,
            height: 35,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              // color: Colors.red,
              border: Border.all(width: 1),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                items: items,
                value: txt == '生产机台'
                    ? eqpIdValue
                    : (txt == '色谱' ? colorValue : null),
                elevation: 24,
                onChanged: (v) {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (txt == '生产机台') {
                      eqpIdValue = v!;
                    } else if (txt == '色谱') {
                      colorValue = v!;
                    }

                    print(v);
                  });
                },
              ),
            ),
          ),
          isScan == true
              ? IconButton(
                  onPressed: () {
                    scanAction();
                  },
                  icon: Icon(Icons.fit_screen_outlined))
              : Container()
        ],
      ),
    );
  }

  Widget cellForRow(txt, var vc, isScan, txts, type) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(txt),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            width: _wwidth - 80 - 70,
            height: 35,
            // color: Colors.red,
            child: type == 'double'
                ? TextField(
                    controller: vc,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                    ],
                  )
                : TextField(
                    controller: vc,
                    inputFormatters: [
                      // FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                      //  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                  ),
            decoration: BoxDecoration(
              // color: Colors.red,
              border: Border.all(width: 1),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
          isScan == true
              ? IconButton(
                  onPressed: () {}, icon: Icon(Icons.fit_screen_outlined))
              : Text(txts)
        ],
      ),
    );
  }

  showAlert(mas) {
    showDialog(
        context: context,
        builder: (content) {
          return AlertDialog(
            title: Text('mas'),
            actions: [
              TextButton(
                child: Text("确定"),
                onPressed: () {},
              ),
            ],
          );
        });
  }
}

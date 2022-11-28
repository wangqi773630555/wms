import 'package:flutter/material.dart';

import '../../common/config/config.dart';
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

class FromCircle extends StatelessWidget {
  static final String sName = Config.FORM_CIRCLE;
  const FromCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('成圈报工'),
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

  var extraField1 = ''; //danwei
  var extraField2 = '';
  var extraField3 = '';
  var extraField4 = '';
  var extraField5 = '';
  var radioValue;
  late double _cd;
  late double _dc;
  int _xps = 0;
  int _zxsl = 0;
  //cd/dc/zxsl=xps
  //xps*dc*zxsl=cd
  //xps * dc * zxsl = cd
  //xps * dc * zxsl = cd
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
  String _url = '';
  bool circle = false;
  ScanResult? scanResult;
  List<DropdownMenuItem<String>> _eqpIdItems = [];
  List<DropdownMenuItem<String>> _colorItems = [];
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(widget.idsList[0]);
    // print(widget.idsList[1]);
    // if(_mechanicalMonitors != null && _mechanicalMonitors.length > 0) {
    //
    //       _monitorsValue = _mechanicalMonitors[0]['id'].toString();
    //     }
    // _focusNode.addListener(() {

    // });
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

            if (element['key'] == 'qty') {
              // vc1.text = (element['value'] ?? '').toString();
              if (element['value'] != null && element['value'] != '') {
                // print('---${element['value']}');

                _cd = double.parse(element['value'].toString());
                vc1.text = '$_cd';
              }

              extraField1 = element['extraField'] ?? '';
            }
            if (element['title'] == '班次') {
              radioList = element['list'];
              if (element['value'] != null) {
                radioValue = int.parse(element['value']);
              }
            }
            if (element['title'] == '护套编号') {
              vc2.text = (element['value'] ?? '').toString();
              _url = element['queryURL'].toString();
              _url = _url.substring(0, _url.length - 7);
              print('url$_url');
            }

            if (element['title'] == '定长') {
              // vc3.text = (element['value'] ?? '').toString();
              if (element['value'] != null && element['value'] != '') {
                _dc = double.parse(element['value'].toString());
                vc3.text = _dc.toString();
              }

              extraField2 = element['extraField'] ?? '';
            }
            if (element['title'] == '箱/盘数') {
              // vc4.text = (element['value'] ?? '').toString();
              if (element['value'] != null && element['value'] != '') {
                _xps = double.parse(element['value'].toString()).truncate();
                ;
                vc4.text = _xps.toString();
              }

              extraField3 = element['extraField'] ?? '';
            }
            if (element['title'] == '箱号') {
              // vc4.text = (element['value'] ?? '').toString();
              if (element['value'] != null && element['value'] != '') {
                vc6.text = element['value'].toString();
              }

              extraField3 = element['extraField'] ?? '';
            }

            if (element['title'] == '装箱数量') {
              // vc5.text = (element['value'] ?? '').toString();
              _zxsl =
                  double.parse((element['value'] ?? '').toString()).truncate();
              vc5.text = _zxsl.toString();
              extraField4 = element['extraField'] ?? '';
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

          // for (var element in productionList) {
          //   print(element['key']);
          // }
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

    // circle = false;
    var paras = {
      "shift_type": (radioValue ?? '').toString(),
      "eqp_id": int.parse(eqpIdValue),
      // "color": colorValue,
      "qty": double.parse(vc1.text),
      "sheath_no": vc2.text,
      "per_qty": double.parse(vc3.text),
      "qty_pack": double.parse(vc4.text),
      "pcs_per_pack": double.parse(vc5.text),
      'box_no': vc6.text
    };

    DataDao.getProductionSave(widget.idsList[1], widget.idsList[0],
            widget.idsList[2], widget.idsList[3], paras)
        .then((res) {
      // print(widget.idsList);

      if (res.data['id'] != null && res.data['id'] != '') {
        print('#####');
        // getData(true, res.data['id']);
        Fluttertoast.showToast(msg: '提交成功');
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

  scanAction(txt) async {
    await _scan();

    Future.delayed(const Duration(milliseconds: 300), () {
      bool f = false;
      if (scanResult?.rawContent != "" && scanResult?.rawContent != null) {
        if (txt == '生产机台') {
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
        } else {
          DataDao.getScanUrl(scanResult!.rawContent, _url).then((res) {
            print(res.data['data']);
            if (res.data['data'] != null && res.data['data'] != '') {
              setState(() {
                // _cd = res.data['data']['qty'];
                vc1.text = res.data['data']['qty'].toString();
                vc2.text = res.data['data']['sheath_no'];
                vc4.text = (double.parse(vc1.text) /
                        double.parse(vc3.text) /
                        double.parse(vc5.text))
                    .truncate()
                    .toString();
              });
            } else {
              Fluttertoast.showToast(msg: res.data['msg']);
            }
          });
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
                  textRow('流水编号', ''),
                  selectRow('生产机台', true, _eqpIdItems),
                  radioWidget(),
                  // selectRow('护套编号', tu, _colorItems),
                  cellForRow('护套编号', vc2, true, '', 'char'),
                  cellForRow('长度', vc1, false, extraField1, 'double'),
                  cellForRow('定长', vc3, false, extraField2, 'double'),
                  cellForRow('箱/盘数', vc4, false, extraField3, 'int'),
                  cellForRow('箱号', vc6, false, '', 'char'),
                  cellForRow('装箱数量', vc5, false, extraField4, 'int'),

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
            margin: EdgeInsets.only(right: 5),
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
                    // FocusScope.of(context).requestFocus(FocusNode());
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
                    scanAction(txt);
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
            margin: EdgeInsets.only(right: 5),
            width: _wwidth - 80 - 70,
            height: 35,
            // color: Colors.red,
            child: type == 'double'
                ? TextField(
                    controller: vc,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                    ],
                    focusNode: txt == '长度' ? _focusNode1 : _focusNode2,
                    onChanged: (value) {
                      if (txt == '长度' && value != '') {
                        _focusNode1.addListener(() {
                          if (!_focusNode1.hasFocus) {
                            setState(() {
                              vc1.text = value;
                              vc4.text = (double.parse(value) /
                                      double.parse(vc3.text) /
                                      double.parse(vc5.text))
                                  .truncate()
                                  .toString();
                            });
                          }
                        });

                        // _cd = double.parse(value);
                      } else if (txt == '定长' && value != '') {
                        _focusNode2.addListener(() {
                          if (!_focusNode2.hasFocus) {
                            setState(() {
                              vc3.text = value;
                              if (vc4.text != '') {
                                vc1.text = (double.parse(value) *
                                        double.parse(vc4.text) *
                                        double.parse(vc5.text))
                                    .toString();
                              }
                              // vc4.text =
                            });
                          }
                        });

                        // _dc = double.parse(value);
                      }
                    })
                : (type == 'int'
                    ? TextField(
                        controller: vc,
                        inputFormatters: [
                          // FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        focusNode: txt == '箱/盘数' ? _focusNode3 : _focusNode4,
                        onChanged: (value) {
                          if (txt == '箱/盘数' && value != '') {
                            // _xps = int.parse(value);
                            _focusNode3.addListener(() {
                              if (!_focusNode3.hasFocus) {
                                setState(() {
                                  vc4.text = value;
                                  if (vc4.text != '') {
                                    vc1.text = (double.parse(value) *
                                            double.parse(vc3.text) *
                                            double.parse(vc5.text))
                                        .toString();
                                  }
                                  // vc4.text =
                                });
                              }
                            });
                          } else if (txt == '装箱数量' && value != '') {
                            // print('------222');
                            _focusNode4.addListener(() {
                              if (!_focusNode4.hasFocus) {
                                if (vc4.text != '') {
                                  vc5.text = value;
                                  setState(() {
                                    vc1.text = (double.parse(value) *
                                            double.parse(vc3.text) *
                                            double.parse(vc4.text))
                                        .toString();
                                    print(
                                        '${double.parse(value)}ff${double.parse(vc3.text)}ff${double.parse(vc4.text)}');
                                  });
                                }
                              }
                            });
                          }
                        })
                    : TextField(
                        controller: vc,
                        inputFormatters: [
                          // FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                          //  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                      )),
            decoration: BoxDecoration(
              // color: Colors.red,
              border: Border.all(width: 1),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
          isScan == true
              ? IconButton(
                  onPressed: () {
                    scanAction(txt);
                  },
                  icon: Icon(Icons.fit_screen_outlined))
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

  @override
  void dispose() {
    super.dispose();
//释放
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
  }
}

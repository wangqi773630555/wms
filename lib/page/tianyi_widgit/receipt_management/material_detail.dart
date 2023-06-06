import 'package:flutter/material.dart';
import 'package:wanma_print/page/tianyi_widgit/receipt_management/post_list.dart';
import '../../../FlutterPlugins.dart';
import '../../../common/config/config.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/dao/data_dao.dart';
import '../../../widget/middle_text.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanma_print/page/common_widgit/select_list/select_item.dart';
import 'package:flutter/services.dart';
import 'dialogs/my_dialog.dart';
import 'dialogs/print_dialog.dart';

class MaterialDetail extends StatelessWidget {
  static const String sName = Config.MATERIAL_DETAIL;
  const MaterialDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('材料收货单'),
          actions: [
            IconButton(
              icon: const Icon(Icons.center_focus_strong_rounded),
              // Icons.qr_code_scanner_outlined,
              tooltip: 'Open shopping cart',
              onPressed: () {
                NavigatorUtils.goMaterialDetail(context, '');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: MaterialDetailBody(args),
        ));
  }
}

class MaterialDetailBody extends StatefulWidget {
  final deliverNo;
  const MaterialDetailBody(this.deliverNo, {Key? key}) : super(key: key);

  @override
  _MaterialDetailBodyState createState() => _MaterialDetailBodyState();
}

class _MaterialDetailBodyState extends State<MaterialDetailBody> {
  late EasyRefreshController _easyfreshController;
  ScanResult? scanResult;
  TextEditingController _searController = TextEditingController();
  late double _wwidth;
  late double _hheight;
  late Map _fhList;
  bool _cirCular = false;
  int _pageNum = 1;
  // var qtyCount = 0;
  var dyPageNum = 1;
  // var dyWlNum = 0;
  List _postList = [];
  List _wlList = [];
  List _selectList = [];
  List detail_ids_list = [];
  late List<SelectItem> _selectValueList = [];
  int cellSelectCount = 0;
  bool isDeferentWare = false;
  bool isShowPost = false;
  var defaultWare;
  // bool selectCell = false;
  var imgUrl = 'images/on.png';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initDatas(widget.deliverNo);

    // print('---cellSelectList-----$cellSelectList');
    _easyfreshController = EasyRefreshController();
    Future.delayed(Duration.zero, () async {
      var args = ModalRoute.of(context)!.settings.arguments;
      if (args == null || args == '') {
        await _scan();
      } else {
        scanResult = ScanResult(
            type: ResultType.Error,
            format: BarcodeFormat.unknown,
            rawContent: args.toString());
      }
      // print('---------------scanResult------------' + scanResult!.rawContent);
      if (scanResult?.rawContent != "") {
        initDatas(scanResult!.rawContent, false);
      } else {
        Navigator.pop(context);
      }
    });
  }

  Future<void> _scan() async {
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
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
            type: ResultType.Error,
            format: BarcodeFormat.unknown,
            rawContent: '00000000');
      });
    }
  }

  initDatas(dev, isPost) {
    DataDao.getInfoByDeliverNo(dev).then((res) {
      _cirCular = true;
      if (res != null && res.result) {
        setState(() {
          var data = res.data['data'];
          _fhList = data['head'];
          _postList = data['acc_details'];
          _wlList = data['part_details'];
          // _wlList.add(_wlList[0]);
          // _wlList.add(_wlList[0]);
          // _wlList.add(_wlList[0]);
          print('-----${_fhList['status_text']}--$isPost');
          if (_fhList['status_text'] == '已过帐' ||
              _fhList['status_text'] == '部分过账') {
            isShowPost = true;
          }
          if (isPost == true) {
            postDialog();
          }
          // print('objec-------$_postList---t');
          _selectList = [];
          if (_selectList.length == 0) {
            for (var element in _wlList) {
              // if (element['is_acc'] == 'N') {
              _selectList.add(false);
              // }
            }
          }
        });
      }

      // setState(() {});
    });
  }

  upDatas(wlId, qty) {
    DataDao.getUpdateQty(wlId, qty).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        Navigator.pop(context);
        Fluttertoast.showToast(msg: '修改成功');
      }
      _cirCular = true;
      setState(() {
        initDatas(_fhList['deliver_no'], false);
      });
    });
  }

  //过账
  postDatas(
      deliverNo, postDate, wareId, isUseForklift, isNeedUnloading, detailIds) {
    DataDao.getBillAcc(deliverNo, postDate, wareId, isUseForklift,
            isNeedUnloading, detailIds)
        .then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        Navigator.pop(context);
        // NavigatorUtils.goMaterialReceiptDetail(context, _fhList['deliver_no']);
        // Fluttertoast.showToast(msg: '执行成功');

        _cirCular = true;
        setState(() {
          initDatas(_fhList['deliver_no'], true);
          cellSelectCount = 0;
        });
      }
    });
  }

  wareListData() {
    _selectValueList = [];
    DataDao.getWareList().then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        for (Map element in data) {
          _selectValueList.add(SelectItem(
              label: element['ware_name'],
              value: element['ware_id'],
              checked: false));
        }

        postAlert();
      } else {}
      _cirCular = true;
      setState(() {});
    });
  }

  postAlert() {
    // NavigatorUtils.goMaterialReceiptDetail(context, _fhList['deliver_no']);

    detail_ids_list = [];
    var ware = [];
    for (var i = 0; i < _wlList.length; i++) {
      if (_selectList[i] == true) {
        detail_ids_list.add(_wlList[i]['id']);
        ware.add(_wlList[i]['default_ware']);
      }
    }
    // print('33333#####$ware');
    defaultWare = ware[0];
    for (var element in ware) {
      if (element != defaultWare) {
        isDeferentWare = true;
      }
    }

    if (detail_ids_list.length > 0) {
      // print('~~~~~~~~~~$_selectValueList');
      showDialog(
          context: context,
          builder: (context) {
            return PrintDialog(
              title: "修改信息",
              deferentWare: isDeferentWare,
              content: "",
              rowsNum: '',
              okBtnTap: () async {
                final prefs = await SharedPreferences.getInstance();
                String startTime = prefs.getString('time')!;

                String cc_flag = 'N';
                String zx_flag = 'N';
                // if (prefs.getBool('cc') != null) {
                if (prefs.getBool('cc') == false) {
                  cc_flag = 'N';
                } else {
                  cc_flag = "Y";
                }
                if (prefs.getBool('zx') == false) {
                  zx_flag = 'N';
                } else {
                  zx_flag = 'Y';
                }

                defaultWare = prefs.getString('kw')!;
                // print('+++$ware_id_select++++++$cc_flag++$zx_flag++++');
                // print('=====$detail_ids_list==+++__-$startTime-----3333####');
                if (_fhList['deliver_no'] == null ||
                    _fhList['deliver_no'] == '') {
                  Fluttertoast.showToast(msg: '发货单号为空');
                  return;
                }
                if (defaultWare == '') {
                  Fluttertoast.showToast(msg: '库位号为空');
                  return;
                }

                Navigator.pop(context);

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('是否确认过账'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                // _cirCular = false;

                                postDatas(
                                    _fhList['deliver_no'],
                                    startTime,
                                    defaultWare,
                                    cc_flag,
                                    zx_flag,
                                    detail_ids_list);
                              },
                              child: Text('确认')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('取消'))
                        ],
                      );
                    });
              },
              selectValuesetList: _selectValueList,
              title2: '${detail_ids_list.length}',
              wareValue:
                  (defaultWare == '' || defaultWare == null) ? '' : defaultWare,
            );
          });
    } else {
      Fluttertoast.showToast(msg: '请勾选相关物料');
    }
  }

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;
    return !_cirCular
        ? Center(
            child: Container(
            margin: EdgeInsets.only(top: 200),
            child: CircularProgressIndicator(
              semanticsLabel: '加载中...',
            ),
          ))
        : Container(
            child: Column(
              children: [
                Container(
                    height: _hheight - 150,
                    // color: Colors.cyan,
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                                // height: _hheight - 145,
                                child: Column(
                              children: [
                                _searchRow(),
                                _cardForDeliver(),
                                _cardForPost(),
                                _cardForMaterial()
                              ],
                            )),
                          ],
                        ),
                      ),
                    )),
                Container(
                  // color: Colors.red,
                  child: backAndToNext(),
                )
              ],
            ),
          );
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
        // prefixIcon:
        suffixIcon: Icon(Icons.search),
        fillColor: Colors.white,
      ),
      onSubmitted: (text) {
        NavigatorUtils.goMaterialDetail(context, text);
      },
    );
  }

//发货
  Widget _cardForDeliver() {
    return ExpansionTile(
      initiallyExpanded: true,
      textColor: Colors.black,
      children: [
        _getRowText('供应商:', _fhList['supplier_name'] ?? ''),
        _getRowText('供应商编码:', _fhList['supplier_no'] ?? ''),
        _getRowText('内向交货单号:', _fhList['inbound_deliver_no'] ?? ""),
        _getRowText('送货日期:', _fhList['deliver_time'] ?? ''),
        _getRowText('订单号:', _fhList['order_no'] ?? ''),
      ],
      title: Container(
        child: Row(
          children: [
            Container(
              width: 100,
              child: Text(
                '发货单号:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: SelectableText(
                _fhList['deliver_no'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardForPost() {
    return isShowPost == true
        ? ExpansionTile(
            initiallyExpanded: true,
            textColor: Colors.black,
            title: Text(
              '过账详情',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: _postList
                .map((e) => postCellForRow(
                    e['post_date'],
                    e['ekotx'],
                    e['mblnr'],
                    e['acc_user'],
                    e['ware_name'],
                    e['operate_time']))
                .toList(),
          )
        : Container();
  }

  Widget _cardForMaterial() {
    List<Widget> widgetList = [];
    for (var i = 0; i < _wlList.length; i++) {
      widgetList.add(materialCellForRow(i));
    }
    if (widgetList.length > _wlList.length) {
      print('物料列表数据列表错误');
    }
    return !_cirCular
        ? Center(
            child: CircularProgressIndicator(
              semanticsLabel: '加载中...',
            ),
          )
        : ExpansionTile(
            initiallyExpanded: true,
            textColor: Colors.black,
            title: Text(
              '物料明细',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: widgetList
            //  _wlList.map((e) => null).toList(),
            );
  }

  Widget postCellForRow(p, e, m, a, w, o) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _getRowText('过账日期:', p ?? ''),
          _getRowText('采购组织:', e ?? ''),
          _getRowText('凭证号:', m ?? ''),
          _getRowText('过账人:', a ?? ''),
          _getRowText('库位:', w ?? ''),
          _getRowText('操作实际时间:', o ?? ''),
        ],
      ),
    );
  }

  Widget materialCellForRow(index) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 180,
            child: Row(
              children: [
                _wlList[index]['is_acc'] == 'N'
                    ? Container(
                        width: 30,
                        height: 30,
                        child: Checkbox(
                          value: _selectList[index],
                          activeColor: Color.fromARGB(255, 54, 244, 67),
                          onChanged: (value) {
                            setState(() {
                              _selectList[index] = value!;
                              if (value == true) {
                                cellSelectCount++;
                              } else if (value == false) {
                                cellSelectCount--;
                              }
                              // print('value:--$value---');
                              // print('cellSelectList---$_selectList');
                            });
                          },
                        ),
                      )
                    : Container(
                        width: 19,
                        height: 19,
                        margin: EdgeInsets.only(right: 11),
                        color: Color.fromARGB(255, 229, 226, 226),
                        child: Checkbox(
                          value: false,
                          activeColor: Color.fromARGB(255, 54, 244, 67),
                          onChanged: (value) {
                            // print('cellSelectList---$_selectList');
                          },
                        ),
                      ),
                Container(
                  height: 165,
                  width: 300,
                  child: Column(children: [
                    // _getRowText('id:', _wlList[index]['id'] ?? ''),
                    _getRowText('物料描述:', _wlList[index]['part_name'] ?? ''),
                    _numRowText(
                        '数量:',
                        '${_wlList[index]['qty'] ?? ''}/${_wlList[index]['acc_qty'] ?? ''}${_wlList[index]['part_unit'] ?? ''}',
                        index),
                    _getRowText('物料号:', _wlList[index]['part_id'] ?? ''),
                    _getRowText('物料批次:', _wlList[index]['part_batch'] ?? ''),
                    _getRowText('明细行:', _wlList[index]['detail_no'] ?? ''),
                  ]),
                ),
              ],
            ),
          ),

          // Divider(),
          ButtonTheme(
            child: ButtonBar(
              children: <Widget>[
                _buttonStyle(
                    '打印', Colors.white, Colors.blue, 100, 20, Colors.grey, 30,
                    () async {
                  final prefs = await SharedPreferences.getInstance();
                  dyPageNum = 1;
                  // dyWlNum = 1;

                  double upNum = _wlList[index]['acc_qty'];
                  prefs.setDouble('wl', upNum);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return MyDialog(
                          title: "物料信息",
                          content: '单张物料',
                          title2: "打印张数",
                          flag: "dayin",
                          model: _fhList,
                          f: () {
                            upNum = prefs.getDouble('wl')!;
                            print('====$dyPageNum==+++++$upNum');
                            String part_name =
                                _wlList[index]['part_name'] ?? '';
                            String part_id = _wlList[index]['part_id'] ?? '';
                            String part_batch =
                                _wlList[index]['part_batch'] ?? '';
                            var id = _wlList[index]['id'];

                            String ids = '001';
                            for (int i = 0; i < dyPageNum; i++) {
                              ids = ids + "001,";
                            }
                            print('${id}');
                            toPrint(
                                part_name +
                                    ";" +
                                    part_id +
                                    ";" +
                                    part_batch +
                                    ";" +
                                    '${_wlList[index]['acc_qty'] ?? ''}' +
                                    ";" +
                                    '${dyPageNum}' +
                                    ";" +
                                    '${upNum}' +
                                    ";",
                                id,
                                dyPageNum,
                                upNum);

                            Navigator.pop(context);
                          },
                          c1: (int c) {
                            // upNum = c;
                          },
                          c2: (int c) {
                            // upNum = c;
                          },
                          c3: (int c) {
                            // upNum = c;
                          },
                          c11: (int c) {
                            dyPageNum = c;
                          },
                          c22: (int c) {
                            dyPageNum = c;
                          },
                          c33: (int c) {
                            dyPageNum = c;
                          },
                          // f2: (String) {},
                          // dyzs: dyWlNum,
                          dyzs: dyPageNum, upDataNum: upNum,
                          // isClick: false,
                        );
                      });
                }),
                _wlList[index]['is_acc'] == 'N'
                    ? _buttonStyle(
                        '修改',
                        Color.fromARGB(255, 209, 232, 251),
                        Color.fromARGB(255, 15, 86, 144),
                        100,
                        10,
                        Colors.white,
                        30, () async {
                        final prefs = await SharedPreferences.getInstance();

                        if (_fhList.isNotEmpty) {
                          // dyWlNum = (_wlList[index]['acc_qty']).toInt();

                          double upNum = _wlList[index]['acc_qty'];
                          prefs.setDouble('wl', upNum);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return MyDialog(
                                  title: "修改信息",
                                  content: "实际收货",
                                  model: _fhList,
                                  f: () {
                                    // _cirCular = false;

                                    var numStr = prefs.getDouble('wl');
                                    print('======+++++$numStr');
                                    upDatas(_wlList[index]['id'], numStr);
                                  },
                                  // f2: (String text) {
                                  //   print('==+++++++=====$text');
                                  //   setState(() {});
                                  // },
                                  c1: (c) {
                                    //++
                                    // qtyCount = c;
                                  },
                                  c2: (c) {
                                    //--
                                    // qtyCount = c;
                                  },
                                  c3: (c) {
                                    // qtyCount = c;
                                  },
                                  c11: (int) {},
                                  c22: (int) {},
                                  c33: (int) {},
                                  dyzs: dyPageNum,
                                  // dzwl: dyPageNum,
                                  upDataNum: upNum,
                                  // isClick: false,
                                );
                              });
                        }
                      })
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  void toPrint(String result, var detail_id, var qty_print, var part_per_qty) {
    DataDao.genPrintIdsByDetailId(detail_id, qty_print, part_per_qty)
        .then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        var idsList = data['ids'];
        String ids = '';
        for (var id in idsList) {
          ids = ids + '$id,';
        }
        FlutterPlugins.print(result + ids).then((value) => {setState(() {})});
      }
    });
  }

  Widget _numRowText(t1, t2, index) {
    Color c = Colors.black;

    return Container(
      // color: Colors.red,
      width: _wwidth - 95,
      child: Row(
        children: [
          Container(
            width: 60,
            child: Text(
              t1,
              style: TextStyle(),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 0),
          ),
          Container(
            width: _wwidth - 95 - 60,
            child: _wlList[index]['qty'] == _wlList[index]['acc_qty']
                ? Text(
                    t2,
                    style: TextStyle(color: c),
                  )
                : Text(
                    t2,
                    style: TextStyle(color: Colors.red),
                  ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 0),
          )
        ],
      ),
    );
  }

  Widget _statusStyle(text) {
    Color textColor = Colors.black;
    Color bgColor = Colors.white;
    switch (text) {
      case '未过账':
        textColor = Color.fromARGB(255, 239, 119, 54);
        bgColor = Color.fromARGB(255, 246, 222, 188);
        break;
      case '部分过账':
        textColor = Color.fromARGB(255, 5, 152, 54);
        bgColor = Color.fromARGB(255, 209, 234, 211);
        break;

      case '已过帐':
        textColor = Color.fromARGB(255, 3, 117, 13);
        bgColor = Color.fromARGB(255, 195, 245, 205);
        break;
      case '已取消':
        textColor = Color.fromARGB(255, 63, 63, 62);
        bgColor = Color.fromARGB(255, 224, 221, 218);
        break;
      default:
        break;
    }
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 10),
      width: 80,
      height: 25,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.circular((20.0)),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buttonStyle(titles, Color bgColore, Color textColor, double ww,
      double rightWW, Color borderCorlor, double h, Function() f) {
    return Container(
      alignment: Alignment.center,
      width: ww,
      height: h,
      margin: EdgeInsets.only(right: rightWW, top: 5
          // left:
          ),
      child: InkWell(
        child: Text(
          titles,
          style: TextStyle(color: textColor, fontSize: 15),
          textAlign: TextAlign.center,
        ),
        onTap: f,
      ),
      decoration: BoxDecoration(
        color: bgColore,
        border: Border.all(width: 1, color: borderCorlor),
        borderRadius: new BorderRadius.circular((20.0)),
        boxShadow: [
          BoxShadow(
              color: bgColore,
              offset: Offset(0.5, 0.5),
              blurRadius: 1.0,
              spreadRadius: 1.0),
        ],
      ),
    );
  }

  Widget _getRowText(String label, dynamic value) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: MiddleText(label, Alignment.centerLeft),
        ),
        Expanded(flex: 3, child: MiddleText(value, Alignment.centerRight)),
      ],
    ));
  }

  postDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return PostList(modelList: _postList);
        });
  }

  Widget backAndToNext() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 5),
        alignment: Alignment.center,
        // decoration: BoxDecoration(

        //   borderRadius: new BorderRadius.circular((10.0)),
        // ),
        decoration: BoxDecoration(
          color: cellSelectCount > 0
              ? Color.fromARGB(255, 70, 215, 75)
              : Color.fromARGB(255, 194, 191, 191),
          // border: Border.all(width: 1, color: borderCorlor),
          borderRadius: new BorderRadius.circular((20.0)),
        ),
        width: 250,
        height: 45,
        child: Text('过 账', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      onTap: () {
        wareListData();

        // postAlert();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
  }
}

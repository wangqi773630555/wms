import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/net/LogUtil.dart';
import 'package:wanma_print/page/common_widgit/picker/picker_second_level.dart';
import 'package:wanma_print/page/common_widgit/picker/picker_three_level.dart';
import 'package:wanma_print/page/dianlan_widgit/search_material.dart';
import 'package:wanma_print/page/dianlan_widgit/search_material_filtrate.dart';
import 'package:wanma_print/widget/middle_text_right.dart';
import '../../common/config/config.dart';
import '../../common/config/scanConfig.dart';
import '../../common/dao/data_dao.dart';
import '../../common/event/scan_event.dart';
import '../../common/utils/navigator_utils.dart';
import '../../common/utils/scanevent_utils.dart';
import '../../widget/middle_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common_widgit/picker/picker_model.dart';
import 'current_task.dart';

/**
 * 下架配送
 */

var selectStartResult;
var selectEndResult;
var selectEndSecondLevelResult;
bool switchValue = false;
bool switchValueQz = false;
List<PickerModel> pickerStartData = [];
List<PickerModel> pickerEndData = [];
var sync_id;
List<dynamic> listDefault = [];
bool isLk = false;

class ShelvesDown extends StatefulWidget {
  static final String sName = Config.SHELVES_DOWN;

  @override
  _ShelvesDownState createState() => _ShelvesDownState();
}

class _ShelvesDownState extends State<ShelvesDown> {
  ScanResult? scanResult;

  StreamSubscription? stream;
  List<dynamic> list = [];

  //用于筛选初始库位的 物料id

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ScanConfig.scanPage = ScanConfig.PAGE_LOAD_PART;
    stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
      if (event.page == ScanConfig.PAGE_LOAD_PART) {}
    });
    selectStartResult = null;
    selectEndResult = null;
    sync_id = null;
    isLk = false;
    switchValue = false;
    switchValueQz =false;
    pickerStartData.clear();
    pickerEndData.clear();
    getWmWare2("",0);
    getWmWare2("0",1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(centerTitle: true, title: Text('下架配送'), actions: <Widget>[]),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
              child: Container(
                child: Column(children: [
                  Row(
                    children: [
                      Text(
                        '起始库位',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(200, 0, 0, 0),
                        ),
                        // showCursor: true,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(3)),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            child: BottomSheetStart(() {
                              setState(() {});
                            }),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: 40,
                          child: IconButton(
                            icon: Icon(
                              Icons.qr_code_scanner_outlined,
                              size: 20,
                            ),
                            onPressed: () async {
                              await _scan();
                              if (scanResult?.type != ResultType.Error) {}
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 40),
                    alignment: Alignment.topLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(
                             '',
                              style: TextStyle(fontSize: 12),
                            )),
                        SizedBox(
                          height: 30,
                          child: OutlinedButton(
                              onPressed: () {
                                //搜索物料
                                var result = Navigator.pushNamed(
                                    context, SearchMaterialFiltrate.sName);
                                result.then((dynamic value) => {
                                  setState(() {
                                    selectStartResult = Map();
                                    selectStartResult['countyId']= value!['id'];
                                    selectStartResult['address'] = value!['name1']+'>'+value!['name2']+'>'+value!['name3'];
                                    selectStartResult['countyId'];
                                    selectStartResult['lk'] = value!['lk'];
                                    //增加是否立库
                                    if (selectStartResult['lk'] == 1) {
                                      sync_id = selectStartResult['countyId'];
                                      isLk = true;
                                      getWmsStockParts();
                                    } else {
                                      isLk = false;
                                    }

                                  }),
                                });
                              },
                              child: Text(
                                '按物料筛选库位',
                                style: TextStyle(fontSize: 14),
                              )),
                        ),
                      ],
                    ),
                  ),

                  Padding(padding: EdgeInsets.all(3)),

                  Row(children: [

                    Row(
                      children: [
                        Text(
                          switchValue ? '配送 > 到库区' : '配送 > 到库位',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(200, 0, 0, 0),
                          ),
                          // showCursor: true,
                        ),
                        Switch(
                            value: switchValue,
                            onChanged: (value) {
                              setState(() {
                                switchValue = !switchValue;
                                selectEndResult = null;
                                selectEndSecondLevelResult = null;
                              });
                            }),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Row(
                      children: [
                        Text(
                          '强制入库',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(200, 0, 0, 0),
                          ),
                          // showCursor: true,
                        ),
                        Switch(
                            value: switchValueQz,
                            onChanged: (value) {
                              setState(() {
                                switchValueQz = !switchValueQz;
                              });
                            }),
                      ],
                    ),
                  ],),

                  //配送库位
                  Row(
                    children: [
                      Text(
                        switchValue ? '配送库区' : '配送库位',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(200, 0, 0, 0),
                        ),
                        // showCursor: true,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(3)),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            child: BottomSheetEnd(),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: 40,
                          child: IconButton(
                            icon: Icon(
                              Icons.qr_code_scanner_outlined,
                              size: 20,
                            ),
                            onPressed: () async {
                              await _scan();
                              if (scanResult?.type != ResultType.Error) {}
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(3)),
                  Row(
                    children: [
                      Text(
                        '配送物料',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(200, 0, 0, 0),
                        ),
                        // showCursor: true,
                      ),
                      Container(
                        child: Visibility(
                          visible: !isLk,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 25,
                            ),
                            onPressed: () {
                              //添加数据
                              setState(() {
                                Map map = Map();
                                map['controller'] = TextEditingController();
                                list.add(map);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  isLk ? _createDefaultListViewItem() : _createListViewItem(),
                ]),
              ),
            ),
          ),
          SizedBox(
            height: 35.0,
            child: ElevatedButton(
                onPressed: () => {
                  setState(() {
                    if (selectStartResult == null) {
                      Fluttertoast.showToast(msg: '请选择初始库位');
                      return;
                    }
                    if (switchValue) {
                      if (selectEndSecondLevelResult == null) {
                        Fluttertoast.showToast(msg: '请选择配送库位');
                        return;
                      }
                    } else {
                      if (selectEndResult == null) {
                        Fluttertoast.showToast(msg: '请选择配送库位');
                        return;
                      }
                    }
                    var startId = selectStartResult['countyId'];
                    var endId = switchValue
                        ? selectEndSecondLevelResult['cityId']
                        : selectEndResult['countyId'];
                    Map<String, dynamic> map = Map();
                    if (isLk) {
                      // 1上架 \2 下架\3库内移库\4配送\5回库
                      map['task_type'] = '2';
                      map['from_ware'] = startId.toString();
                      map['to_ware'] = endId.toString();
                      map['tk'] = switchValue? 'Y':'N';
                      List<Map> details = [];
                      for (int i = 0; i < listDefault.length; i++) {
                        Map<String, dynamic> map = Map();
                        map['part_name'] = listDefault[i]['part_name'];
                        map['part_id'] = listDefault[i]['part_id'];
                        map['qty'] = double.parse(listDefault[i]['qty'].toString());
                        details.add(map);
                      }
                      map['qzrk'] =  switchValueQz?'1':'0';
                      map['details'] = details;
                    } else {
                      // 1上架 \2 下架\3库内移库\4配送\5回库
                      map['task_type'] = '2';
                      map['from_ware'] = startId.toString();
                      map['to_ware'] = endId.toString();
                      List<Map> details = [];
                      for (int i = 0; i < list.length; i++) {
                        Map<String, dynamic> map = Map();
                        map['part_name'] = list[i]['name'];
                        map['part_id'] = list[i]['id'];
                        if(list[i]['controller'].text==''){
                          Fluttertoast.showToast(msg: '请输入数量');
                          return;
                        }
                        map['qty'] = double.parse(list[i]['controller'].text);
                        details.add(map);
                      }
                      map['qzrk'] =  switchValueQz?'1':'0';
                      map['details'] = details;
                    }

                    createAgvEqpTask(map);
                  }),
                },
                child: Text('  确认下架配送  ')),
          ),
          Padding(padding: EdgeInsets.all(10)),
        ],
      ),
    );
  }

  Widget _searchWidget(String hint, TextEditingController _controller) {
    return Row(
      children: [
        Text(
          hint,
          style: TextStyle(fontSize: 14),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
        Expanded(
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(15), //限制长度
              FilteringTextInputFormatter.allow(RegExp("[0-9.]")),//数字包括小数
            ],
            controller: _controller,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(5),
              disabledBorder: OutlineInputBorder(
                /*边角*/
                borderRadius: BorderRadius.all(
                  Radius.circular(2), //边角为5
                ),
                borderSide: BorderSide(
                  color: Colors.grey, //边线颜色为白色
                  width: 1, //边线宽度为2
                ),
              ),
              enabledBorder: OutlineInputBorder(
                /*边角*/
                borderRadius: BorderRadius.all(
                  Radius.circular(2), //边角为5
                ),
                borderSide: BorderSide(
                  color: Colors.grey, //边线颜色为白色
                  width: 1, //边线宽度为2
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey, //边框颜色为白色
                  width: 1, //宽度为5
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(2), //边角为30
                ),
              ),
              hintText: '',
            ),
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
        Text(
          'kg',
          style: TextStyle(fontSize: 14),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
      ],
    );
  }

  Widget _searchDefaultWidget(
      String hint, TextEditingController _controller, String qty) {
    _controller.text = qty;
    return Row(
      children: [
        Text(
          hint,
          style: TextStyle(fontSize: 14),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
        Expanded(
          child: TextField(
            enabled: false,
            controller: _controller,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(5),
              disabledBorder: OutlineInputBorder(
                /*边角*/
                borderRadius: BorderRadius.all(
                  Radius.circular(2), //边角为5
                ),
                borderSide: BorderSide(
                  color: Colors.grey, //边线颜色为白色
                  width: 1, //边线宽度为2
                ),
              ),
              enabledBorder: OutlineInputBorder(
                /*边角*/
                borderRadius: BorderRadius.all(
                  Radius.circular(2), //边角为5
                ),
                borderSide: BorderSide(
                  color: Colors.grey, //边线颜色为白色
                  width: 1, //边线宽度为2
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey, //边框颜色为白色
                  width: 1, //宽度为5
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(2), //边角为30
                ),
              ),
              hintText: '',
            ),
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
        Text(
          'kg',
          style: TextStyle(fontSize: 14),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
      ],
    );
  }

  /**
   * 创建列表item(不可修改)
   */
  Widget _createDefaultListViewItem() {
    List<Widget> _list = [];
    for (int i = 0; i < listDefault.length; i++) {
      _list.add(_createDefaultItem(i, "下架数量："));
    }
    return Column(
      children: _list,
    );
  }

  Widget _createDefaultItem(int index, String hint) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        listDefault[index]['part_name'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35.0,
                  child: _searchDefaultWidget(
                      hint,
                      TextEditingController(),
                      listDefault[index]['qty']
                          .toString()),
                ),
              ],
            ),
          ),
          Container(
            child: Visibility(
              visible: false,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 25,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    list.removeAt(index);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 创建列表item
   */
  Widget _createListViewItem() {
    List<Widget> _list = [];
    for (int i = 0; i < list.length; i++) {
      _list.add(_createItem(i, "下架数量：", list[i]['controller']));
    }
    return Column(
      children: _list,
    );
  }

  Widget _createItem(
      int index, String hint, TextEditingController _controller) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  child: OutlinedButton(
                    onPressed: () {
                      var result =
                      Navigator.pushNamed(context, SearchMaterial.sName);
                      result.then((dynamic value) => {
                        setState(() {
                          list[index]['name'] = value!['name'];
                          list[index]['id'] = value['id'];
                        }),
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        list[index]['name'] != null
                            ? list[index]['name']
                            : '请选择物料',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35.0,
                  child: _searchWidget(hint, _controller),
                ),
              ],
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 25,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  list.removeAt(index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    if (stream != null) {
      stream?.cancel();
      stream = null;
    }
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
      scanResult = result;
    } on PlatformException catch (e) {
      scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: '00000000');
    }
  }

  getWmWare2(var liku_tag,var page) {
    DataDao.getWmWare2(liku_tag,page).then((res) {
      if(res!=null&&res.result) {
        setState(() {
          var datas = res.data['data']['wares'];
          for (int i = 0; i < datas.length; i++) {
            if (page == 0) {
              pickerStartData.add(PickerModel.fromMap(datas[i]));
            } else if (page == 1) {
              pickerEndData.add(PickerModel.fromMap(datas[i]));
            }
          }
        });
      }
    });
  }

  createAgvEqpTask(Map<String, dynamic> body) {
    DataDao.createAgvEqpTask(body).then((res) {
      if(res!=null&&res.result) {
        Fluttertoast.showToast(msg: '提交成功');
        Navigator.pop(context);
        NavigatorUtils.goPage(context, CurrentTask.sName);
      }
    });
  }
  getWmsStockParts() {
    DataDao.getWmsStockParts(sync_id).then((res) {
      if(res!=null&&res.result) {
        var datas = res.data['data']['parts'];
        listDefault = datas;
        setState(() {

        });
      }
    });
  }
}

class BottomSheetStart extends StatefulWidget {
  final Function onChanged;

  BottomSheetStart(this.onChanged);

  @override
  BottomSheetState createState() => BottomSheetState(onChanged);
}

class BottomSheetState extends State<BottomSheetStart> {
  final Function onChanged;

  BottomSheetState(this.onChanged);

  void handleSelect(Map target) {
    setState(() {
      selectStartResult = target;
      LogUtil.d(selectStartResult['lk'].toString());
      if (selectStartResult['lk'] == 1) {
        sync_id = selectStartResult['countyId'];
        isLk = true;
        getWmsStockParts();
      } else {
        isLk = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return OutlinedButton(
      onPressed: () {
        showBottomSheet(
            context: context,
            builder: (_) => Container(
              height: 260.0,
              child: PickerThreeLevel(
                handleSelect,
               /* selectStartResult == null
                    ? 0
                    : selectStartResult['proviceIndex'],
                selectStartResult == null
                    ? 0
                    : selectStartResult['cityIndex'],
                selectStartResult == null
                    ? 0
                    : selectStartResult['countyIndex'],*/
                0,0,0,
                pickerStartData,
              ),
            ));
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          selectStartResult != null
              ? selectStartResult['address']
              : '请选择起始库位...',
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  //6.1
  getWmsStockParts() {
    DataDao.getWmsStockParts(sync_id).then((res) {
      if(res!=null&&res.result) {
        var datas = res.data['data']['parts'];
        listDefault = datas;
        onChanged();
      }
    });
  }
}

class BottomSheetEnd extends StatefulWidget {
  @override
  BottomSheetEndState createState() => BottomSheetEndState();
}

class BottomSheetEndState extends State<BottomSheetEnd> {
  ///接收选择的结果
  void handleSelect(Map target) {
    setState(() {
      if (switchValue) {
        selectEndSecondLevelResult = target;
      } else {
        selectEndResult = target;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return OutlinedButton(
      onPressed: () {
        if (switchValue) {
          showBottomSheet(
              context: context,
              builder: (_) => Container(
                height: 260.0,
                child: PickerSecondLevel(
                  handleSelect,
                  selectEndSecondLevelResult == null
                      ? 0
                      : selectEndSecondLevelResult['proviceIndex'],
                  selectEndSecondLevelResult == null
                      ? 0
                      : selectEndSecondLevelResult['cityIndex'],
                  pickerEndData,
                ),
              ));
        } else {
          showBottomSheet(
              context: context,
              builder: (_) => Container(
                height: 260.0,
                child: PickerThreeLevel(
                  handleSelect,
                  selectEndResult == null
                      ? 0
                      : selectEndResult['proviceIndex'],
                  selectEndResult == null
                      ? 0
                      : selectEndResult['cityIndex'],
                  selectEndResult == null
                      ? 0
                      : selectEndResult['countyIndex'],
                  pickerEndData,
                ),
              ));
        }
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          switchValue
              ? selectEndSecondLevelResult != null
              ? selectEndSecondLevelResult['address']
              : '请选择配送库区...'
              : selectEndResult != null
              ? selectEndResult['address']
              : '请选择配送库位...',
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}

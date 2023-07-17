import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/net/LogUtil.dart';
import 'package:wanma_print/page/common_widgit/picker/picker_three_level.dart';
import 'package:wanma_print/page/dianlan_widgit/search_material.dart';
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

/**
 * 任务（任务确认）
 */

var selectStartResult;
List<PickerModel> pickerData = [];

class TaskWaitNotarize extends StatefulWidget {
  static final String sName = Config.TASK_WAIT_NOTARIZE;

  @override
  _TaskWaitNotarizeState createState() => _TaskWaitNotarizeState();
}

class _TaskWaitNotarizeState extends State<TaskWaitNotarize> {
  ScanResult? scanResult;

  StreamSubscription? stream;
  var data;
  List<dynamic> listDefault = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ScanConfig.scanPage = ScanConfig.PAGE_LOAD_PART;
    stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
      if (event.page == ScanConfig.PAGE_LOAD_PART) {}
    });
    selectStartResult = null;
    pickerData.clear();
    getWmWare2("", 8);
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments;
    getWmsStockParts();
    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: Text('任务确认'), actions: <Widget>[]),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
              child: Container(
                child: Column(children: [
                  Row(
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.yellow[700],
                        size: 60,
                      ),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '任务待确认',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                                (data['from_ware_name1'] != null
                                        ? data['from_ware_name1']
                                        : "") +
                                    '>' +
                                    (data['from_ware_name2'] != null
                                        ? data['from_ware_name2']
                                        : "") +
                                    '>' +
                                    (data['from_ware_name3'] != null
                                        ? data['from_ware_name3']
                                        : ""),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54)),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Divider(
                              height: 1,
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      (data['to_ware_name1'] != null
                                              ? data['to_ware_name1']
                                              : "") +
                                          '>' +
                                          (data['to_ware_name2'] != null
                                              ? data['to_ware_name2']
                                              : "") +
                                          '>' +
                                          (data['to_ware_name3'] != null
                                              ? data['to_ware_name3']
                                              : ""),
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black54)),
                                ),
                                Text(
                                    data['add_user'] != null
                                        ? data['add_user']
                                        : '',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  _createDefaultListViewItem(),
                  Padding(padding: EdgeInsets.all(10)),
                  Row(
                    children: [
                      Text(
                        '放置库位',
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
                            child: BottomSheetStart(),
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
                ]),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              height: 40.0,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow[700],
                    //change background color of button
                    //change text color of button
                  ),
                  onPressed: () => {
                        setState(() {
                          if (selectStartResult == null) {
                            Fluttertoast.showToast(msg: '请选择库位');
                            return;
                          }
                          var ware = selectStartResult['countyId'];
                          Map<String, dynamic> map = Map();
                          map['task_id'] = data['task_id'];
                          //map['eqp_id'] = data['eqp_id'];
                          map['ware'] = ware;
                          List<Map> details = [];
                          for (int i = 0; i < listDefault.length; i++) {
                            Map<String, dynamic> map = Map();
                            map['part_name'] = listDefault[i]['part_name'];
                            map['part_id'] = listDefault[i]['part_id'];
                            map['qty'] =
                                double.parse(listDefault[i]['qty'].toString());
                            details.add(map);
                          }
                          map['details'] = details;
                          confirmTask(map);
                        }),
                      },
                  child: Text('任务确认')),
            ),
          ),
        ],
      ),
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
                  child: _searchDefaultWidget(hint, TextEditingController(),
                      listDefault[index]['qty'].toString()),
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
                    listDefault.removeAt(index);
                  });
                },
              ),
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

  confirmTask(Map<String, dynamic> body) {
    DataDao.confirmTask(body).then((res) {
      if (res != null && res.result) {
        Fluttertoast.showToast(msg: '提交成功');
        Navigator.pop(context, '1');
      }
    });
  }

  getWmWare2(var liku_tag, var page) {
    DataDao.getWmWare2(liku_tag, page).then((res) {
      if (res != null && res.result) {
        setState(() {
          var datas = res.data['data']['wares'];
          for (int i = 0; i < datas.length; i++) {
            pickerData.add(PickerModel.fromMap(datas[i]));
          }
        });
      }
    });
  }

  //6.1
  getWmsStockParts() {
    DataDao.getWmsStockParts(data['sync_id']).then((res) {
      if (res != null && res.result) {
        var datas = res.data['data']['parts'];
        listDefault = datas;
      }
    });
  }
}

class BottomSheetStart extends StatefulWidget {
  @override
  BottomSheetState createState() => BottomSheetState();
}

class BottomSheetState extends State<BottomSheetStart> {
  void handleSelect(Map target) {
    setState(() {
      selectStartResult = target;
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
                    selectStartResult == null
                        ? 0
                        : selectStartResult['proviceIndex'],
                    selectStartResult == null
                        ? 0
                        : selectStartResult['cityIndex'],
                    selectStartResult == null
                        ? 0
                        : selectStartResult['countyIndex'],
                    pickerData,
                  ),
                ));
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          selectStartResult != null
              ? selectStartResult['address']
              : '请选择放置库位...',
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}

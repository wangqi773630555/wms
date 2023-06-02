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

/**
 * 移库
 */

var selectStartResult;
var selectEndResult;
List<PickerModel> pickerData = [];
List<PickerModel> pickerEndData = [];

class WarehouseMove extends StatefulWidget {
  static final String sName = Config.WAREHOUSE_MOVE;

  @override
  _WarehouseMoveState createState() => _WarehouseMoveState();
}

class _WarehouseMoveState extends State<WarehouseMove> {

  ScanResult? scanResult;

  StreamSubscription? stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ScanConfig.scanPage = ScanConfig.PAGE_LOAD_PART;
    stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
      if (event.page == ScanConfig.PAGE_LOAD_PART) {}
    });
    selectStartResult  = null;
    selectEndResult = null;
    pickerData.clear();
    pickerEndData.clear();
    getWmWare2("1",4);
    getWmWare2("1",5);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('移库'), actions: <Widget>[]),
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
                              if (scanResult?.type != ResultType.Error) {
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 40),
                    alignment: Alignment.topLeft,
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text('',style: TextStyle(fontSize: 12),)),
                        SizedBox(
                        height: 30,
                        child:OutlinedButton(onPressed: () {
                          //搜索物料
                          var result = Navigator.pushNamed(context, SearchMaterialFiltrate.sName);
                          result.then((dynamic value) => {
                              //物料id
                              setState(() {
                                selectStartResult = Map();
                                selectStartResult['countyId']= value!['id'];
                                selectStartResult['address'] = value!['name1']+'>'+value!['name2']+'>'+value!['name3'];
                                selectStartResult['countyId'];
                                selectStartResult['lk'] = value!['lk'];
                            }),
                          });

                        }, child: Text('按物料筛选库位',style: TextStyle(fontSize: 14),)),),],
                    ),
                    ) ,

                  Padding(padding: EdgeInsets.all(3)),
                  //目标库位
                  Row(
                    children: [
                      Text(
                        '目标库位',
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
                              if (scanResult?.type != ResultType.Error) {
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(3)),
                ]),
              ),
            ),
          ),
          SizedBox(
            height: 35.0,
            child: ElevatedButton(
                onPressed: () => {
                  setState(() {
                    if(selectStartResult==null){
                      Fluttertoast.showToast(msg: '请选择初始库位');
                      return;
                    }
                    if (selectEndResult == null) {
                      Fluttertoast.showToast(msg: '请选择目标库位');
                      return;
                    }
                    var startId = selectStartResult['countyId'];
                    var endId = selectEndResult['countyId'];
                    Map<String, dynamic> map = Map();
                    // 1上架 \2 下架\3库内移库\4配送\5回库
                    map['task_type'] = '3';
                    map['from_ware'] = startId.toString();
                    map['to_ware'] = endId.toString();
                    List<Map> details  = [];
                    map['details'] = details;
                    createAgvEqpTask(map);
                  }),
                }, child: Text('  确认移库  ')),
          ),
          Padding(padding: EdgeInsets.all(10)),
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

  getWmWare2(var liku_tag,page) {
    DataDao.getWmWare2(liku_tag,page).then((res) {
      if(res!=null&&res.result) {
        setState(() {
          var datas = res.data['data']['wares'];
          for (int i = 0; i < datas.length; i++) {
            if (page == 4) {
              pickerData.add(PickerModel.fromMap(datas[i]));
            } else if (page == 5) {
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
      }
    });
  }

}


class BottomSheetStart extends StatefulWidget {

  @override
  BottomSheetState createState() => BottomSheetState();
}

class BottomSheetState extends State <BottomSheetStart>{
  void handleSelect (Map target) {
    setState(() {
      selectStartResult = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return OutlinedButton(
      onPressed: () {
        showBottomSheet(context: context, builder: (_)=>Container(
          height: 260.0,
          child: PickerThreeLevel(
            handleSelect,
            selectStartResult == null ? 0 : selectStartResult['proviceIndex'],
            selectStartResult == null ? 0 : selectStartResult['cityIndex'],
            selectStartResult == null ? 0 : selectStartResult['countyIndex'],pickerData,
          ),
        ));
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          selectStartResult != null ? selectStartResult['address'] : '请选择起始库位...',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

}

class BottomSheetEnd extends StatefulWidget {

  @override
  BottomSheetEndState createState() => BottomSheetEndState();
}

class BottomSheetEndState extends State <BottomSheetEnd> {
  ///接收选择的结果
  void handleSelect(Map target) {
    setState(() {
        selectEndResult = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return OutlinedButton(
      onPressed: () {
          showBottomSheet(context: context, builder: (_) =>
              Container(
                height: 260.0,
                child: PickerThreeLevel(
                  handleSelect,
                  selectEndResult == null ? 0 : selectEndResult['proviceIndex'],
                  selectEndResult == null ? 0 : selectEndResult['cityIndex'],
                  selectEndResult == null ? 0 : selectEndResult['countyIndex'],
                  pickerEndData,
                ),
              ));
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          selectEndResult != null ? selectEndResult['address'] : '请选择目标库位...',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}




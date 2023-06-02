import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/net/LogUtil.dart';
import 'package:wanma_print/page/common_widgit/picker/picker_three_level.dart';
import 'package:wanma_print/page/dianlan_widgit/current_task.dart';
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
 * 上架
 */

var selectStartResult;
var selectEndResult;
List<PickerModel> pickerStartData = [];
List<PickerModel> pickerEndData = [];

class ShelvesUp extends StatefulWidget {
  static final String sName = Config.SHELVES_UP;

  @override
  _ShelvesUpState createState() => _ShelvesUpState();
}

class _ShelvesUpState extends State<ShelvesUp> {

  ScanResult? scanResult;

  StreamSubscription? stream;
  List<dynamic> list = [];


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
    pickerStartData.clear();
    pickerEndData.clear();
    getWmWare2("0",2);
    getWmWare2("1",3);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('上架'), actions: <Widget>[]),
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
                  Padding(padding: EdgeInsets.all(3)),

                  //目标库位
                  Row(
                    children: [
                      Text(
                        '指定目标库位',
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
                              Icons.delete,
                              size: 20,
                            ),
                            onPressed: () {
                              //添加数据
                              setState(() {
                                selectEndResult = null;
                              });
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
                        '上架物料',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(200, 0, 0, 0),
                        ),
                        // showCursor: true,
                      ),
                      Container(
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
                    ],
                  ),
                  _createListViewItem(),
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
                  var startId = selectStartResult['countyId'];
                  var endId = selectEndResult==""?null:selectEndResult['countyId'];
                  Map<String, dynamic> map = Map();
                  // 1上架 \2 下架\3库内移库\4配送\5回库
                  map['task_type'] = '1';
                  map['from_ware'] = startId.toString();
                  map['to_ware'] = endId.toString();
                  List<Map> details  = [];
                  for(int i=0;i<list.length;i++){
                    Map<String, dynamic> map = Map();
                    map['part_name'] = list[i]['name'];
                    map['part_id'] = list[i]['id'];
                    if(list[i]['controller'].text==''){
                      Fluttertoast.showToast(msg: '请输入数量');
                      return;
                    }
                    map['qty'] = int.parse(list[i]['controller'].text);
                    details.add(map);
                  }
                  map['details'] = details;
                  createAgvEqpTask(map);
                }),
                }, child: Text('  确认上架  ')),
          ),
          Padding(padding: EdgeInsets.all(10)),
        ],
      ),
    );
  }



  Widget _searchWidget(String hint, TextEditingController _controller) {
    return Row(
      children: [
        Text(hint,style: TextStyle(fontSize: 14),),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
        Expanded(child: TextField(
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
        ),),
        Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
        Text('kg',style: TextStyle(fontSize: 14),),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
      ],
    );
  }


  /**
   * 创建列表item
   */
  Widget _createListViewItem() {
    List<Widget> _list = [];
    for (int i = 0; i < list.length; i++) {
      _list.add(_createItem(i,"上架数量：",list[i]['controller']));
    }
    return Column(
      children: _list,
    );
  }

  Widget _createItem(int index,String hint, TextEditingController _controller) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child:Column(
              children: [
                Container(
                  child: OutlinedButton(
                    onPressed: () {
                      var result = Navigator.pushNamed(context, SearchMaterial.sName);
                      result.then((dynamic value) => {
                      setState(() {
                        list[index]['name'] = value!['name'];
                        list[index]['id'] = value!['id'];
                      }),
                      });

                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        list[index]['name']!=null?list[index]['name']:'请选择物料',
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
          ),        ],
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
            if (page == 2) {
              pickerStartData.add(PickerModel.fromMap(datas[i]));
            } else if (page == 3) {
              pickerEndData.add(PickerModel.fromMap(datas[i]));
            }
          }
        });
      }
    });
  }


  test() {
    DataDao.testAgv().then((res) {
      if(res!=null&&res.result) {
        setState(() {
         Fluttertoast.showToast(msg: res.data['msg']);
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
            selectStartResult == null ? 0 : selectStartResult['countyIndex'],pickerStartData,
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
          selectEndResult != null ? selectEndResult['address'] : '请选择目的库位...',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}



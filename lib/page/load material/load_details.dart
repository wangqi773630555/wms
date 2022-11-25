import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/widget/middle_text_right.dart';
import '../../common/config/config.dart';
import '../../common/config/scanConfig.dart';
import '../../common/dao/data_dao.dart';
import '../../common/event/scan_event.dart';
import '../../common/utils/scanevent_utils.dart';
import '../../widget/middle_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MaterialLoadDetails extends StatefulWidget {
  static final String sName = Config.Material_LoadDetails;

  @override
  _MaterialLoadDetailsState createState() => _MaterialLoadDetailsState();
}

class _MaterialLoadDetailsState extends State<MaterialLoadDetails> {
  late double _wwidth;
  TextEditingController _noController = TextEditingController();
  TextEditingController _countController = TextEditingController();
  TextEditingController _lotController = TextEditingController();

  var _code;
  var _part_id;
  var _partName;
  var _part_per_qty;
  var _part_batch;

  var _id;
  var _order_id;
  var _recipe_id;
  var _eqp_id;
  var _recipe_name;

  var _data;
  var _eqps;
  var _time;

  ScanResult? scanResult;
  List<DropdownMenuItem<Object>> items = [];

  StreamSubscription? stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ScanConfig.scanPage = ScanConfig.PAGE_LOAD_PART;
    stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
      if (event.page == ScanConfig.PAGE_LOAD_PART) {
        _getInfoById(event.scanResult);
      }
    });
    print('initState_load_details');
    Future.delayed(Duration.zero, () async {
      _data = ModalRoute.of(context)!.settings.arguments;
      setState(() {
        _order_id = _data['order_id'];
        _recipe_id = _data['id'];
        _recipe_name = _data['title'];
        _eqps = _data['eqps'];
        _time = _data['add_time'];
        _id = _data['uid'];

        //回填缺少二维码code
        //_code = _data['id'];
        if(_id!=null) {
          _part_id = _data['part_id'];
          _partName = _data['part_name'];
          _part_per_qty = _data['release_qty'].toString();
          _part_batch = _data['part_batch'];
          _code = _data['code'];

          _noController.text = _part_id;
          _countController.text = _part_per_qty;
          _lotController.text = _part_batch;

        }

        for (int i = 0; i < _eqps.length; i++) {
          DropdownMenuItem<Object> item = DropdownMenuItem(
            child: Text(_eqps[i]['title']),
            value: _eqps[i]['id'],
          );
          items.add(item);
          if(i==0){
            _eqp_id = _eqps[i]['id'];
          }
          print('${_eqps[i]['id']}000${_data['order_id']}');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: Text('设备上料'), actions: <Widget>[]),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
        child: Container(
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: 15, top: 5),
                    child: Row(
                      children: [
                        Text(
                          '订单号:$_order_id',
                          style: TextStyle(fontSize: 18),
                          // showCursor: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '$_recipe_name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Padding(padding: EdgeInsets.all(5))
              ],
            ),
            Divider(),
            _editTextForScan('物料号', '请输入物料号', _noController),
            Padding(padding: EdgeInsets.all(3)),
            _getRowTextRight('物料名称:', _partName),
            Padding(padding: EdgeInsets.all(3)),
            _DropdownButtonForScan('机号:', '请选择机号'),
            Padding(padding: EdgeInsets.all(3)),
            _editText('上料数量', '请输入上料数量', _countController, true),
            Padding(padding: EdgeInsets.all(3)),
            _editText('上料批次', '请输入物料批次', _lotController, false),
            Padding(padding: EdgeInsets.all(3)),
            //_getRowText('上料人:', '张三'),
            //Padding(padding: EdgeInsets.all(3)),
            _getRowText('上料时间:', _time??""),
            Divider(),
            Padding(
              padding: EdgeInsets.all(6),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               /* SizedBox(
                  height: 35.0,
                  child: ElevatedButton(
                      onPressed: () => {_getInfoById(_noController.text)},
                      child: Text('重新匹配')),
                ),
                Padding(padding: EdgeInsets.all(10)),*/
                SizedBox(
                  height: 35.0,
                  child: ElevatedButton(
                      onPressed: () => {_getSaveData()}, child: Text('确定投料')),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget _getRowText(String label, dynamic value) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          child: MiddleText(label, Alignment.centerLeft),
        ),
        Expanded(flex: 3, child: MiddleText(value, Alignment.centerRight)),
      ],
    ));
  }

  Widget _getRowTextRight(String label, dynamic value) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              child: MiddleTextRight(label, Alignment.centerLeft),
            ),
            Expanded(flex: 3, child: MiddleText(value, Alignment.centerRight)),
          ],
        ));
  }

  /**
   * 数量和批次
   */
  Widget _editText(
      String label, String hint, TextEditingController _controller, bool show) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: MiddleText(label, Alignment.centerLeft),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 30.0,
              child: _searchWidget(hint, _controller),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 40,
            child: Visibility(
              visible: show,
              child: MiddleText('kg', Alignment.centerRight),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 物料号
   */
  Widget _editTextForScan(
      String label, String hint, TextEditingController _controller) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: MiddleText(label, Alignment.centerLeft),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 30.0,
              child: _searchWidget(hint, _controller),
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
                  _getInfoById(scanResult!.rawContent);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //通过标签id获取打印信息
  _getInfoById(var id) {
    print('标签id:$id');
    DataDao.getInfoById(int.parse(id)).then((res) {
      if (res != null && res.result) {
        setState(() {
          var data = res.data['data'];
          _code = data['id'];
          _part_id = data['part_id'];
          _partName = data['part_name'];
          _part_per_qty = data['part_per_qty'].toString();
          _part_batch = data['part_batch'];

          _noController.text = _part_id;
          _countController.text = _part_per_qty;
          _lotController.text = _part_batch;
        });
      }
    });
  }

  //确定投料
  _getSaveData() {

    DataDao.getSaveData(
            _id, _order_id, _recipe_id, _eqp_id, _code, _countController.text)
        .then((res) {
      if (res != null && res.result) {
        ScanConfig.scanPage = ScanConfig.PAGE_LOAD;
        ScanEventUtils.send(ScanConfig.PAGE_LOAD, "refresh");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('是否继续投料?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _noController.text = '';
                          _countController.text = '';
                          _lotController.text = '';
                          _code = '';
                          _part_id = '';
                          _partName = '';
                          _part_per_qty = '';
                          _part_batch = '';
                        });
                        Navigator.pop(context);
                      },
                      child: Text('继续')),
                  TextButton(
                      onPressed: () {
                       /* ScanConfig.scanPage = ScanConfig.PAGE_LOAD;
                        ScanEventUtils.send(ScanConfig.PAGE_LOAD, "refresh");*/
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('取消'))
                ],
              );
            });
      }
    });
  }

  /**
   * 机号
   */
  Widget _DropdownButtonForScan(String label, String hint) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: MiddleText(label, Alignment.centerLeft),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 30.0,
              child: _dropDownWidget(hint),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 40,
           /* child: IconButton(
              icon: Icon(
                Icons.qr_code_scanner_outlined,
                size: 20,
              ),
              onPressed: () async {
                await _scan();
                if (scanResult?.type != ResultType.Error) {
                  Fluttertoast.showToast(msg: '机号：$scanResult!.rawContent');
                }
              },
            ),*/
          ),
        ],
      ),
    );
  }

  Widget _dropDownWidget(String hint) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
              //设置边框
              border: new Border.all(color: Colors.grey, width: 1),
              //背景颜色
              color: Colors.white,
              //设置圆角
              borderRadius: new BorderRadius.circular((2)),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: DropdownButton(
              //提示文本
              hint: Text(hint),
              underline: Container(height: 0),
              //下拉列表项
              items: items,
              //默认值
              value: _eqp_id,
              //下拉三角大小
              iconSize: 30.0,
              //阴影大小
              elevation: 1,
              //是否和父容器宽度保持一致（默认false,占一般左右）,通常用这个设置宽度
              isExpanded: true,
              //下拉文本样式
              style: TextStyle(color: Colors.black, fontSize: 15),
              //下拉改变事件
              onChanged: (value) {
                setState(() {
                  this._eqp_id = value;
                  print(value.toString());
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _searchWidget(String hint, TextEditingController _controller) {
    return TextField(
      controller: _controller,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.all(5),
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
        hintText: hint,
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
    print('dispose_load_details');
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


}

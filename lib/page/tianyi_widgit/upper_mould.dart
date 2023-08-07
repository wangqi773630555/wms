import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/net/LogUtil.dart';
import '../../common/config/config.dart';
import '../../common/config/scanConfig.dart';
import '../../common/dao/data_dao.dart';
import '../../common/event/scan_event.dart';
import '../../common/utils/scanevent_utils.dart';
import '../../widget/middle_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../common_widgit/refresh/custom_refresh_footer.dart';
import '../common_widgit/refresh/custom_refresh_header.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

/**
 * 上模管理
 */
class UpperMould extends StatefulWidget {
  static final String sName = Config.UPPER_MOULD;

  @override
  _UpperMouldState createState() => _UpperMouldState();
}

class _UpperMouldState extends State<UpperMould> {
  ScanResult? scanResult;
  StreamSubscription? stream;
  TextEditingController _mjController = TextEditingController();
  TextEditingController _jtController = TextEditingController();

  late EasyRefreshController _easyfreshController;
  bool isLeft = true;

  late double _wwidth;
  late double _hheight;
  var _data;

  //模具类型
  List _types = [];
  var _type_id;
  var _recipe_id;
  List<DropdownMenuItem<Object>> _type_items = [];

  //柜台组
  List _counters = [];
  var _counter_id;
  List<DropdownMenuItem<Object>> _counter_items = [];

  //铲鲟
  List _modelList = [];
  var _selectDateStart = DateTime.now();
  var _selectDateEnd = DateTime.now();
  String startDate = '';
  String endDate = '';
  int pageNumber = 1;
  bool lastPage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ScanConfig.scanPage = ScanConfig.PAGE_LOAD_PART;
    stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
      if (event.page == ScanConfig.PAGE_LOAD_PART) {
        print(event.scanResult);
      }
    });
    _easyfreshController = EasyRefreshController();
    startDate = _selectDateStart.toString().substring(0, 10);
    endDate = _selectDateEnd.toString().substring(0, 10);
    getCtEqpModule();
    getSelectLoad();
  }

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    _hheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: Text('上模管理'), actions: <Widget>[]),
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 35.0,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          return isLeft ? Colors.grey[300] : Colors.white;
                        }),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, //外边距
                        shape: MaterialStateProperty.all(BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(0)))),
                    child: Text(
                      "上模",
                    ),
                    onPressed: () {
                      setState(() {
                        isLeft = true;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 35.0,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        return isLeft ? Colors.white : Colors.grey[300];
                      }),
                      shape: MaterialStateProperty.all(BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(0))),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, //外边距
                    ),
                    child: Text(
                      "查询",
                    ),
                    onPressed: () {
                      setState(() {
                        isLeft = false;
                      });
                      //getInintData();
                    },
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 1,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              //内容
              isLeft
                  ? Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(children: [
                        _dropdownButton('模具类型:', '请选择', true),
                        Padding(padding: EdgeInsets.all(3)),
                        _dropdownButton('机台组/号', '请选择', false),
                        Padding(padding: EdgeInsets.all(3)),
                        _editText('机台号', '非必填', _jtController),
                        _editTextForScan('模具编码', '请输入物料号', _mjController),
                        Padding(padding: EdgeInsets.all(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 35.0,
                              child: ElevatedButton(
                                  onPressed: () => {saveUpModule()},
                                  child: Text(' 确定上模 ')),
                            ),
                          ],
                        )
                      ]),
                    )
                  : Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            color: Colors.white,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        return Colors.white;
                                      }),
                                      shape: MaterialStateProperty.all(
                                          BeveledRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0))),
                                      tapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, //外边距
                                    ),
                                    child: Text(
                                      startDate,
                                    ),
                                    onPressed: () {
                                      _showDataBottomPicker(true);
                                    },
                                  ),
                                ),
                                Text('~'),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        return Colors.white;
                                      }),
                                      shape: MaterialStateProperty.all(
                                          BeveledRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0))),
                                      tapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, //外边距
                                    ),
                                    child: Text(
                                      endDate,
                                    ),
                                    onPressed: () {
                                      _showDataBottomPicker(false);
                                    },
                                  ),
                                ),
                                Icon(
                                  Icons.date_range,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                SizedBox(
                                  height: 30,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      padding: EdgeInsets.zero,
                                      tapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, //外边距
                                    ),
                                    child: Text(
                                      "查询",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    onPressed: () {
                                      pageNumber = 1;
                                      getCtEqpModule();
                                    },
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                          Container(
                            // color: Color.fromARGB(111, 236, 243, 100),
                            height: _hheight - 170,
                            child: EasyRefresh.custom(
                              controller: _easyfreshController,
                              enableControlFinishRefresh: false,
                              enableControlFinishLoad: true,
                              header: CustomRefreshHeader(
                                  Colors.white,
                                  Colors.grey,
                                  Color.fromARGB(255, 244, 158, 54)),
                              footer:
                                  CustomRefreshFooter(Colors.grey, Colors.grey),
                              onRefresh: () async {
                                pageNumber = 1;
                                getCtEqpModule();
                                setState(() {});
                                _easyfreshController.resetLoadState();
                              },
                              onLoad: () async {
                                setState(() {});
                                Future.delayed(Duration(milliseconds: 200), () {
                                  _easyfreshController.finishLoad(
                                      noMore: (lastPage));
                                  if (!lastPage) {
                                    pageNumber++;
                                    getCtEqpModule();
                                  }
                                });
                              },
                              slivers: <Widget>[
                                // 这里设置列表
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    // 这里为iOS UITableViewCell （android的adapter）,样式大家自定义即可
                                    return _cellForRow(context, index);
                                  },
                                      // 设置返回数据个数
                                      childCount: _modelList.length),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }

  Widget _cellForRow(conttext, index) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_modelList[index]['type_name']} - ${_modelList[index]['eqp_name']}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text(
              _modelList[index]['module'],
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _modelList[index]['add_time'],
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  _modelList[index]['user_name'],
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black38,
            ),
          ],
        ),
      ),
      onTap: () {
        //点击
      },
    );
  }

  /**
   * 机台号
   */
  Widget _editText(
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
          ),
        ],
      ),
    );
  }

  /**
   * 模具编号
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
              child: _searchWidgetForPart(hint, _controller),
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
                  _mjController.text = scanResult!.rawContent;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 模具类型
   */
  Widget _dropdownButton(String label, String hint, bool isType) {
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
              child: _dropDownWidget(hint, isType),
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

  Widget _dropDownWidget(String hint, bool isType) {
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
              items: isType ? _type_items : _counter_items,
              //默认值
              value: isType ? _type_id : _counter_id,
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
                  if (isType) {
                    this._type_id = value;
                    print(value.toString());

                    for (int i = 0; i < _types.length; i++) {
                      if (_type_id == _types[i]['id']) {
                        _recipe_id = _types[i]['recipe_id'];
                        _counters.clear();
                        _counter_items.clear();
                        _counters.addAll(_types[i]['children']);
                        LogUtil.d(_types[i]['children']);
                        LogUtil.d('type' +
                            _counters.length.toString() +
                            '|' +
                            i.toString() +
                            '|' +
                            _types.length.toString());
                        for (int j = 0; j < _counters.length; j++) {
                          DropdownMenuItem<Object> item = DropdownMenuItem(
                            child: Text(_counters[j]['description']),
                            value: _counters[j]['eqp_id'],
                          );
                          _counter_items.add(item);
                          if (j == 0) {
                            _counter_id = _counters[j]['eqp_id'];
                          }
                        }
                      }
                    }
                  } else {
                    this._counter_id = value;
                    print(value.toString());
                  }
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

  Widget _searchWidgetForPart(String hint, TextEditingController _controller) {
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
    print('upper_mould');
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

  _showDataBottomPicker(bool isStart) {
    DatePicker.showDatePicker(context,
        initialDateTime: isStart ? _selectDateStart : _selectDateEnd,
        dateFormat: "yyyy年 MM月 dd日", //通过空格设置滚轮数量
        pickerTheme: DateTimePickerTheme(
            confirm: Text("确认",
                style: TextStyle(fontSize: 14, color: Colors.black))),
        onConfirm: (DateTime dateTime, List<int> selectedIndex) async {
      setState(() {
        String monthStr, dayStr;
        if (dateTime.month < 10) {
          monthStr = '0' + dateTime.month.toString();
        } else {
          monthStr = dateTime.month.toString();
        }
        if (dateTime.day < 10) {
          dayStr = '0' + dateTime.day.toString();
        } else {
          dayStr = dateTime.day.toString();
        }

        if (isStart) {
          _selectDateStart = dateTime;
          startDate = dateTime.year.toString() +
              '-' +
              monthStr +
              '-' +
              dateTime.day.toString();
        } else {
          _selectDateEnd = dateTime;
          endDate = dateTime.year.toString() + '-' + monthStr + '-' + dayStr;
        }
      });
    });
  }

  _showDataPicker(bool isStart) async {
    debugPrint('选择时间方法');
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: isStart ? _selectDateStart : _selectDateEnd,
        firstDate: DateTime(1998),
        lastDate: DateTime(2030),
        locale: Locale('zh'));

    if (date == null) return;

    setState(() {
      if (isStart) {
        _selectDateStart = date;
        startDate = _selectDateStart.toString().substring(0, 10);
      } else {
        _selectDateEnd = date;
        endDate = _selectDateEnd.toString().substring(0, 10);
      }
    });
  }

  /**
   * 上模查询
   */
  getCtEqpModule() {
    DataDao.getCtEqpModule(startDate, endDate, pageNumber, 15).then((res) {
      if (res != null && res.result) {
        setState(() {
          _modelList.clear();
          lastPage = res.data['data']['lastPage'];
          _modelList = res.data['data']['list'];
        });
      }
    });
  }

  /**
   * 确认上模
   */
  saveUpModule() {
    DataDao.saveUpModule(_type_id, _recipe_id, _counter_id, _jtController.text,
            _mjController.text)
        .then((res) {
      if (res != null && res.result) {
        setState(() {
          Fluttertoast.showToast(msg: '提交成功');
        });
      }
    });
  }

  /**
   * 获取下拉框数据
   */
  getSelectLoad() {
    DataDao.getSelectLoad().then((res) {
      if (res != null && res.result) {
        setState(() {
          var data = res.data['data'];
          _types.add(data[0]);
          for (int i = 0; i < data.length; i++) {
            bool contains = false;
            for (int j = 0; j < _types.length; j++) {
              if (_types[j]['id']
                  .toString()
                  .contains(data[i]['id'].toString())) {
                contains = true;
                Map map = Map();
                map['description'] = data[i]['description'];
                map['eqp_id'] = data[i]['eqp_id'];
                if (_types[j]['children'] == null) {
                  _types[j]['children'] = [];
                }
                _types[j]['children'].add(map);
              }
            }
            if (!contains) {
              _types.add(data[i]);
              Map map = Map();
              map['description'] = data[i]['description'];
              map['eqp_id'] = data[i]['eqp_id'];
              _types[_types.length - 1]['children'] = [];
              _types[_types.length - 1]['children'].add(map);
            }
          }
          LogUtil.d(jsonEncode(_types.toString()));

          for (int i = 0; i < _types.length; i++) {
            DropdownMenuItem<Object> item = DropdownMenuItem(
              child: Text(_types[i]['type_name']),
              value: _types[i]['id'],
            );
            _type_items.add(item);
            if (i == 0) {
              _type_id = _types[i]['id'];
              _recipe_id = _types[i]['recipe_id'];
              _counters.addAll(_types[i]['children']);
              for (int j = 0; j < _counters.length; j++) {
                DropdownMenuItem<Object> item = DropdownMenuItem(
                  child: Text(_counters[j]['description']),
                  value: _counters[j]['eqp_id'],
                );
                _counter_items.add(item);
                if (j == 0) {
                  _counter_id = _counters[j]['eqp_id'];
                }
              }
            }
          }
        });
      }
    });
  }
}

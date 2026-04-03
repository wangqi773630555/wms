import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/page/dianlan_widgit/semi_list.dart';
import '../../../common/config/config.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

import '../../common/dao/data_dao.dart';
import '../../common/utils/navigator_utils.dart';
import '../common_widgit/refresh/custom_refresh_footer.dart';
import '../common_widgit/refresh/custom_refresh_header.dart';
import 'package:dotted_border/dotted_border.dart';

/**
 * 半制品盘库
 */
class SemiFinishedCheck extends StatefulWidget {
  const SemiFinishedCheck({Key? key}) : super(key: key);
  static const String sName = Config.SEMI_FINISHED_CHECK;

  @override
  State<SemiFinishedCheck> createState() => _SemiFinishedCheckState();
}

class _SemiFinishedCheckState extends State<SemiFinishedCheck> {

  final FocusNode _focusNode = FocusNode();
  //分厂
  List deptList = [];
  List<DropdownMenuItem<Object>> depts = [];
  var deptCode;
  ScanResult? scanResult;

  late EasyRefreshController _easyfreshController;

  List _modelList = [];

  bool open = true;
  bool _hasMore = true;
  var startTime;
  var _selectDateStart = DateTime.now();

  List typeList = [];
  var po_no = '',recipe_name='';
  var dlp_info_id;


  //订单批号
  TextEditingController _controllerDdph = TextEditingController();

  List checkList = [];

  List files = [];

  /**
   * 获取数据
   */
  getInintData() {
    DataDao.getProdWoResultSemis(_controllerDdph.text.toString()).then((res) {
      setState(() {
        if (res != null && res.result) {
          var data = res.data['data'];
          _modelList.clear();
         // _modelList.addAll([{}]);
          _modelList.addAll(data['list']);
          //创建选中的数据的数组
          checkList.clear();
          for (int i = 0; i < _modelList.length; i++) {
            Map map = {};
            TextEditingController eidt1 = TextEditingController();
            eidt1.text = _modelList[i]['po_no'] ?? '';
            TextEditingController eidt2 = TextEditingController();
            eidt2.text = _modelList[i]['customer_name'] ?? '';
            TextEditingController eidt3 = TextEditingController();
            eidt3.text = _modelList[i]['model'] ?? '';
            TextEditingController eidt4 = TextEditingController();
            eidt4.text = _modelList[i]['spec'] ?? '';
            TextEditingController eidt5 = TextEditingController();
            eidt5.text = _modelList[i]['vol'] ?? '';
            TextEditingController eidt6 = TextEditingController();
            eidt6.text = _modelList[i]['semi_part_name'] ?? '';
            TextEditingController eidt7 = TextEditingController();
            eidt7.text = _modelList[i]['recipe_name'] ?? '';
            TextEditingController eidt8 = TextEditingController();
            eidt8.text = _modelList[i]['color'] ?? '';
            TextEditingController eidt9 = TextEditingController();
            try {
              eidt9.text = _modelList[i]['qty'].toString() ?? '';
            } catch (e) {}
            TextEditingController eidt10 = TextEditingController();
            eidt10.text = _modelList[i]['result_date'] ?? '';
            TextEditingController eidt11 = TextEditingController();
            eidt11.text = _modelList[i]['zpronumber'] ?? '';

            map['edit1'] = eidt1;
            map['edit2'] = eidt2;
            map['edit3'] = eidt3;
            map['edit4'] = eidt4;
            map['edit5'] = eidt5;
            map['edit6'] = eidt6;
            map['edit7'] = eidt7;
            map['edit8'] = eidt8;
            map['edit9'] = eidt9;
            map['edit10'] = eidt10;
            map['edit11'] = eidt11;
            map['final'] = false;
            map['fc_id'] = deptCode;
            map['isAdd'] = false;
            checkList.add(map);
          }

          //数据填充
          recipe_name =  data['recipe_name'];
          po_no = data['po_no'];
        }
      });
    });
  }

  //提交
  saveResult() {

    if(deptCode==null){
      Fluttertoast.showToast(msg: '请选择盘点分厂');
      return;
    }

    List datas = [];

    for (int i = 0; i < _modelList.length; i++) {
      /*if(checkList[i]['fc_id']==null){
        Fluttertoast.showToast(msg: '请选择线缆所属');
        return;
      }*/
      var json2 = {};
      json2['po_no'] = checkList[i]['edit1'].text.toString();
      json2['customer_name'] = checkList[i]['edit2'].text.toString();
      json2['model'] = checkList[i]['edit3'].text.toString();
      json2['spec'] = checkList[i]['edit4'].text.toString();
      json2['vol'] = checkList[i]['edit5'].text.toString();
      json2['semi_part_name'] = checkList[i]['edit6'].text.toString();
      json2['recipe_name'] = checkList[i]['edit7'].text.toString();
      json2['color'] = checkList[i]['edit8'].text.toString();
      json2['qty'] = checkList[i]['edit9'].text.toString();
      json2['result_date'] = checkList[i]['edit10'].text.toString();
      json2['zpronumber'] = checkList[i]['edit11'].text.toString();

      //是否异常
      json2['tag'] = checkList[i]['final']?'1':'0';
      //线缆归属
      json2['dept_code'] = checkList[i]['fc_id'];
      var wo_zpronumber = '';
      wo_zpronumber = checkList[i]['wo_zpronumber'] ?? '';
      if(wo_zpronumber==''){
        wo_zpronumber =checkList[i]['edit1'].text.toString()+'_'+checkList[i]['edit11'].text.toString();
      }

      var data = {
        'code': _controllerDdph.text.toString(),
        'create_date': startTime,
        'tag': checkList[i]['final']?'0':'1',
        'line_dept_code':checkList[i]['fc_id'],
        'dlp_info_id': dlp_info_id,
        'dept_code': deptCode,
        'json1': jsonEncode(_modelList[i]),
        'json2': jsonEncode(json2),
        'wo_zpronumber':wo_zpronumber,

      };
      datas.add(data);
    }

    DataDao.saveResult(datas).then((res) {
      setState(() {
        if (res != null && res.result) {
          var data = res.data['data'];
          if (data['code'] == 200 || data['code'] == null) {
            Fluttertoast.showToast(msg: data['des']);
            checkList.clear();
            _modelList.clear();
            po_no = '';
            recipe_name = '';
            _controllerDdph.text='';
            _focusNode.requestFocus();
          } else {
            Fluttertoast.showToast(msg: data['msg']);
          }
        }
      });
    });
  }



  loadPara() {
    DataDao.loadPara().then((res) {
      setState(() {
        if (res != null && res.result) {
          deptList = res.data['data']['depts'];
          for (int i = 0; i < deptList.length; i++) {
            DropdownMenuItem<Object> item = DropdownMenuItem(
              child: Text(deptList[i]['dept_name']),
              value: deptList[i]['dept_code'],
            );
            depts.add(item);
          }
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    return Scaffold(
        appBar: AppBar(
          title: Text('半制品盘库'),
          centerTitle: true,
            actions: <Widget>[
              TextButton(
                  onPressed: () => {
                    NavigatorUtils.goPage(
                      context,
                      SemiList.sName,
                    )
                  },
                  child: Text(
                    '盘库记录',
                    style: TextStyle(color: Colors.white),
                  ))
            ]
        ),
        body: _ListView());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _easyfreshController = EasyRefreshController();
    _selectDateStart = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    startTime = _selectDateStart.toString().substring(0, 10);
    loadPara();
  }
  Widget _HeaderView(){
    return Column(
      children: [

        open
            ? Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 5)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _leftText('盘库批次:'),
                _timeView(startTime ?? '', true),
                Padding(padding: EdgeInsets.only(right: 10)),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  alignment: Alignment.centerLeft,
                  width: 30,
                  height: 30,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.qr_code_scanner_outlined,
                      size: 25,
                      color: Colors.black54,
                    ),
                    onPressed: () async {
                      await _scan();
                      if (scanResult?.type != ResultType.Error) {
                        //设备扫码
                        if (scanResult?.rawContent != '') {
                          //扫码结束
                          setState(() {
                            _controllerDdph.text = scanResult?.rawContent ?? '';
                            getInintData();
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _leftText('盘点分厂:'),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 30.0,
                    child: _dropDownWidget('请选择'),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  alignment: Alignment.centerLeft,
                  width: 35,
                  height: 35,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _leftText('订单批号:'),
                _editView1(_controllerDdph, true),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 5)),

            Padding(padding: EdgeInsets.only(top: 5)),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SizedBox(
                  width: double.infinity,
                  height: 25.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => {
                            //重置
                            setState(() {
                              //deptCode = null;
                              //startTime = _selectDateStart.toString().substring(0, 10);
                              _controllerDdph.text = '';
                              po_no = '';
                              recipe_name = '';
                              _focusNode.requestFocus();
                            })
                          },
                          child: Text('重置')),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                          onPressed: () => {
                            //搜索
                            getInintData()
                          },
                          child: Text('搜索')),
                      Padding(padding: EdgeInsets.only(right: 10)),
                    ],
                  )),
            ),
          ],
        )
            : Container(),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
        po_no==''
            ? Container()
            : SizedBox(
            width: double.infinity,
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _leftText(
                  '所检订单：${po_no}',
                ),
                Expanded(child: Text('')),

                Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    onPressed: () => {
                      addData(),
                    },
                    child: Text('新增')),
                Padding(padding: EdgeInsets.only(right: 10)),
              ],
            )),
        po_no==''
            ? Container()
            : SizedBox(
            width: double.infinity,
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _leftText(
                  '所处工序：${recipe_name}',
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
              ],
            )),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
      ],
    );
  }
  Widget _ListView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            // color: Color.fromARGB(111, 236, 243, 100),
            child: EasyRefresh.custom(
              controller: _easyfreshController,
              enableControlFinishRefresh: false,
              enableControlFinishLoad: true,
              header: CustomRefreshHeader(
                  Colors.white, Colors.grey, Color.fromARGB(255, 244, 158, 54)),
              footer: CustomRefreshFooter(Colors.grey, Colors.grey),
              onRefresh: () async {
                getInintData();
                setState(() {});
                _easyfreshController.resetLoadState();
              },
              onLoad: () async {
                Future.delayed(Duration(milliseconds: 200), () {
                  _easyfreshController.finishLoad(noMore: _hasMore);
                });
              },
              slivers: <Widget>[
                // 这里设置列表
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    // 这里为iOS UITableViewCell （android的adapter）,样式大家自定义即可
                    return _cellForRow(context, index);
                  },
                      // 设置返回数据个数
                      childCount: _modelList.length+1),
                ),
              ],
            ),
          ),
        ),
        _modelList.isEmpty
            ? Container()
            : Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text('')),
                    SizedBox(
                      height: 25.0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () => {
                                // submit()
                                saveResult()
                              },
                          child: Text('提交')),
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                  ],
                ),
              ),
      ],
    );
  }

  addData() {
    var _date = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    Map modelMap = {
      'po_no': '',
      'customer_name': '',
      'model': '',
      'spec': '',
      'vol': '',
      'semi_part_name': '',
      'recipe_name': '',
      'color': '',
      'qty': '0',
      'result_date': _date.toString().substring(0, 10),
      'zpronumber':'',
    };

    TextEditingController eidt1 = TextEditingController();
    eidt1.text = modelMap['po_no'] ?? '';
    TextEditingController eidt2 = TextEditingController();
    eidt2.text = modelMap['customer_name'] ?? '';
    TextEditingController eidt3 = TextEditingController();
    eidt3.text = modelMap['model'] ?? '';
    TextEditingController eidt4 = TextEditingController();
    eidt4.text = modelMap['spec'] ?? '';
    TextEditingController eidt5 = TextEditingController();
    eidt5.text = modelMap['vol'] ?? '';
    TextEditingController eidt6 = TextEditingController();
    eidt6.text = modelMap['semi_part_name'] ?? '';
    TextEditingController eidt7 = TextEditingController();
    eidt7.text = modelMap['recipe_name'] ?? '';
    TextEditingController eidt8 = TextEditingController();
    eidt8.text = modelMap['color'] ?? '';
    TextEditingController eidt9 = TextEditingController();
    try {
      eidt9.text = modelMap['qty'].toString() ?? '';
    } catch (e) {}
    TextEditingController eidt10 = TextEditingController();
    eidt10.text = modelMap['result_date'] ?? '';
    TextEditingController eidt11 = TextEditingController();
    eidt11.text = modelMap['zpronumber'] ?? '';
    Map checkMap = {
      'edit1': eidt1,
      'edit2': eidt2,
      'edit3': eidt3,
      'edit4': eidt4,
      'edit5': eidt5,
      'edit6': eidt6,
      'edit7': eidt7,
      'edit8': eidt8,
      'edit9': eidt9,
      'edit10': eidt10,
      'edit11': eidt11,
      'final':true,
      'fc_id':deptCode,
      'isAdd' :true
    };

    setState(() {
      checkList.insert(0,checkMap);
      _modelList.insert(0,modelMap);
    });
  }


  _showDataBottomPicker() {
    DatePicker.showDatePicker(context,
        initialDateTime: _selectDateStart,
        dateFormat: "yyyy年 MM月 dd日", //通过空格设置滚轮数量
        pickerTheme: DateTimePickerTheme(
            backgroundColor: Colors.white,
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
        _selectDateStart = dateTime;
        startTime = dateTime.year.toString() + '-' + monthStr + '-' + dayStr;
      });
    });
  }

  Widget _timeView(timeStr, isStartTime) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              _showDataBottomPicker();
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              height: 25,
              decoration: BoxDecoration(
                //设置边框
                border: new Border.all(color: Colors.grey, width: 1),
                //背景颜色
                color: Colors.white,
                //设置圆角
                borderRadius: new BorderRadius.circular((2)),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Text(
                      timeStr,
                      style: TextStyle(fontSize: 14),
                    ),
                  )),
                  Icon(
                    Icons.date_range,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            )));
  }

  Widget _editView(TextEditingController _controller, isEnable) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 25.0,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: TextField(
            enabled: isEnable,
            maxLines: 1,
            style: TextStyle(fontSize: 14),
            controller: _controller,
            decoration: InputDecoration(
              fillColor: Colors.white12,
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
            ),
          ),
        ),
      ),
    );
  }
  Widget _editView1(TextEditingController _controller, isEnable) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 25.0,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: TextField(
            onChanged: (value) => {
              if(_controllerDdph.text.length==18){
                getInintData()
              }
            },
            focusNode: _focusNode,
            enabled: isEnable,
            maxLines: 1,
            style: TextStyle(fontSize: 14),
            controller: _controller,
            decoration: InputDecoration(
              fillColor: Colors.white12,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _editView20(TextEditingController _controller,isEnable) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 26.0,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: TextField(
            enabled: isEnable,
            maxLines: 1,
            style: TextStyle(fontSize: 14),
            controller: _controller,
            decoration: InputDecoration(
              fillColor: Colors.white12,
              filled: true,
              contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              disabledBorder: OutlineInputBorder(
                /*边角*/
                borderRadius: BorderRadius.all(
                  Radius.circular(2), //边角为5
                ),
                borderSide: BorderSide(
                  color: Colors.white, //边线颜色为白色
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _cellForRow(conttext, j) {
    if(j==0){
      return _HeaderView();
    }else {
      var i = j-1;
      return GestureDetector(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 5)),
              SizedBox(
                  width: double.infinity,
                  height: 25.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '线缆（${i + 1}）',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      checkList[i]['isAdd'] ? Container() : IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(
                          checkList[i]["final"]
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 22,
                          color: checkList[i]["final"] ? Colors.green : Colors
                              .grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (!checkList[i]["final"]) {
                              checkList[i]["final"] = true;
                            } else {
                              checkList[i]['edit1'].text =
                                  _modelList[i]['po_no'] ?? '';
                              checkList[i]['edit2'].text =
                                  _modelList[i]['customer_name'] ?? '';
                              checkList[i]['edit3'].text =
                                  _modelList[i]['model'] ?? '';
                              checkList[i]['edit4'].text =
                                  _modelList[i]['spec'] ?? '';
                              checkList[i]['edit5'].text =
                                  _modelList[i]['vol'] ?? '';
                              checkList[i]['edit6'].text =
                                  _modelList[i]['semi_part_name'] ?? '';
                              checkList[i]['edit7'].text =
                                  _modelList[i]['recipe_name'] ?? '';
                              checkList[i]['edit8'].text =
                                  _modelList[i]['color'] ?? '';
                              try {
                                checkList[i]['edit9'].text =
                                    _modelList[i]['qty'].toString() ?? '';
                              } catch (e) {
                                checkList[i]['edit9'].text = '';
                              }
                              checkList[i]['edit10'].text =
                                  _modelList[i]['result_date'] ?? '';

                              checkList[i]['final'] = false;
                            }
                          });
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      checkList[i]['isAdd'] ? Container() : Expanded(
                          child: Text('是否异常')),
                    ],
                  )),
              Padding(padding: EdgeInsets.only(top: 5)),
              SizedBox(
                  width: double.infinity,
                  height: 20.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Text(
                        '线缆归属',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 25.0,
                          child: _dropDownWidgetList('请选择', i),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 30)),
                      checkList[i]['isAdd'] ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () =>
                          {
                            //删除
                            setState(() {
                              _modelList.removeAt(i);
                              checkList.removeAt(i);
                            }),
                          },
                          child: Text(
                            '删除',
                            style: TextStyle(fontSize: 12),
                          )) : Container(),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      checkList[i]['final']
                          ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                          ),
                          onPressed: () =>
                          {
                            //清空
                            setState(() {
                              checkList[i]['edit1'] = TextEditingController();
                              checkList[i]['edit2'] = TextEditingController();
                              checkList[i]['edit3'] = TextEditingController();
                              checkList[i]['edit4'] = TextEditingController();
                              checkList[i]['edit5'] = TextEditingController();
                              checkList[i]['edit6'] = TextEditingController();
                              checkList[i]['edit7'] = TextEditingController();
                              checkList[i]['edit8'] = TextEditingController();
                              checkList[i]['edit9'] = TextEditingController();
                              checkList[i]['edit10'] = TextEditingController();
                            }),
                          },
                          child: Text('清空', style: TextStyle(fontSize: 12)))
                          : Container(),

                    ],
                  )),
              Padding(padding: EdgeInsets.only(top: 10)),
              //编辑部分
              DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: [6, 3], // 虚线样式，6像素实线，3像素间距
                  child: Container(
                    constraints: BoxConstraints(minHeight: 100),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        getItemBottomWidget(
                            i, '订单批号：    ', 'edit1', 'check1'),
                        getItemBottomWidget(
                            i, '客户：            ', 'edit2', 'check2'),
                        getItemBottomWidget(
                            i, '型号：            ', 'edit3', 'check3'),
                        getItemBottomWidget(
                            i, '规格：            ', 'edit4', 'check4'),
                        getItemBottomWidget(
                            i, '电压等级：    ', 'edit5', 'check5'),
                        getItemBottomWidget(
                            i, '半制品：        ', 'edit6', 'check6'),
                        getItemBottomWidget(
                            i, '所属工序：    ', 'edit7', 'check7'),
                        getItemBottomWidget(
                            i, '颜色：            ', 'edit8', 'check8'),
                        getItemBottomWidget(
                            i, '半成品数量：', 'edit9', 'check9'),
                        getItemBottomWidget(
                            i, '报工日期：    ', 'edit10', 'check10'),
                        getItemBottomWidget(
                            i, '盘具：            ', 'edit11', 'check11'),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
    }
  }

  Widget getItemBottomWidget(i, title, editIndex, checkIndex) {
    return Column(
      children: [
        Row(children: [
          Text(
            '${title}',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          _editView20(checkList[i][editIndex],checkList[i]['final']),
        ]),
        Padding(padding: EdgeInsets.only(top: 3))
      ],
    );
  }

  Widget _leftText(value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Text(
        value,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _dropDownWidget(String hint) {
    var value;
    List<DropdownMenuItem<Object>> items = [];
    value = deptCode;
    items = depts;
    return Container(
      height: 25,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 25,
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
              value: value,
              //下拉三角大小
              iconSize: 30.0,
              //阴影大小
              elevation: 1,
              //是否和父容器宽度保持一致（默认false,占一般左右）,通常用这个设置宽度
              isExpanded: true,
              //下拉文本样式
              style: TextStyle(color: Colors.black, fontSize: 14),
              //下拉改变事件
              onChanged: (value) {
                setState(() {
                  deptCode = value;
                  print(value.toString() + '');
                  for (int i = 0; i < checkList.length; i++) {
                    checkList[i]['fc_id'] = deptCode;
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _dropDownWidgetList(String hint,int i) {
    var value;
    List<DropdownMenuItem<Object>> items = [];
    value = checkList[i]['fc_id'];
    items = depts;
    return Container(
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 20,
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
              value: value,
              //下拉三角大小
              iconSize: 20.0,
              //阴影大小
              elevation: 1,
              //是否和父容器宽度保持一致（默认false,占一般左右）,通常用这个设置宽度
              isExpanded: true,
              //下拉文本样式
              style: TextStyle(color: Colors.black, fontSize: 12),
              //下拉改变事件
              onChanged: (value) {
                setState(() {
                  checkList[i]['fc_id'] = value;
                  print(value.toString() + '');
                });
              },
            ),
          )
        ],
      ),
    );
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


  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
  }
}

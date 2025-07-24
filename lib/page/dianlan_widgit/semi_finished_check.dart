import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../common/config/config.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

import '../../common/dao/data_dao.dart';
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
  var fcName = '';
  var qRcode = '';
  var dlp_info_id = '';

  //规格
  TextEditingController _controllerGg = TextEditingController();
  //盘具编号
  TextEditingController _controllerPjbh = TextEditingController();

  List checkList = [];

  getInintData() {
    DataDao.getProdWoResultSemis(qRcode).then((res) {
      setState(() {
        if (res != null && res.result) {
          var data = res.data['data'];
          _modelList.clear();
          _modelList.addAll(data['list']);
          //创建选中的数据的数组
          checkList.clear();
          for (int i = 0; i < _modelList.length; i++) {
            Map map = {};
            map['checkAll'] = false;
            map['check1'] = false;
            map['check2'] = false;
            map['check3'] = false;
            map['check4'] = false;
            map['check5'] = false;
            map['check6'] = false;
            map['check7'] = false;
            map['check8'] = false;
            map['check9'] = false;
            map['check10'] = false;
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
            try{
              eidt9.text = _modelList[i]['qty'].toString() ?? '';
            }catch(e){
            }
            TextEditingController eidt10 = TextEditingController();
            eidt10.text = _modelList[i]['result_date'] ?? '';

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
            checkList.add(map);
          }

          //数据填充
          fcName =  data['code_name'];
          deptCode = data['dlp']['dept_code'];
          _controllerGg.text = data['dlp']['pj'];
          _controllerPjbh.text = data['dlp']['sn'];
          dlp_info_id = data['dlp']['dlp_info_id'];
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

  //提交
  saveResult() {
    List datas = [];

    for (int i = 0; i < _modelList.length; i++) {
      var tag = (!checkList[i]['check1']&&!checkList[i]['check2']&&!checkList[i]['check3']&&!checkList[i]['check4']&&!checkList[i]['check5']&&!checkList[i]['check6']&&!checkList[i]['check7']&&!checkList[i]['check8']&&!checkList[i]['check9']&&!checkList[i]['check10'])?'0':'1';
      var json2 = {};
      if(checkList[i]['check1']){
        json2['po_no'] = checkList[i]['edit1'].text.toString();
      }
      if(checkList[i]['check2']){
        json2['customer_name'] = checkList[i]['edit2'].text.toString();
      }
      if(checkList[i]['check3']){
        json2['model'] = checkList[i]['edit3'].text.toString();
      }
      if(checkList[i]['check4']){
        json2['spec'] = checkList[i]['edit4'].text.toString();
      }
      if(checkList[i]['check5']){
        json2['vol'] = checkList[i]['edit5'].text.toString();
      }
      if(checkList[i]['check6']){
        json2['semi_part_name'] = checkList[i]['edit6'].text.toString();
      }
      if(checkList[i]['check7']){
        json2['recipe_name'] = checkList[i]['edit7'].text.toString();
      }
      if(checkList[i]['check8']){
        json2['color'] = checkList[i]['edit8'].text.toString();
      }
      if(checkList[i]['check9']){
        json2['qty'] = checkList[i]['edit9'].text.toString();
      }
      if(checkList[i]['check10']){
        json2['result_date'] = checkList[i]['edit10'].text.toString();
      }
      var data = {
        'code':qRcode,
        'create_date':startTime,
        'tag':tag,
        'dlp_info_id':dlp_info_id,
        'dept_code':deptCode,
        'json1':jsonEncode(_modelList[i]),
        'json2':jsonEncode(json2)
      };
      datas.add(data);
    }

    DataDao.saveResult(datas).then((res) {
      setState(() {
        if (res != null && res.result) {
          var data = res.data['data'];
          if(data['code']==200||data['code']==null){
            Fluttertoast.showToast(msg: data['des']);
            _controllerPjbh.text = '';
            _controllerGg.text = '';
            checkList.clear();
            _modelList.clear();
            fcName = '';
          }else{
            Fluttertoast.showToast(msg: data['msg']);
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
          actions: [],
        ),
        body: _headView());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _easyfreshController = EasyRefreshController();
    _selectDateStart = new DateTime(
        DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
    startTime = _selectDateStart.toString().substring(0, 10);
    loadPara();
  }


  Widget _headView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
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
                        width: 35,
                        height: 35,
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
                                  qRcode = scanResult?.rawContent??'';
                                /*  try{
                                    deptCode = qRcode.toString().split(',')[0];
                                    _controllerGg.text = qRcode.toString().split(',')[1].split('-')[0];
                                    _controllerPjbh.text = qRcode.toString().split(',')[1].split('-')[1];
                                  }catch(e){
                                    
                                  }*/
                                  getInintData();

                                });
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _leftText('所属分厂:'),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 30.0,
                          child: _dropDownWidget('请选择'),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      _leftText('规格:'),
                      _editView(_controllerGg),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: SizedBox(
                        width: double.infinity,
                        height: 25.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _leftText('盘具编号:'),
                            _editView(_controllerPjbh),
                            Padding(padding: EdgeInsets.only(right: 10)),
                            //Expanded(child: Text('')),

                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => {
                                      //重置
                                      setState(() {
                                        qRcode = '';
                                        deptCode = null;
                                        startTime = _selectDateStart
                                            .toString()
                                            .substring(0, 10);
                                        _controllerGg.text = '';
                                        _controllerPjbh.text = '';
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
                                      checkSubmit(),
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
        _modelList.isEmpty?Container():Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _leftText(
              '所检盘具：${fcName}',
            ),
            Expanded(child: Text('')),

          ],
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
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
                      childCount: _modelList.length),
                ),
              ],
            ),
          ),
        ),
        _modelList.isEmpty?Container():Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child:Row(
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

  checkSubmit() {
    if(deptCode==null){
      Fluttertoast.showToast(msg: '请选择分厂');
      return;
    }
    if(_controllerGg.text.isEmpty){
      Fluttertoast.showToast(msg: '请输入规格');
      return;
    }
    if(_controllerPjbh.text.isEmpty){
      Fluttertoast.showToast(msg: '请输入编号');
      return;
    }
    qRcode = deptCode+','+_controllerGg.text.toString()+'-'+_controllerPjbh.text.toString();
    getInintData();
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

  Widget _editView(TextEditingController _controller) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 25.0,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: TextField(
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

  Widget _editView20(TextEditingController _controller) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 20.0,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: TextField(
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

  Widget _cellForRow(conttext, i) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '线上盘具情况',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '整盘异常',
                  style: TextStyle(fontSize: 16),
                ),
                Padding(padding: EdgeInsets.only(left: 5)),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(
                    checkList[i]['checkAll']
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    size: 20,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      checkList[i]['checkAll'] = !checkList[i]['checkAll'];
                      checkList[i]['check1'] = checkList[i]['checkAll'];
                      checkList[i]['check2'] = checkList[i]['checkAll'];
                      checkList[i]['check3'] = checkList[i]['checkAll'];
                      checkList[i]['check4'] = checkList[i]['checkAll'];
                      checkList[i]['check5'] = checkList[i]['checkAll'];
                      checkList[i]['check6'] = checkList[i]['checkAll'];
                      checkList[i]['check7'] = checkList[i]['checkAll'];
                      checkList[i]['check8'] = checkList[i]['checkAll'];
                      checkList[i]['check9'] = checkList[i]['checkAll'];
                      checkList[i]['check10'] = checkList[i]['checkAll'];
                    });
                  },
                ),
                Padding(padding: EdgeInsets.only(left: 7)),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            //显示部分
            DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [6, 3], // 虚线样式，6像素实线，3像素间距
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      getItemTopWidget(i, '订单批号', 'check1',
                          _modelList[i]['po_no'] ?? ''),
                      getItemTopWidget(
                          i, '客户', 'check2', _modelList[i]['customer_name'] ?? ''),
                      getItemTopWidget(
                          i, '型号', 'check3', _modelList[i]['model'] ?? ''),
                      getItemTopWidget(
                          i, '规格', 'check4', _modelList[i]['spec'] ?? ''),
                      getItemTopWidget(i, '电压等级', 'check5',
                          _modelList[i]['vol'] ?? ''),
                      getItemTopWidget(
                          i, '半制品', 'check6', _modelList[i]['semi_part_name'] ?? ''),
                      getItemTopWidget(i, '所属工序', 'check7',
                          _modelList[i]['recipe_name'] ?? ''),
                      getItemTopWidget(
                          i, '颜色', 'check8', _modelList[i]['color'] ?? ''),
                      getItemTopWidget(i, '半成品数量', 'check9',
                          _modelList[i]['qty'] ?? ''),
                      getItemTopWidget(i, '报工日期', 'check10',
                          _modelList[i]['result_date'] ?? ''),
                    ],
                  ),
                )),

            Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              '真实盘存',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
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
                      getItemBottomWidget(i, '订单批号：    ', 'edit1',
                          _modelList[i]['partTitle'] ?? '', 'check1'),
                      getItemBottomWidget(i, '客户：            ', 'edit2',
                          _modelList[i]['partTitle'] ?? '', 'check2'),
                      getItemBottomWidget(i, '型号：            ', 'edit3',
                          _modelList[i]['partTitle'] ?? '', 'check3'),
                      getItemBottomWidget(i, '规格：            ', 'edit4',
                          _modelList[i]['partTitle'] ?? '', 'check4'),
                      getItemBottomWidget(i, '电压等级：    ', 'edit5',
                          _modelList[i]['partTitle'] ?? '', 'check5'),
                      getItemBottomWidget(i, '半制品：        ', 'edit6',
                          _modelList[i]['partTitle'] ?? '', 'check6'),
                      getItemBottomWidget(i, '所属工序：    ', 'edit7',
                          _modelList[i]['partTitle'] ?? '', 'check7'),
                      getItemBottomWidget(i, '颜色：            ', 'edit8',
                          _modelList[i]['partTitle'] ?? '', 'check8'),
                      getItemBottomWidget(i, '半成品数量：', 'edit9',
                          _modelList[i]['partTitle'] ?? '', 'check9'),
                      getItemBottomWidget(i, '报工日期：    ', 'edit10',
                          _modelList[i]['partTitle'] ?? '', 'check10'),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget getItemTopWidget(i, title, checkIndex, value) {
    return Row(children: [
      Expanded(
        child: Text(
          '${title}：${value}',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        icon: Icon(
          checkList[i][checkIndex]
              ? Icons.check_box
              : Icons.check_box_outline_blank,
          size: 20,
          color: Colors.black54,
        ),
        onPressed: () {
          setState(() {
            checkList[i][checkIndex] = !checkList[i][checkIndex];
            if (checkList[i]['check1'] &&
                checkList[i]['check2'] &&
                checkList[i]['check3'] &&
                checkList[i]['check4'] &&
                checkList[i]['check5'] &&
                checkList[i]['check6'] &&
                checkList[i]['check7'] &&
                checkList[i]['check8'] &&
                checkList[i]['check9'] &&
                checkList[i]['check10']) {
              checkList[i]['checkAll'] = true;
            } else {
              checkList[i]['checkAll'] = false;
            }
          });
        },
      ),
    ]);
  }

  Widget getItemBottomWidget(i, title, editIndex, value, checkIndex) {
    bool show = checkList[i][checkIndex];
    return show
        ? Column(
            children: [
              Row(children: [
                Text(
                  '${title}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                _editView20(checkList[i][editIndex]),
              ]),
              Padding(padding: EdgeInsets.only(top: 3))
            ],
          )
        : Container();
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

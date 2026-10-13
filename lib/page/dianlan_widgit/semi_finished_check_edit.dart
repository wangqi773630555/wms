import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/page/dianlan_widgit/semi_search.dart';
import '../../../common/config/config.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

import '../../common/dao/data_dao.dart';
import 'package:wanma_print/common/utils/common_utils.dart';
import '../common_widgit/refresh/custom_refresh_footer.dart';
import '../common_widgit/refresh/custom_refresh_header.dart';
import 'package:dotted_border/dotted_border.dart';

/**
 * 半制品盘库(编辑)
 */
class SemiFinishedCheckEdit extends StatefulWidget {
  const SemiFinishedCheckEdit({Key? key}) : super(key: key);
  static const String sName = Config.SEMI_FINISHED_CHECK_EDIT;

  @override
  State<SemiFinishedCheckEdit> createState() => _SemiFinishedCheckEditState();
}

class _SemiFinishedCheckEditState extends State<SemiFinishedCheckEdit> {

  //分厂
  List deptList = [];
  List<DropdownMenuItem<Object>> depts = [];

  late EasyRefreshController _easyfreshController;
  bool _hasMore = true;

  var _selectDateStart = DateTime.now();
  var deptCode,po_no = '',recipe_name='',dlp_info_id,startTime,line_dept_code;
  List _modelList = [];
  List checkList = [];

  var id = null;
  /**
   * 获取数据
   */
  getInintData() {
    DataDao.getResultSemisLoad(id).then((res) {
      setState(() {
        if (res != null && res.result) {
          var data = res.data['data'];
          _modelList.clear();
         // _modelList.addAll([{}]);
          _modelList.addAll(data['list2']);
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
            map['final'] = _modelList[i]['tag']==null?false:_modelList[i]['tag']=='1';//tag
            map['fc_id'] = _modelList[i]['dept_code'];
            map['isAdd'] = false;
            checkList.add(map);
          }

          //数据填充
          recipe_name =  data['recipe_name'];
          startTime =  data['create_date'];
          po_no = data['po_no'];
          deptCode = data['dept_code'];
          line_dept_code = data['line_dept_code'];
        }
      });
    });
  }


  //删除
  delResultSemis() {

    DataDao.delResultSemis(id).then((res) {
      setState(() {
        if (res != null && res.result) {
          var data = res.data['data'];
          if (data['code'] == 200 || data['code'] == null) {
            Fluttertoast.showToast(msg: '操作成功');
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(msg: data['msg']);
          }
        }
      });
    });
  }


  //提交
  saveResult() {

    List lists = [];

    for (int i = 0; i < _modelList.length; i++) {
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

      lists.add(json2);
    }

    DataDao.updateResultSemis(id,startTime,deptCode,line_dept_code,lists).then((res) {
      setState(() {
        if (res != null && res.result) {
          var data = res.data['data'];
          if (data['code'] == 200 || data['code'] == null) {
            Fluttertoast.showToast(msg: '操作成功');
            Navigator.pop(context);
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
    return Scaffold(
        appBar: AppBar(
          title: Text('半制品盘库（编辑）'),
          centerTitle: true,
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
    Future.delayed(Duration.zero, () async {
      var data = (ModalRoute.of(context)!.settings.arguments);
      id = data;
      getInintData();
    });
  }
  Widget _HeaderView(){
    return Column(
      children: [
       Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 5)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _leftText('盘库批次:'),
                _timeView(startTime ?? '', true),
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
              ],
            ),

            Padding(padding: EdgeInsets.only(top: 5)),
          ],
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
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
                //getInintData();
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
                padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text('')),
                    SizedBox(
                      height: 30.0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            CommonUtils.showCustomAlertDialog(
                                context, '是否确认删除数据？', () {
                              delResultSemis();
                            });
                          },
                          child: Text('删除')),
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    SizedBox(
                      height: 30.0,
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


  Widget _editView20Search(TextEditingController _controller,isEnable,searchType,index) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 26.0,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: TextField(
            onTap: () async {
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    // 在这里传参数
                    return SemiSearch(
                      keyword: searchType,
                    );
                  }));

              setState(() {
                if(result!=null) {
                  if(searchType=='po_no'){
                    checkList[index]['edit1'].text = result['po_no']??'';
                    checkList[index]['edit2'].text = result['customer_name']??"";
                    checkList[index]['edit3'].text = result['model']??'';
                    checkList[index]['edit4'].text = result['spec']??'';
                    checkList[index]['edit5'].text = result['vol']??'';
                    checkList[index]['edit8'].text = result['color']??'';
                    checkList[index]['edit9'].text = result['qty']==null?'':result['qty'].toString();
                  }else {
                    _controller.text = result;
                  }
                }
              });
            },
            readOnly: true,
            enabled: isEnable,
            maxLines: 1,
            style: TextStyle(fontSize: 14),
            controller: _controller,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
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
              GestureDetector(
                onTap: () {
                  // 点击回调
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
                child:  SizedBox(
                    width: double.infinity,
                    height: 36.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '线缆（${i + 1}）',
                          style: TextStyle(
                              fontSize: 24,
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
                            size: 30,
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
                        Expanded(
                            child: Text('是否异常' ,style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ))),
                      ],
                    )),
              ),
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
                        getItemBottomWidgetSearch(
                            i, '订单批号：    ', 'edit1', 'check1','po_no'),
                        getItemBottomWidget(
                            i, '客户：            ', 'edit2', 'check2'),
                        getItemBottomWidgetSearch(
                            i, '型号：            ', 'edit3', 'check3','model'),
                        getItemBottomWidgetSearch(
                            i, '规格：            ', 'edit4', 'check4','spec'),
                        getItemBottomWidgetSearch(
                            i, '电压等级：    ', 'edit5', 'check5','vol'),
                        getItemBottomWidget(
                            i, '半制品：        ', 'edit6', 'check6'),
                        getItemBottomWidget(
                            i, '所属工序：    ', 'edit7', 'check7'),
                        getItemBottomWidgetSearch(
                            i, '颜色：            ', 'edit8', 'check8','color'),
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

  Widget getItemBottomWidgetSearch(i, title, editIndex, checkIndex,searchType) {
    return Column(
      children: [
        Row(children: [
          Text(
            '${title}',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          _editView20Search(checkList[i][editIndex],checkList[i]['final'],searchType,i),
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
                 /* for (int i = 0; i < checkList.length; i++) {
                    checkList[i]['fc_id'] = deptCode;
                  }*/
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


  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
  }
}

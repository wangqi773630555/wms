import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:wanma_print/page/common_widgit/select_list/select_item.dart';
import 'package:wanma_print/page/common_widgit/select_list/select_widget.dart';
import 'package:flutter_switch/flutter_switch.dart';

class PrintDialog extends StatefulWidget {
  final String title;
  final String content;
  final String title2;
  final String rowsNum;
  var _selectDate1 = DateTime.now();
  var _startTime = '';
  var ccMark;
  var zxMark;
  bool status1; //0/1
  bool status2; //0/1
  bool deferentWare;
  String wareValue;
  VoidCallback? okBtnTap;
  List<SelectItem> selectValuesetList;
  // 构造函数赋值
  PrintDialog({
    this.title = "",
    this.content = "",
    this.title2 = '',
    this.rowsNum = "",
    this.okBtnTap,
    required this.selectValuesetList,
    this.status1 = false,
    this.status2 = false,
    this.ccMark,
    this.zxMark,
    required this.wareValue,
    required this.deferentWare,
  });

  State<PrintDialog> createState() => _PrintDialogState();
}

class _PrintDialogState extends State<PrintDialog> {
  @override
  void initState() {
    // TODO: implement initState
    time();

    // print('____+++++++${widget.selectValuesetList}');
    super.initState();
  }

  time() async {
    final prefs = await SharedPreferences.getInstance();

    widget._startTime = widget._selectDate1.toString().substring(0, 10);
    prefs.setString('time', widget._startTime);
    prefs.setString('kw', widget.wareValue);
    prefs.setBool('cc', false);
    prefs.setBool('zx', false);
  }

  Widget build(BuildContext context) {
    widget._startTime = widget._selectDate1.toString().substring(0, 10);
    var itemValue = widget.wareValue;
    return Material(
        type: MaterialType.transparency,
        child: Center(
            child: Container(
                width: 320,
                height: 280,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${widget.title}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              )),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              child: Icon(Icons.close),
                              onTap: () {
                                // widget.okBtnTap!();

                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                        // padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: Column(
                          children: [
                            // centerWg(),

                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  _dateWidget(
                                      "from", widget._startTime, '过账日期:'),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    '入库库位:',
                                    style: TextStyle(
                                      color: Color(0xFF111E3E),
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 236, 245, 247),
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                    ),
                                    alignment: Alignment.center,
                                    width: 222,

                                    // padding: EdgeInsets.only(top: 5),
                                    child: SelectWidget(
                                      items: widget.selectValuesetList,
                                      selectWidth: 220,
                                      value: itemValue,
                                      valueChanged: (ral) async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        setState(() {
                                          itemValue = ral;
                                          prefs.setString('kw', ral);
                                        });
                                        // print('===$itemValue=');
                                      },
                                      leftPosition: 10,
                                    ),
                                    height: 35,
                                    // width: lineWidth + 5,
                                  )
                                ],
                              ),
                            ),

                            widget.deferentWare == true
                                ? Container(
                                    child: Text(
                                    '库位不一致请检查',
                                    style: TextStyle(color: Colors.red),
                                  ))
                                : Container(),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  _swichWg('cc', widget.status1, '使用叉车: '),
                                  _swichWg('zx', widget.status2, '需要装卸: '),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 25,
                                    ),
                                    height: 35,
                                    child: Text('已选择明细[',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Text(widget.title2,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red)),
                                  Text(']行', style: TextStyle(fontSize: 16)),
                                  // Text('   '),
                                  Padding(padding: EdgeInsets.only(left: 20)),
                                  InkWell(
                                    // behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            new BorderRadius.circular((10.0)),
                                      ),
                                      // padding: EdgeInsets.only(top: 10),
                                      alignment: Alignment.center,
                                      width: 120,
                                      height: 40,
                                      child: Text('确认过账',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                    ),
                                    onTap: () {
                                      // print(
                                      // '--------------${widget.title}-------');
                                      widget.okBtnTap!();
                                    },
                                  )
                                ],
                              ),
                            )

                            // )
                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: InkWell(
                            //     child: Icon(Icons.close),
                            //     onTap: () {
                            //       Navigator.pop(context);
                            //     },
                            //   ),
                            // )
                          ],
                        ))
                  ],
                ))));
  }

  Widget _dateWidget(String mak, String showTime, String name) {
    return Container(
        padding: EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: Color(0xFF111E3E),
                fontSize: 16,
              ),
            ),
            // _dateWidget(, ),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // _showDataPickers(mak);

                  selectTime();
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 2 + 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xFFE8EEF1),
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Text(
                          showTime,
                          style: TextStyle(
                              color: Color(0xFF111E3E),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Icon(Icons.date_range)
                    ],
                  ),
                ))
          ],
        ));
  }

  Widget _swichWg(String mark, bool states, String title) {
    return Container(
        padding: EdgeInsets.only(right: 25),
        child: Row(
          children: [
            Container(
                child: Text(
              title,
              style: TextStyle(
                color: Color(0xFF111E3E),
                fontSize: 16,
              ),
            )),
            FlutterSwitch(
                width: 45.0,
                height: 25.0,
                valueFontSize: 15.0,
                toggleSize: 18.0,
                value: states,
                borderRadius: 20.0,
                // padding: 8.0,

                showOnOff: false,
                onToggle: (val) async {
                  final prefs = await SharedPreferences.getInstance();
                  setState(() {
                    if (mark == 'cc') {
                      widget.status1 = val;

                      prefs.setBool('cc', widget.status1);
                    } else {
                      widget.status2 = val;
                      prefs.setBool('zx', widget.status2);
                    }
                  });
                }),
          ],
        ));
  }

  //选择日期的方法
  selectTime() {
    DatePicker.showDatePicker(context,
        dateFormat: "yyyy年 MM月 dd日", //通过空格设置滚轮数量
        pickerTheme: DateTimePickerTheme(
            confirm:
                Text("确认", style: TextStyle(fontSize: 14, color: Colors.red))),
        onConfirm: (DateTime dateTime, List<int> selectedIndex) async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        widget._selectDate1 = dateTime;
        widget._startTime = widget._selectDate1.toString().substring(0, 10);
        prefs.setString('time', widget._startTime);
      });
    });
  }
}

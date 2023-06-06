import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'counter_page.dart';

class MyDialog extends Dialog {
  final String title;
  final String title2;
  final String content;
  // final bool isClick;
  // var count;
  int dyzs;
  // int dzwl;

  double upDataNum;
  var model;
  Function() f;
  // Function(String) f2;
  Function(int) c1;
  Function(int) c2;
  Function(int) c3;
  Function(int) c11;
  Function(int) c22;
  Function(int) c33;
  double _h_height = 5 * 26 + 200;
  String flag;
  // 构造函数赋值
  MyDialog(
      {this.title = "",
      this.content = "",
      // required this.isClick,
      this.title2 = "",
      this.flag = "",
      required this.dyzs,
      // required this.dzwl,
      required this.upDataNum,
      required this.f,
      // required this.f2,
      required this.c1,
      required this.c2,
      required this.c3,
      required this.c11,
      required this.c22,
      required this.c33,
      this.model});

  Widget build(BuildContext context) {
    if (this.flag == "dayin") {
      _h_height = 5 * 26 + 200;
    } else {
      _h_height = 5 * 26 + 160;
    }
    TextEditingController textController = TextEditingController();
    textController.text = upDataNum.toString();
    return Material(
        type: MaterialType.transparency,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print("点击了空白区域");
//         _focusNodeTelephone.unfocus();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Center(
                  child: Container(
                      width: 300,
                      height: _h_height,
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
                                      "${this.title}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    )),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    child: Icon(Icons.close),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Container(
                              //xiugai
                              // padding: EdgeInsets.all(10),
                              // height: 40,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  centerWg(),
                                  _dayinWg(),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 10,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          "${this.content}",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, top: 5, bottom: 5),
                                          height: 35,
                                          alignment: Alignment.center,
                                          width: 150,
                                          // color: Colors.grey.shade200,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            border: Border.all(
                                                color: Colors.grey, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9.]")),
                                            ],
                                            // keyboardType: TextInputType.number,

                                            controller: TextEditingController
                                                .fromValue(TextEditingValue(
                                                    text: textController.text,
                                                    // 保持光标在最后
                                                    selection: TextSelection
                                                        .fromPosition(TextPosition(
                                                            affinity:
                                                                TextAffinity
                                                                    .downstream,
                                                            offset:
                                                                '${this.upDataNum}'
                                                                    .length)))),

                                            onChanged: (text) async {
                                              print(
                                                  'objecdddddddddddddddd$text');
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();

                                              prefs.setDouble(
                                                  'wl', double.parse(text));
                                            },
                                            textAlign: TextAlign.center,
                                            autofocus: false,
                                            cursorColor: Colors.green,
                                          ),
                                        ),
                                        // CounterPage(
                                        //   addCallBack: c1,
                                        //   mzeCallBack: c2,
                                        //   enterDelete: c3, count: this.dyzs,
                                        //   // isClick: isClick,
                                        // ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 33, 207, 39),
                                          borderRadius:
                                              new BorderRadius.circular((10.0)),
                                        ),
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.center,
                                        width: 250,
                                        height: 43,
                                        child: flag == 'dayin'
                                            ? Text('立即打印',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18))
                                            : Text('确认修改',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18)),
                                      ),
                                      onTap: f)
                                ],
                              ))
                        ],
                      ))),
            )));
  }

  Widget centerWg() {
    return Container(
        // alignment: Alignment.center,
        // padding: EdgeInsets.only(top: 10),
        width: 280,
        height: 5 * 26,
        color: Color.fromARGB(255, 243, 237, 237),
        child: Column(
          children: [
            textCells('供应商:', model['supplier_name'] ?? '', 280),
            textCells('供应商编码:', model['supplier_no'] ?? '', 280),
            textCells('内向交货单号:', model['inbound_deliver_no'] ?? "", 280),
            textCells('送货日期:', model['deliver_time'] ?? '', 280),
            textCells('订单号:', model['order_no'] ?? '', 280),
          ],
        ));
  }

  // Widget _getRowText(String label, dynamic value) {
  //   return Container(
  //       child: Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       Expanded(
  //         flex: 2,
  //         child: MiddleText(label, Alignment.centerLeft),
  //       ),
  //       Expanded(flex: 3, child: MiddleText(value, Alignment.centerRight)),
  //     ],
  //   ));
  // }

  textCells(String label, dynamic value, double ww) {
    return Container(
      child: Row(
        children: [
          Container(
            // margin: EdgeInsets.only(left: 20),
            // color: Colors.red,
            width: 100,
            child: Text(label),
          ),
          Container(
            width: ww - 100,
            alignment: Alignment.centerRight,
            // margin: EdgeInsets.only(right: 20),
            child: Text(
              value,
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayinWg() {
    return this.flag == "dayin"
        ? Container(
            height: 45,
            // color: Colors.red,
            margin: EdgeInsets.only(
              left: 10,
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  "${this.title2}",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                CounterPage(
                  addCallBack: c11,
                  mzeCallBack: c22,
                  enterDelete: c33, count: this.dyzs,
                  // isClick: isClick,
                ),
                Text('个', style: TextStyle(fontSize: 18)),
              ],
            ),
          )
        : Container();
  }
}

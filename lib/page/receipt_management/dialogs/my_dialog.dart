import 'package:flutter/material.dart';
import 'package:wanma_print/page/receipt_management/dialogs/counter_page.dart';

import '../../../widget/middle_text.dart';

class MyDialog extends Dialog {
  final String title;
  final String title2;
  final String content;
  // var count;
  var model;
  Function() f;
  Function(int) c1;
  Function(int) c2;
  Function(int) c3;
  double _h_height = 400;
  String flag;
  // 构造函数赋值
  MyDialog(
      {this.title = "",
      this.content = "",
      this.title2 = "",
      this.flag = "",
      required this.f,
      required this.c1,
      required this.c2,
      required this.c3,
      this.model});

  @override
  Widget build(BuildContext context) {
    if (this.flag == "dayin") {
      _h_height = 5 * 40 + 250;
    }
    return Material(
        type: MaterialType.transparency,
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
                                    fontSize: 20, fontWeight: FontWeight.w600),
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
                        // padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: Column(
                          children: [
                            centerWg(),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    "${this.content}",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  CounterPage(
                                      addCallBack: c1,
                                      mzeCallBack: c2,
                                      enterDelete: c3),
                                ],
                              ),
                            ),
                            _dayinWg(),
                            InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 33, 207, 39),
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
                ))));
  }

  Widget centerWg() {
    return Container(
        // alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10),
        width: 280,
        height: 5 * 40,
        color: Color.fromARGB(255, 243, 237, 237),
        child: Column(
          children: [
            _getRowText('供应商:', model['supplier_name'] ?? ''),
            _getRowText('供应商编码:', model['supplier_no'] ?? ''),
            _getRowText('内向交货单号:', model['inbound_deliver_no'] ?? ""),
            _getRowText('送货日期:', model['deliver_time'] ?? ''),
            _getRowText('订单号:', model['order_no'] ?? ''),
          ],
        ));
  }

  Widget _getRowText(String label, dynamic value) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: MiddleText(label, Alignment.centerLeft),
        ),
        Expanded(flex: 3, child: MiddleText(value, Alignment.centerRight)),
      ],
    ));
  }

  Widget _dayinWg() {
    return this.flag == "dayin"
        ? Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  "${this.title2}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                CounterPage(
                    addCallBack: (c) {},
                    mzeCallBack: (c) {},
                    enterDelete: (c) {}),
                Text('个', style: TextStyle(fontSize: 18)),
              ],
            ),
          )
        : Container();
  }
}

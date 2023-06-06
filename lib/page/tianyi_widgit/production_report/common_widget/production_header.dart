import 'package:flutter/material.dart';

class ProductionHeader extends StatelessWidget {
  final double wwidth;
  final double hheight;
  final bool isSelectWork;
  final String txt;
  final String txt1;
  final String txt2;
  final String txt3;
  final String txt4;
  final String txt5;
  final String txt6;
  final String ts;
  const ProductionHeader(this.wwidth, this.hheight, this.isSelectWork, this.txt,
      this.txt1, this.txt2, this.txt3, this.txt4, this.txt5, this.txt6, this.ts,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // shadowColor: null,
      elevation: 0,

      // color: Colors.white,
      margin: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 15, top: 10, bottom: 5),
                width: wwidth - 70,
                child: Row(
                  children: [
                    Text(
                      '订单号:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      // showCursor: true,
                    ),
                    SelectableText(
                      txt,
                      // _modelList[index]['deliver_no'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                ts,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )
            ],
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                textCells('客户订单号', txt1),
                textCells('产品名称', txt2),
                textCells('产品规格', txt3),
                textCells('任务数量', txt4),
                textCells('SAP订单号', txt5),
                isSelectWork == false ? textCells('已报工数量', txt6) : Container(),
                Divider()
              ],
            ),
          ),
          // Divider(),
          // _modelList[index]['status_text'] == '已取消'
          //     ? Container()
          //     :
        ],
      ),
    );
  }

  textCells(String label, dynamic value) {
    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, top: 5),
            // color: Colors.red,
            width: 80,
            child: Text(label),
          ),
          Container(
            // color: Colors.red,
            width: this.wwidth - 115,
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 20),
            child: Text(
              value,
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

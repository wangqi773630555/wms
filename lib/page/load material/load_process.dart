import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:wanma_print/widget/middle_text_right.dart';
import '../../common/config/config.dart';
import '../../common/utils/navigator_utils.dart';
import '../../widget/middle_text.dart';

class MaterialLoadProcess extends StatefulWidget {
  static final String sName = Config.Material_LoadProcess;

  @override
  _MaterialLoadProcessState createState() => _MaterialLoadProcessState();
}

class _MaterialLoadProcessState extends State<MaterialLoadProcess> {
  late double _wwidth;
  var _bstkd;
  var _part_name;
  var _id;
  var _part_description;
  var _order_no;
  var _init_order_id;
  var _data;
  var _recipes;
  List _colors = [
    0xff0000ff,
    0xff8080ff,
    0xff027db4,
    0xffc280ff,
    0xff02a7f0,
    0xff0000ff,
    0xff8080ff,
    0xff027db4,
    0xffc280ff
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      _data = ModalRoute.of(context)!.settings.arguments;
      setState(() {
        _bstkd = _data['bstkd'].toString();
        _part_name = _data['part_name'].toString();
        _id = _data['id'].toString();
        _part_description = _data['part_descrption'];
        _order_no = _data['order_no'].toString();
        _init_order_id = _data['init_order_id'].toString();
        _recipes = _data['recipes'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: Text('选择报工工序'), actions: <Widget>[]),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Container(
          child: Column(children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Text(
                '订单号：$_id',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),
            _getRowText('客户订单号:', _bstkd),
            _getRowText('产品名称:', _part_name ?? ""),
            _getRowText('产品规格:', _part_description ?? ""),
            _getRowText('任务数量:', _order_no),
            _getRowText('SAP订单号:', _init_order_id),
            Divider(),
            Column(
              children: _getButton(),
            ),
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
        Expanded(
          flex: 2,
          child: MiddleText(label, Alignment.centerLeft),
        ),
        Expanded(flex: 3, child: MiddleTextRight(value, Alignment.centerRight)),
      ],
    ));
  }

  List<Widget> _getButton() {
    List<Widget> list = [];
    if(_recipes!=null) {
      for (int i = 0; i < _recipes?.length; i++) {
        list.add(_button(i, _recipes[i]['title'], _colors[i]));
      }
    }
    return list;
  }

  Widget _button(i, String label, int color) {
    var sendData;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(6),
        ),
        SizedBox(
          width: _wwidth - 40,
          height: 40.0,
          child: ElevatedButton(
            child: Text(label),
            style: ButtonStyle(
              //背景色
              backgroundColor: MaterialStateProperty.all(Color(color)),
              //文字颜色
              foregroundColor: MaterialStateProperty.all(Color(0xffffffff)),
            ),

            onPressed: () => {
              sendData = _recipes[i],
              sendData['order_id'] = _id,
              NavigatorUtils.goMaterialLoadDetails(context,sendData)
            },
          ),
        )
      ],
    );
  }

  @override
  void dispose() async {
    super.dispose();
  }
}

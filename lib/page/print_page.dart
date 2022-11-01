import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../FlutterPlugins.dart';
import '../common/config/config.dart';

class ToPrint extends StatelessWidget {
  static final String sName = Config.MATERIAL_PRINT;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('打印'),
      ),
      body: ToPrintBody(),
    );
  }
}

class ToPrintBody extends StatefulWidget {
  // const RepairDetailBody(this.repairId, {Key? key}) : super(key: key);

  @override
  _ToPrintBodyState createState() => _ToPrintBodyState();
}

class _ToPrintBodyState extends State<ToPrintBody> {
  TextEditingController _noController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lotController = TextEditingController();
  TextEditingController _countController = TextEditingController();
  TextEditingController _singelCountController = TextEditingController();
  TextEditingController _pageCountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageCountController.text = '1';
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 35.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [

                  Expanded(flex: 1, child: Row(
                    children: [
                      Text('物料号:'),
                      Text('*',style: TextStyle(color: Colors.red),),
                    ],
                  )),

                  Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _noController,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 35.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 1, child: Text('物料名称:')),
                  Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _nameController,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 35.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 1, child: Row(
                    children: [
                      Text('物料批次:'),
                      Text('*',style: TextStyle(color: Colors.red),),
                    ],
                  )),
                  Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _lotController,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 35.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 1, child: Row(
                    children: [
                      Text('数量:'),
                      Text('*',style: TextStyle(color: Colors.red),),
                    ],
                  )),
                  Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _countController,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 35.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 1, child: Row(
                    children: [
                      Text('单张物料:'),
                      Text('*',style: TextStyle(color: Colors.red),),
                    ],
                  )),
                  Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _singelCountController,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 35.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 1, child: Row(
                    children: [
                      Text('打印张数:'),
                      Text('*',style: TextStyle(color: Colors.red),),
                    ],
                  )),
                  Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _pageCountController,
                      )),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            SizedBox(
              width: 200.0,
              height: 40.0,
              child:
                  ElevatedButton(onPressed: () => _save(), child: Text('打印')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    _noController.dispose();
    _nameController.dispose();
    _lotController.dispose();
    _countController.dispose();
    _singelCountController.dispose();
    _pageCountController.dispose();
  }

  _save() {
    //调用打印
    toPrint(_nameController.text.toString() +
        ";" +
        _noController.text.toString() +
        ";" +
        _lotController.text.toString() +
        ";" +
        _countController.text.toString() +
        ";" +
        _pageCountController.text.toString() +
        ";" +
        _singelCountController.text.toString());
  }

  void toPrint(String result) {
    FlutterPlugins.print(result).then((value) => {setState(() {})});
  }
}

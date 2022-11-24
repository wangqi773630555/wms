import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/event/scan_event.dart';
import 'package:wanma_print/common/utils/scanevent_utils.dart';
import '../FlutterPlugins.dart';
import '../common/config/config.dart';
import '../common/config/scanConfig.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../common/dao/data_dao.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToPrint extends StatefulWidget {
  // const RepairDetailBody(this.repairId, {Key? key}) : super(key: key);
  static final String sName = Config.MATERIAL_PRINT;

  @override
  _ToPrintState createState() => _ToPrintState();
}

class _ToPrintState extends State<ToPrint> {
  TextEditingController _noController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lotController = TextEditingController();
  TextEditingController _countController = TextEditingController();
  TextEditingController _singelCountController = TextEditingController();
  TextEditingController _pageCountController = TextEditingController();
  StreamSubscription? stream;
  ScanResult? scanResult;
  var _partName;
  var _lotName;
  var _noList = <String>[];
  var jsonData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageCountController.text = '1';
    stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
      if (event.page == ScanConfig.scanPage) {
        _getMessageById(event.scanResult);
      }
    });
    print('printInitState');
    ScanConfig.scanPage = ScanConfig.PAGE_PRINT;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('自助打印'), actions: <Widget>[
        IconButton(
          // action button
          icon: Icon(Icons.center_focus_strong_rounded),
          onPressed: () async {
            await _scan();
            if (scanResult?.type != ResultType.Error) {
              _getMessageById(scanResult!.rawContent);
            }
          },
        ),
      ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 35.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                        width: 85.0,
                        child: Row(
                          children: [
                            Text('物料号:'),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _noController,
                        )),
                    Padding(padding: EdgeInsets.all(5)),
                    SizedBox(
                      height: 25.0,
                      child: ElevatedButton(
                          onPressed: () => _getMessageByNo(),
                          child: Text(
                            '匹配',
                            style: TextStyle(fontSize: 12),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 45.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(width: 85.0, child: Text('物料名称:')),
                    Expanded(
                        flex: 3,
                        child: TextField(
                          maxLines: 1,
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
                    SizedBox(
                        width: 85.0,
                        child: Row(
                          children: [
                            Text('物料批次:'),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _lotController,
                        )),
                    Padding(padding: EdgeInsets.all(5)),
                    SizedBox(
                      height: 25.0,
                      child: ElevatedButton(
                          onPressed: () => _selectLot(),
                          child: Text(
                            '选择',
                            style: TextStyle(fontSize: 12),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                        width: 85.0,
                        child: Row(
                          children: [
                            Text('数量:'),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
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
                    SizedBox(
                        width: 85.0,
                        child: Row(
                          children: [
                            Text('单张物料:'),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
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
                    SizedBox(
                        width: 85.0,
                        child: Row(
                          children: [
                            Text('打印张数:'),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
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
                child: ElevatedButton(
                    onPressed: () => _getPrintids(), child: Text('打印')),
              ),
            ],
          ),
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
    print('printDispost');
    ScanConfig.scanPage = "";
    if (stream != null) {
      stream?.cancel();
      stream = null;
    }
  }

  //通过物料号获取打印信息
  _getMessageByNo() {

    if (_noController.text == '') {
      Fluttertoast.showToast(msg: '请先输入物料号');
      return;
    }

    var no = _noController.text.toString();
    DataDao.getPartInfoByParas(null,no).then((res) {
      if (res != null && res.result) {
        setState(() {
          var data = res.data['data'];
          _partName = data['part_name'];
          _nameController.text = _partName;
           jsonData =  data['batch_info'];

          // jsonData = json.decode(_batch_info);
          _noList.clear();
          if(jsonData!=null) {
            for (int i = 0; i < jsonData.length; i++) {
              _noList.add(jsonData[i]['part_batch'].toString());
              if(i==0){
                _lotController.text = jsonData[i]['part_batch'].toString();
                _countController.text = jsonData[i]['qty'].toString();
              }
            }
          }
        });
      }
    });

  }

  //通过标签id获取打印信息
  _getMessageById(var id) {
    print('标签id:$id');
    DataDao.getPartInfoByParas(int.parse(id),null).then((res) {
      if (res != null && res.result) {
        setState(() {
          var data = res.data['data'];
          _partName = data['part_name'];
          _noController.text = data['part_id'];
          _nameController.text = _partName;
           jsonData =  data['batch_info'];

          //jsonData = json.decode(_batch_info);
          _noList.clear();
          if(jsonData!=null) {
            for (int i = 0; i < jsonData.length; i++) {
              _noList.add(jsonData[i]['part_batch'].toString());
              if(i==0){
                _lotController.text = jsonData[i]['part_batch'].toString();
                _countController.text = jsonData[i]['qty'].toString();


              }
            }
          }
        });
      }
    });

  }

  //选择批次
  _selectLot() {
    _showNoBottomSheet(context, _noList);
  }

  //打印获取ids
  _getPrintids() {

    if (_noController.text == '') {
      Fluttertoast.showToast(msg: '物料号必填');
      return;
    }
    if (_lotController.text == '') {
      Fluttertoast.showToast(msg: '物料批次必填');
      return;
    }
    if (_countController.text == '') {
      Fluttertoast.showToast(msg: '数量必填');
      return;
    }
    if (_singelCountController.text == '') {
      Fluttertoast.showToast(msg: '单张物料必填');
      return;
    }
    if (_pageCountController.text == '') {
      Fluttertoast.showToast(msg: '打印张数必填');
      return;
    }
    DataDao.genPrintIdsByDetailIdAtSelfPrint(_noController.text,_lotController.text, _pageCountController.text,_singelCountController.text).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        var idsList =data['ids'];
        String ids = '';
        for (var id in idsList) {
          ids = ids + '$id,';
        }
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
            _singelCountController.text.toString() +
            ";" +
            ids +
            ",");
      }
    });


  }

  void toPrint(String result) {
    FlutterPlugins.print(result).then((value) => {setState(() {})});
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

  Future _showNoBottomSheet(BuildContext context, var options) async {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context1, setState) {
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
            ),
            height: MediaQuery.of(context).size.height / 2,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: new Text(
                    '物料批次',
                    style: new TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16.0),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.black38,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _lotName = _noList[index].toString();
                          _lotController.text = _lotName;
                          _countController.text = jsonData[index]['qty'].toString();

                        });
                      },
                      child: Container(
                        child: Text(
                          options[index],
                          style: TextStyle(
                              fontSize: 16.0),
                        ),
                        alignment: Alignment.center,
                        height: 40,
                        width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                      ),
                    );
                  },

                  //itemExtent: 35.0,
                  itemCount: options.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 1.0, color: Colors.grey),
                ),
              ),
            ]),
          );
        });
      },
    );
  }
}

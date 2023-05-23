import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/net/LogUtil.dart';
import 'package:wanma_print/page/common_widgit/picker/picker_three_level.dart';
import 'package:wanma_print/page/dianlan_widgit/search_material.dart';
import 'package:wanma_print/page/dianlan_widgit/task_finish_notarize.dart';
import 'package:wanma_print/widget/middle_text_right.dart';
import '../../common/config/config.dart';
import '../../common/config/scanConfig.dart';
import '../../common/dao/data_dao.dart';
import '../../common/event/scan_event.dart';
import '../../common/utils/navigator_utils.dart';
import '../../common/utils/scanevent_utils.dart';
import '../../widget/middle_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common_widgit/picker/picker_model.dart';

/**
 * 任务（任务查看）
 */


class TaskExamineNotarize extends StatefulWidget {
  static final String sName = Config.TASK_EXAMINE_NOTARIZE;

  @override
  _TaskExamineNotarizeState createState() => _TaskExamineNotarizeState();
}

class _TaskExamineNotarizeState extends State<TaskExamineNotarize> {

  ScanResult? scanResult;
  StreamSubscription? stream;
  var data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ScanConfig.scanPage = ScanConfig.PAGE_LOAD_PART;
    stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
      if (event.page == ScanConfig.PAGE_LOAD_PART) {}
    });

  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('任务查看'), actions: <Widget>[]),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
              child: Container(
                child: Column(children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle,color:Colors.green,size: 60,),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      Expanded(child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('运行正常', style: TextStyle(fontSize: 18,),),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Text((data['from_ware_name1']!=null?data['from_ware_name1']:"")+'>'+(data['from_ware_name2']!=null?data['from_ware_name2']:"")+'>'+(data['from_ware_name3']!=null?data['from_ware_name3']:""),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54)),
                          Padding(padding: EdgeInsets.only(top: 8)),
                          Divider(height: 1,),
                          Padding(padding: EdgeInsets.only(top: 8)),
                          Row(children: [
                            Expanded(child: Text((data['to_ware_name1']!=null?data['to_ware_name1']:"")+'>'+(data['to_ware_name2']!=null?data['to_ware_name2']:"")+'>'+(data['to_ware_name3']!=null?data['to_ware_name3']:""),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54)),),
                            Text(data['add_user']!=null?data['add_user']:'',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54)),
                          ],),

                        ],
                      ),)

                    ],),
                  Divider(),
                ]),
              ),
            ),
          ),
          Visibility(visible:false,child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                      style:  ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => {
                        Navigator.pop(context),
                        Navigator.pushNamed(context, TaskFinishNotarize.sName, arguments: data['id']),

                      }, child: Text('紧急停止')),
                ),
              ],
            ),),
          ),

        ],
      ),
    );
  }


  @override
  void dispose() async {
    super.dispose();
    if (stream != null) {
      stream?.cancel();
      stream = null;
    }
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
}




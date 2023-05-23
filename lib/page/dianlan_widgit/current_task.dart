import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';
import 'package:wanma_print/page/dianlan_widgit/task_examine_notarize.dart';
import 'package:wanma_print/page/dianlan_widgit/task_finish_notarize.dart';
import 'package:wanma_print/page/dianlan_widgit/task_return_notarize.dart';
import 'package:wanma_print/page/dianlan_widgit/task_wait_notarize.dart';
import '../../common/config/config.dart';
import '../../common/config/scanConfig.dart';
import '../../common/dao/data_dao.dart';
import '../../common/event/scan_event.dart';
import '../../common/utils/scanevent_utils.dart';
import '../../widget/middle_text.dart';
import 'package:wanma_print/page/common_widgit/refresh/custom_refresh_footer.dart';
import 'package:wanma_print/page/common_widgit/refresh/custom_refresh_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';

/**
 * 当前任务
 */
class CurrentTask extends StatefulWidget {
  const CurrentTask({Key? key}) : super(key: key);
  static const String sName = Config.CURRENT_TASK;

  @override
  State<CurrentTask> createState() => _CurrentTaskState();
}

class _CurrentTaskState extends State<CurrentTask> {
  bool _cirCular = false;
  late EasyRefreshController _easyfreshController;
  TextEditingController _searController = TextEditingController();
  late double _wwidth;
  late double _hheight;
  ScanResult? scanResult;

  List _modelList = [];
  List _allList = [];
  late IconData iconData;
  var color;

  getInintData() {
    DataDao.getAgvEqpTasks().then((res) {
      if(res!=null&&res.result) {
        setState(() {
          _searController.text = '';
          _modelList = res.data['data']['tasks'];
          _allList.clear;
          _allList.addAll(_modelList);
          _cirCular = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('当前任务'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              color: Color.fromARGB(255, 236, 243, 250),
              child: Column(
                children: [
                  Container(
                    // margin: EdgeInsets.only(top: 5),
                    height: _hheight - 90,
                    width: _wwidth,
                    child: _listWidget(),
                  )
                ],
              )),
        ));

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _easyfreshController = EasyRefreshController();
    getInintData();
    print('initState_load_list');
  }

  //列表
  Widget _listWidget() {
    return !_cirCular
        ? Center(
            child: CircularProgressIndicator(
              semanticsLabel: '加载中...',
            ),
          )
        : EasyRefresh.custom(
            controller: _easyfreshController,
            enableControlFinishRefresh: false,
            enableControlFinishLoad: true,
            header: CustomRefreshHeader(
                Colors.white, Colors.grey, Color.fromARGB(255, 244, 158, 54)),
            footer: CustomRefreshFooter(Colors.grey, Colors.grey),
            onRefresh: () async {
              _modelList.clear();
              _allList.clear();
              getInintData();
              setState(() {});
              _easyfreshController.resetLoadState();
            },
           /* onLoad: () async {
              setState(() {
                getInintData();
              });
              Future.delayed(Duration(milliseconds: 200), () {
                _easyfreshController.finishLoad(
                    // noMore: (_pageNum >= _modelList.length));
                    noMore: (true));
              });
            },*/
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
          );
  }

  Widget _cellForRow(conttext, index) {
    var confirm_status = _modelList[index]['task_status'];
    var title='回库确认';
    if(confirm_status=='1'){
      iconData = Icons.access_time_filled;
      color = Colors.blue;
      title = '回库确认';
    }else if(confirm_status=='2'){
      iconData = Icons.error;
      color = Colors.red;
      title = 'AGV状体异常';
    }else if(confirm_status=='3'){
      iconData = Icons.check_circle;
      color = Colors.green;
      title = '运行正常';
    }else{
      iconData = Icons.error;
      color = Colors.yellow[700];
      title = '任务待确认';
    }
    return GestureDetector(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
        child:Column(children: [
          Row(
          children: [
            Icon(iconData,color: color,size: 60,),
            Padding(padding: EdgeInsets.only(right: 10)),
            Expanded(child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18,),),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text((_modelList[index]['from_ware_name1']!=null?_modelList[index]['from_ware_name1']:"")+'>'+(_modelList[index]['from_ware_name2']!=null?_modelList[index]['from_ware_name2']:"")+'>'+(_modelList[index]['from_ware_name3']!=null?_modelList[index]['from_ware_name3']:""),
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                Padding(padding: EdgeInsets.only(top: 8)),
                Divider(height: 1,),
                Padding(padding: EdgeInsets.only(top: 8)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Expanded(child:  Text((_modelList[index]['to_ware_name1']!=null?_modelList[index]['to_ware_name1']:"")+'>'+(_modelList[index]['to_ware_name2']!=null?_modelList[index]['to_ware_name2']:"")+'>'+(_modelList[index]['to_ware_name3']!=null?_modelList[index]['to_ware_name3']:""),
                      style: TextStyle(fontSize: 14, color: Colors.black54)),),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text(_modelList[index]['add_name']!=null?_modelList[index]['add_name']:'',
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                ],),

              ],
            ),)

          ],),
          Padding(padding: EdgeInsets.only(top: 10)),
          Divider(height: 1,),
        ],),

      ),
      onTap: () {
        //点击
        if(confirm_status=='1'){
        var result  = Navigator.pushNamed(context, TaskReturnNotarize.sName, arguments:  _modelList[index]);
          result.then((value) => {
            if(value!=null){
              getInintData()
            }
          });
        }else if(confirm_status=='2'){
          var result  = Navigator.pushNamed(context, TaskFinishNotarize.sName, arguments: _modelList[index]);
          result.then((value) => {
            if(value!=null){
              getInintData()
            }
          });
        }else if(confirm_status=='3'){
         Navigator.pushNamed(context, TaskExamineNotarize.sName, arguments: _modelList[index]);
        }else{
          var result = Navigator.pushNamed(context, TaskWaitNotarize.sName, arguments: _modelList[index]);
          result.then((value) => {
            if(value!=null){
              getInintData()
            }
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
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

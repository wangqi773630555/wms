import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/net/LogUtil.dart';
import 'package:wanma_print/page/common_widgit/picker/picker_three_level.dart';
import 'package:wanma_print/page/dianlan_widgit/search_material.dart';
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
 * 任务（回库确认）
 */


class TaskReturnNotarize extends StatefulWidget {
  static final String sName = Config.TASK_RETURN_NOTARIZE;

  @override
  _TaskReturnNotarizeState createState() => _TaskReturnNotarizeState();
}

class _TaskReturnNotarizeState extends State<TaskReturnNotarize> {

  ScanResult? scanResult;

  StreamSubscription? stream;
  List<dynamic> list = [];
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
      appBar: AppBar(
          centerTitle: true, title: Text(''), actions: <Widget>[]),
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
                      Icon(Icons.access_time_filled, color: Colors.blue,
                        size: 60,),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('回库确认', style: TextStyle(fontSize: 18,),),
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
                  Row(
                    children: [
                      Text(
                        '回库确认',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(200, 0, 0, 0),
                        ),
                        // showCursor: true,
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 25,
                          ),
                          onPressed: () {
                            //添加数据
                            setState(() {
                              Map map = Map();
                              //map['name'] = '';
                              map['controller'] = TextEditingController();
                              list.add(map);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  _createListViewItem(),
                ]),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                height: 40.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: Colors.blue,
                      backgroundColor: Colors.blue,
                      //change background color of button
                      //change text color of button
                    ),
                    onPressed: () =>
                    {
                      setState(() {

                        Map<String, dynamic> map = Map();
                        map['task_id'] = data['task_id'];
                        List<Map> details  = [];
                        for(int i=0;i<list.length;i++){
                          Map<String, dynamic> map = Map();
                          map['part_name'] = list[i]['name'];
                          map['part_id'] = list[i]['id'];
                          if(list[i]['controller'].text==''){
                            Fluttertoast.showToast(msg: '请输入数量');
                            return;
                          }
                          map['qty'] = double.parse(list[i]['controller'].text);
                          details.add(map);
                        }
                        map['details'] = details;
                        confirmTask5(map);
                      }),
                    }, child: Text('回库确认')),
              ),),

        ],
      ),
    );
  }


  Widget _searchWidget(String hint, TextEditingController _controller) {
    return Row(
      children: [
        Text(hint, style: TextStyle(fontSize: 14),),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
        Expanded(child: TextField(
          controller: _controller,
          style: TextStyle(fontSize: 15),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.all(5),
            disabledBorder: OutlineInputBorder(
              /*边角*/
              borderRadius: BorderRadius.all(
                Radius.circular(2), //边角为5
              ),
              borderSide: BorderSide(
                color: Colors.grey, //边线颜色为白色
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
            hintText: '',
          ),
        ),),
        Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
        Text('kg', style: TextStyle(fontSize: 14),),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
      ],
    );


  }


  /**
   * 创建列表item
   */
  Widget _createListViewItem() {
    List<Widget> _list = [];
    for (int i = 0; i < list.length; i++) {
      _list.add(_createItem(i, "回库数量：", list[i]['controller']));
    }
    return Column(
      children: _list,
    );
  }

  Widget _createItem(int index, String hint,
      TextEditingController _controller) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  child: OutlinedButton(
                    onPressed: () {
                      var result = Navigator.pushNamed(
                          context, SearchMaterial.sName);
                      result.then((dynamic value) =>
                      {
                        setState(() {
                          list[index]['name'] = value!['name'];
                          list[index]['id'] = value!['id'];
                        }),
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        list[index]['name'] != null
                            ? list[index]['name']
                            : '请选择物料',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35.0,
                  child: _searchWidget(hint, _controller),
                ),

              ],
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 25,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  list.removeAt(index);
                });
              },
            ),
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

  confirmTask5(Map<String, dynamic> body) {
    DataDao.confirmTask5(body).then((res) {
      if(res!=null&&res.result) {
        Fluttertoast.showToast(msg: '提交成功');
        Navigator.pop(context, '1');
      }
    });
  }
}


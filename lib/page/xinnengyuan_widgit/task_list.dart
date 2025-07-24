import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import '../../../common/config/config.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../common_widgit/refresh/custom_refresh_footer.dart';
import '../common_widgit/refresh/custom_refresh_header.dart';
import 'checkout_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

/**
 * 检验任务查询
 */
class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);
  static const String sName = Config.TASKLIST;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {

  ScanResult? scanResult;
  //工单编号
  TextEditingController _controllerGdbh = TextEditingController();

  //改造派工单号
  TextEditingController _controllerGzpgdh = TextEditingController();

  //整机条码
  TextEditingController _controllerZjtm = TextEditingController();

  int position = 0;
  int _pageNumber = 1;
  int _pageSize = 5;
  late EasyRefreshController _easyfreshController;

  List _modelList = [];

  bool open = true;
  bool _hasMore = false;

  getInintData() {
    DataDao.taksPage(
            _pageNumber,
            _pageSize,
            _controllerGdbh.text,
            _controllerGzpgdh.text,
            _controllerZjtm.text,
           )
        .then((res) {
      setState(() {
        if (res != null && res.result) {
          if (_pageNumber == 1) {
            _modelList.clear();
          }
          var data = res.data['data'];
          if (_pageNumber <= data['total']) {
            _modelList.addAll(data['list']);
          }
          _hasMore = _pageNumber >= data['total'];
          if (_pageNumber == 1 && _modelList.length == 0) {
            Fluttertoast.showToast(msg: '无数据');
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    return Scaffold(
        appBar: AppBar(
          title: Text('查询检验任务'),
          centerTitle: true,
          actions: [],
        ),
        body: _headView());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _easyfreshController = EasyRefreshController();
  }


  Widget _headView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        open
            ? Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _leftText('工单编号:        '),
                      _editView(_controllerGdbh),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _leftText('改造派工单号:'),
                      _editView(_controllerGzpgdh),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _leftText('整机条码:        '),
                      _editView(_controllerZjtm),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 35,
                        height: 35,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(
                            Icons.qr_code_scanner_outlined,
                            size: 30,
                            color: Colors.black54,
                          ),
                          onPressed: () async {
                            await _scan();
                            if (scanResult?.type != ResultType.Error) {
                              //设备扫码
                              if (scanResult?.rawContent != '') {
                                //扫码结束
                                setState(() {
                                  _controllerZjtm.text = scanResult!.rawContent;
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                        width: double.infinity,
                        height: 25.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => {
                                      //重置
                                      setState(() {
                                        _controllerGzpgdh.text = '';
                                        _controllerGdbh.text = '';
                                        _controllerZjtm.text = '';
                                      })
                                    },
                                child: Text('取消')),
                            Padding(padding: EdgeInsets.only(right: 10)),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                ),
                                onPressed: () => {
                                      //搜索
                                  _pageNumber = 1,
                                      getInintData()
                                    },
                                child: Text('确认')),
                            Padding(padding: EdgeInsets.only(right: 10)),
                          ],
                        )),
                  ),
                ],
              )
            : Container(),
        IconButton(
          onPressed: () {
            setState(() {
              open = !open;
            });
          },
          icon: Icon(
            open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 30,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Container(
            // color: Color.fromARGB(111, 236, 243, 100),
            child: EasyRefresh.custom(
              controller: _easyfreshController,
              enableControlFinishRefresh: false,
              enableControlFinishLoad: true,
              header: CustomRefreshHeader(
                  Colors.white, Colors.grey, Color.fromARGB(255, 244, 158, 54)),
              footer: CustomRefreshFooter(Colors.grey, Colors.grey),
              onRefresh: () async {
                _pageNumber = 1;
                getInintData();
                setState(() {});
                _easyfreshController.resetLoadState();
              },
              onLoad: () async {
                _pageNumber++;
                getInintData();
                Future.delayed(Duration(milliseconds: 200), () {
                  _easyfreshController.finishLoad(noMore: _hasMore);
                });
              },
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
            ),
          ),
        ),
      ],
    );
  }


  Widget _editView(TextEditingController _controller) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 25.0,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: TextField(
            maxLines: 1,
            style: TextStyle(fontSize: 14),
            controller: _controller,
            decoration: InputDecoration(
              fillColor: Colors.white12,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _cellForRow(conttext, i) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '销售订单号:  ${_modelList[i]['soId'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '生产订单:  ${_modelList[i]['poId'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '工单号:  ${_modelList[i]['lotId'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '检验批次:  ${_modelList[i]['batchId'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '改造派工单号:  ${_modelList[i]['col02'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '改造备注:  ${_modelList[i]['col03'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '物料编码:  ${_modelList[i]['partCode'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '物料名称:  ${_modelList[i]['partTitle'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '订单数量:  ${_modelList[i]['qty'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Divider(
              color: Colors.black38,
            ),
          ],
        ),
      ),
      onTap: () {
        //点击
        var result = Navigator.pushNamed(context, CheckOutList.sName,
            arguments: {'id': _modelList[i]['id']});
        result.then((dynamic value) {
          if (value != null && value == '1') {
            setState(() {

            });
          }
        });
      },
    );
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


  Widget _leftText(value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Text(
        value,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
  }

}

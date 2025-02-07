import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import '../../../common/config/config.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../common/net/url_constant.dart';
import '../common_widgit/refresh/custom_refresh_footer.dart';
import '../common_widgit/refresh/custom_refresh_header.dart';
import 'package:open_file/open_file.dart' as OpenFile;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';



/**
 * 打卡记录
 */
class ScanSignInList extends StatefulWidget {
  const ScanSignInList({Key? key}) : super(key: key);
  static const String sName = Config.SCANSIGNINLIST;

  @override
  State<ScanSignInList> createState() => _ScanSignInListState();
}

class _ScanSignInListState extends State<ScanSignInList> {

  int position = 0;
  bool _hasMore = true;
  int _pageNumber = 1;
  int _pageSize = 20;
  late EasyRefreshController _easyfreshController;
  late double _hheight;

  var startDay, endDay;
  var _selectDateStart = DateTime.now();
  var _selectDateEnd = DateTime.now();

 // List _modelList = [{'egp_name':'设备名','add_time':'2024-12-13','img_id':1734017398139676,'remark':'备注信息'},{'egp_name':'设备名','add_time':'2024-12-13','img_id':1734017398139676,'remark':'备注信息'},{'egp_name':'设备名','add_time':'2024-12-13','img_id':1734017398139676,'remark':'备注信息'},{'egp_name':'设备名','add_time':'2024-12-13','img_id':1734017398139676,'remark':'备注信息'},{'egp_name':'设备名','add_time':'2024-12-13','img_id':1734017398139676,'remark':'备注信息'},{'egp_name':'设备名','add_time':'2024-12-13','img_id':1734017398139676,'remark':'备注信息'},{'egp_name':'设备名','add_time':'2024-12-13','img_id':1734017398139676,'remark':'备注信息'},{'egp_name':'设备名','add_time':'2024-12-13','img_id':1734017398139676,'remark':'备注信息'},{'egp_name':'设备名','add_time':'2024-12-13','img_id':1734017398139676,'remark':'备注信息'}];
  List _modelList = [];
  var _jt_id;
  var eqp_name = '';
  List<DropdownMenuItem<Object>> _jt_items = [];
  List datas = [];


  getInintData() {
      DataDao.getUserScanCodeList(_pageNumber, _pageSize,startDay,endDay,eqp_name)
          .then((res) {
        setState(() {
          if (res != null && res.result) {

            var patrols = json.decode(res.data['message'])['patrols'];
            _hasMore = patrols['lastPage'];
            if (_pageNumber == 1) {
              _modelList.clear();
            }
            _modelList.addAll(patrols['list']);
          }
        });
      });
  }

  getDataList() {
    DataDao.rtQmSampleInit().then((res) {
      if (res.data != null && res.data != '') {
        if (res != null && res.result) {
          var message = json.decode(res.data['message']);
           datas = message['eqps'];
          for (int i = 0; i < datas.length; i++) {
            DropdownMenuItem<Object> item = DropdownMenuItem(
              child: Text(datas[i]['iot_eqp_name']),
              value: datas[i]['id'],
            );
            _jt_items.add(item);
          }
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('打卡记录'),
        centerTitle: true,
      ),
      body:Column(children: [
        Container(
          height: _hheight-100,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.resolveWith(
                                  (states) {
                                return Colors.white;
                              }),
                          shape: MaterialStateProperty.all(
                              BeveledRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(0))),
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, //外边距
                        ),
                        child: Text(
                          startDay??'选择开始时间',
                        ),
                        onPressed: () {
                          _showDataBottomPicker(true);
                        },
                      ),
                    ),
                    Text('~'),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.resolveWith(
                                  (states) {
                                return Colors.white;
                              }),
                          shape: MaterialStateProperty.all(
                              BeveledRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(0))),
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, //外边距
                        ),
                        child: Text(
                          endDay??'选择结束时间',
                        ),
                        onPressed: () {
                          _showDataBottomPicker(false);
                        },
                      ),
                    ),
                    Icon(
                      Icons.date_range,
                      color: Colors.grey,
                      size: 20,
                    ),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, //外边距
                        ),
                        child: Text(
                          "查询",
                          style: TextStyle(fontSize: 12),
                        ),
                        onPressed: () {
                          _pageNumber = 1;
                          getInintData();
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 5)),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(padding: EdgeInsets.only(left: 15)),
                  Text(
                    '机台:',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.only(left: 15)),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 30.0,
                      child: _dropDownWidget('请选择'),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 15)),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),

              Expanded(flex:1,child:  Container(
                child: EasyRefresh.custom(
                  controller: _easyfreshController,
                  enableControlFinishRefresh: false,
                  enableControlFinishLoad: true,
                  header: CustomRefreshHeader(
                      Colors.white,
                      Colors.grey,
                      Color.fromARGB(255, 244, 158, 54)),
                  footer:
                  CustomRefreshFooter(Colors.grey, Colors.grey),
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
                      delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            // 这里为iOS UITableViewCell （android的adapter）,样式大家自定义即可
                            return _cellForRow(context, index);
                          },
                          // 设置返回数据个数
                          childCount: _modelList.length),
                    ),
                  ],
                ),
              ),)

            ],
          ),
        ),
      ],),

    );
  }

  Widget _dropDownWidget(String hint) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
              //设置边框
              border: new Border.all(color: Colors.grey, width: 1),
              //背景颜色
              color: Colors.white,
              //设置圆角
              borderRadius: new BorderRadius.circular((2)),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: DropdownButton(
              //提示文本
              hint: Text(hint),
              underline: Container(height: 0),
              //下拉列表项
              items: _jt_items,
              //默认值
              value: _jt_id,
              //下拉三角大小
              iconSize: 30.0,
              //阴影大小
              elevation: 1,
              //是否和父容器宽度保持一致（默认false,占一般左右）,通常用这个设置宽度
              isExpanded: true,
              //下拉文本样式
              style: TextStyle(color: Colors.black, fontSize: 15),
              //下拉改变事件
              onChanged: (value) {
                setState(() {
                  this._jt_id = value;
                  print(value.toString());

                  for (int i = 0; i < datas.length; i++) {
                    if (_jt_id == datas[i]['id']) {
                      eqp_name = datas[i]['iot_eqp_name'];
                    }
                  }

                  _pageNumber = 1;
                  getInintData();

                });
              },
            ),
          )
        ],
      ),
    );
  }


  _showDataBottomPicker(bool isStart) {
    DatePicker.showDatePicker(context,
        initialDateTime: isStart ? _selectDateStart : _selectDateEnd,
        dateFormat: "yyyy年 MM月 dd日", //通过空格设置滚轮数量
        pickerTheme: DateTimePickerTheme(
            confirm: Text("确认",
                style: TextStyle(fontSize: 14, color: Colors.black))),
        onConfirm: (DateTime dateTime, List<int> selectedIndex) async {
          setState(() {
            String monthStr, dayStr;
            if (dateTime.month < 10) {
              monthStr = '0' + dateTime.month.toString();
            } else {
              monthStr = dateTime.month.toString();
            }
            if (dateTime.day < 10) {
              dayStr = '0' + dateTime.day.toString();
            } else {
              dayStr = dateTime.day.toString();
            }

            if (isStart) {
              _selectDateStart = dateTime;
              startDay = dateTime.year.toString() + '-' + monthStr + '-' + dayStr;
            } else {
              _selectDateEnd = dateTime;
              endDay = dateTime.year.toString() + '-' + monthStr + '-' + dayStr;
            }
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _easyfreshController = EasyRefreshController();
    getInintData();
    getDataList();
  }


  Widget _cellForRow(conttext, index) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: 1,
              color: Colors.black38,
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              '机台：${_modelList[index]['eqp_name']??''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 3)),
            Text(
              '备注：${_modelList[index]['remark']??''}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 3)),
            Text(
              '打卡时间：${_modelList[index]['add_time']}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Text(
                  '照片：',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),

                TextButton(
                    style: ButtonStyle(
                      // 去除外边距
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // 去除内边距
                        minimumSize: MaterialStateProperty.all(Size.zero),
                       ),
                    onPressed: () => {
                    _startDownload(_modelList[index]['img_id'], _modelList[index]['img_id'].toString()+'.png')
                    },
                    child: Text(
                      '${_modelList[index]['img_id']??''}',
                      style: TextStyle(color: Colors.blue,fontSize: 12),
                    ))
              ],
            ),


          ],
        ),
      ),
      onTap: () {
        //点击
       /* Navigator.pop(context, {
          'jcTfjcd': _modelList[index]['id'],
          'jcTfjcdName': _modelList[index]['pointName']
        });*/
      },
    );
  }

  Future _startDownload(file_id, fileName) async {
    String _fileUrl = UrlConstant.getDownloadFile() + '/' + file_id.toString();
    Dio _dio = Dio();
    Map<String, String> header = {"Accept-Encoding": "identity"};
    Options _options = Options(headers: header);
    var localPath = await findLocalPath(fileName);
    if (localPath == null) return;
    await _dio.download(
      _fileUrl,
      localPath,
      options: _options,
    );
    /*CommonUtils.showCustomAlertDialog(context, '下载成功，是否打开？', () async {
      await OpenFile.OpenFile.open(localPath);
    });*/
    OpenFile.OpenFile.open(localPath);
  }

  Future<dynamic> findLocalPath(name) async {
    var _localPath;
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    if (directory == null) return;
    String localPath = directory.path + '/Download';
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    File file = File(localPath + '/' + name);
    if (await file.exists()) {
      await OpenFile.OpenFile.open(file.path);
      return;
    } else {
      _localPath = localPath + '/' + name;
      return _localPath;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
  }
}

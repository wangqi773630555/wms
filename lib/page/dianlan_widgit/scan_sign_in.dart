import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanma_print/page/dianlan_widgit/scan_sign_in_list.dart';
import '../../../common/config/config.dart';
import '../../../common/dao/data_dao.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/local/local_storage.dart';

import '../../common/dao/user_dao.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/net/url_constant.dart';
import '../../common/utils/navigator_utils.dart';

import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:open_file/open_file.dart' as OpenFile;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class ScanSignIn extends StatelessWidget {
  static const String sName = Config.SCANSIGNIN;

  const ScanSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScanSignInBody());
  }
}

class ScanSignInBody extends StatefulWidget {
  const ScanSignInBody({Key? key}) : super(key: key);

  @override
  _ScanSignInBodyState createState() => _ScanSignInBodyState();
}

class _ScanSignInBodyState extends State<ScanSignInBody> {
  ScanResult? scanResult;
  bool isScan = true;
  var _userName;
  var text = '';
  bool success = false;
  TextEditingController _controller = TextEditingController();
  var image;
  List _jts = [];
  var _jt_id;
  List<DropdownMenuItem<Object>> _jt_items = [];
  var fileName = '';
  var fileId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*  Future.delayed(Duration.zero, () async {
      await _scan();
    });*/
    initParams();
    getDataList();
  }

  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY) ?? '';
  }

  signin(content,check_type) {
    UserDao.signin(content + ',' + _userName, fileId, _controller.text,check_type)
        .then((res) {
      if (res != null && res.result) {
        setState(() {
          text = '签到成功';
          success = true;
          isScan = false;
        });
      } /*else {
        setState(() {
          text = res.data;
          success = false;
          isScan = false;
        });
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(centerTitle: true, title: Text('扫码签到'), actions: <Widget>[
          TextButton(
              onPressed: () => {
                    NavigatorUtils.goPage(
                      context,
                      ScanSignInList.sName,
                    )
                  },
              child: Text(
                '打卡记录',
                style: TextStyle(color: Colors.white),
              ))
        ]),
        body: isScan
            ? Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(20)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 15)),
                        Text(
                          '照片:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(left: 15)),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: TextButton(
                                onPressed: () =>
                                    {_startDownload(fileId, fileName)},
                                child: Text(
                                  fileName,
                                  style: TextStyle(color: Colors.blue),
                                  softWrap: true,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                //backgroundColor: Colors.red,
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () async => {
                                    image = await ImagePicker().pickImage(
                                        source: ImageSource.camera,
                                        maxHeight: 1920,
                                        maxWidth: 1080),
                                    _upLoadFile(image, context)
                                  },
                              child: Text('拍照')),
                        ),
                        Padding(padding: EdgeInsets.only(left: 15)),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 15)),
                        Text(
                          '机台:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                    Padding(padding: EdgeInsets.all(20)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 15)),
                        Text(
                          '备注:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(left: 15)),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: TextField(
                              maxLines: 3,
                              controller: _controller,
                              decoration: InputDecoration(
                                fillColor: Colors.white12,
                                filled: true,
                                contentPadding: EdgeInsets.all(5),
                                disabledBorder: OutlineInputBorder(
                                  /*边角*/
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5), //边角为5
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black12, //边线颜色为白色
                                    width: 1, //边线宽度为2
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  /*边角*/
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5), //边角为5
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black12, //边线颜色为白色
                                    width: 1, //边线宽度为2
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey, //边框颜色为白色
                                    width: 1, //宽度为5
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5), //边角为30
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(30)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              //backgroundColor: Colors.red,
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => {
                                  if (fileId == null)
                                    {Fluttertoast.showToast(msg: "请先拍照")}
                                  else if (_controller.text == '')
                                    {Fluttertoast.showToast(msg: "请输入备注信息")}
                                  else if (_jt_id == null)
                                    {Fluttertoast.showToast(msg: "请选择机台")}
                                  else
                                    {
                                      signin(DateTime.now().millisecondsSinceEpoch.toString()+","+_jt_id.toString()+", ",2)
                                    }
                                },
                            child: Text('异常签到')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              //backgroundColor: Colors.red,
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () => {_scan()},
                            child: Text('扫码签到')),
                      ],
                    )
                  ],
                ),
              )
            : Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 100)),
                    Icon(
                      success ? Icons.check_circle : Icons.error,
                      color: success ? Colors.green : Colors.red,
                      size: 100,
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Text(
                      text,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ));
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
                });
              },
            ),
          )
        ],
      ),
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
      setState(() => {
            scanResult = result,
            if (scanResult?.rawContent != '')
              {signin(scanResult!.rawContent,1)}
            else
              {
                Fluttertoast.showToast(msg: '二维码扫描失败'),
                //Navigator.pop(context)
              }
          });
    } on PlatformException catch (e) {
      //Fluttertoast.showToast(msg: '二维码扫描失败');
      Navigator.pop(context);
    }
  }

  void _upLoadFile(XFile? image, mContext) async {
    //上传照片
    File file = File(image!.path);
    int length = await file.length();
    var d = await file.lastModified();
    var date =
        formatDate(d, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    setState(() {});
    //  MultipartFile.fromFile(image!.path, filename: '');
    DataDao.getUploadFile(file, image.name, 'image/jpg', length, date)
        .then((res) {
      if (res != null && res.result) {
        var data = res.data['message'];
        setState(() {
          //files.add(data['ctBaseFile']);
          var file = json.decode(data)['ctBaseFile'];
          //files.add(data['ctBaseFile']);
          fileName = file['file_name'];
          fileId = file['id'];
        });
      }
    });
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

  getDataList() {
    DataDao.rtQmSampleInit().then((res) {
      if (res.data != null && res.data != '') {
        if (res != null && res.result) {
          var message = json.decode(res.data['message']);
          List datas = message['eqps'];
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
  void dispose() {
    super.dispose();
  }
}

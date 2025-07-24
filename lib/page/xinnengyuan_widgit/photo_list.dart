import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import '../../../common/config/config.dart';

import '../../common/utils/common_utils.dart';

import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart' as OpenFile;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

/**
 * 图片列表
 */
class PhotoList extends StatefulWidget {
  const PhotoList({Key? key}) : super(key: key);
  static const String sName = Config.PHOTOLIST;

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  var photoList = [];
  var _data;
  var _id,_col02;
  var canEdit  =true;


  updateSheetInfo() {
    DataDao.updateSheetInfo(_id,jsonEncode(photoList)).then((res) {
      setState(() {
        if (res != null && res.result) {
          Fluttertoast.showToast(msg: '操作成功');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    return Scaffold(
        appBar: AppBar(
          title: Text('照片上传'),
          centerTitle: true,
          actions: [
          ],
        ),
        body: _photoSelectView('图片列表'));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      _data = ModalRoute.of(context)!.settings.arguments;
      setState(() {
        _id = _data['id'];
        _col02 = _data['col02'];
        if (_col02!= null) {
          photoList = json.decode(_col02);
        }
      });
    });
  }


  ///选择图片组件
  Widget _photoSelectView(var title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///头部
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
          child: Row(
            children: [
              Text(title),
              SizedBox(
                width: 30,
                height: 40,
                child: !canEdit
                    ? Container()
                    : IconButton(
                        // action button
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          ///选择
                          CommonUtils.showCustomBottomSheet(context, (context) {
                            return Container(
                              height: 100,
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _getFileShow(
                                          1, Icons.camera_alt_outlined, '相机',
                                          () async {
                                        Navigator.pop(context);
                                        var image = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.camera,
                                                imageQuality: 80,
                                                maxHeight: 1920,
                                                maxWidth: 1080);
                                        _upLoadFile(image, context);
                                      }),
                                      Padding(padding: const EdgeInsets.all(5)),
                                      _getFileShow(
                                          1, Icons.photo_album_outlined, '本地相册',
                                          () async {
                                        Navigator.pop(context);
                                        var image = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery,
                                                imageQuality: 80,
                                                maxHeight: 1920,
                                                maxWidth: 1080);
                                        _upLoadFile(image, context);
                                      }),
                                    ],
                                  ),
                                  Padding(padding: const EdgeInsets.all(5))
                                ],
                              ),
                            );
                          });
                        },
                      ),
              )
            ],
          ),
        ),
        showPicture(photoList, true, setState),
      ],
    );
  }

  ///上传图片
  void _upLoadFile(XFile? image, mContext) async {
    File file = File(image!.path);
    setState(() {});
    DataDao.upload(file).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        setState(() {
          photoList.add(data);
          updateSheetInfo();
        });
      }
    });
  }


  ///拍照和图库按钮
  //文件时flag为1，此时fileName为文件名，text为path
  Widget _getFileShow(mark, IconData icon, text, callback,
      {flag = 0, fileName = ''}) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.black,
            ),
            Padding(padding: EdgeInsets.all(2.0)),
            Text(
              flag == 1 ? fileName : text,
              style: flag == 1
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: Colors.black)
                  : TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
            )
          ],
        ),
        onTap: () {
          callback();
        },
      ),
    );
  }

  //图片显示
  Widget showPicture(list, isShow, setState) {
    List<Widget> _list = [];
    if (list == null || list.length == 0) {
      return Container();
    }

    for (int i = 0; i < list.length; i++) {
      Widget item = Container(
        padding: EdgeInsets.all(5),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.network(
                  list[i]['accessUrl'].toString().replaceAll('https://minio.wanmaco.com/wanma-public/','https://gateway.wanmaco.com/file-server/minio/file/download?bucketname=wanma-public&object='),
                  fit: BoxFit.fill,
                )),
            (canEdit)
                ? Container(
                    width: double.infinity,
                    height: 18,
                    color: Color.fromARGB(128, 0, 0, 0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0), //内边距
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, //外边距
                      ),
                      onPressed: () {
                        setState(() {
                          list.removeAt(i);
                          updateSheetInfo();
                        });
                      },
                      child: Text(
                        '删 除',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
      _list.add(TextButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(Size(0, 0)),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        child: item,
        onPressed: () {
          _startDownload(list[i]['accessUrl'], list[i]['accessUrl']);
        },
      ));
    }
    return Container(
      child: GridView(
        // 设置滚动的方式
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // 禁止滚动
        padding: EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        children: _list,
      ),
    );
  }

  ///图片下载
  Future _startDownload(accessUrl, fileName) async {
    // String _fileUrl = UrlConstant.getDownloadFile() + '/' + file_id;
    Dio _dio = Dio();
    Map<String, String> header = {"Accept-Encoding": "identity"};
    Options _options = Options(headers: header);
    var localPath = await findLocalPath(fileName);
    if (localPath == null) return;
    await _dio.download(
      accessUrl,
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
  }

}


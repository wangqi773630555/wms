import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';
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
 * 物料选择（用于初始参为的筛选）
 */
class SearchMaterialFiltrate extends StatefulWidget {
  const SearchMaterialFiltrate({Key? key}) : super(key: key);
  static const String sName = Config.SEARCH_MATERIAL_FILTRATE;

  @override
  State<SearchMaterialFiltrate> createState() => _SearchMaterialFiltrateState();
}

class _SearchMaterialFiltrateState extends State<SearchMaterialFiltrate> {
  bool _cirCular = false;
  late EasyRefreshController _easyfreshController;
  TextEditingController _searController = TextEditingController();
  late double _wwidth;
  late double _hheight;
  ScanResult? scanResult;

  List _modelList = [];
  List _allList = [];

  getInintData() {
    DataDao.getWmsStockParts(null).then((res) {
      if(res!=null&&res.result) {
        setState(() {
          _searController.text = '';
          _modelList = res.data['data']['parts'];
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
          title: Text('搜索物料'),
          centerTitle: true,
          actions: [
            IconButton(
              // action button
              icon: Icon(Icons.center_focus_strong_rounded),
              onPressed: () async {
                await _scan();
                if (scanResult?.type != ResultType.Error) {}
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              color: Color.fromARGB(255, 236, 243, 250),
              child: Column(
                children: [
                  _searchRow(),
                  Container(
                    // margin: EdgeInsets.only(top: 5),
                    height: _hheight - 150,
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
  }

  Widget _searchRow() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: SizedBox(
        height: 40.0,
        child: _searchWidget(),
      ),
    );
  }

  Widget _searchWidget() {
    return TextField(
      style: TextStyle(fontSize: 15),
      controller: _searController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.all(5),
        enabledBorder: OutlineInputBorder(
          /*边角*/
          borderRadius: BorderRadius.all(
            Radius.circular(5), //边角为5
          ),
          borderSide: BorderSide(
            color: Colors.white, //边线颜色为白色
            width: 1, //边线宽度为2
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white, //边框颜色为白色
            width: 1, //宽度为5
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5), //边角为30
          ),
        ),
        hintText: '请输入物料编号/物料名称/物料描述',

        // prefixIcon:
        //suffixIcon: Icon(Icons.search),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        print(value.toString() + "1111");
        print('${_allList.length}');
        setState(() {
          _modelList.clear();
          for (int i = 0; i < _allList.length; i++) {
            if (_allList[i]['part_id'].toString().contains(value.toString())||_allList[i]['part_name'].toString().contains(value.toString())) {
              _modelList.add(_allList[i]);
            }
          }
        });
      },
    );
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
    return GestureDetector(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (_modelList[index]['ware_name1']==null?'':_modelList[index]['ware_name1'])+'>'+(_modelList[index]['ware_name2']==null?'':_modelList[index]['ware_name2'])+'>'+(_modelList[index]['ware_name3']==null?'':_modelList[index]['ware_name3']),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(_modelList[index]['part_id'].toString(), style: TextStyle(fontSize: 14,color: Colors.black54)),
            Text(_modelList[index]['part_name'], style: TextStyle(fontSize: 14,color: Colors.black54)),
            Padding(padding: EdgeInsets.all(2)),
            Divider(
              height: 1,
            ),
          ],
        ),
      ),
      onTap: () {
        //点击
        Navigator.pop(context, {'name1': _modelList[index]['ware_name1']==null?'':_modelList[index]['ware_name1'],'name2':_modelList[index]['ware_name2']==null?'':_modelList[index]['ware_name2'],'name3':_modelList[index]['ware_name3']==null?'':_modelList[index]['ware_name3'], 'id': _modelList[index]['sync_id']==null?'':_modelList[index]['sync_id'],'lk': 1});
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

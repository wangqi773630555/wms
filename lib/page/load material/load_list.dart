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

class MaterialLoadList extends StatefulWidget {
  const MaterialLoadList({Key? key}) : super(key: key);
  static const String sName = Config.Material_LoadList;

  @override
  State<MaterialLoadList> createState() => _MaterialLoadListState();
}

class _MaterialLoadListState extends State<MaterialLoadList> {
  bool _cirCular = false;
  int _pageNum = 1;
  late EasyRefreshController _easyfreshController;
  TextEditingController _searController = TextEditingController();
  late double _wwidth;
  late double _hheight;
  ScanResult? scanResult;

  List _modelList = [];
  List _allList = [];
  StreamSubscription? stream;
  getInintData() {
    DataDao.getLoadIndexList('').then((res) {
      setState(() {
        _searController.text = '';
        _modelList = res.data['data'];
        _allList.clear;
        _allList.addAll(_modelList);
        _cirCular = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('设备上料'),
          centerTitle: true,
          actions: [
            IconButton(
              // action button
              icon: Icon(Icons.center_focus_strong_rounded),
              onPressed: () async {
                await _scan();
                if (scanResult?.type != ResultType.Error) {
                  _getOrderInfoAndRecipeDataListByParas(scanResult?.rawContent);
                }
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
                    width: _wwidth - 14,
                    child: _listWidget(),
                  )
                ],
              )),
        ));
  }

  //通过标签id获取打印信息
  _getOrderInfoAndRecipeDataListByParas(var id) {
    print('标签id:$id');
    DataDao.getOrderInfoAndRecipeDataListByParas(id,null,null).then((res) {
      if (res != null && res.result) {
        setState(() {
          var data = res.data['data'];
          NavigatorUtils.goMaterialLoadProcess(context,data);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ScanConfig.scanPage = ScanConfig.PAGE_LOAD;
    stream = ScanEventUtils.eventBus.on<ScanEvent>().listen((event) {
      if (event.page ==  ScanConfig.PAGE_LOAD) {
        if(event.scanResult=='refresh') {
          print('refresh');
          _allList.clear();
          _modelList.clear();
          getInintData();
        }else {
          _getOrderInfoAndRecipeDataListByParas(event.scanResult);
        }
      }
    });

    _easyfreshController = EasyRefreshController();
    getInintData();
    print('initState_load_list');
  }


  Widget _searchRow() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10,bottom: 5),
      child:  SizedBox(
      height: 40.0,child: _searchWidget(),),
    );
  }

  Widget _searchWidget() {
    return TextField(
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
        hintText: '请输入订单号',

        // prefixIcon:
        //suffixIcon: Icon(Icons.search),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        print(value.toString()+"1111");
        print('${_allList.length}');
        setState(() {
          _modelList.clear();
          _allList.clear();
          for(int i=0;i<_allList.length;i++){
            if(_allList[i]['order_id'].toString().contains(value.toString())){
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
            onLoad: () async {
              setState(() {
                getInintData();
              });
              Future.delayed(Duration(milliseconds: 200), () {
                _easyfreshController.finishLoad(
                   // noMore: (_pageNum >= _modelList.length));
                    noMore: (true));
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
          );
  }

  //cell
  Widget _cellForRow(conttext, index) {
    return GestureDetector(child: Card(
      elevation: 1,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(flex: 1,child: Container(
                padding: EdgeInsets.only(left: 15, top: 5),
                child: Row(
                  children: [
                    Text(
                      '订单号:${_modelList[index]['order_id']}',
                      style:
                      TextStyle(fontSize: 18),
                      // showCursor: true,
                    ),
                  ],
                ),
              ),),

              Text(_modelList[index]['recipe_title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Padding(padding: EdgeInsets.all(5))
            ],
          ),
          Divider(),
          Container(
            child: Column(
              children: [
                _getRowText('物料号:', _modelList[index]['part_id']),
                _getRowText('物料名称:', _modelList[index]['part_name']),
                _getRowText('机台:', _modelList[index]['eqp_description']),
                _getRowText('上料数量:', _modelList[index]['release_qty']),
                _getRowText('上料批次:', _modelList[index]['part_batch']),
                _getRowText('上料时间:', _modelList[index]['add_time']),
                Padding(padding: EdgeInsets.all(5))
              ],
            ),
          ),
        ],
      ),
    ),
    onTap: () {
      var sendData = _modelList[index];
      sendData['uid'] = sendData['id'];
      sendData['id'] =sendData['recipe_id'];
      sendData['title'] =sendData['recipe_title'];
      sendData['code'] = sendData['material_bill_print_id'];
      NavigatorUtils.goMaterialLoadDetails1(context,sendData);
    },) ;
  }

  Widget _getRowText(String label, dynamic value) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: MiddleText(label, Alignment.centerLeft),
        ),
        Expanded(flex: 3, child: MiddleText(value, Alignment.centerRight)),
      ],
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
    ScanConfig.scanPage = "";
    if (stream != null) {
      stream?.cancel();
      stream = null;
    }
    print('dispose_load_list');
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

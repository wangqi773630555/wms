import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../../common/dao/data_dao.dart';

class SemiSearch extends StatefulWidget {

  final String? keyword;

  const SemiSearch({
    this.keyword,
  });
  @override
  _SemiSearchState createState() => _SemiSearchState();
}

class _SemiSearchState extends State<SemiSearch> {
  var keyword = '';
  var searchText ='';
  var listText ='';
  var _allData = [];
  var _po_noData = [];

  bool isShow = false;
  var query = '';
  bool isLoad = false; //防止load多次加载

  EasyRefreshController _easyController = EasyRefreshController();

  ScanResult? scanResult;

  var key;

  Future getLoadParas() async {
    var data = {
      keyword : query
    };

    if(query==''){
      _allData.clear();
      return;
    }
    var res =
        await DataDao.loadParas(data);
    if (res != null && res.result) {
      var _tempData = res.data;
      if ((_tempData["data"][listText])?.isNotEmpty) {
        if(listText=='prod_wo_list'){
          //处理订单
          _po_noData = _tempData["data"][listText];
          for (var item in _po_noData) {
            _allData.add(item['po_no']);
          }

        }else {
          _allData.addAll(_tempData["data"][listText]);
        }
      } else {
        Fluttertoast.showToast(msg: '暂无数据');
      }

      setState(() {
        isShow = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    keyword = widget.keyword!;
    if(keyword=='po_no'){
      searchText = '请输入订单信息';
      listText = 'prod_wo_list';
    }else if(keyword=='model'){
      searchText = '请输入型号信息';
      listText = 'models';
    }else if(keyword=='spec'){
      searchText = '请输入规格信息';
      listText = 'specs';
    }else if(keyword=='vol'){
      searchText = '请输入电压信息';
      listText = 'vols';
    }else if(keyword=='color'){
      searchText = '请输入颜色信息';
      listText = 'colors';
    }
    super.initState();
    getLoadParas();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(color: Colors.black87,child: Column(children: [
          Padding(padding: EdgeInsets.all(25)),
          _appBarSearch(),
          Padding(padding: EdgeInsets.all(5)),
        ],),),
        Expanded(
            flex: 1,
            child: EasyRefresh.custom(
              enableControlFinishRefresh: false,
              enableControlFinishLoad: false,
              controller: _easyController,
              header: ClassicalHeader(),
              footer: ClassicalFooter(),
              onRefresh: () async {
                print('onRefresh');
                _allData.clear();
                await getLoadParas();
                setState(() {});
                //没有更多后，刷新调用,不调用，刷新后就不能刷新了
                _easyController.resetLoadState();
              },
              onLoad: () async {
                print('onLoad');
                setState(() {});
                Future.delayed(Duration(milliseconds: 300), () {
                  _easyController.finishLoad(noMore: true);
                });
              },
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return !isShow && _allData.isEmpty
                          ? Container()
                          : InkWell(
                              onTap: () {
                                if( listText== 'prod_wo_list'){
                                  Navigator.pop(context, _po_noData[index]
                                  );
                                }else{
                                  Navigator.pop(context, _allData[index]
                                  );
                                }

                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Container(
                                              padding: const EdgeInsets.fromLTRB(20,10,20,10),
                                              child: Text(_allData[index] ?? ''))),
                                    ],
                                  ),
                                  Divider(
                                    height: 1,
                                  )
                                ],
                              ),
                            );
                    },
                    childCount: _allData.length,
                  ),
                ),
              ],
            ))
      ],
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _easyController.dispose();
  }

  _appBarSearch() {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: 5)),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 35,
          ),
        ),
        Padding(padding: EdgeInsets.all(5)),
        Expanded(
            flex: 5,
            child: SizedBox(
              height: 35,
              child: TextField(
                autofocus: true,
                style: TextStyle(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                  hintText: searchText,
                    suffixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    // 禁用状态边框
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)))),
                onChanged: (value) {
                  query = value;
                  _allData.clear();
                  isShow = false;
                  getLoadParas();
                },
                onSubmitted: (value) {
                  query = value;
                  _allData.clear();
                  isShow = false;
                  getLoadParas();
                },
              ),
            )),
        Padding(padding: EdgeInsets.only(left: 10)),
      ],
    );
  }
}

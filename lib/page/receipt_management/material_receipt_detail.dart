import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:wanma_print/page/receipt_management/dialogs/material_search_page.dart';
import 'package:wanma_print/page/receipt_management/dialogs/print_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../FlutterPlugins.dart';
import '../../common/config/config.dart';

import '../../common/dao/data_dao.dart';
import '../../widget/middle_text.dart';
// import '../../widget/search_page.dart';
import 'package:wanma_print/page/common_widgit/refresh/custom_refresh_footer.dart';
import 'package:wanma_print/page/common_widgit/refresh/custom_refresh_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../page/receipt_management/dialogs/my_dialog.dart';
// import '../repair/material_search_page.dart';

class MaterialReceiptDetail extends StatelessWidget {
  static const String sName = Config.MATERIAL_RECEIPT_DETAIL;
  const MaterialReceiptDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('材料收货单'),
      ),
      body: SingleChildScrollView(
        child: MaterialReceiptDetailBody(args),
      ),
    );
  }
}

class MaterialReceiptDetailBody extends StatefulWidget {
  final deliverNo;
  const MaterialReceiptDetailBody(this.deliverNo, {Key? key}) : super(key: key);
  @override
  State<MaterialReceiptDetailBody> createState() =>
      _MaterialReceiptDetailStateBody();
}

class _MaterialReceiptDetailStateBody extends State<MaterialReceiptDetailBody> {
  bool _cirCular = false;
  int _pageSize = 5;
  int _pageNum = 1;
  late EasyRefreshController _easyfreshController;
  late EasyRefreshController _easyfreshController2;
  TextEditingController _searController = TextEditingController();
  late double _wwidth;
  late double _hheight;
  var dyPageNum = 0;
  var dyWlNum = 0;
  final List<Map<String, dynamic>> _dataList = [];
  late Map _fhList;
  List _wlList = [];
  List _postList = [];
  initDatas(dev) {
    DataDao.getInfoByDeliverNo(dev).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        _fhList = data['head'];
        _postList = data['acc_details'];
        _wlList = data['part_details'];
        // _postList.add(data['acc_details'][0]);
        // _postList.add(data['acc_details'][0]);
        // _postList.add(data['acc_details'][0]);
        // _wlList.add(data['part_details'][0]);
        // _wlList.add(data['part_details'][0]);
        // _wlList.add(data['part_details'][0]);

        print('+++++++++++$_postList');
        // Fluttertoast.
        // Fluttertoast.showToast(msg: '取消成功');
      }
      _cirCular = true;
      setState(() {
        // getInintData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;
    return !_cirCular
        ? Center(
            child: CircularProgressIndicator(
              semanticsLabel: '加载中...',
            ),
          )
        : Container(
            color: Colors.white,
            child: Column(
              children: [
                // _searchRow(),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: _wwidth - 14,
                  height: 240,
                  child: _cardForfirst(),
                ),

                //====
                // Container(
                //   padding: EdgeInsets.only(left: 20, top: 5),
                //   width: _wwidth - 23,
                //   height: 35,
                //   color: Colors.white,
                //   child: Text(
                //     '过账详情',
                //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //   ),
                // ),
                // Container(
                //   width: _wwidth - 23,
                //   height: 0.5,
                //   color: Colors.grey,
                // ),
                _postList.length > 0
                    ? ExpansionTile(
                        textColor: Colors.black,
                        tilePadding: EdgeInsets.only(left: 30),
                        backgroundColor: Colors.white,
                        initiallyExpanded: true,
                        title: Text(
                          '过账详情',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          // _listWidget(_easyfreshController2, 'wlmx'),
                          SingleChildScrollView(
                              child: Container(
                            child: _listWidget(_easyfreshController2, 'gzxq'),
                            height: _postList.length * 180 > 400
                                ? 400
                                : _postList.length * 180,
                            width: _wwidth - 23,
                          ))
                        ],
                      )
                    : Container(),
                _wlList.length > 0
                    ? ExpansionTile(
                        textColor: Colors.black,
                        tilePadding: EdgeInsets.only(left: 30),
                        backgroundColor: Colors.white,
                        initiallyExpanded: true,
                        title: Text(
                          '物料明细',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          // _listWidget(_easyfreshController2, 'wlmx'),
                          SingleChildScrollView(
                              child: Container(
                            child: _listWidget(_easyfreshController2, 'wlmx'),
                            height: 400,
                            width: _wwidth - 23,
                          ))
                        ],
                      )
                    : Container()
                // Container(
                //   padding: EdgeInsets.only(left: 20, top: 5),
                //   width: _wwidth - 23,
                //   height: 35,
                //   color: Colors.white,
                //   child: Text(
                //     '物料明细',
                //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //   ),
                // ),
                // Container(
                //   width: _wwidth - 23,
                //   height: 0.5,
                //   color: Colors.grey,
                // ),
                // Container(
                //   color: Colors.white,
                //   height: _hheight - 626,
                //   width: _wwidth - 23,
                //   child: _listWidget(_easyfreshController2, 'wlmx'),
                // ),
              ],
            ));
    // ),

    ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDatas(widget.deliverNo);

    _easyfreshController = EasyRefreshController();
    _easyfreshController2 = EasyRefreshController();
  }

  Widget _searchRow() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      color: Colors.white,
      child: _searchWidget(),
    );
  }

  Widget _searchWidget() {
    return TextField(
      controller: _searController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        hintStyle:
            TextStyle(color: Color.fromARGB(179, 153, 149, 149), fontSize: 14),
        hintText: '点击进入查询页',
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.center_focus_strong_rounded),
        fillColor: Colors.white,
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        var result =
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MaterialSearchPage('0');
        }));

        var _devCode = result?[0] ?? '';
        print('++++3333###$_devCode#####');
        setState(() {
          initDatas(_devCode);
        });
      },
      onSubmitted: (text) {
        //内容提交(按回车)的回调
      },
    );
  }

  Widget _cardForfirst() {
    return Card(
      // elevation: 1,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                width: _wwidth - 120,
                child: Row(
                  children: [
                    Text(
                      '发货单号:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(_fhList['deliver_no'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
              _statusStyle(_fhList['status_text'] ?? ""),
            ],
          ),
          Divider(),
          _getRowText('供应商:', _fhList['supplier_name'] ?? ''),
          _getRowText('供应商编码:', _fhList['supplier_no'] ?? ''),
          _getRowText('内向交货单号:', _fhList['inbound_deliver_no'] ?? ""),
          _getRowText('送货日期:', _fhList['deliver_time'] ?? ''),
          _getRowText('订单号:', _fhList['order_no'] ?? ''),
        ],
      ),
    );
  }

  Widget _statusStyle(text) {
    Color textColor = Colors.black;
    Color bgColor = Colors.white;
    switch (text) {
      case '未过账':
        textColor = Color.fromARGB(255, 239, 119, 54);
        bgColor = Color.fromARGB(255, 246, 222, 188);
        break;
      case '部分过账':
        textColor = Color.fromARGB(255, 5, 152, 54);
        bgColor = Color.fromARGB(255, 209, 234, 211);
        break;

      case '已过帐':
        textColor = Color.fromARGB(255, 3, 117, 13);
        bgColor = Color.fromARGB(255, 195, 245, 205);
        break;
      case '已取消':
        textColor = Color.fromARGB(255, 63, 63, 62);
        bgColor = Color.fromARGB(255, 224, 221, 218);
        break;
      default:
        break;
    }
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 10),
      width: 80,
      height: 25,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.circular((20.0)),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }

//列表
  Widget _listWidget(easyfreshControllers, mark) {
    int num = 0;
    if (mark == 'wlmx') {
      num = _wlList.length;
    } else {
      num = _postList.length;
    }
    return EasyRefresh.custom(
      controller: easyfreshControllers,
      enableControlFinishRefresh: false,
      enableControlFinishLoad: true,
      header: CustomRefreshHeader(
          Colors.white, Colors.grey, Color.fromARGB(255, 244, 158, 54)),
      footer: CustomRefreshFooter(Colors.grey, Colors.grey),
      onRefresh: () async {
        // 控制器关闭刷新功能
        // _tempList.clear();
        // _pageNum = 1;
        // _pageSize = 5;
        // _params = {};
        // _deleteIds = [];
        // await _getRepairLst(_pageNum, _pageSize, _params);
        setState(() {});

        easyfreshControllers.resetLoadState();
      },
      onLoad: () async {
        setState(() {
          // if (_pageNum < _totalNUmber) {
          //   _pageNum++;
          //   _getRepairLst(_pageNum, _pageSize, _params);
          // }
        });

        Future.delayed(Duration(milliseconds: 200), () {
          easyfreshControllers.finishLoad(noMore: (_pageNum >= num));
        });
      },
      slivers: <Widget>[
        // 这里设置列表
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            // 这里为iOS UITableViewCell （android的adapter）,样式大家自定义即可
            return _cellForRow(context, index, mark);
          },
              // 设置返回数据个数

              childCount: num),
        ),
      ],
    );
  }

  //cell
  Widget _cellForRow(conttext, index, String mark) {
    return mark == 'wlmx'
        ? Card(
            color: Colors.white,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _getRowText('物料描述:', _wlList[index]['part_name'] ?? ''),
                _getRowText('数量:',
                    '${_wlList[index]['qty'] ?? ''}/${_wlList[index]['acc_qty'] ?? ''}${_wlList[index]['part_unit'] ?? ''}'),
                _getRowText('物料号:', _wlList[index]['part_id'] ?? ''),
                _getRowText('物料批次:', _wlList[index]['part_batch'] ?? ''),
                _getRowText('明细行:', _wlList[index]['detail_no'] ?? ''),
                ButtonTheme(
                  child: ButtonBar(
                    children: <Widget>[
                      _buttonStyle('打印', Colors.white, Colors.blue, 100, 20,
                          Colors.grey, 30, () async {
                        final prefs = await SharedPreferences.getInstance();
                        dyPageNum = 1;
                        // dyWlNum = 1;

                        double upNum = _wlList[index]['acc_qty'];
                        prefs.setDouble('wl', upNum);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return MyDialog(
                                title: "物料信息",
                                content: '单张物料',
                                title2: "打印张数",
                                flag: "dayin",
                                model: _fhList,
                                f: () {
                                  upNum = prefs.getDouble('wl')!;
                                  print('====$dyPageNum==+++++$upNum');
                                  String part_name =
                                      _wlList[index]['part_name'] ?? '';
                                  String part_id =
                                      _wlList[index]['part_id'] ?? '';
                                  String part_batch =
                                      _wlList[index]['part_batch'] ?? '';
                                  toPrint(part_name +
                                      ";" +
                                      part_id +
                                      ";" +
                                      part_batch +
                                      ";" +
                                      '${_wlList[index]['acc_qty'] ?? ''}' +
                                      ";" +
                                      '${dyPageNum}' +
                                      ";" +
                                      '${upNum}');
                                  Navigator.pop(context);
                                },
                                c1: (int c) {
                                  // upNum = c;
                                },
                                c2: (int c) {
                                  // upNum = c;
                                },
                                c3: (int c) {
                                  // upNum = c;
                                },
                                c11: (int c) {
                                  dyPageNum = c;
                                },
                                c22: (int c) {
                                  dyPageNum = c;
                                },
                                c33: (int c) {
                                  dyPageNum = c;
                                },
                                // f2: (String) {},
                                // dyzs: dyWlNum,
                                dyzs: dyPageNum, upDataNum: upNum,
                                // isClick: false,
                              );
                            });
                      }),
                    ],
                  ),
                )
              ],
            ),
          )
        : Card(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _getRowText('过账日期:', _postList[index]['post_date'] ?? ''),
                _getRowText('采购组织:', _postList[index]['ekotx'] ?? ''),
                _getRowText('凭证号:', _postList[index]['mblnr'] ?? ''),
                _getRowText('过账人:', _postList[index]['acc_user'] ?? ''),
                _getRowText('库位:', _postList[index]['ware_name'] ?? ''),
                _getRowText('操作实际时间:', _postList[index]['operate_time'] ?? ''),
              ],
            ),
          );
  }

  void toPrint(String result) {
    FlutterPlugins.print(result).then((value) => {setState(() {})});
  }

  Widget _buttonStyle(titles, Color bgColore, Color textColor, double ww,
      double rightWW, Color borderCorlor, double h, Function() f) {
    return Container(
      alignment: Alignment.center,
      width: ww,
      height: h,
      margin: EdgeInsets.only(right: rightWW, top: 5
          // left:
          ),
      child: InkWell(
        child: Text(
          titles,
          style: TextStyle(color: textColor, fontSize: 15),
          textAlign: TextAlign.center,
        ),
        onTap: f,
      ),
      decoration: BoxDecoration(
        color: bgColore,
        border: Border.all(width: 1, color: borderCorlor),
        borderRadius: new BorderRadius.circular((20.0)),
        boxShadow: [
          BoxShadow(
              color: bgColore,
              offset: Offset(0.5, 0.5),
              blurRadius: 1.0,
              spreadRadius: 1.0),
        ],
      ),
    );
  }

  Widget _getRowText(String label, dynamic value) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 3,
          child: MiddleText(label, Alignment.centerLeft),
        ),
        Expanded(flex: 3, child: MiddleText(value, Alignment.centerRight)),
      ],
    ));
  }

  // Widget backAndToNext() {
  //   return Container(
  //       width: _wwidth,
  //       height: 43,
  //       child: InkWell(
  //         child: Container(
  //           padding: EdgeInsets.only(left: 10),
  //           alignment: Alignment.center,
  //           color: Color.fromARGB(255, 33, 207, 39),
  //           child: Text('过 账',
  //               style: TextStyle(color: Colors.white, fontSize: 18)),
  //         ),
  //       ));
  // }

  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
    _easyfreshController2.dispose();
  }
}

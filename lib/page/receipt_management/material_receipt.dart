import 'package:flutter/material.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:wanma_print/page/receipt_management/dialogs/material_search_page.dart';
import '../../common/config/config.dart';
import '../../common/dao/data_dao.dart';
import '../../widget/middle_text.dart';
import 'package:wanma_print/page/common_widgit/refresh/custom_refresh_footer.dart';
import 'package:wanma_print/page/common_widgit/refresh/custom_refresh_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class MaterialReceipt extends StatefulWidget {
  const MaterialReceipt({Key? key}) : super(key: key);
  static const String sName = Config.MATERIAL_RECEIPT;

  @override
  State<MaterialReceipt> createState() => _MaterialReceiptState();
}

class _MaterialReceiptState extends State<MaterialReceipt> {
  bool _cirCular = false;
  int _pageNum = 1;
  // bool _isloading = true;
  late EasyRefreshController _easyfreshController;
  TextEditingController _searController = TextEditingController();
  late double _wwidth;
  late double _hheight;

  // final List<Map<String, dynamic>> _dataList = [];
  List _modelList = [];
  getInintData() {
    DataDao.getIndexList().then((res) {
      //
      // if (res != null && res.result) {
      //   var data = res.data['data'];

      //   if (data != null) {}
      // }
      _modelList = res;
      _cirCular = true;
      setState(() {});
    });
  }

  dataBillCancel(deliver_no) {
    // _cirCular = false;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('是否确定取消单据'),
            actions: [
              TextButton(
                child: Text("确定"),
                onPressed: () {
                  DataDao.getBillCancel(deliver_no).then((res) {
                    if (res != null && res.result) {
                      // Fluttertoast.
                      Fluttertoast.showToast(msg: '取消成功');
                    }
                    Navigator.pop(context);
                    setState(() {
                      getInintData();
                    });
                  });
                },
              ),
              TextButton(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('材料收货单'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.center_focus_strong_rounded),
              // Icons.qr_code_scanner_outlined,
              tooltip: 'Open shopping cart',
              onPressed: () async {
                // NavigatorUtils.goMaterialDetail(context, '');
                var result = await NavigatorUtils.goMaterialDetail(context, '');

                setState(() {
                  getInintData();
                });
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
                    height: _hheight - 180,
                    width: _wwidth - 14,
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
    _searController.text = '';
    getInintData();
    _easyfreshController = EasyRefreshController();
  }

  // back() {
  //   setState(() {
  //     getInintData();

  //   });
  // }

  Widget _searchRow() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      color: Colors.white,
      child: _searchWidget(),
    );
  }

  Widget _searchWidget() {
    return TextField(
      textAlign: TextAlign.center,
      controller: _searController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        hintStyle:
            TextStyle(color: Color.fromARGB(179, 153, 149, 149), fontSize: 14),
        hintText: '请输入发货单号',
        // prefixIcon:
        suffixIcon: Icon(Icons.search),
        fillColor: Colors.white,
      ),
      onSubmitted: (text) async {
        var result = await NavigatorUtils.goMaterialDetail(context, text);

        // print('**result******++++$result');
        setState(() {
          getInintData();
        });
        // NavigatorUtils.goMaterialDetail(context, text);
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
              // 控制器关闭刷新功能
              // _tempList.clear();
              // _pageNum = 1;
              // _pageSize = 5;
              // _params = {};
              // _deleteIds = [];
              // await _getRepairLst(_pageNum, _pageSize, _params);
              getInintData();
              setState(() {});
              _easyfreshController.resetLoadState();
            },
            onLoad: () async {
              setState(() {
                // if (_pageNum < _totalNUmber) {
                //   _pageNum++;
                //   _getRepairLst(_pageNum, _pageSize, _params);
                // }
                getInintData();
              });

              Future.delayed(Duration(milliseconds: 200), () {
                _easyfreshController.finishLoad(
                    noMore: (_pageNum >= _modelList.length));
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
    return Card(
      elevation: 1,
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
                      // showCursor: true,
                    ),
                    SelectableText(
                      _modelList[index]['deliver_no'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              _statusStyle(_modelList[index]['status_text']),
            ],
          ),
          Divider(),
          Container(
            child: Column(
              children: [
                _getRowText('供应商:', _modelList[index]['supplier_name']),
                _getRowText('供应商编码:', _modelList[index]['supplier_no']),
                _getRowText('内向交货单号:', _modelList[index]['inbound_deliver_no']),
                _getRowText('送货日期:', _modelList[index]['deliver_time']),
                _getRowText('订单号:', _modelList[index]['order_no']),
              ],
            ),
          ),
          Divider(),
          _modelList[index]['status_text'] == '已取消'
              ? Container()
              : ButtonTheme(
                  // make buttons use the appropriate styles for cards
                  child: ButtonBar(
                    children: <Widget>[
                      // _buttonStyle(, bgColore, textColor, ww, rightWW)
                      (_modelList[index]['status_text'] == '已取消' ||
                              _modelList[index]['status_text'] == '已过帐' ||
                              _modelList[index]['status_text'] == '部分过账')
                          ? Container()
                          : _buttonStyle('取消单据', Colors.white, Colors.blue, 100,
                              20, Colors.grey, 30, () {
                              _cirCular = false;
                              dataBillCancel(_modelList[index]['deliver_no']);
                            }),
                      _buttonStyle(
                          '查看详情',
                          Color.fromARGB(255, 209, 232, 251),
                          Color.fromARGB(255, 15, 86, 144),
                          100,
                          10,
                          Colors.white,
                          30, () {
                        //  ModalRoute.of(context)!.s
                        NavigatorUtils.goMaterialDetail(
                                context, _modelList[index]['deliver_no'])
                            .then((result) {
                          print('111111111111111');
                        });
                      })
                    ],
                  ),
                ),
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

  Widget _buttonStyle(titles, Color bgColore, Color textColor, double ww,
      double rightWW, Color borderCorlor, double h, Function() f) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 36,
      margin: EdgeInsets.only(
        right: rightWW,
        // left:
      ),
      child: TextButton(
        child: Text(
          titles,
          style: TextStyle(color: textColor, fontSize: 14),
          // textAlign: TextAlign.justify,
        ),
        onPressed: f,
      ),
      decoration: BoxDecoration(
        color: bgColore,
        border: Border.all(width: 1, color: borderCorlor),
        borderRadius: new BorderRadius.circular((18.0)),
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
          flex: 2,
          child: MiddleText(label, Alignment.centerLeft),
        ),
        Expanded(flex: 3, child: MiddleText(value, Alignment.centerRight)),
      ],
    ));
  }

  // Widget _getTextDetail() {
  //   return Column(children: [Text('data'), Text('data')]);
  //   // _dataList.map((e) => .toList());
  // }

  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
  }
}

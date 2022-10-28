import 'package:flutter/material.dart';
import 'package:wanma_print/page/receipt_management/dialogs/print_dialog.dart';
import '../../FlutterPlugins.dart';
import '../../common/config/config.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/dao/data_dao.dart';
import '../../widget/middle_text.dart';
import 'package:wanma_print/page/common_widgit/refresh/custom_refresh_footer.dart';
import 'package:wanma_print/page/common_widgit/refresh/custom_refresh_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../page/receipt_management/dialogs/my_dialog.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanma_print/page/common_widgit/select_list/select_item.dart';

import 'dialogs/material_search_page.dart';

class MaterialDetail extends StatelessWidget {
  static const String sName = Config.MATERIAL_DETAIL;
  const MaterialDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('报修单'),
        ),
        body: SingleChildScrollView(
          child: MaterialDetailBody(args),
        ));
  }
}

class MaterialDetailBody extends StatefulWidget {
  final deliverNo;
  const MaterialDetailBody(this.deliverNo, {Key? key}) : super(key: key);

  @override
  _MaterialDetailBodyState createState() => _MaterialDetailBodyState();
}

class _MaterialDetailBodyState extends State<MaterialDetailBody> {
  late EasyRefreshController _easyfreshController;
  TextEditingController _searController = TextEditingController();
  late double _wwidth;
  late double _hheight;
  late Map _fhList;
  bool _cirCular = false;
  int _pageNum = 1;
  var qtyCount = 0;
  var dyPageNum = 0;
  var dyWlNum = 0;
  List _wlList = [];
  List _selectList = [];
  List detail_ids_list = [];
  late List<SelectItem> _selectValueList = [];
  bool selectCell = false;
  var imgUrl = 'images/on.png';

  initDatas(dev) {
    DataDao.getInfoByDeliverNo(dev).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        _fhList = data['head'];

        _wlList = data['part_details'];
        _selectList = [];
        if (_selectList.length == 0) {
          for (var element in _wlList) {
            _selectList.add(false);
          }
        }
      }
      _cirCular = true;
      setState(() {});
    });
  }

  upDatas(wlId, qty) {
    DataDao.getUpdateQty(wlId, qty).then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        Navigator.pop(context);
        Fluttertoast.showToast(msg: '修改成功');
      }
      _cirCular = true;
      setState(() {});
    });
  }

  //过账
  postDatas(
      deliverNo, postDate, wareId, isUseForklift, isNeedUnloading, detailIds) {
    DataDao.getBillAcc(deliverNo, postDate, wareId, isUseForklift,
            isNeedUnloading, detailIds)
        .then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        Navigator.pop(context);
        NavigatorUtils.goMaterialReceiptDetail(context, _fhList['deliver_no']);
        Fluttertoast.showToast(msg: '执行成功');
      }
      _cirCular = true;
      setState(() {});
    });
  }

  wareListData() {
    _selectValueList = [];
    DataDao.getWareList().then((res) {
      if (res != null && res.result) {
        var data = res.data['data'];
        for (Map element in data) {
          _selectValueList.add(SelectItem(
              label: element['ware_name'], value: element['ware_id']));
        }
      } else {}
      _cirCular = true;
      setState(() {});
    });
  }

  postAlert() {
    NavigatorUtils.goMaterialReceiptDetail(context, _fhList['deliver_no']);

    detail_ids_list = [];
    for (var i = 0; i < _wlList.length; i++) {
      if (_selectList[i] == true) {
        detail_ids_list.add(_wlList[i]['id']);
      }
    }
    if (detail_ids_list.length > 0) {
      showDialog(
          context: context,
          builder: (context) {
            return PrintDialog(
              title: "修改信息",
              content: "",
              rowsNum: '',
              okBtnTap: () async {
                final prefs = await SharedPreferences.getInstance();
                String startTime = prefs.getString('time')!;

                String cc_flag = 'N';
                String zx_flag = 'N';
                // if (prefs.getBool('cc') != null) {
                if (prefs.getBool('cc') == false) {
                  cc_flag = 'N';
                } else {
                  cc_flag = "Y";
                }
                if (prefs.getBool('zx') == false) {
                  zx_flag = 'N';
                } else {
                  zx_flag = 'Y';
                }

                String ware_id_select = prefs.getString('kw')!;
                print('+++$ware_id_select++++++$cc_flag++$zx_flag++++');
                print('=====$detail_ids_list==+++__-$startTime-----3333####');
                if (_fhList['deliver_no'] == null ||
                    _fhList['deliver_no'] == '') {
                  Fluttertoast.showToast(msg: '发货单号为空');
                  return;
                }
                if (ware_id_select == '') {
                  Fluttertoast.showToast(msg: '库位号为空');
                  return;
                }

                postDatas(_fhList['deliver_no'], startTime, ware_id_select,
                    cc_flag, zx_flag, detail_ids_list);
              },
              selectValuesetList: _selectValueList,
              title2: '${detail_ids_list.length}',
            );
          });
    } else {
      Fluttertoast.showToast(msg: '请勾选相关物料');
    }
  }

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Container(
              height: _hheight - 145,
              child: Column(
                children: [
                  _searchRow(),
                  Container(
                    width: _wwidth - 14,
                    height: 200,
                    child: _cardForfirst(),
                  ),
                  _wlList.length > 0
                      ? Container(
                          padding: EdgeInsets.only(left: 20, top: 5),
                          width: _wwidth - 23,
                          height: 35,
                          color: Colors.white,
                          child: Text(
                            '物料明细',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(),
                  Container(
                    width: _wwidth - 23,
                    height: 0.5,
                    color: Colors.grey,
                  ),
                  _wlList.length > 0
                      ? Container(
                          color: Colors.white,
                          height: _hheight - 440,
                          width: _wwidth - 18,
                          child: _listWidget(),
                        )
                      : Container(),
                ],
              )),
          backAndToNext(),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDatas(widget.deliverNo);

    _easyfreshController = EasyRefreshController();
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
    return !_cirCular
        ? Center(
            child: CircularProgressIndicator(
              semanticsLabel: '加载中...',
            ),
          )
        : Card(
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
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
              setState(() {});
              _easyfreshController.resetLoadState();
            },
            onLoad: () async {
              setState(() {});

              Future.delayed(Duration(milliseconds: 200), () {
                _easyfreshController.finishLoad(
                    noMore: (_pageNum >= _wlList.length));
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
                    childCount: _wlList.length),
              ),
            ],
          );
  }

  //cell
  Widget _cellForRow(conttext, int index) {
    return !_cirCular
        ? Center(
            child: CircularProgressIndicator(
              semanticsLabel: '加载中...',
            ),
          )
        : Card(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 180,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        child: Checkbox(
                          value: _selectList[index],
                          activeColor: Color.fromARGB(255, 54, 244, 67),
                          onChanged: (value) {
                            setState(() {
                              _selectList[index] = value!;
                              print('value:--$value---');
                              print('_deleteIds---$_selectList');
                            });
                          },
                        ),
                      ),
                      Container(
                        height: 165,
                        width: 300,
                        child: Column(children: [
                          _getRowText(
                              '物料描述:', _wlList[index]['part_name'] ?? ''),
                          _getRowText('数量:',
                              '${_wlList[index]['qty'] ?? ''}/${_wlList[index]['sum_qty'] ?? ''}${_wlList[index]['part_unit'] ?? ''}'),
                          _getRowText('物料号:', _wlList[index]['part_id'] ?? ''),
                          _getRowText(
                              '物料批次:', _wlList[index]['part_batch'] ?? ''),
                          _getRowText(
                              '过账明细行:', _wlList[index]['detail_no'] ?? ''),
                        ]),
                      ),
                    ],
                  ),
                ),
                // Divider(),
                ButtonTheme(
                  child: ButtonBar(
                    children: <Widget>[
                      _buttonStyle('打印', Colors.white, Colors.blue, 100, 20,
                          Colors.grey, 30, () {
                        dyPageNum = 0;
                        dyWlNum = 0;
                        showDialog(
                            context: context,
                            builder: (context) {
                              return MyDialog(
                                title: "物料信息",
                                content: "打印张数",
                                title2: '单张物料',
                                flag: "dayin",
                                model: _fhList,
                                f: () {
                                  print('====$dyPageNum==+++++$dyWlNum');
                                  String part_name = _wlList[index]['part_name'] ?? '';
                                  String part_id =  _wlList[index]['part_id'] ?? '';
                                  String part_batch = _wlList[index]['part_batch'] ?? '';
                                  toPrint(part_name+";"+part_id+";"+part_batch+";"+'${_wlList[index]['qty'] ?? ''}'+";"+'${dyWlNum}'+";"+'${dyPageNum}');
                                  Navigator.pop(context);
                                },
                                c1: (int c) {
                                  dyPageNum = c;
                                },
                                c2: (int c) {
                                  dyPageNum = c;
                                },
                                c3: (int c) {
                                  dyPageNum = c;
                                },
                                c11: (int c) {
                                  dyWlNum = c;
                                },
                                c22: (int c) {
                                  dyWlNum = c;
                                },
                                c33: (int c) {
                                  dyWlNum = c;
                                },
                                // isClick: false,
                              );
                            });
                      }),
                      _buttonStyle(
                          '修改',
                          Color.fromARGB(255, 209, 232, 251),
                          Color.fromARGB(255, 15, 86, 144),
                          100,
                          10,
                          Colors.white,
                          30, () {
                        qtyCount = 0;
                        if (_fhList.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return MyDialog(
                                  title: "修改信息",
                                  content: "实际收货",
                                  model: _fhList,
                                  f: () {
                                    print('======+++++$qtyCount');

                                    upDatas('100003', qtyCount.toString());
                                  },
                                  c1: (c) {
                                    //++
                                    qtyCount = c;
                                  },
                                  c2: (c) {
                                    //--
                                    qtyCount = c;
                                  },
                                  c3: (c) {
                                    qtyCount = c;
                                  },
                                  c11: (int) {},
                                  c22: (int) {},
                                  c33: (int) {},
                                  // isClick: false,
                                );
                              });
                        }
                      })
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void toPrint(String result) {
    FlutterPlugins.print(result).then((value) => {
      setState(() {

      })
    });
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
  Widget backAndToNext() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 5),
        alignment: Alignment.center,
        // decoration: BoxDecoration(

        //   borderRadius: new BorderRadius.circular((10.0)),
        // ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 70, 215, 75),
          // border: Border.all(width: 1, color: borderCorlor),
          borderRadius: new BorderRadius.circular((20.0)),
        ),
        width: 250,
        height: 45,
        child: Text('过 账', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      onTap: () {
        wareListData();

        postAlert();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
  }
}

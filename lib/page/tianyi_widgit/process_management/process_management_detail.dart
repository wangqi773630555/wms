import 'package:flutter/material.dart';
import 'package:wanma_print/page/tianyi_widgit/process_management/s_header.dart';
import '../../../common/config/config.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/utils/common_utils.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../../../widget/loading.dart';

class ProcessManageMentDetail extends StatelessWidget {
  static final String sName = Config.PROCESS_MANAGEMENT_DETAIL;
  const ProcessManageMentDetail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('参数下置'),
          centerTitle: true,
        ),
        body: ProcessManageMentDetailBody(args));
  }
}

class ProcessManageMentDetailBody extends StatefulWidget {
  final idsList;
  const ProcessManageMentDetailBody(this.idsList, {Key? key}) : super(key: key);
  @override
  State<ProcessManageMentDetailBody> createState() =>
      _ProcessManageMentDetailBodyState();
}

class _ProcessManageMentDetailBodyState
    extends State<ProcessManageMentDetailBody> {
  ScanResult? scanResult;
  List<DropdownMenuItem<String>> _eqpIdItems = [];
  Map modelist = {};
  Map modelist2 = {};
  List productionList = [];
  List eqpIdItemsList = [];
  List keyList = [];
  List valueList = [];
  List textFieldList = [];
  List<Widget> celldList = [];
  List saveLs = [];
  // List ColorLs = [];
  // List bzhLs = [];//
  double hh = 0;
  bool ff = false;
  bool isCircle = false;
  bool isRed = false;
  var eqpIdValue;
  @override
  void initState() {
    super.initState();
    getDataBindEqps();
    getDataList();
  }

  getDataList() {
    DataDao.getCtProcessScanOrderId(306016).then((res) {
      if (res.data != null && res.data != '') {
        if (res.data['code'] == 351) {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: res.data['msg'].toString(), timeInSecForIosWeb: 5);
        } else {
          modelist = res.data['data'];
          productionList = modelist['recipes'];
        }
      }
      setState(() {});
    });
  }

  getDataBindEqps() {
    // print('__________${this.widget.idsList}');
    DataDao.getCtProcessBindEqps(this.widget.idsList[2], this.widget.idsList[3],
            this.widget.idsList[1])
        .then((res) {
      if (res.data != null && res.data != '') {
        if (res.data['code'] == 351) {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: res.data['msg'].toString(), timeInSecForIosWeb: 5);
        } else {
          eqpIdItemsList = res.data['data'];
          if (eqpIdItemsList.length > 0) {
            // for (var element in eqpIdItemsList) {
            _eqpIdItems = [];
            CommonUtils.renderDropdownMenuItem(
                eqpIdItemsList, _eqpIdItems, "description", "eqp_id");
            // }
            setState(() {
              eqpIdValue = eqpIdItemsList[0]['eqp_id'].toString();
              getEqpParas(int.parse(eqpIdValue));
            });
          }
        }
        setState(() {});
      }
    });
  }

  getEqpParas(eqp_id) {
    isCircle = true;
    DataDao.getCtProcessEqpParas(
            eqp_id, this.widget.idsList[2], this.widget.idsList[3])
        .then((res) {
      isCircle = false;
      setState(() {});
      if (res.data != null && res.data != '') {
        if (res.data['code'] == 351) {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: res.data['msg'].toString(), timeInSecForIosWeb: 5);
        } else {
          modelist2 = res.data['data']['设备参数'];
          keyList = [];
          valueList = [];
          saveLs = [];
          // ColorLs = [];
          textFieldList = [];
          keyList.addAll(modelist2.keys);
          valueList.addAll(modelist2.values);
          for (var element in valueList) {
            List sls = [];
            for (var element2 in element) {
              TextEditingController txtController = TextEditingController();
              txtController.text =
                  (element2['meter_para_standard'] ?? '').toString();
              sls.add(txtController);

              saveLs.add({
                'meter_para_standard': element2['meter_para_standard'] ?? '',
                'meter_para_standard2': element2['meter_para_standard'] ?? '',
                'meter_para_id': element2['id'],
                'meter_para_deviation': element2['meter_para_deviation'] ?? '',
                'para_desc': element2['para_desc'],
                'textFieldColorIsRed': 0
              });
              //  ColorLs.add(false);

            }
            textFieldList.add(sls);
          }
        }
      }
      setState(() {});
    });
  }

  getCtProcessSave(List ls) {
    List<Widget> isEmptyLs = [];
    List<Widget> isWarmLs = [];
    List paramLs = [];
    for (var i = 0; i < ls.length; i++) {
      paramLs.add({
        'meter_para_standard': ls[i]['meter_para_standard'],
        'meter_para_id': ls[i]['meter_para_id'],
      });
      if (ls[i]['meter_para_standard'] == '' ||
          ls[i]['meter_para_standard'] == null) {
        isEmptyLs.add(Text('${ls[i]['para_desc'].toString()}为空!'));
        setState(() {
          saveLs[i]['textFieldColorIsRed'] = 1;
        });
      } else {
        //输入框灰色
        setState(() {
          saveLs[i]['textFieldColorIsRed'] = 0;
        });
        if (ls[i]['meter_para_deviation'] != '' &&
            ls[i]['meter_para_deviation'] != null &&
            ls[i]['meter_para_standard2'] != '' &&
            ls[i]['meter_para_standard2'] != null) {
          // print('+++++++++++${element['meter_para_standard2']}');
          double top =
              ls[i]['meter_para_standard2'] + ls[i]['meter_para_deviation'];
          double down =
              ls[i]['meter_para_standard2'] - ls[i]['meter_para_deviation'];
          if (ls[i]['meter_para_standard'] > top ||
              ls[i]['meter_para_standard'] < down) {
            isWarmLs.add(Text('${ls[i]['para_desc'].toString()}'));
            setState(() {
              saveLs[i]['textFieldColorIsRed'] = 1;
            });
          } else {
            //输入框灰色色
            setState(() {
              saveLs[i]['textFieldColorIsRed'] = 0;
            });
          }
        }
      }
    }

    for (var element in saveLs) {
      print('#############${element['textFieldColorIsRed']}');
    }
    // var requestParams = {
    //   'order_id': this.widget.idsList[1],
    //   'ctProcessPartEqpParas': paramLs
    // };
    if (isEmptyLs.length > 0) {
      // setState(() {
      //   saveLs;
      // });
      showConfirmDialog(context, isEmptyLs, () {}, "提示");
    } else {
      if (isWarmLs.length > 0) {
        showConfirmDialog(context, isWarmLs, () {
          getsave(paramLs);
        }, "*以下参数不符合标准范围，是否确认下置？");
      } else {
        getsave(paramLs);
      }
    }

    print('===${this.widget.idsList[1]}=====ls$paramLs');

    // print('requestParams###$requestParams');
  }

  getsave(paramLs) {
//     Loading.show(context);
//  Loading.hide(context);
    DataDao.getCtProcessSave(this.widget.idsList[1], paramLs).then((res) {
      if (res.data != null && res.data != '') {
        if (res != null && res.result) {
          Fluttertoast.showToast(
              msg: res.data['msg'].toString(), timeInSecForIosWeb: 5);
          if (res.data['code'] == 200) {
            Navigator.pop(context);
          }
        }
      }
    });
  }

  void showConfirmDialog(
      BuildContext context, List<Widget> ls, Function confirmCallback, str) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text(
              str,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            content: ls.length > 0
                ? Container(
                    child: SingleChildScrollView(
                      child: Column(children: ls),
                    ),
                  )
                : Container(),
            actions: <Widget>[
              new TextButton(
                onPressed: () {
                  confirmCallback();
                  Navigator.of(context).pop();
                },
                child: new Text(
                  "确认",
                  style: TextStyle(color: Colors.blue, fontSize: 18),
                ),
              ),
              str != "提示"
                  ? new TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text(
                        "取消",
                        style: TextStyle(fontSize: 18),
                      ))
                  : Container(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var _wwidth = MediaQuery.of(context).size.width;
    var _hheight = MediaQuery.of(context).size.height;
    hh = _hheight;
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            width: _wwidth,
            height: _hheight - 140,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  child: SHeader(
                    _wwidth,
                    300,
                    true,
                    this.widget.idsList[1].toString(),
                    (value) {
                      setState(() {
                        ff = value;
                        (context as Element).markNeedsBuild();
                      });
                    },
                    modelist['customer_po'] ?? '',
                    modelist['part_name'] ?? '',
                    modelist['part_description'] ?? '',
                    modelist['order_no'].toString(),
                    modelist['bstkd_sap'] ?? '',
                    '7',
                    this.widget.idsList[0].toString(),
                  ),
                ),
                Divider(
                  height: 4,
                ),
                selectRow('生产机台', true, _eqpIdItems, _wwidth),
                isCircle == true
                    ? Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: '加载中...',
                          ),
                        ))
                    : listBlocks(context, _wwidth, _hheight),
              ],
            ))),
        saveButt(),
      ],
    ));
  }

  Widget selectRow(txt, isScan, items, w) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15),
      child: Row(
        children: [
          Container(
            width: 90,
            child: Text(
              txt,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: w - 90 - 65,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                items: items,
                value: eqpIdValue,
                elevation: 24,
                onChanged: (v) {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    eqpIdValue = v!;
                    getEqpParas(int.parse(eqpIdValue));
                    print(v);
                  });
                },
              ),
            ),
          ),
          isScan == true
              ? IconButton(
                  onPressed: () {
                    scanAction('生产机台');
                  },
                  icon: Icon(Icons.fit_screen_outlined))
              : Container()
        ],
      ),
    );
  }

  Future<void> _scan() async {
    scanResult = null;
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
      setState(() {
        scanResult = ScanResult(
            type: ResultType.Error,
            format: BarcodeFormat.unknown,
            rawContent: '00000000');
      });
    }
  }

  scanAction(txt) async {
    await _scan();
    Future.delayed(const Duration(milliseconds: 500), () {
      bool f = false;
      if (scanResult?.rawContent != "" && scanResult?.rawContent != null) {
        for (var element in eqpIdItemsList) {
          if (element['eqp_id'].toString() ==
              scanResult!.rawContent.toString()) {
            // print('+++++${element['eqp_id']}====${scanResult!.rawContent}');
            f = true;
            setState(() {
              eqpIdValue = scanResult!.rawContent.toString();
              getEqpParas(int.parse(eqpIdValue));
            });
          }
        }

        if (f == false) {
          Fluttertoast.showToast(
            msg: "${scanResult!.rawContent}不存在",
          );
          setState(() {
            eqpIdValue = '';
          });
        }
      }
      setState(() {});
    });
  }

  Widget blocks(w, tit, List ls, index) {
    celldList = [];
    int i = 0;
    for (var element in ls) {
      celldList.add(textCells(
          element['para_desc'].toString(),
          (element['meter_para_standard'] ?? '').toString(),
          w,
          element['id'],
          textFieldList[index][i],
          (element['meter_para_deviation'] ?? '').toString()));
      print('+++++===========${index + i + (index * i)}');
      i++;
    }
    return Stack(
      children: [
        Positioned(
            child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(top: 10, left: 15, right: 10, bottom: 10),
          alignment: Alignment(0, 0),
          width: w,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            border: new Border.all(
              width: 1,
            ),
          ),
          child: Column(children: celldList),
        )),
        Positioned(
            left: 20,
            child: Container(
              alignment: Alignment.center,
              width: 100,
              height: 30,
              color: Colors.white,
              child: Text(
                tit,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ))
      ],
    );
  }

  Widget listBlocks(BuildContext context, w, h) {
    return Container(
        width: w,
        height: ff == false ? h - 260 : h - 420,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return blocks(w, keyList[index], valueList[index], index);
          },
          itemCount: keyList.length,
        ));
  }

  Widget saveButt() {
    return InkWell(
      child: Container(
        width: 200,
        height: 40,
        alignment: Alignment.center,
        child: Text(
          "确认下置",
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onTap: () {
        print('===++++++++${saveLs.length}');
        // List ts = saveLs;
        getCtProcessSave(saveLs);
        // saveLs = ts;
      },
    );
  }

  Widget textCells(String label, dynamic values, w, ids, textController, txt) {
    var isRed;
    for (var element in saveLs) {
      if (element['para_desc'].toString() == label) {
        isRed = element['textFieldColorIsRed'];
      }
    }
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 0, top: 5),
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     width: 1,
            //     // color: Colors.red,
            //   ),
            //   borderRadius: BorderRadius.all(Radius.circular(0)),
            // ),
            width: w - 265,
            height: 40,
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: isRed == 1 ? Colors.red : Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: isRed == 1 ? Colors.red : Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                // border: new OutlineInputBorder(
                //
                //     borderSide: BorderSide(
                //         width: 1, color: Colors.red) //This is Ignored,
                //     ),
              ),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
              ],
              style: TextStyle(fontSize: 14),
              // decoration: InputDecoration(),
              onChanged: (String value) {
                for (var i = 0; i < saveLs.length; i++) {
                  if (saveLs[i]['meter_para_id'].toString() == ids.toString()) {
                    // print('val-----${saveLs[i]['meter_para_standard']}');
                    value == ''
                        ? saveLs[i]['meter_para_standard'] = ''
                        : saveLs[i]['meter_para_standard'] =
                            double.parse(value);
                  }
                }
              },
              onSubmitted: (String value) {
                for (var i = 0; i < saveLs.length; i++) {
                  if (saveLs[i]['meter_para_id'].toString() == ids.toString()) {
                    // print('val-----${saveLs[i]['meter_para_standard']}');
                    value == ''
                        ? saveLs[i]['meter_para_standard'] = ''
                        : saveLs[i]['meter_para_standard'] =
                            double.parse(value);

                    setState(() {
                      saveLs[i]['textFieldColorIsRed'] = 0;
                    });
                    if (saveLs[i]['meter_para_deviation'] != '' &&
                        saveLs[i]['meter_para_deviation'] != null &&
                        saveLs[i]['meter_para_standard2'] != '' &&
                        saveLs[i]['meter_para_standard2'] != null) {
                      // print('+++++++++++${element['meter_para_standard2']}');
                      double top = saveLs[i]['meter_para_standard2'] +
                          saveLs[i]['meter_para_deviation'];
                      double down = saveLs[i]['meter_para_standard2'] -
                          saveLs[i]['meter_para_deviation'];
                      if (saveLs[i]['meter_para_standard'] > top ||
                          saveLs[i]['meter_para_standard'] < down) {
                        setState(() {
                          saveLs[i]['textFieldColorIsRed'] = 1;
                          showConfirmDialog(
                              context,
                              [Text('参数【${saveLs[i]['para_desc']}】不符合标准范围')],
                              () {},
                              '提示');
                        });
                      } else {
                        //输入框灰色色
                        setState(() {
                          saveLs[i]['textFieldColorIsRed'] = 0;
                        });
                      }
                    }
                  }
                }
              },
            ),
          ),
          Container(
            // color: Colors.green,
            width: 30,
            height: 30,
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                // color: Colors.blue,
                width: 30,
                height: 10,
                child: Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
              ),
              Container(
                // color: Colors.yellow,
                margin: EdgeInsets.only(top: 0),
                width: 30,
                height: 10,
                child: Icon(
                  Icons.remove,
                  color: Colors.grey,
                ),
              )
            ]),
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            width: 80,
            child: Text(
              txt,
              style: TextStyle(color: Colors.grey),
            ),
            decoration: new BoxDecoration(
              // color: Colors.white,
              // borderRadius: BorderRadius.all(Radius.circular(25.0)),
              border: new Border.all(width: 1, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

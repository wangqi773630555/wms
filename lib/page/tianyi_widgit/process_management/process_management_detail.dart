import 'package:flutter/material.dart';
import 'package:wanma_print/page/tianyi_widgit/process_management/s_header.dart';

import '../../../common/config/config.dart';

import 'package:flutter/services.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/utils/common_utils.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

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
  // Map modelist = {};
  List productionList = [];
  List eqpIdItemsList = [];
  List keyList = [];
  List valueList = [];
  List textFieldList = [];
  List<Widget> celldList = [];
  List saveLs = [];
  double hh = 0;
  bool ff = true;
  // List<DropdownMenuItem<String>> _eqpIdItems = [];
  var eqpIdValue;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // print('-------');

    // print(this.widget.idsList[0]);
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
    DataDao.getCtProcessBindEqps(this.widget.idsList[2], this.widget.idsList[3])
        .then((res) {
      if (res.data != null && res.data != '') {
        if (res.data['code'] == 351) {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: res.data['msg'].toString(), timeInSecForIosWeb: 5);
        } else {
          eqpIdItemsList = res.data['data'];
          print('-----eqpIdItemsList--$eqpIdItemsList');
          if (eqpIdItemsList.length > 0) {
            for (var element in eqpIdItemsList) {
              _eqpIdItems = [];
              CommonUtils.renderDropdownMenuItem(
                  eqpIdItemsList, _eqpIdItems, "description", "eqp_id");
            }
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
    DataDao.getCtProcessEqpParas(
            eqp_id, this.widget.idsList[2], this.widget.idsList[3])
        .then((res) {
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
          textFieldList = [];
          //
          // FocusNode _focusNode = FocusNode();

          // textFieldList.add(txtController);
          keyList.addAll(modelist2.keys);
          valueList.addAll(modelist2.values);
          for (var element in valueList) {
            List sls = [];
            for (var element2 in element) {
              TextEditingController txtController = TextEditingController();
              //
              txtController.text =
                  (element2['meter_para_standard'] ?? '').toString();
              sls.add(txtController);
            }
            textFieldList.add(sls);
          }

          print('-keyList-----${textFieldList}');
          // productionList = modelist['recipes'];
        }
      }
      setState(() {});
    });
  }

  getCtProcessSave(ls) {
    var requestParams = {
      'order_id': this.widget.idsList[1],
      'ctProcessPartEqpParas': ls
    };
    print('requestParams###$requestParams');
    // DataDao.getCtProcessSave(this.widget.idsList[1], ls).then((res) {
    //   if (res.data != null && res.data != '') {
    //     if (res.data['code'] == 351) {
    //       Navigator.pop(context);
    //       Fluttertoast.showToast(
    //           msg: res.data['msg'].toString(), timeInSecForIosWeb: 5);
    //     }
    //     if (res.data['code'] == 200) {}
    //   }
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    // print('------');
    // print(this.widget.idsList);
    var _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    var _hheight = MediaQuery.of(context).size.height;
    hh = _hheight;
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            width: _wwidth,
            height: _hheight - 140,
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
                        // FocusScope.of(context).requestFocus(FocusNode());
                        ff = value;
                        // (context as Element).markNeedsBuild();
                      });

                      print('++++++++++%@$value');
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
                listBlocks(context, _wwidth, _hheight),
              ],
            )),
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
      // showAlert(scanResult!.rawContent);

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
          print('+++++2');
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
    // textFieldList = [];
    celldList = [];
    int i = 0;
    for (var element in ls) {
      saveLs.add({
        'meter_para_standard': element['meter_para_standard'],
        'meter_para_id': element['id']
      });
      // String str = ls.length.toString();
      celldList.add(textCells(
          element['para_desc'].toString(),
          (element['meter_para_standard'] ?? '').toString(),
          w,
          element['id'],
          textFieldList[index][i]));
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
    // setState(() {
    //               if (value == true) {
    //                 hh = _hheight;
    //               } else {
    //                 hh = _hheight - 300;
    //               }
    //
    //             });
    return Container(
        // color: Colors.cyan,
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
        // margin: e,
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
        // print('====save:$saveLs');
        getCtProcessSave(saveLs);
      },
    );
  }

  Widget textCells(String label, dynamic values, w, ids, textController) {
    // TextEditingController txtController;
    print('!!!!!!!!!!!!!!!!!!!!!!!!');
    // textController.text = values;
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
            decoration: BoxDecoration(
              border: Border.all(width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            width: w - 155,
            height: 40,
            child: TextField(
                controller: textController,
                textAlign: TextAlign.center,
                autofocus: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                ],
                // focusNode: _focusNode,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(),
                onChanged: (String value) {
                  //   txtController.value = TextEditingValue(
                  //       text: txtController.text,
                  //       selection: TextSelection.fromPosition(TextPosition(
                  //         affinity: TextAffinity.downstream,
                  //         offset: txtController.text.length,
                  //       )));
                  //   // },

                  //   // txtController.text = value;
                  //   for (var i = 0; i < saveLs.length; i++) {
                  //     if (saveLs[i]['meter_para_id'].toString() ==
                  //         ids.toString()) {
                  //       saveLs[i]['meter_para_standard'] =
                  //           int.parse(txtController.text);
                  //     }
                  //   }
                  // },

                  // onSubmitted: (String value) {
                  //   txtController.value = TextEditingValue(
                  //       text: txtController.text,
                  //       selection: TextSelection.fromPosition(TextPosition(
                  //         affinity: TextAffinity.downstream,
                  //         offset: txtController.text.length,
                  //       )));
                }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
//释放
    // _focusNode1.dispose();
  }
}

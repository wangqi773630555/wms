import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import 'package:wanma_print/widget/search_bar.dart';

import '../../../common/utils/navigator_utils.dart';

class MaterialSearchPage extends StatefulWidget {
  final pageMark;
  const MaterialSearchPage(this.pageMark, {Key? key}) : super(key: key);

  @override
  _MaterialSearchPageState createState() => _MaterialSearchPageState();
}

class _MaterialSearchPageState extends State<MaterialSearchPage> {
  bool isShow = false;
  var query = '';

  var _modelList;

  TextEditingController _controller = TextEditingController();
  EasyRefreshController _easyController = EasyRefreshController();

  ScanResult? scanResult;

  getInfoByDeliverNoData() {
    DataDao.getIndexList().then((res) {
      _modelList = res;
      print('=========+++++++++++$_modelList');
      setState(() {
        isShow = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _appBar(),
        Expanded(
          flex: 1,
          child: !isShow
              ? Container()
              : ListView.separated(
                  itemCount: _modelList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (widget.pageMark == '1') {
                          NavigatorUtils.goMaterialDetail(
                              context, _modelList[index]['deliver_no']);
                        } else {
                          Navigator.pop(
                              context, [_modelList[index]['deliver_no']]);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 3,
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                      _modelList[index]['deliver_no'] ?? ''))),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                    );
                  }),
        )
      ],
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _easyController.dispose();
    _controller.dispose();
  }

  _appBar() {
    _controller.selection = TextSelection.fromPosition(
        TextPosition(affinity: TextAffinity.downstream, offset: query.length));
    return Container(
      padding: EdgeInsets.only(top: 25),
      height: 80,
      decoration: BoxDecoration(color: Colors.white),
      child: SearchBar(
        controller: _controller,
        hint: '发货单号',
        onChanged: (text) {
          query = text;
        },
        onSubmitted: (text) {
          query = text;
          isShow = false;
          getInfoByDeliverNoData();
        },
        leftButtonClick: () {
          Navigator.pop(context);
        },
        rightButtonClick: () {
          isShow = false;
          getInfoByDeliverNoData();
        },
        // speakClick: () async {
        //   //扫码
        //   await _scan();
        //   if (scanResult?.type != ResultType.Error) {
        //     _controller.text = query = scanResult!.rawContent;
        //     isShow = false;
        //     getInfoByDeliverNoData();
        //     setState(() {});
        //   }
        // },
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
      scanResult = result;
    } on PlatformException catch (e) {
      scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: '00000000');
    }
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/config/config.dart';
import '../../../common/dao/data_dao.dart';
import 'common_widget/production_header.dart';

class SelectWork extends StatelessWidget {
  const SelectWork({Key? key}) : super(key: key);
  static final String sName = Config.SELECT_WORK;
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('选择报工工序'),
          centerTitle: true,
        ),
        body: SelectWorks(args));
  }
}

class SelectWorks extends StatefulWidget {
  final idsList;
  const SelectWorks(this.idsList, {Key? key}) : super(key: key);
  @override
  State<SelectWorks> createState() => _SelectWorkStates();
}

class _SelectWorkStates extends State<SelectWorks> {
  late double _wwidth;
  late double _hheight;
  Map modelist = {};
  List productionList = [];
  var pro_ids;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pro_ids = widget.idsList.toString();
    getData();
  }

  chuanlian() {
    if (productionList.length > 0) {
      var ids;
      for (var element in productionList) {
        if (element['title'] == '串联') {
          ids = element['id'];
        }
      }
      NavigatorUtils.goSeriesConnection(context, ids, pro_ids, '', false);
    }
  }

  duijiao() {
    if (productionList.length > 0) {
      var ids;
      for (var element in productionList) {
        if (element['title'] == '对绞') {
          ids = element['id'];
        }
      }
      NavigatorUtils.goTwistedPair(context, ids, pro_ids, '', false);
    }
  }

  chenglan() {
    if (productionList.length > 0) {}
    // NavigatorUtils.goTwistedPair(context);

    if (productionList.length > 0) {
      var ids;
      for (var element in productionList) {
        if (element['title'] == '成缆') {
          ids = element['id'];
        }
      }
      NavigatorUtils.goCabling(context, ids, pro_ids, '', false);
    }
    //  (context);
  }

  hutao() {
    if (productionList.length > 0) {}
    // NavigatorUtils.goTwistedPair(context);

    if (productionList.length > 0) {
      var ids;
      for (var element in productionList) {
        if (element['title'] == '护套') {
          ids = element['id'];
        }
      }
      NavigatorUtils.goSheath(context, ids, pro_ids, '', false);
    }
  }

  chengquan() {
    // NavigatorUtils.goTwistedPair(context);

    if (productionList.length > 0) {
      var ids;
      for (var element in productionList) {
        if (element['title'] == '成圈') {
          ids = element['id'];
        }
      }
      NavigatorUtils.goFormCircle(context, ids, pro_ids, '', false);
    }
  }

  getData() {
    DataDao.getSelectProduction(pro_ids).then((res) {
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

  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;
    // var idtxt =  ?? '';
    return SingleChildScrollView(
        child: Center(
      child: Column(children: [
        ProductionHeader(
            _wwidth,
            _hheight,
            true,
            modelist['id'].toString(),
            modelist['bstkd'] ?? '',
            modelist['part_name'] ?? '',
            modelist['part_description'] ?? '',
            modelist['order_no'].toString(),
            modelist['init_order_id'] ?? '',
            '',
            ''),
        Divider(
          color: Colors.white,
        ),
        rowForSelect('串联 报工', Color.fromARGB(255, 22, 55, 238),
            Color.fromARGB(255, 69, 94, 241), chuanlian),
        Divider(
          color: Colors.white,
        ),
        rowForSelect('对绞 报工', Color.fromARGB(223, 138, 116, 235),
            Color.fromARGB(223, 176, 162, 238), duijiao),
        Divider(
          color: Colors.white,
        ),
        rowForSelect('成缆 报工', Color.fromARGB(255, 22, 115, 127),
            Color.fromARGB(255, 57, 206, 225), chenglan),
        Divider(
          color: Colors.white,
        ),
        rowForSelect('护套 报工', Color.fromARGB(255, 198, 116, 213),
            Color.fromARGB(255, 212, 137, 225), hutao),
        Divider(
          color: Colors.white,
        ),
        rowForSelect('成圈 报工', Color.fromARGB(255, 44, 185, 224),
            Color.fromARGB(255, 91, 204, 235), chengquan),
      ]),
    ));

    // Scaffold(
    // 选择报工工序
  }

  Widget rowForSelect(name, backgroundColor, overlayColor, Function() f) {
    return TextButton(
        onPressed: f,
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(_wwidth - 40, 40)),
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            overlayColor: MaterialStateProperty.all(overlayColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))))),
        child: Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ));
  }
}

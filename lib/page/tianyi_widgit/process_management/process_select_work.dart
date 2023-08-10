import 'package:flutter/material.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/config/config.dart';
import '../../../common/dao/data_dao.dart';
import '../../tianyi_widgit/production_report/common_widget/production_header.dart';

class ProcessSelectWork extends StatelessWidget {
  const ProcessSelectWork({Key? key}) : super(key: key);
  static final String sName = Config.PROCESS_SELECT_WORK;
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('选择工艺管理工序'),
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
  var recipe_id;
  var part_id;
  var pro_ids;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pro_ids = widget.idsList;
    getData();
  }

  chuanlian() {
    if (productionList.length > 0) {
      var ids;
      for (var element in productionList) {
        if (element['recipe_title'] == '串联') {
          recipe_id = element['recipe_id'];
        }
      }

      print('++++++');
      print(recipe_id);
      print(pro_ids);
      print(modelist['part_id']);
      NavigatorUtils.goProgressManagementDetail(
          context, '串联', pro_ids, recipe_id, modelist['part_id'], false);
    }
  }

  hutao() {
    if (productionList.length > 0) {}
    // NavigatorUtils.goTwistedPair(context);

    if (productionList.length > 0) {
      var ids;
      for (var element in productionList) {
        if (element['recipe_title'] == '护套') {
          recipe_id = element['recipe_id'];
        }
      }
      NavigatorUtils.goProgressManagementDetail(
          context, '护套', pro_ids, recipe_id, modelist['part_id'], false);
    }
  }

  getData() {
    DataDao.getCtProcessScanOrderId(int.parse(pro_ids)).then((res) {
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
            modelist['customer_po'] ?? '',
            modelist['part_name'] ?? '',
            modelist['part_description'] ?? '',
            modelist['order_no'].toString(),
            modelist['bstkd_sap'] ?? '',
            '',
            ''),
        Divider(
          color: Colors.white,
        ),
        rowForSelect('串联工艺管理', Color.fromARGB(255, 22, 55, 238),
            Color.fromARGB(255, 69, 94, 241), chuanlian),
        Divider(
          color: Colors.white,
        ),
        rowForSelect('护套工艺管理', Color.fromARGB(255, 198, 116, 213),
            Color.fromARGB(255, 212, 137, 225), hutao),
        Divider(
          color: Colors.white,
        ),
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

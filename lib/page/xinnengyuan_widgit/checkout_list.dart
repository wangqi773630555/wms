import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import 'package:wanma_print/page/xinnengyuan_widgit/photo_list.dart';
import '../../../common/config/config.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../common/net/LogUtil.dart';
import '../../main.dart';
import '../common_widgit/refresh/custom_refresh_footer.dart';
import '../common_widgit/refresh/custom_refresh_header.dart';

/**
 * 检验单列表
 */
class CheckOutList extends StatefulWidget {
  const CheckOutList({Key? key}) : super(key: key);
  static const String sName = Config.CHECKOUTLIST;

  @override
  State<CheckOutList> createState() => _CheckOutListState();
}

class _CheckOutListState extends State<CheckOutList> with RouteAware{


  int position = 0;
  late EasyRefreshController _easyfreshController;
  late double _hheight;

  List _modelList = [];
  var _data;
  var _id;

  getInintData() {
   DataDao.sheetList(_id)
        .then((res) {
      setState(() {
        if (res != null && res.result) {
            _modelList.clear();
          var data = res.data['data'];
          _modelList.addAll(data);
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('检验单列表'),
        centerTitle: true,
        actions: [
        ],
      ),
      body: Container(
          color: Color.fromARGB(255, 236, 243, 250),
          child: Column(
            children: [
              _titleView(),
              Expanded(child:  Container(
                // color: Color.fromARGB(111, 236, 243, 100),
                height: _hheight - 135,
                child: EasyRefresh.custom(
                  controller: _easyfreshController,
                  enableControlFinishRefresh: false,
                  enableControlFinishLoad: true,
                  header: CustomRefreshHeader(Colors.white, Colors.grey,
                      Color.fromARGB(255, 244, 158, 54)),
                  footer: CustomRefreshFooter(Colors.grey, Colors.grey),
                  onRefresh: () async {
                    getInintData();
                    setState(() {});
                    _easyfreshController.resetLoadState();
                  },
                  onLoad: () async {
                    getInintData();
                    Future.delayed(Duration(milliseconds: 200), () {
                      _easyfreshController.finishLoad(noMore: true);
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
                ),
              ),)
            ],
          )),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _easyfreshController = EasyRefreshController();

    Future.delayed(Duration.zero, () async {
      _data = ModalRoute.of(context)!.settings.arguments;
      setState(() {
        _id = _data['id'];
        getInintData();
      });
    });

  }


  Widget _cellForRow(conttext, index) {
    return GestureDetector(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child:  Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black54, // 描边的颜色
                  width: 0.5, // 描边的宽度
                ),
              ),
              child: Text(
                _modelList[index]['typeTitle'],
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child:  Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black54, // 描边的颜色
                  width: 0.5, // 描边的宽度
                ),
              ),
              child: Text(
                (_modelList[index]['typeTitle']??'')+'-'+(_modelList[index]['col01']??''),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child:  Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black54, // 描边的颜色
                  width: 0.5, // 描边的宽度
                ),
              ),
              child: TextButton(onPressed: () {
                var result = Navigator.pushNamed(context, PhotoList.sName,
                    arguments: {'id': _modelList[index]['id'],'col02':_modelList[index]['col02']});
                result.then((dynamic value) {
                  if (value != null && value == '1') {
                    setState(() {
                      getInintData();
                    });
                  }
                });
              }, child: Text(
                '上传照片',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),)
            ),
          ),

        ],
      ),
    );
  }


  Widget _titleView() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child:  Container(
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.black, // 描边的颜色
                width: 0.5, // 描边的宽度
              ),
            ),
            child: Text(
              '检验类型',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child:  Container(
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.black, // 描边的颜色
                width: 0.5, // 描边的宽度
              ),
            ),
            child: Text(
              '检验单名称',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child:  Container(
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.black, // 描边的颜色
                width: 0.5, // 描边的宽度
              ),
            ),
            child: Text(
              '质检操作',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),

      ],
    );
  }


  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
    routeObserver.unsubscribe(this);
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    LogUtil.d('onResumeCheckList');
    getInintData();
    super.didPopNext();
  }
}

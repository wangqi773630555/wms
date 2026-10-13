import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/page/dianlan_widgit/semi_finished_check_edit.dart';
import '../../../common/config/config.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../common/dao/data_dao.dart';
import '../common_widgit/refresh/custom_refresh_footer.dart';
import '../common_widgit/refresh/custom_refresh_header.dart';

/**
 * 盘库列表
 */
class SemiList extends StatefulWidget {
  const SemiList({Key? key}) : super(key: key);
  static const String sName = Config.SEMI_LIST;

  @override
  State<SemiList> createState() => _SemiListState();
}

class _SemiListState extends State<SemiList> {
  late EasyRefreshController _easyfreshController;
  TextEditingController _searController = TextEditingController();

  List _modelList = [];

  bool _hasMore = true;
  var startTime;
  late double _hheight;

  /**
   * 获取数据
   */
  getInintData() {
    startTime =  new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString().substring(0, 10);
    DataDao.getSemisList(_searController.text.toString(),startTime).then((res) {
      setState(() {
        if (res != null && res.result) {
          var data = res.data['data'];
          _modelList.clear();
          _modelList.addAll(data['list']);

        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    _hheight = MediaQuery.of(context).size.height;
    // ignore: non_constant_identifier_names
    return Scaffold(
        appBar: AppBar(
          title: Text('盘库记录'),
          centerTitle: true,
            actions: <Widget>[]
        ),
      body: SingleChildScrollView(
        child: Container(
            color: Color.fromARGB(255, 236, 243, 250),
            child: Column(
              children: [
                _searchWidget(),
                Divider(
                  height: 1,
                ),
                Container(
                  // color: Color.fromARGB(111, 236, 243, 100),
                  height: _hheight - 100,
                  child: EasyRefresh.custom(
                    controller: _easyfreshController,
                    enableControlFinishRefresh: false,
                    enableControlFinishLoad: true,
                    header: CustomRefreshHeader(
                        Colors.white, Colors.grey, Color.fromARGB(255, 244, 158, 54)),
                    footer: CustomRefreshFooter(Colors.grey, Colors.grey),
                    onRefresh: () async {
                      getInintData();
                      setState(() {});
                      _easyfreshController.resetLoadState();
                    },
                    onLoad: () async {
                      Future.delayed(Duration(milliseconds: 200), () {
                        _easyfreshController.finishLoad(noMore: _hasMore);
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
                ),
              ],
            )),
      ),
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    _easyfreshController = EasyRefreshController();
    super.initState();
    getInintData();
  }

  Widget _searchWidget() {
    return TextField(
      controller: _searController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.all(5),
        enabledBorder: OutlineInputBorder(
          /*边角*/
          borderRadius: BorderRadius.all(
            Radius.circular(5), //边角为5
          ),
          borderSide: BorderSide(
            color: Colors.white, //边线颜色为白色
            width: 1, //边线宽度为2
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white, //边框颜色为白色
            width: 1, //宽度为5
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5), //边角为30
          ),
        ),
        hintText: '请输入搜索内容',

        // prefixIcon:
        //suffixIcon: Icon(Icons.search),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        setState(() {
          getInintData();
        });
      },
    );
  }


  Widget _cellForRow(conttext, index) {

      return GestureDetector(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Text(
                    '${_modelList[index]['part_name']??''}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),

                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Text(
                    '${_modelList[index]['po_no']??''}-${_modelList[index]['zpronumber']??''}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),

                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Text(
                    '扫描时间：${_modelList[index]['add_time']??''}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black
                    ),
                  ),

                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Text(
                    '数量：${_modelList[index]['qty']??''}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black
                    ),
                  ),

                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(),
            ],
          ),
        ),onTap: () {
        //var result = Navigator.pushNamed(context, SemiFinishedCheckEdit.sName, arguments: '1782745664398218');
        var result = Navigator.pushNamed(context, SemiFinishedCheckEdit.sName, arguments: _modelList[index]['id']);
        result.then((value) => {
            getInintData()
        });
        },
      );
  }



  @override
  void dispose() {
    super.dispose();
    _easyfreshController.dispose();
  }
}

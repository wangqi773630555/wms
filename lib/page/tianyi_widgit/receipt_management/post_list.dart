import 'package:flutter/material.dart';

import '../../../widget/middle_text.dart';

class PostList extends StatefulWidget {
  final List modelList;
  PostList({
    required this.modelList,
  });

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late double _wwidth;
  late double _hheight;

  @override
  Widget build(BuildContext context) {
    _wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    _hheight = MediaQuery.of(context).size.height;

    print('++++++_____*****${widget.modelList}');
    return Material(
      type: MaterialType.transparency,
      child: Center(
          child: Container(
              width: _wwidth - 20,
              height: _hheight - 100,
              color: Colors.white,
              child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 15),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '过账详情',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: Icon(Icons.close),
                          onTap: () {
                            // widget.okBtnTap!();

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  width: _wwidth - 20,
                  height: _hheight - 180,
                  child: ListView.builder(
                    itemCount: widget.modelList.length,
                    itemBuilder: (context, index) {
                      return cellForRow(context, index);
                    },
                  ),
                )
              ]))),
    );
  }

  Widget cellForRow(context, index) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _getRowText('过账日期:', widget.modelList[index]['post_date'] ?? ''),
          _getRowText('采购组织:', widget.modelList[index]['ekotx'] ?? ''),
          _getRowText('凭证号:', widget.modelList[index]['mblnr'] ?? ''),
          _getRowText('过账人:', widget.modelList[index]['acc_user'] ?? ''),
          _getRowText('库位:', widget.modelList[index]['ware_name'] ?? ''),
          _getRowText('操作实际时间:', widget.modelList[index]['operate_time'] ?? ''),
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
}

import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:bruno/bruno.dart';

typedef _AddCallBack = void Function(
  int selectIndex,
);
typedef _MzeCallBack = void Function(
  int selectIndex,
);
typedef _EnterDelete = void Function(
  int selectIndex,
);

class CounterPage extends StatefulWidget {
  /// 默认数
  final int count;

  /// 是否显示删除提示框
  final bool isShowDialog;

  /// 允许最大数量
  final int maxCount;

  /// 点击加号的回调方法
  final _AddCallBack addCallBack;

  /// 点击减号的回调方法
  final _MzeCallBack mzeCallBack;

  /// 点击提示框删除的回调方法
  final _EnterDelete enterDelete;

  const CounterPage(
      {Key? key,
      this.count = 0,
      required this.addCallBack,
      required this.mzeCallBack,
      required this.enterDelete,
      this.isShowDialog = true,
      this.maxCount = 1000000})
      : super(key: key);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  late int count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // color: Colors.red,
      child: Row(
        children: [
          Container(
            // width: 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 9),
            child: IconButton(
              onPressed: () {
                if (count == 0) {
                  // if (widget.isShowDialog == true) {
                  //   BrnDialogManager.showConfirmDialog(context,
                  //       cancel: '取消',
                  //       confirm: '确定',
                  //       message: '确定要删除',
                  //       title: '温馨提示', onCancel: () {
                  //     Navigator.of(context).pop();
                  //   }, onConfirm: () {
                  //     widget.enterDelete(count);
                  //     Navigator.of(context).pop();
                  //   });
                  // }
                  // count == 0;
                  return;
                } else {
                  count--;
                }
                widget.mzeCallBack(
                  count,
                );

                setState(() {});
              },
              icon: const Icon(Icons.minimize_rounded),
              iconSize: 30,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 35,
            alignment: Alignment.center,
            width: 100,
            color: Colors.grey.shade200,
            child: Text(
              '$count',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            onPressed: () {
              if (count == widget.maxCount) {
                return;
              }

              print(count);
              if (count < widget.maxCount) {
                count++;
              }
              widget.addCallBack(count);
              setState(() {});
            },
            icon: const Icon(Icons.add_rounded),
            iconSize: 30,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

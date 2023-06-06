import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef _AddCallBack = void Function(
  double selectIndex,
);
typedef _MzeCallBack = void Function(
  double selectIndex,
);
typedef _EnterDelete = void Function(
  double selectIndex,
);
final TextEditingController textController = TextEditingController();

class CountDouble extends StatefulWidget {
  /// 默认数
  final double count;
  final bool isClick;

  /// 是否显示删除提示框
  final bool isShowDialog;

  /// 允许最大数量
  final double maxCount;

  /// 点击加号的回调方法
  final _AddCallBack addCallBack;

  /// 点击减号的回调方法
  final _MzeCallBack mzeCallBack;

  /// 点击提示框删除的回调方法
  final _EnterDelete enterDelete;

  const CountDouble(
      {Key? key,
      required this.count,
      this.isClick = false,
      required this.addCallBack,
      required this.mzeCallBack,
      required this.enterDelete,
      this.isShowDialog = true,
      this.maxCount = 1000000})
      : super(key: key);

  @override
  _CountDoubleState createState() => _CountDoubleState();
}

class _CountDoubleState extends State<CountDouble> {
  late double count;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    print('===================${widget.count}');
    // count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    textController.text = count.toString();
    return Container(
      alignment: Alignment.center,
      // color: Colors.red,
      child: Row(
        children: [
          Container(
            // width: 100,
            alignment: Alignment.center,
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
              icon: const Icon(Icons.indeterminate_check_box),
              iconSize: 30,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 35,
            alignment: Alignment.center,
            width: 100,
            color: Colors.grey.shade200,
            child: CupertinoTextField(
              // keyboardType: TextInputType.number,
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: textController.text,
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '$count'.length)))),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey, width: 0.3),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              onChanged: (text) {
                setState(() {
                  count = double.parse(text);
                  textController.text = '$count';
                  widget.addCallBack(count);
                });
              },
              textAlign: TextAlign.center,
              autofocus: false,
              cursorColor: Colors.green,
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
              setState(() {
                // widget.isClick = true;
              });
            },
            icon: const Icon(Icons.add_box),
            iconSize: 30,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

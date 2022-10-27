import 'package:wanma_print/page/common_widgit/select_list/select_item.dart';
import 'package:flutter/material.dart';

/// 弹出菜单按钮组件
class SelectWidget extends StatefulWidget {
  final List<SelectItem> items; // 显示的内容
  final dynamic value; // 当前选中的值
  final String? title; // 选择框前的标题
  final String tooltip; // 提示语
  final double? selectWidth;
  final double leftPosition;
  final ValueChanged<dynamic>? valueChanged; // 选中数据的回调事件
  const SelectWidget(
      {Key? key,
      this.items = const [],
      this.value,
      this.valueChanged,
      this.title,
      required this.leftPosition,
      this.selectWidth,
      this.tooltip = "点击选择"})
      : super(key: key);

  @override
  State<SelectWidget> createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {
  String label = '请选择';
  bool isExpand = false; // 是否展开下拉按钮
  dynamic currentValue; // 此时的值

  @override
  void initState() {
    // initTitle();
    currentValue = widget.value;
    // label = widget.items[0].label;
    print('value==${widget.value}');
    super.initState();
  }

  /// 根据当前的value处理当前文本显示
  void initTitle() {
    if (currentValue != null) {
      // 有值查值
      for (SelectItem item in widget.items) {
        if (item.value == currentValue) {
          label = item.label;
          // print('item.label${item.label}');
          break;
        }
      }
    }
    //  else {
    //   // 没值默认取第一个
    //   if (widget.items.isNotEmpty) {
    //     label = widget.items[0].label;
    //     // print('widget.items[0].value${widget.items[0].value}');
    //     // print('widget.items[0].label${widget.items[0].label}');
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    initTitle();
    return Wrap(
      children: [
        if (widget.title != null)
          Text(widget.title!, style: TextStyle(fontSize: 14)),
        PopupMenuButton<String>(
          // initialValue: currentValue,
          tooltip: widget.tooltip,
          offset: Offset(25, 25),
          enableFeedback: true,
          child: Listener(
            // 使用listener事件能够继续传递
            onPointerDown: (event) {
              setState(() {
                isExpand = !isExpand;
              });
            },
            child: Wrap(
              children: [
                Container(
                    width: widget.selectWidth,
                    padding: EdgeInsets.only(left: widget.leftPosition),
                    child: Column(
                      children: [
                        Text(
                          label,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          onSelected: (value) {
            widget.valueChanged?.call(value);
            setState(() {
              currentValue = value;
              isExpand = !isExpand;
            });
          },
          onCanceled: () {
            // 取消展开
            setState(() {
              isExpand = false;
            });
          },
          itemBuilder: (context) {
            return widget.items
                .map(
                  (item) => item.value == currentValue
                      ? PopupMenuItem<String>(
                          value: item.value,
                          child: Text(
                            item.label,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      : PopupMenuItem<String>(
                          value: item.value,
                          child: Text(item.label),
                        ),
                )
                .toList();
          },
        )
      ],
    );
  }
}

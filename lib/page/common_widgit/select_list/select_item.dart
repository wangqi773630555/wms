class SelectItem {
  String label; // 显示的文本
  dynamic value; // 选中的值
  bool checked; // 是否选中

  SelectItem({this.label = '', this.value, this.checked = false});
}

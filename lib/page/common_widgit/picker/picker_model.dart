
class PickerModel {
  late int id;
  late String title;
  late String sync_id;
  late int lk;
  late List<PickerModel> children;

  static PickerModel fromMap(Map<String, dynamic> map) {
    PickerModel invoiceAreaBean = PickerModel();
    invoiceAreaBean.id = map['id'];
    invoiceAreaBean.title = map['title'];
    invoiceAreaBean.sync_id = map['sync_id'];
    invoiceAreaBean.lk = map['lk'];
    invoiceAreaBean.children = []..addAll(
        (map['children'] as List ?? []).map((o) => PickerModel.fromMap(o))
    );
    return invoiceAreaBean;
  }

 /* Map toJson() => {
    "id": id,
    "name": name,
    "childs": childs,
  };*/
}


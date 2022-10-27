import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanma_print/common/config/config.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import 'package:wanma_print/common/local/local_storage.dart';
import 'package:wanma_print/common/utils/common_utils.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';

class GridItemWidget extends StatelessWidget {
  final String? text;
  final String? functionName;
  final String? mid;
  final IconData? icon;

  GridItemWidget({Key? key, this.text, this.functionName, this.mid, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CommonUtils.renderTab(icon, text,
          size: 35.0, color: Theme.of(context).primaryColor),
      onTap: () async {
        switch (functionName) {
          case 'goHomeGfz':
            await LocalStorage.save(Config.MODULE_CATEGORY, 'wmgfzandroid');

            var userName = await LocalStorage.get(Config.USER_NAME_KEY);
            var password = await LocalStorage.get(Config.PW_KEY);
            DataDao.getAuthority(userName, password);
            break;
          // case Config.NEW_REPAIR_ORDER:
          //   await LocalStorage.save(Config.FLAG_REPAIR_MODIFY, '0');
          //   NavigatorUtils.goNewRepairOrder(context);
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return MyApp();
          // }));
          // break;
          case Config.MATERIAL_RECEIPT:
            //拍照权限
            // bool isCamera = await CommonUtils.checkPermissionCamera();
            // if (!isCamera) {
            //   Fluttertoast.showToast(msg: '没有拍照权限');
            //   return;
            // }

            var sk = await LocalStorage.get(Config.SET_KEY);

            if (sk != null && sk != '') {
              NavigatorUtils.goMaterialReceipt(context);
            } else {
              Fluttertoast.showToast(msg: '请设置参数');
            }

            break;
          // case Config.NEW_REPORT_ORDER:
          //   await LocalStorage.save(Config.FLAG_REPORT_MODIFY, '0');
          //   NavigatorUtils.goNewReportOrder(context);
          //   break;
          // case Config.EQUIPMENT_LIST:
          //   NavigatorUtils.goEquipmentList(context);
          //   break;
          // case Config.REPAIR_LIST:
          //   NavigatorUtils.goRepairList(context);
          //   break;
          // case Config.MATERIAL_RECEIPT:
          //   NavigatorUtils.goMaterialReceipt(context);
          //   break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('暂未开通')));
            break;
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wanma_print/page/app.dart';
import '../../page/login_page.dart';
import '../../page/param_setting.dart';
import '../../page/receipt_management/material_detail.dart';
import '../../page/receipt_management/material_receipt.dart';
import '../../page/receipt_management/material_receipt_detail.dart';
import '../../page/update_pwd.dart';
//========

///导航栏
class NavigatorUtils {
  ///登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }

  ///主页
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, App.sName);
  }

  ///跳转到登录，关闭所有界面
  static exitToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.sName, (route) => false);
  }

  //新增end
  ///修改密码
  static goUpdatePwd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdatePwd(),
      ),
    );
  }

  ///设置参数
  static goParamSetting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParamSetting(),
      ),
    );
  }

  static goMaterialReceipt(BuildContext context) {
    Navigator.pushNamed(context, MaterialReceipt.sName);
  }

  static goMaterialDetail(BuildContext context, deliverNo) {
    Navigator.pushNamed(context, MaterialDetail.sName, arguments: deliverNo);
  }

  static goMaterialReceiptDetail(BuildContext context, deliverNo) {
    Navigator.pushNamed(context, MaterialReceiptDetail.sName,
        arguments: deliverNo);
  }
}

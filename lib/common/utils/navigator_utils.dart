import 'package:flutter/material.dart';
import 'package:wanma_print/page/app.dart';
import 'package:wanma_print/page/frame_widgit/main_page.dart';
import 'package:wanma_print/page/frame_widgit/mine/account_security_page.dart';
import 'package:wanma_print/page/frame_widgit/mine/change_password_page.dart';
import 'package:wanma_print/page/frame_widgit/mine/change_work_page.dart';
import 'package:wanma_print/page/print_page.dart';

import '../../page/login_page.dart';
import '../../page/frame_widgit/menu_page.dart';
import '../../page/param_setting.dart';
import '../../page/tianyi_widgit/load material/load_details.dart';
import '../../page/tianyi_widgit/load material/load_list.dart';
import '../../page/tianyi_widgit/load material/load_process.dart';
import '../../page/tianyi_widgit/production_report/cabling.dart';
import '../../page/tianyi_widgit/production_report/form_circle.dart';
import '../../page/tianyi_widgit/production_report/production_report.dart';
import '../../page/tianyi_widgit/production_report/select_work.dart';
import '../../page/tianyi_widgit/production_report/series_connection.dart';
import '../../page/tianyi_widgit/production_report/sheath.dart';
import '../../page/tianyi_widgit/production_report/twisted_pair.dart';
import '../../page/tianyi_widgit/receipt_management/material_detail.dart';
import '../../page/tianyi_widgit/receipt_management/material_receipt.dart';
import '../../page/tianyi_widgit/receipt_management/material_receipt_detail.dart';
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

  //公用路由
  static goPage(BuildContext context,String route) {
    Navigator.pushNamed(context, route);
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

  static goMaterialDetail(BuildContext context, deliverNo) async {
    await Navigator.pushNamed(context, MaterialDetail.sName,
        arguments: deliverNo);
  }

  static goMaterialReceiptDetail(BuildContext context, deliverNo) {
    Navigator.pushNamed(context, MaterialReceiptDetail.sName,
        arguments: deliverNo);
  }

  static goMaterialPrint(BuildContext context) {
    Navigator.pushNamed(context, ToPrint.sName);
  }

  // static goTaskList(BuildContext context) {
  //   Navigator.pushNamed(context, TaskList.sName);
  // }
  static goProductionReport(BuildContext context) {
    Navigator.pushNamed(context, ProductionReport.sName);
  }

  static goSelectWork(BuildContext context, ids) async {
    await Navigator.pushNamed(context, SelectWork.sName, arguments: ids);
  }

  static goCabling(
      BuildContext context, ids, order_id, id_from_list, flag) async {
    await Navigator.pushNamed(context, Cabling.sName,
        arguments: [ids, order_id, id_from_list, flag]);
  }

  static goFormCircle(
      BuildContext context, ids, order_id, id_from_list, flag) async {
    await Navigator.pushNamed(context, FromCircle.sName,
        arguments: [ids, order_id, id_from_list, flag]);
  }

  static goSeriesConnection(
      BuildContext context, ids, order_id, id_from_list, flag) async {
    await Navigator.pushNamed(context, SeriesConnection.sName,
        arguments: [ids, order_id, id_from_list, flag]);
  }

  static goSheath(
      BuildContext context, ids, order_id, id_from_list, flag) async {
    await Navigator.pushNamed(context, Sheath.sName,
        arguments: [ids, order_id, id_from_list, flag]);
  }

  static goTwistedPair(
      BuildContext context, ids, order_id, id_from_list, flag) async {
    await Navigator.pushNamed(context, TwistedPair.sName,
        arguments: [ids, order_id, id_from_list, flag]);
  }

  static goMaterialLoadList(BuildContext context) {
    Navigator.pushNamed(context, MaterialLoadList.sName);
  }

  static goMaterialLoadProcess(BuildContext context, data) {
    Navigator.pushNamed(context, MaterialLoadProcess.sName, arguments: data);
  }

  static goMaterialLoadDetails(BuildContext context, data) {
    Navigator.pushReplacementNamed(context, MaterialLoadDetails.sName,
        arguments: data);
  }

  static goMaterialLoadDetails1(BuildContext context, data) {
    Navigator.pushNamed(context, MaterialLoadDetails.sName, arguments: data);
  }

  //新首页
  ///主页
  static goHomeNew(BuildContext context) {
    Navigator.pushReplacementNamed(context, MainPage.sName);
  }

  //首页更多
  static goMainTabMore(BuildContext context) {
    Navigator.pushNamed(context, MenuPage.sName);
  }

  //我的->账户与安全
  static goAccountSecurity(BuildContext context) {
    Navigator.pushNamed(context, AccountSecurityPage.sName);
  }

  //我的->账户与安全->修改密码
  static goChangePassword(BuildContext context) {
    Navigator.pushNamed(context, ChangePasswordPage.sName);
  }

  //我的->切换工作
  static goChangeWork(BuildContext context) {
    Navigator.pushNamed(context, ChangeWorkPage.sName);
  }

}

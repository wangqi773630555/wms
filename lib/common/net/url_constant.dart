import '../config/config.dart';
import '../local/local_storage.dart';

///接口地址
class UrlConstant {
  // static const String host = 'http://app.wanmagroup.com:8988/';//正式
  // static const String host2 = 'http://wms.wanmagroup.com/';//正式
  // static const String host = 'http://172.18.2.254:8004/';//测试
  // static const String host = 'https://eqptest.wanmaco.com/api/'; //测试
  static const String host = 'https://gatewaydev.wanmaco.com/authority-system/'; //登录测试
  static const String host2 = 'http://itest.wanmagroup.com/'; //测试
  //static const String host = 'https://gateway.wanmaco.com/authority-system/'; //登录正式
  //static const String host2 = 'http://wms.wanmagroup.com/'; //正式


  ///登陆
  static getLogin() {
    return '${host}auth/app/login';
  }

//退出
  static getOutLogin() {
    return '${host}admin/getLogout';
  }

  ///修改密码
  static updatePwd() {
    return '${host}admin/updateCurrUser';
  }

  //==========================================

  // static skData() async {
  //   return '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
  // }

  static getIndexListData() {
    return '${host2}wm/rtWmMaterialBill/indexList?';
  }

  static getInfoByDeliverNoData() {
    return '${host2}wm/rtWmMaterialBill/infoByDeliverNo?';
  }

  static getUpdateQtyData() {
    return '${host2}wm/rtWmMaterialBillDetail/updateQty?';
  }

  static getBillAccData() {
    return '${host2}wm/rtWmMaterialBill/billAcc?';
  }

  static getBillCancelData() {
    return '${host2}wm/rtWmMaterialBill/billCancel?';
  }

  static getWareListData() {
    return '${host2}wm/ctWmWare/wareList?';
  }

  static getSk() {
    return '${host}auth/sk/gfz';
  }

  static getPartInfoById() {
    return '${host2}process/ctProcessPart/partInfoById?';
  }

  static genPrintIdsByDetailId() {
    return '${host2}wm/rtWmMaterialBillPrint/genPrintIdsByDetailId?';
  }

  static getPartInfoByParas() {
    return '${host2}wm/rtWmMaterialBillDetail/partInfoByParas?';
  }

  static genPrintIdsByDetailIdAtSelfPrint() {
    return '${host2}wm/rtWmMaterialBillPrint/genPrintIdsByDetailIdAtSelfPrint?';
  }

  static getInfoById() {
    return '${host2}wm/rtWmMaterialBillPrint/infoById?';
  }

  static getSaveData() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotPickRelease/saveData&';
  }

  static getorderInfoAndRecipeDataListByParas() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotOrder/orderInfoAndRecipesByOrderId&';
  }

  static getLoadIndexListData() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotPickRelease/indexList&';
  }


}

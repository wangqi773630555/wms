import '../config/config.dart';
import '../local/local_storage.dart';

///接口地址
class UrlConstant {
  // static const String host = 'http://app.wanmagroup.com:8988/';//正式
  // static const String host2 = 'http://wms.wanmagroup.com/';//正式
  // static const String host = 'http://172.18.2.254:8004/';//测试
  // static const String host = 'https://eqptest.wanmaco.com/api/'; //测试
  static const String host =
      'https://gatewaydev.wanmaco.com/'; //登录测试
  static const String host2 = 'http://itest.wanmagroup.com/'; //测试
  // static const String host =
  //     'https://gateway.wanmaco.com/'; //登录正式
  // static const String host2 = 'http://wms.wanmagroup.com/'; //正式


   //本地测试地址
  //static const String host3 = 'http://10.3.32.33:8080/ams/'; //登录测试

  ///登陆
  static getLogin() {
    return '${host}authority-system/auth/app/login';
  }

//退出
  static getOutLogin() {
    return '${host}authority-system/admin/getLogout';
  }

  ///修改密码
  static updatePwd() {
    return '${host}authority-system/admin/updateCurrUser';
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
    return '${host}authority-system/auth/sk/gfz';
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

  static getSelectProduction() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotOrder/orderInfoAndRecipesByOrderIdAtResult&';
  }

  static getProduction() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotWorkPart/orderInfoAndRecipeDataListByParas&';
  }

  static getProductionList() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotWorkPart/workPartIndexData&';
  }

  static getSaveProduction() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotWorkResult/saveResultData&';
  }

  static getProductionQueryURL(queryURL) {
    return '${host2}sync/mesProxy/mesJsonReq?route=$queryURL';
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

  static getcancelByIdData() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotWorkPart/cancelById&';
  }

  static getCancel() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotPickRelease/cancel&';
  }

  static getPreAuthorize() {
    return '${host}authority-system/auth/preAuthorize';
  }

  static getAuthorizeResources() {
    return '${host}authority-system/auth/authorizeResources';
  }

  static secretModify() {
    return '${host}authority-system/user/secret/modify';
  }

  static getAppUserList() {
    return '${host}ams/app-user-info/getAppUserList';
  }

  static saveApp() {
    return '${host}ams/app-user-info/saveApp';
  }

  static removeApp() {
    return '${host}ams/app-user-info/removeApp';
  }
  static appVerison() {
    return '${host}ams/app-version/list';
  }

}

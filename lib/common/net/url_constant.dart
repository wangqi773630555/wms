///接口地址
class UrlConstant {
   //测试环境
   /*static const String host = 'https://gatewaydev.wanmaco.com/'; //登录测试（新框架）
   static const String host2 = 'http://itest.wanmagroup.com/'; //测试（天屹数据缆）
   static const String host3 = 'http://dlmestest.wanmagroup.com/api/'; //测试（电缆低压三厂）
   static const String host4 = 'https://public.wanmaco.com/'; //正式*/




  //本地环境
  // static const String host3 = 'http://10.3.32.37:8002/'; //测试 智航本地（电缆低压三厂）

  // 正式环境
  static const String host = 'https://gateway.wanmaco.com/'; //登录正式（新框架）
  static const String host2 = 'http://wms.wanmaco.com/'; //正式（天屹数据缆）
  static const String host3 = 'http://dlmes.wanmagroup.com/api/'; //正式（电缆低压三厂）
  static const String host4 = 'https://public.wanmaco.com/'; //正式


  //登陆
  static getLogin() {
    return '${host}authority-system/auth/app/login';
  }

  //退出
  static getOutLogin() {
    return '${host}authority-system/admin/getLogout';
  }

  //修改密码
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

  static getDlSk() {
    return '${host}authority-system/auth/sk/dl';
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

  static getQtyByPartId() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotOrder/getQtyByPartId&';
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
    return '${host}ams/app-version/getVersion';
  }

  static feedingOfCheckRecipe() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/lot/rtLotOrder/feedingOfCheckRecipe&';
  }

  //--------------电缆低压三厂------------------------
  static getProdPickParts() {
    return '${host3}agv/rtAgvCommon/getProdPickParts?';
  }

  static getWmWare2() {
    return '${host3}agv/rtAgvCommon/getWmWare2?';
  }

  static createAgvEqpTask() {
    return '${host3}agv/rtAgvCommon/createAgvEqpTask?';
  }

  static getWmsStockParts() {
    return '${host3}agv/rtAgvCommon/getWmsStockParts?';
  }

  static getAgvEqpTasks() {
    return '${host3}agv/rtAgvCommon/getAgvEqpTasks?';
  }

  static confirmTask5() {
    return '${host3}agv/rtAgvCommon/confirmTask5?';
  }

  static confirmTask() {
    return '${host3}agv/rtAgvCommon/confirmTask?';
  }

  static syncAGVTaskEnd() {
    return '${host3}agv/rtAgvCommon/syncAGVTaskEnd?';
  }

  static getWarnMsgByID() {
    return '${host3}agv/rtAgvCommon/getWarnMsgByID?';
  }

  static testAgv() {
    return '${host3}agv/rtAgvCommon/testAgv?';
  }

  static getSelectLoad() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/eqp/ctEqpModule/getSelectLoad&';
  }

  static saveUpModule() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/eqp/ctEqpModule/saveUpModule&';
  }

  static getCtEqpModule() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/eqp/ctEqpModule/getCtEqpModule&';
  }

  //工艺管理
// 首页列表
  static getCtProcessIndexData() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/process/ctProcessPartEqpPara/indexData&';
  }

  //扫码/查看工艺参数
  static getCtProcessScanOrderId() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/process/ctProcessPartEqpPara/scanOrderId&';
  }

  //获取设备列表
  static getCtProcessBindEqps() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/process/ctProcessPartEqpPara/getBindEqps&';
  }

  // 获取辅机参数信息
  static getCtProcessEqpParas() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/process/ctProcessPartEqpPara/getEqpParas&';
  }

  // 参数下置
  static getCtProcessSave() {
    return '${host2}sync/mesProxy/mesJsonReq?route=/process/ctProcessPartEqpPara/downParas&';
  }

  //打卡
  static signin() {
    return '${host4}dl-wms-service/common/common/scanCode';
  }

  /// 上传文件
  static getUploadFile() {
    return '${host4}dl-wms-service/base/ctBaseFile/uploadFile50';
  }

  /// 文件下载
  static getDownloadFile() {
    return '${host4}dl-wms-service/common/download';
  }

  //获取sk
  static getUserSk() {
    return '${host4}dl-wms-service/common/common/getUserSk';
  }

  //获取机台
  static rtQmSampleInit() {
    return '${host4}dl-wms-service/qm/rtQmSample/init';
  }

  //获取签到列表
  static getUserScanCodeList() {
    return '${host4}dl-wms-service/common/common/getUserScanCodeList';
  }

  //获取检验任务列表
  static taskPage() {
    return '${host}ams/qms-data/taskPage';
  }

  //检验单列表
  static sheetList() {
    return '${host}ams/qms-data/sheetList';
  }


  //保存检验单附件
  static updateSheetInfo() {
    return '${host}ams/qms-data/sheet/updateSheetInfo';
  }


  // 上传文件
  static upload() {
    return '${host}file-server/minio/file/upload';
  }

  //【APP扫码盘库】扫码获取在制品信息
  static getResult() {
    return '${host}ams/mes-data/semi/getResult';
  }


  //【APP扫码盘库】扫码获取在制品信息
  static getSemisByOrder() {
    return '${host}ams/mes-data/semi/getSemisByOrder';
  }

  //【APP扫码盘库】获取扫码APP参数清单
  static loadPara() {
    return '${host}ams/mes-data/semi/loadPara';
  }

  //【APP扫码盘库】保存盘点信息
  static saveResult() {
    return '${host}ams/mes-data/semi/saveResult';
  }



}

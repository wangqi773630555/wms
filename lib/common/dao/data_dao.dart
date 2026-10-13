import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wanma_print/common/config/config.dart';
import 'package:wanma_print/common/dao/result_dao.dart';
import 'package:wanma_print/common/local/local_storage.dart';
import 'package:wanma_print/common/net/code.dart';
import 'package:wanma_print/common/net/http_manager.dart';
import 'package:wanma_print/common/net/url_constant.dart';

///获取订单状态数据
class DataDao {
  static Future getAuthority(userName, password) async {
    var url =
        'http://app.wanmagroup.com:8988/wmgfzandroid/loginService/subsystem/login.do?userId=$userName&password=$password';
    await HttpManager.netFetch(url, null, null, Options(method: 'get'));
  }

  //退出登录
  static getOutLogin() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    var res = await HttpManager.netFetch(
        UrlConstant.getOutLogin(), null, header, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  ///修改密码
  static updatePwd(oldPwd, newPwd, newPwd2, name, ids, mobile) async {
    // var resultData;
    // var _userId = await LocalStorage.get(Config.USER_NAME_KEY);
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    Map userList = {
      'user_name': name.toString(),
      'id': int.parse(ids),
      'mobile': mobile.toString()
    };
    Map<String, dynamic> requestParams = {
      'ctSysUser': userList,
      'newpwd': newPwd.toString(),
      'oldpwd': oldPwd.toString(),
      'pwd2': newPwd2.toString(),
    };

    var res = await HttpManager.netFetch(UrlConstant.updatePwd(), requestParams,
        header, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  //====================================================================================================

  ///扫码获取设备详情
  ///
  ///
  ///安装设备时选择信息
  static getIndexList() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    var res = await HttpManager.netFetch(
        '${UrlConstant.getIndexListData()}${setSk}',
        null,
        header,
        Options(method: 'get'));
    return res.data;
  }

  static getBillCancel(String deliverNo) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };

    // Map<String, dynamic> requestParams = {'deliver_no': deliverNo};

    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    var res = await HttpManager.netFetch(
        '${UrlConstant.getBillCancelData()}${setSk}&deliver_no=$deliverNo',
        null,
        header,
        Options(method: 'get'));

    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  static getInfoByDeliverNo(String deliverNo) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    // Map<String, dynamic> requestParams = {'deliver_no': deliverNo};

    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';

    var res = await HttpManager.netFetch(
        '${UrlConstant.getInfoByDeliverNoData()}${setSk}&deliver_no=$deliverNo',
        null,
        header,
        Options(method: 'get'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  static getUpdateQty(wlId, qty) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };

    // Map<String, dynamic> requestParams = {'id': wlId, 'qty': qty};
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    var url = '${UrlConstant.getUpdateQtyData()}${setSk}&id=$wlId&qty=$qty';

    var res =
        await HttpManager.netFetch(url, null, header, Options(method: 'get'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  static getBillAcc(deliverNo, postDate, wareId, isUseForklift, isNeedUnloading,
      detailIds) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams = {
      'deliver_no': deliverNo, //必须  发货单二维码
      'post_date': postDate, //过账日期(yyyy-MM-dd)
      'ware_id': wareId, // string 必须  入库库位
      'is_use_forklift': isUseForklift, // string 必须  使用叉车(是: Y, 否: N)
      'is_need_unloading': isNeedUnloading, // string 必须  需要装卸(是: Y, 否: N)
      'detail_ids': detailIds, // number [] 必须  勾选物料行 item 类型: number
    };

    var res = await HttpManager.netFetch(
        '${UrlConstant.getBillAccData()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  static getWareList() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    // Map<String, dynamic> requestParams = {'eqp_code': eqpCode};

    var res = await HttpManager.netFetch(
        '${UrlConstant.getWareListData()}${setSk}',
        null,
        header,
        Options(method: 'get'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 根据物料号搜索物料信息
   */
  static getPartInfoById(String id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    // Map<String, dynamic> requestParams = {'deliver_no': deliverNo};

    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';

    var res = await HttpManager.netFetch(
        '${UrlConstant.getPartInfoById()}${setSk}&id=$id',
        null,
        header,
        Options(method: 'get'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 物料明细打印
   */
  static genPrintIdsByDetailId(detail_id, qty_print, part_per_qty) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams = {
      'detail_id': detail_id,
      'qty_print': qty_print,
      'part_per_qty': part_per_qty,
    };

    var res = await HttpManager.netFetch(
        '${UrlConstant.genPrintIdsByDetailId()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 扫二维码/输入物料号返回物料信息
   */
  static getPartInfoByParas(id, part_id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    if (id == null) {
      requestParams = {
        'part_id': part_id,
      };
    } else {
      requestParams = {
        'id': id,
      };
    }

    var res = await HttpManager.netFetch(
        '${UrlConstant.getPartInfoByParas()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  //------------------产量报工
  static getSelectProduction(
    productionId,
  ) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams = {
      'id': productionId, // string 必须  入库库位
    };

    var res = await HttpManager.netFetch(
        '${UrlConstant.getSelectProduction()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200 || res.data['code'] == 351) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

//工序
  static getProductions(orderId, recipeId, ids, flag) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    if (flag == true) {
      requestParams = {'id': ids.toString()};
    } else {
      requestParams = {
        "orderId": orderId,
        "recipeId": recipeId.toString(),
      };
    }

    print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getProduction()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200 || res.data['code'] == 351) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

//产量列表
  static getProductionList() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    var res = await HttpManager.netFetch(
        '${UrlConstant.getProductionList()}${setSk}',
        null,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  //申报
  static getProductionSave(orderId, recipeId, ids, flag, paras) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    var requestParams;
    if (flag == true) {
      requestParams = {'id': ids, 'paras': paras};
    } else {
      requestParams = {
        "orderId": orderId,
        "recipeId": recipeId,
        'paras': paras
      };
    }

    var res = await HttpManager.netFetch(
        '${UrlConstant.getSaveProduction()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;

    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  //申报
  static getScanUrl(scanStr, url) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';

    var res = await HttpManager.netFetch(
        '${UrlConstant.getProductionQueryURL(url)}${scanStr}&${setSk}',
        null,
        header,
        Options(method: 'get'));
    var resultData;

    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 自助打印
   */
  static genPrintIdsByDetailIdAtSelfPrint(
      part_id, part_batch, qty_print, part_per_qty) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams = {
      'part_id': part_id,
      'part_batch': part_batch,
      'qty_print': qty_print,
      'part_per_qty': part_per_qty,
    };

    var res = await HttpManager.netFetch(
        '${UrlConstant.genPrintIdsByDetailIdAtSelfPrint()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 扫描物料号返回物料信息
   */
  static getInfoById(id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'id': id,
    };
    var res = await HttpManager.netFetch('${UrlConstant.getInfoById()}${setSk}',
        requestParams, header, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 确定投料
   */

  /**
   * 确定投料
   */
  static getSaveData(id, order_id, recipe_id, eqp_id, material_bill_print_id,
      release_qty, part_id, part_batch) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'id': id,
      'order_id': order_id,
      'recipe_id': recipe_id,
      'eqp_id': eqp_id,
      'material_bill_print_id': material_bill_print_id,
      'release_qty': release_qty,
      'part_id': part_id,
      'part_batch': part_batch,
    };
    var res = await HttpManager.netFetch('${UrlConstant.getSaveData()}${setSk}',
        requestParams, header, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 主页顶部扫码框 -> 扫订单二维码返回信息
   */
  static getOrderInfoAndRecipeDataListByParas(id, order_id, recipe_id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    if (id == null) {
      requestParams = {
        'order_id': order_id,
        'recipe_id': recipe_id,
      };
    } else {
      requestParams = {
        'id': id,
      };
    }
    var res = await HttpManager.netFetch(
        '${UrlConstant.getorderInfoAndRecipeDataListByParas()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  static getLoadIndexList(id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'id': id,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.getLoadIndexListData()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  static getProductCancelById(id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'id': id,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.getcancelByIdData()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  static getCancleById(id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'id': id,
    };
    var res = await HttpManager.netFetch('${UrlConstant.getCancel()}${setSk}',
        requestParams, header, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 判断上料工序是否可用
   */
  static check(order_id, recipe_id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'id': order_id,
      'recipe_id': recipe_id,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.feedingOfCheckRecipe()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 扫描物料号返回物料信息
   */
  static getQtyByPartId(order_id, part_id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'order_id': order_id,
      'part_id': part_id,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.getQtyByPartId()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 上模管理  下拉框加载
   */
  static getSelectLoad() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    // String setSk = '_SK_=tyadmin11';

    /* Map<String, dynamic> requestParams;
    requestParams = {
    };*/
    var res = await HttpManager.netFetch(
        '${UrlConstant.getSelectLoad()}${setSk}',
        null,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 上模管理  确认上模
   */
  static saveUpModule(id, recipe_id, eqp_id, jth, module,order_id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    //String setSk = '_SK_=tyadmin11';
    Map<String, dynamic> requestParams;
    requestParams = {
      'id': id,
      'recipe_id': recipe_id,
      'eqp_id': eqp_id,
      'jth': jth,
      'module': module,
      'order_id': order_id
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.saveUpModule()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 上模管理  上模查询
   */
  static getCtEqpModule(startDay, endDay, pageNumber, pageSize) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    // String setSk = '_SK_=tyadmin11';
    Map<String, dynamic> requestParams;
    requestParams = {
      'startDay': startDay,
      'endDay': endDay,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.getCtEqpModule()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  //----------------电缆低压三场--------------------------
  /**
   * 1.2.获取领料单物料清单接口
   */
  static getProdPickParts() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams = {
      //   "orderId": 306018, "recipeId": '100001'
      //   // 'id': ids
    };
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getProdPickParts()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 2.2获取库位清单接口(库区+库位)
   * liku_tag 0 不包含立库 /1仅立库/ 不传是所有
   * page 0 1 2 3 4 5 6 7 8 9下架 上架 移库 调库 待确认任务（开始/结束）
   */
  static getWmWare2(var liku_tag, var page) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams;
    if (liku_tag != null) {
      requestParams = {"liku_tag": liku_tag, "page": page};
    } else {
      requestParams = {};
    }
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch('${UrlConstant.getWmWare2()}${setSk}',
        requestParams, header, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 4.创建机台配送任务接口
   */
  static createAgvEqpTask(Map<String, dynamic> body) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams = body;
    var res = await HttpManager.netFetch(
        '${UrlConstant.createAgvEqpTask()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 6.1.获取立库库存清单接口
   */
  static getWmsStockParts(var sync_id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams;
    if (sync_id == null) {
      requestParams = {};
    } else {
      requestParams = {"sync_id": sync_id};
    }
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getWmsStockParts()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 5.1.获取当前任务清单接口
   */
  static getAgvEqpTasks() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {};
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getAgvEqpTasks()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 8.回库确认接口
   */
  static confirmTask5(Map<String, dynamic> body) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams = body;
    var res = await HttpManager.netFetch(
        '${UrlConstant.confirmTask5()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 7.机台确认接收任务
   */
  static confirmTask(Map<String, dynamic> body) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams = body;
    var res = await HttpManager.netFetch('${UrlConstant.confirmTask()}${setSk}',
        requestParams, header, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 12.指定AGV进行强制完成
   */
  static syncAGVTaskEnd(var task_id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams;
    if (task_id == null) {
      requestParams = {};
    } else {
      requestParams = {"task_id": task_id};
    }
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.syncAGVTaskEnd()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 测试接口
   */
  static testAgv() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams = {
      //   "orderId": 306018, "recipeId": '100001'
      //   // 'id': ids
    };
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch('${UrlConstant.testAgv()}${setSk}',
        requestParams, header, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 获取异常信息
   */
  static getWarnMsgByID(var task_id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams;
    if (task_id == null) {
      requestParams = {};
    } else {
      requestParams = {"task_id": task_id};
    }
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getWarnMsgByID()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  //工艺管理
// 首页列表

  static getCtProcessIndexData(pageNumber, pageSize) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {'pageSize': pageSize, 'pageNum': pageNumber};
    var res = await HttpManager.netFetch(
        '${UrlConstant.getCtProcessIndexData()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  //扫码/查看工艺参数

  static getCtProcessScanOrderId(int id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'id': id,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.getCtProcessScanOrderId()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  //获取设备列表

  static getCtProcessBindEqps(recipeId, partId, dataId) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {'recipe_id': recipeId, 'part_id': partId, 'id': dataId};
    var res = await HttpManager.netFetch(
        '${UrlConstant.getCtProcessBindEqps()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  // 获取辅机参数信息

  static getCtProcessEqpParas(eqpId, recipeId, partId) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'eqp_id': eqpId,
      'recipe_id': recipeId,
      'part_id': partId,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.getCtProcessEqpParas()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  // 参数下置
  static getCtProcessSave(orderId, ls) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {'order_id': orderId, 'ctProcessPartEqpParas': ls};
    var res = await HttpManager.netFetch(
        '${UrlConstant.getCtProcessSave()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }


  ///上传文件
  static getUploadFile(file, name, type, size, lastModifiedDate) async {
    Map<String, String> header = {
      'Content-Type': "multipart/form-data",
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '?_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams = {
      'file': await MultipartFile.fromFile(file.path),
      'name': name,
      'type': type,
      'size': size,
      'lastModifiedDate': lastModifiedDate
    };

    var formData = FormData.fromMap(requestParams);

    var res = await HttpManager.netFetch(
        '${UrlConstant.getUploadFile()}${setSk}',
        formData, header, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 'ok') {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }


  static rtQmSampleInit() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '?_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {};
    var res = await HttpManager.netFetch(
        '${UrlConstant.rtQmSampleInit()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 'ok') {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['message'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }




  /**
   * 获取签到列表
   */
  static getUserScanCodeList(pageNumber, pageSize,startDay, endDay,eqp_name) async {
    Map<String, String> header = {
      //'Authorization': 'SK:${await LocalStorage.get(Config.SET_DL_KEY)}'
    };
    String setSk = '?_SK_=${await LocalStorage.get(Config.SET_DL_KEY)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'pageNum': pageNumber,
      'pageSize': pageSize,
      'params':{
        'start_date':startDay,
        'end_date':endDay,
        'eqp_name':eqp_name
      }
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.getUserScanCodeList()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 'ok') {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['message'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }


  static taksPage(pageNumber, pageSize,lotId, col02,xnyZjBarcode) async {
    Map<String, String> header = {
      'Authorization':  await LocalStorage.get(Config.UA)
    };
    Map<String, dynamic> requestParams;
    requestParams = {
      'pageNum': pageNumber,
      'pageSize': pageSize,
      'lotId': lotId,
      'col02': col02,
      'xnyZjBarcode':xnyZjBarcode
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.taskPage()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['message'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  static sheetList(id) async {
    Map<String, String> header = {
      'Authorization':  await LocalStorage.get(Config.UA)
    };
    Map<String, dynamic> requestParams;
    requestParams = {
      'id': id,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.sheetList()}?id=${id}',
        null,
        header,
        Options(method: 'get'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['message'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  static updateSheetInfo(id, col02) async {
    Map<String, String> header = {
      'Authorization':  await LocalStorage.get(Config.UA)
    };
    Map<String, dynamic> requestParams;
    requestParams = {
      'id': id,
      'col02': col02,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.updateSheetInfo()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['message'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }


  static upload(file) async {
    Map<String, String> header = {
      'Content-Type': "multipart/form-data",
      'Authorization': await LocalStorage.get(Config.UA)
    };
    Map<String, dynamic> requestParams = {
      'file': await MultipartFile.fromFile(file.path),
    };

    var formData = FormData.fromMap(requestParams);

    var res = await HttpManager.netFetch(
        '${UrlConstant.upload()}',
        formData, header, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }


  /**
   * 【APP扫码盘库】扫码获取在制品信息
   */
  static getProdWoResultSemis(var code) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String sk = await LocalStorage.get(Config.SET_DL_KEY);
    Map<String, dynamic> requestParams;
    requestParams = {
      "_SK_": sk,
      "code": code
    };
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getResult()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 【APP扫码盘库】扫码获取在制品信息
   */
  static getSemisByOrder(var code) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String sk = await LocalStorage.get(Config.SET_DL_KEY);
    Map<String, dynamic> requestParams;
    requestParams = {
      "_SK_": sk,
      "code": code
    };
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getSemisByOrder()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 【APP扫码盘库】获取扫码APP参数清单
   */
  static loadPara() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String sk = await LocalStorage.get(Config.SET_DL_KEY);
    Map<String, dynamic> requestParams;
    requestParams = {"_SK_": sk};
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.loadPara()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 【APP扫码盘库】保存盘点信息
   */
  static saveResult(var datas) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String sk = await LocalStorage.get(Config.SET_DL_KEY);
    Map<String, dynamic> requestParams;
    requestParams = {
      '_SK_': sk,
      'list': datas
    };
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.saveResult()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 盘库列表
   */
  static getSemisList(var code,var create_date) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String sk = await LocalStorage.get(Config.SET_DL_KEY);
    Map<String, dynamic> requestParams;
    requestParams = {
      "_SK_": sk,
      "code": code,
      "create_date":create_date
    };
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getSemisList()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  static loadParas(Map<String, dynamic> requestParams) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String sk = await LocalStorage.get(Config.SET_DL_KEY);
    requestParams['_SK_'] = sk;
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.loadPara()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }


  /**
   * 加载接口
   */
  static getResultSemisLoad(var id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String sk = await LocalStorage.get(Config.SET_DL_KEY);
    Map<String, dynamic> requestParams;
    requestParams = {
      "_SK_": sk,
      "id": id
    };
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getResultSemisLoad()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }

  /**
   * 修改接口
   */
  static updateResultSemis(var id,var create_date,var dept_code,var line_dept_code,var list2) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String sk = await LocalStorage.get(Config.SET_DL_KEY);
    Map<String, dynamic> requestParams;
    requestParams = {
      "_SK_": sk,
      "id": id,
      "create_date": create_date,
      "dept_code": dept_code,
      "line_dept_code": line_dept_code,
      "list2": list2,

    };
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.updateResultSemis()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }


  /**
   * 删除
   */
  static delResultSemis(var id) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String sk = await LocalStorage.get(Config.SET_DL_KEY);
    Map<String, dynamic> requestParams;
    requestParams = {
      "_SK_": sk,
      "id": id
    };
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.delResultSemis()}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      if (res.data['code'] == 200) {
        return ResultDao(res.data, res.result);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
            false);
        return ResultDao(resultData, false);
      }
    } else {
      resultData =
          ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      return ResultDao(resultData, false);
    }
  }



}

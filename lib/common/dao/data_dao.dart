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

//产量列表
  static getProductionList() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    // Map<String, dynamic> requestParams = {
    //   "orderId": 306018, "recipeId": '100001'
    //   // 'id': ids
    // };
    // print('======-----##$requestParams');
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
    // Map<String, dynamic> requestParams = {
    //   "orderId": orderId,
    //   "recipeId": recipeId,
    //   'id': ids,
    //   'paras': paras
    // };
    if (flag == true) {
      requestParams = {'id': ids, 'paras': paras};
    } else {
      requestParams = {
        "orderId": orderId,
        "recipeId": recipeId,
        'paras': paras
      };
    }
    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getSaveProduction()}${setSk}',
        requestParams,
        header,
        Options(method: 'post'));
    var resultData;
    // print('+++++++${res.data}');

    if (res != null && res.result) {
      // if (res.data['code'] == 200) {
      return ResultDao(res.data, res.result);
      //   } else {
      //     resultData = ResultDao(
      //         Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
      //         false);
      //     return ResultDao(resultData, false);
      //   }
      // } else {
      //   resultData =
      //       ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      //   return ResultDao(resultData, false);
    }
  }

  //申报
  static getScanUrl(scanStr, url) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String setSk = '_SK_=${await LocalStorage.get(Config.SET_KEY)}';
    // var requestParams;
    // Map<String, dynamic> requestParams = {
    //   "orderId": orderId,
    //   "recipeId": recipeId,
    //   'id': ids,
    //   'paras': paras
    // };

    // print('======-----##$requestParams');
    var res = await HttpManager.netFetch(
        '${UrlConstant.getProductionQueryURL(url)}${scanStr}&${setSk}',
        null,
        header,
        Options(method: 'get'));
    var resultData;
    // print('+++++++${res.data}');

    if (res != null && res.result) {
      // if (res.data['code'] == 200) {
      return ResultDao(res.data, res.result);
      //   } else {
      //     resultData = ResultDao(
      //         Code.errorHandleFunction(res.data['code'], res.data['msg'], false),
      //         false);
      //     return ResultDao(resultData, false);
      //   }
      // } else {
      //   resultData =
      //       ResultDao(Code.errorHandleFunction(res.code, '', false), false);
      //   return ResultDao(resultData, false);
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
      release_qty,part_id) async {
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
      'part_id':part_id,
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
    var res = await HttpManager.netFetch(
        '${UrlConstant.getCancel()}${setSk}',
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

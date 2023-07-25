import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:wanma_print/common/config/config.dart';
import 'package:wanma_print/common/dao/result_dao.dart';
import 'package:wanma_print/common/db/provider/user_info_db_provider.dart';
import 'package:wanma_print/common/local/local_storage.dart';
import 'package:wanma_print/common/model/User.dart';
import 'package:wanma_print/common/net/LogUtil.dart';
import 'package:wanma_print/common/net/code.dart';
import 'package:wanma_print/common/net/http_manager.dart';
import 'package:wanma_print/common/net/url_constant.dart';
import 'package:wanma_print/common/redux/user_reducer.dart';
import 'package:wanma_print/common/utils/common_utils.dart';

class UserDao {
  ///登录
  static login(userName, password, appType, store) async {
//    String type = userName + ':' +password;
//    var bytes = utf8.encode(type);
//    var base64Str = base64.encode(bytes);
//    if(Config.DEBUG) {
//      print("base64Str login " + base64Str);
//    }
    await LocalStorage.save(Config.USER_NAME_KEY, userName);

    Map<String, dynamic> requestParams = {
      'username': userName,
      'password': password
    };

    var res = await HttpManager.netFetch(
        UrlConstant.getLogin(), requestParams, null, Options(method: 'post'));
    var resultData;
    if (res != null && res.result) {
      var resultData;
        if (res.data['code'] == 200 || res.data['code'] == 10000) {
        await LocalStorage.save(Config.PW_KEY, password);

        User user = User(userName: userName, password: password);
        // //存入数据库
        // UserInfoDbProvider provider = UserInfoDbProvider();
        // provider.insert(userName, password);

        //取出头像照片地址
        // var imagePath = await LocalStorage.get(Config.AVATAR);
        // user.image = imagePath;
        //保存用户信息
        await LocalStorage.save(Config.USER_INFO, json.encode(user.toJson()));

        resultData = ResultDao(user, res.result);
        if (Config.DEBUG) {
          print("user result " + resultData.result.toString());
          print(resultData.data);
          print(res.data.toString());
        }
        store.dispatch(UpdateUserAction(resultData.data));
//        Code.errorHandleFunction(200, res.data['msg'], false);
      } else {
        resultData = ResultDao(
            Code.errorHandleFunction(res.code, res.data['msg'], false), false);
        return ResultDao(resultData, false);
      }
    }
    return ResultDao(res.data, res.result);
  }

  // ///修改密码
  // static updatePwd(oldPwd, newPwd, newPwd2) async {
  //   var resultData;
  //   var _userId = await LocalStorage.get(Config.USER_NAME_KEY);

  //   Map<String, dynamic> requestParams = {
  //     'userId': _userId,
  //     'newPwd': newPwd,
  //     'oldPwd': oldPwd,
  //   };

  //   var res = await HttpManager.netFetch(
  //       UrlConstant.updatePwd(), requestParams, null, Options(method: 'post'));
  //   if (res.data['result']) {
  //     resultData = ResultDao(res.data['msg'], true);
  //   } else {
  //     resultData = ResultDao(
  //         Code.errorHandleFunction(res.code, res.data['msg'], false), false);
  //   }

  //   return resultData;
  // }

  ///获取用户信息
//  static getUserInfo(String userName) async {
//    UserInfoDbProvider provider = UserInfoDbProvider();
//    var res = await HttpManager.netFetch('', null, null, null);
//  }

  static clearAll(Store store) async {
    LocalStorage.remove(Config.USER_INFO);
    store.dispatch(new UpdateUserAction(User.empty()));
  }

  ///初始化用户信息
  static initUserInfo(Store store) async {
    var token = await LocalStorage.get(Config.TOKEN_KEY);
    ResultDao res = await getUserInfoLocal();

    if (res != null && res.result && token != null) {
      store.dispatch(UpdateUserAction(res.data));
    }

    //读取主题
    String themeIndex = await LocalStorage.get(Config.THEME_COLOR) ?? "";
    if (themeIndex != null && themeIndex.length != 0) {
      CommonUtils.pushTheme(store, int.parse(themeIndex));
    }

    return ResultDao(res.data, (res.result && (token != null)));
  }

  ///获取本地登录用户信息
  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      User user = User.fromJson(userMap);
      return ResultDao(user, true);
    } else {
      return ResultDao(null, false);
    }
  }

  /**
   *获取高分子 数据缆 sk
   */

  static getSk() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };

    var res = await HttpManager.netFetch(
        '${UrlConstant.getSk()}',
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
   *获取电缆 sk
   */

  static getDlSk() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };

    var res = await HttpManager.netFetch(
        '${UrlConstant.getDlSk()}',
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
   * 预授权
   */
  static getPreAuthorize() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };

    var res = await HttpManager.netFetch(
        '${UrlConstant.getPreAuthorize()}',
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
   * 资源授权
   */
  static getAuthorizeResources(workId) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String param = workId==''?'workId=${await LocalStorage.get(Config.WORK_ID)}&appname=app-platform':'workId=${workId}&appname=app-platform';
    var res = await HttpManager.netFetch(
        '${UrlConstant.getAuthorizeResources()}?${param}',
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
   * 首页应用菜单
   */
  static getAppUserList(resType) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String param = 'workId=${await LocalStorage.get(Config.WORK_ID)}';
    Map<String, dynamic> requestParams;
    requestParams = {
      'resType': resType,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.getAppUserList()}?${param}',
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
   * 添加App
   */
  static saveApp(resId,sort,resName,resType,icon,disabled,route,attributes) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String workId = await LocalStorage.get(Config.WORK_ID);
    Map<String, dynamic> requestParams;
    requestParams = {
      'workId':workId,
      'resId': resId,
      'sort': sort,
      'resName': resName,
      'resType': resType,
      'icon': icon,
      'disabled':disabled,
      'route':route,
      'attributes':attributes,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.saveApp()}',
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
   * 移除App
   */
  static removeApp(resId) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };
    String param = 'resId=${resId}';
    var res = await HttpManager.netFetch(
        '${UrlConstant.removeApp()}?${param}',
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
   * 修改密码
   */
  static secretModify(oldSecret,newSecret) async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };

    Map<String, dynamic> requestParams;
    requestParams = {
      'oldSecret': oldSecret,
      'newSecret': newSecret,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.secretModify()}',
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
   * 版本更新
   */
  static getAppVersion() async {
    Map<String, String> header = {
      'Authorization': await LocalStorage.get(Config.UA)
    };

    Map<String, dynamic> requestParams;
    requestParams = {
      'name': 'WMApp',
      'flag': 1,
    };
    var res = await HttpManager.netFetch(
        '${UrlConstant.appVerison()}',
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

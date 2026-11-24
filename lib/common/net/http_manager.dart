import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:wanma_print/common/config/config.dart';
import 'package:wanma_print/common/local/local_storage.dart';
import 'package:wanma_print/common/net/code.dart';
import 'package:wanma_print/common/net/result_data.dart';
import 'dart:collection';

import 'LogUtil.dart';

class HttpManager {
  static const CONTENT_TYPE_JSON = 'application/json';
  static const CONTENT_TYPE_FORM = 'application/x-www-form-urlencoded';

  static Dio? _dio;
  static BaseOptions? orgOption;

  static const int CONNECT_TIMEOUT = 60000;
  static const int RECEIVE_TIMEOUT = 60000;

  static const Map<String, String> header = {
    'Content-Type': "application/json"
  };

  static Dio? createInstance() {
    if (_dio == null) {
      orgOption = BaseOptions(
          contentType: CONTENT_TYPE_JSON,
          connectTimeout: CONNECT_TIMEOUT,
          receiveTimeout: RECEIVE_TIMEOUT,
          headers: header);
      _dio = Dio(orgOption);
      // iOS 上对证书链校验严格；服务器未下发完整中间证书时会被系统拒绝连接，
      // 表现为请求一直失败/超时（Android 通常能容忍）。这里仅在 iOS 放宽证书校验。
      if (Platform.isIOS) {
        final adapter = _dio!.httpClientAdapter;
        if (adapter is DefaultHttpClientAdapter) {
          adapter.onHttpClientCreate = (client) {
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          };
        }
      }
      _dio?.interceptors.add(CookieManager(CookieJar()));
    }
    return _dio;
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  static netFetch(url, params, Map<String, String>? header, Options option,
      {noTip = false, download = false}) async {
    //判断网络
   /* var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return ResultData(Code.errorHandleFunction(Code.NETWORK_ERROR, '', noTip),
          false, Code.NETWORK_ERROR);
    }*/

    Map<String, String> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (option != null) {
      option.headers = headers;
    } else {
      option = Options(method: 'get');
      option.headers = headers;
    }

    Dio dio = createInstance()!;
    Response response;
    try {
      response = await dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response!;
      } else {
        errorResponse =
            Response(statusCode: 111, requestOptions: RequestOptions(path: ''));
      }
      if (e.type == DioErrorType.connectTimeout) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      if (Config.DEBUG) {
        print('请求异常：' + e.toString());
        print('请求异常url：' + url);
      }
      return ResultData(
          Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip),
          false,
          errorResponse.statusCode);
    }

    //调试模式
    if (Config.DEBUG) {
      print('请求url: ' + url);
      print('请求头: ' + option.headers.toString());
      if (params != null) {
        //print('请求参数: ' + params.toString());
        try{
          LogUtil.d('请求参数: ' + json.encode(params));
        }catch(e){
          print('请求参数: ' + params.toString());
        }
      }
      if (response != null) {
        LogUtil.d(response.toString());
      }
    }

    if (response.statusCode == 200) {
      return ResultData(response.data, true, Code.SUCCESS,
          headers: response.headers);
    }
    return ResultData(Code.errorHandleFunction(response.statusCode, '', noTip),
        false, response.statusCode);
  }
}

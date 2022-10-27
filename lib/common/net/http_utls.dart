import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:home_framework/utils/cookie_manager.dart';

enum HttpMethod {
  GET,
  PUT,
  POST,
  PATCH,
  DELETE,
  UPLOAD,
}

class HttpUtil {
  static Dio? _dioInstance;
  static Dio? getDioInstance() {
    if (_dioInstance == null) {
      _dioInstance = Dio();
      // _dioInstance.interceptors.add(CookieManager.instance);
      // _dioInstance.interceptors.add(
      //   InterceptorsWrapper(onRequest: (options, handler) {
      //     print(options.path);
      //     return handler.next(options);
      //   }, onResponse: (response, handler) {
      //     print(response.statusMessage);
      //     //throw new Exception('');
      //     handler.next(response);
      //   }, onError: (DioError e, handler) {
      //     print(e.message);
      //     return handler.next(e);
      //   }),
      // );
    }

    return _dioInstance;
  }

  static Future download(
      String url,
      String savePath, {
        Map<String, dynamic>? queryParams,
        CancelToken? cancelToken,
        dynamic data,
        Options? options,
        void Function(int, int)? onReceiveProgress,
      }) async {
    try {
      return await _dioInstance?.download(
        url,
        savePath,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        // EasyLoading.showInfo('下载已取消！');
      } else {
        if (e.response != null) {
          // _handleErrorResponse(e.response);
        } else {
          // EasyLoading.showError(e.message);
        }
      }
    } on Exception catch (e) {
      // EasyLoading.showError(e.toString());
    }
  }

  // static void setCookie(String cookie) {
  //   _dioInstance.options.headers['Cookie'] = cookie;
  // }

  // static void clearCookie() {
  //   _dioInstance.options.headers['Cookie'] = null;
  // }

  // static Future get(String url,
  //     {Map<String, dynamic> queryParams, CancelToken cancelToken}) async {
  //   return await sendRequest(HttpMethod.GET, url,
  //       queryParams: queryParams, cancelToken: cancelToken);
  // }
  //
  // static Future put(String url,
  //     {Map<String, dynamic> queryParams, dynamic data}) async {
  //   return await sendRequest(HttpMethod.PUT, url,
  //       queryParams: queryParams, data: data);
  // }
  //
  // static Future post(String url,
  //     {Map<String, dynamic> queryParams,
  //       dynamic data,
  //       CancelToken cancelToken}) async {
  //   return await sendRequest(HttpMethod.POST, url,
  //       queryParams: queryParams, data: data, cancelToken: cancelToken);
  // }
  //
  // static Future patch(String url,
  //     {Map<String, dynamic> queryParams, dynamic data}) async {
  //   return await sendRequest(HttpMethod.PATCH, url,
  //       queryParams: queryParams, data: data);
  // }
  //
  // static Future delete(String url,
  //     {Map<String, dynamic> queryParams, dynamic data}) async {
  //   return await sendRequest(HttpMethod.DELETE, url,
  //       queryParams: queryParams, data: data);
  // }
  //
  // static Future uploadSingle(String url, String fileKey, File file,
  //     {Map<String, dynamic> queryParams}) async {
  //   FormData formData = FormData.fromMap({
  //     fileKey: await MultipartFile.fromFile(file.path),
  //   });
  //   return await sendRequest(HttpMethod.POST, url,
  //       queryParams: queryParams, data: formData);
  // }

  // static Future sendRequest(HttpMethod method, String url,
  //     {Map<String, dynamic> queryParams,
  //       dynamic data,
  //       CancelToken cancelToken}) async {
  //   try {
  //     switch (method) {
  //       case HttpMethod.GET:
  //         return await HttpUtil.getDioInstance()
  //             .get(url, queryParameters: queryParams, cancelToken: cancelToken);
  //       case HttpMethod.PUT:
  //         return await HttpUtil.getDioInstance().put(url,
  //             queryParameters: queryParams,
  //             data: data,
  //             cancelToken: cancelToken);
  //       case HttpMethod.POST:
  //         return await HttpUtil.getDioInstance().post(url,
  //             queryParameters: queryParams,
  //             data: data,
  //             cancelToken: cancelToken);
  //       case HttpMethod.PATCH:
  //         return await HttpUtil.getDioInstance().patch(url,
  //             queryParameters: queryParams,
  //             data: data,
  //             cancelToken: cancelToken);
  //       case HttpMethod.DELETE:
  //         return await HttpUtil.getDioInstance().delete(url,
  //             queryParameters: queryParams,
  //             data: data,
  //             cancelToken: cancelToken);
  //       default:
  //         EasyLoading.showError('请求方式错误');
  //     }
  //   } on DioError catch (e) {
  //     if (CancelToken.isCancel(e)) {
  //       EasyLoading.showInfo('领导喊你回去改 Bug 啦！');
  //     } else {
  //       if (e.response != null) {
  //         _handleErrorResponse(e.response);
  //       } else {
  //         EasyLoading.showError(e.message);
  //       }
  //     }
  //   } on Exception catch (e) {
  //     EasyLoading.showError(e.toString());
  //   }
  //
  //   return null;
  // }

  // static void _handleErrorResponse(Response response) {
  //   switch (response.statusCode) {
  //     case 401:
  //       EasyLoading.showError('验票失败!');
  //       break;
  //     case 403:
  //       EasyLoading.showError('无权限访问!');
  //       break;
  //     case 404:
  //       EasyLoading.showError('404未找到!');
  //       break;
  //     case 500:
  //     case 502:
  //       EasyLoading.showError('服务器内部错误!');
  //       break;
  //     default:
  //       EasyLoading.showError(response.statusMessage);
  //   }
  // }
}

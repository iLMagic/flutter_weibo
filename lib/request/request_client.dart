export 'package:dio/dio.dart' show DioError;
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// typedef SuccessHandler = void Function(Map data);
// typedef FailHandler = void Function(DioError error);

class RequestClient {
  Dio dio;

  static RequestClient _instance;

  // 外部唯一实例化对象的方法
  factory RequestClient.shareInstance() {
    if (_instance == null) {
      _instance = RequestClient._();
    }
    return _instance;
  }

  // 私有化构造方法，只会初始化一次
  RequestClient._() {
    dio = Dio(
      BaseOptions(
        // connectTimeout: 60,
        // baseUrl: 'https://train.odrcloud.cn:8443/',
        baseUrl: 'https://api.weibo.com/',
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic> params,
    RequestConfig config,
  }) async {
    Completer cpl = Completer();
    Map nparams = await _requestProcess(params);
    Response resp = await dio.get(path, queryParameters: nparams);
    _responseProcess(resp, cpl, config);
    return resp;
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic> params,
    RequestConfig config,
  }) async {
    Completer cpl = Completer();
    Map nparams = await _requestProcess(params);
    Response resp = await dio.post(path, queryParameters: nparams);
    _responseProcess(resp, cpl, config);
    return cpl.future;
  }

  /// 请求预处理
  Future<Map> _requestProcess(Map params) async {
    // 拼接公共请求参数
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    token = '2.00BGPNzH8X_T8Dc7c2506aa0JqOdyC';
    Map<String, dynamic> newParams = {'access_token': token};
    if (params != null) {
      newParams.addAll(params);
    }
    return newParams;
  }

  /// 响应预处理
  void _responseProcess(Response resp, Completer cpl, RequestConfig config,) {
    if (config == null) {
      config = RequestConfig(debugConsole: true);
    }
    if (config.debugConsole) {
      DHJsonPrint.dhPrint(resp.data);
    } 
    if (resp.data is Map) {
      Map data = resp.data;
      if (data.containsKey('error_code')) {
        cpl.completeError(DioError(
          response: resp,
        ));
      } else {
        cpl.complete(resp);
      }
    } else {
      cpl.complete(resp);
    }
  }
}

/// 请求配置
class RequestConfig {
  // final requestSe
  bool debugConsole = true;

  RequestConfig({this.debugConsole}) {
    bool isReleaseEnv =  bool.fromEnvironment('dart.vm.product');
    if (isReleaseEnv) {
      this.debugConsole = false;
    } 
  }
}



/// 打印工具
class DHJsonPrint {
  static void printTest() {
    Map map = {
      'name': 'dava',
      'famly': [
        {'father': 'jack'},
        {'mother': 'rose'}
      ],
      'age': 18,
    };
    DHJsonPrint.dhPrint(map);
    // _printJson(0, '', map);
  }

  static void dhPrint(object) {
    _printJson(0, '', object);
  }

  static void _printJson(int index, String key, object) {
    String str = '';
    for (var i = 0; i < index; i++) {
      str += ' ';
    }
    if (object is Map) {
      String tempStr;
      if (key.isEmpty) {
        tempStr = '$str{';
      } else {
        tempStr = '$str$key: {';
      }
      print(tempStr);
      object.forEach((key, vaule) {
        _printJson(tempStr.length + 1, key, vaule);
      });
      String temp2Str = '';
      for (var i = 0; i < tempStr.length - 1; i++) {
        temp2Str += ' ';
      }
      print('$temp2Str}');
    } else if (object is List) {
      String tempStr;
      if (key.isEmpty) {
        tempStr = '$str[';
      } else {
        tempStr = '$str$key: [';
      }
      print(tempStr);
      object.forEach((vaule) {
        _printJson(tempStr.length + 1, '', vaule);
      });
      String temp2Str = '';
      for (var i = 0; i < tempStr.length - 1; i++) {
        temp2Str += ' ';
      }
      print('$temp2Str]');
    } else {
      if (key.isEmpty) {
        print(object);
      } else {
        print('$str$key: $object');
      }
    }
  }
}

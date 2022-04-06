import 'dart:io';import 'package:dio/adapter.dart';import 'package:dio/dio.dart';import 'package:flutter/material.dart';import 'package:fluttertoast/fluttertoast.dart';import 'package:library_reservation/core/service/utils/common.dart';import 'package:library_reservation/core/service/utils/manager_utils.dart';import 'constant.dart';class HttpUtil {  static HttpUtil get instance => _getInstance();  static HttpUtil? _httpUtil;  int timeOut = 10000;  Map<String,CancelToken> _cancelTokenMap = Map();  static HttpUtil _getInstance() {    if (_httpUtil == null) {      _httpUtil = new HttpUtil._internal();    }    return _httpUtil!;  }  //通用全局单例，第一次使用时初始化  HttpUtil._internal();  Dio _getDio()  {    // String? token = ManagerUtils.instance.getHttpToken();    String? token = '';    Dio _dio = Dio();    _dio.options      ..connectTimeout = timeOut      ..sendTimeout = timeOut      ..receiveTimeout = timeOut;    // ..baseUrl = Common.baseApi;    //日志拦截器    _dio.interceptors.add(        InterceptorsWrapper(onRequest: (RequestOptions options,RequestInterceptorHandler handler) {          //添加请求头token          options.headers.addAll({"dcqc-request-id":"22222222222222222222222222222222"});          options.headers.addAll({"dcqc-channel-type":"2"});          options.headers.addAll({"dcqc-app-key":"CQQRCode"});          // options.headers.addAll({"Authorization": "$token"});          // print("\n================================= 请求数据 =================================");          print("method = ${options.method.toString()}");          print("url = ${options.uri.toString()}");          print("headers = ${options.headers}");          print("params = ${options.queryParameters}");          print("data = ${options.data}");          return handler.next(options);        }, onResponse: (Response response,ResponseInterceptorHandler handler) {          print(              "\n================================= 响应数据开始 =================================");          print("code = ${response.statusCode}");          print("data = ${response.data}");          // print("format_data = ${JsonLogUtils.convert(response.data, 0,isObject:true)}");          print(              "================================= 响应数据结束 =================================\n");          return handler.next(response);        }, onError: (DioError e,ErrorInterceptorHandler errorHandler) {          print(              "\n=================================错误响应数据 =================================");          print("type = ${e.type}");          print("message = ${e.message}");          print("response = ${e.response}");          print("error = ${e.error}");          print("\n");          return errorHandler.next(e);        }));    _dio.options.headers['Authorization'] = token;    if(!Common.isRelease){///只在debug模式下运行      //配置抓包代理      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {        if(Constant.proxyUrl.length>0){          client.findProxy = (uri) {            //proxy all request to localhost:8888            print('PROXY '+Constant.proxyUrl+':'+Constant.proxyPort);            return 'PROXY '+Constant.proxyUrl+':'+Constant.proxyPort; //测试电脑代理ip            // return "PROXY 192.168.10.28:8866";          };          // 你也可以自己创建一个新的HttpClient实例返回。          // return new HttpClient(SecurityContext);          //抓Https包设置          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;        }else{          client.findProxy=null;          client.badCertificateCallback = null;        }      };    }    return _dio;  }  //通用的POST请求  Future<Response> post(api, {Map<String, dynamic>? parameters, Map<String, dynamic>? data, Options? options,    bool showLoading = false,BuildContext? context}) async {    assert(!showLoading||context!=null);    String tmpApi = api;    String? baseApi = Common.DEFAULT_API;    if(baseApi.isEmpty){      baseApi = Common.DEFAULT_API;    }    api = baseApi + api;    if (showLoading) {      // CommonWidgets.showLoadingWidgets(context!);    }    Response response;    CancelToken _cancelToken = new CancelToken();    _cancelTokenMap[tmpApi]=_cancelToken;    try {      response = await _getDio().post(api, queryParameters: parameters, data: data, options: options,cancelToken: _cancelToken);      if (showLoading) {        // CommonWidgets.dismissLoading();      }      _cancelTokenMap.remove(tmpApi);      return response;    } on DioError catch (e) {      if (showLoading) {        // CommonWidgets.dismissLoading();      }      _cancelTokenMap.remove(tmpApi);      if(e.type==DioErrorType.cancel){//取消请求        Fluttertoast.cancel();        return new Response(data: {'code': 'CANCEL','message':null}, requestOptions: _cancelToken.requestOptions!);      }      if(e.type==DioErrorType.connectTimeout){        Fluttertoast.showToast(msg: '请求超时');        return new Response(data: {'code': 'TIME_OUT','message':'请求超时'}, requestOptions: _cancelToken.requestOptions!);      }      //处理请求返回的鉴权失败      if (e.response != null && e.response!.statusCode == 401) {        // LoginUtil.instance.loginNativePage();      } else if (e.response != null && e.response!.statusCode == 500) {        String message = '服务器错误';        return new Response(            statusCode: 500,data: {'code':'error','message':message}, requestOptions: _cancelToken.requestOptions!);      }else if (e.response != null && e.response!.statusCode == 422) {        String message = '未知错误';        Map <dynamic, dynamic>arg = e.response!.data['data'];        arg.forEach((key, value) {          if(arg.values.length > 0){            if(arg.values.first.length>0){              message  = arg.values.first[arg.values.first.length>1?1:0];            }          }        });        print('message=== ${message.toString()}');        return new Response(            statusCode: 422,data: {'code':'error','message':message}, requestOptions: _cancelToken.requestOptions!);      }      return e.response != null ? e.response! : new Response(statusCode: 666, data: {'code': 'no_response'}, requestOptions: _cancelToken.requestOptions!);    }  }  Future<Response> get(api, {Map<String,      dynamic>? parameters, Options? options, bool showLoading = false,BuildContext? context}) async {    assert(!showLoading||context!=null);    String tmpApi = api;    String? baseApi = Common.DEFAULT_API;    if(baseApi.isEmpty){      baseApi = Common.DEFAULT_API;    }    api = baseApi + api;    if (showLoading) {      // CommonWidgets.showLoadingWidgets(context!);    }    CancelToken _cancelToken = new CancelToken();    _cancelTokenMap[tmpApi]=_cancelToken;    try {      Response response = await _getDio().get(api, queryParameters: parameters, options: options,cancelToken: _cancelToken);      if (showLoading) {        // CommonWidgets.dismissLoading();      }      _cancelTokenMap.remove(tmpApi);      return response;    } on DioError catch (e) {      if (showLoading) {        // CommonWidgets.dismissLoading();      }      _cancelTokenMap.remove(tmpApi);      if(e.type==DioErrorType.cancel){//取消请求        Fluttertoast.cancel();        return new Response(data: {'code': 'CANCEL','message':null}, requestOptions: _cancelToken.requestOptions!);      }      if(e.type==DioErrorType.connectTimeout){        // Fluttertoast.showToast(msg: '请求超时');        return new Response(data: {'code': 'TIME_OUT','message':'请求超时'}, requestOptions: _cancelToken.requestOptions!);      }      //处理请求返回的鉴权失败      if (e.response != null && e.response!.statusCode == 401) {        // LoginUtil.instance.loginNativePage();      } else if (e.response != null && e.response!.statusCode == 500) {        String message = '服务器错误';        return new Response(statusCode: 500,data: {'code':'error','message':message}, requestOptions: _cancelToken.requestOptions!);      }else if (e.response != null && e.response!.statusCode == 422) {        String message = '未知错误';        Map <dynamic, dynamic>arg = e.response!.data['data'];        arg.forEach((key, value) {          if(arg.values.length > 0){            message  = arg.values.first[0];          }        });        print('message=== ${message.toString()}');        return new Response(statusCode: 422,data: {'code':'error','message':message}, requestOptions: _cancelToken.requestOptions!);      }      return e.response != null ? e.response! : new Response(statusCode: 666, data: {'code': 'no_response'}, requestOptions: _cancelToken.requestOptions!);    }  }  void cancel(String cancelApi){    if(!_cancelTokenMap.containsKey(cancelApi)){      return;    }    CancelToken? cancelToken=_cancelTokenMap[cancelApi];    if(cancelToken!=null&&!cancelToken.isCancelled){      cancelToken.cancel('$cancelApi is cancelled');    }  }  void dispose(){    _cancelTokenMap.clear();  }  // 下载  static Future<Response> download(String url, String savePath,      Function(int count, int total) progressCallback) async {    return Dio().download(url, savePath, onReceiveProgress: progressCallback);  }}
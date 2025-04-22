import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class DioNetworkService {
  late Dio _dio;

  // 单例实例
  static final DioNetworkService _instance = DioNetworkService._internal();

  // 工厂构造函数，返回单例实例
  factory DioNetworkService() => _instance;

  // 私有构造函数
  DioNetworkService._internal() {
    _dio = Dio(BaseOptions(baseUrl: 'https://picaapi.picacomic.com/'));
  }

  static const apiKey = 'C69BAF41DA5ABD1FFEDC6D2FEA56B';
  static const apiSecret =
      '~d}\$Q7\$eIni=V)9\\RK/P.RM4;9[7|@/CA}b~OW!3?EV`:<>M7pddUBL5n|0/*Cn';
  static const staticHeaders = {
    'accept': 'application/vnd.picacomic.com.v1+json',
    'api-key': apiKey,
    'app-build-Version': '45',
    'app-channel': '3',
    'app-platform': 'android',
    'app-version': '2.2.1.3.3.4',
    'app-uuid': 'defaultUuid',
    'content-type': 'application/json; charset=UTF-8',
    'user-agent': 'okhttp/3.8.1',
  };

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: generateHeaders('GET', path)),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        options: Options(headers: generateHeaders('POST', path)),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 错误处理
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      if (response != null) {
        final statusCode = response.statusCode;
        final errorMessage =
            response.data is Map ? response.data['message'] ?? '未知错误' : '失败请求';
        switch (statusCode) {
          case 401:
            return Exception('错误 401 Unauthorized: $errorMessage');
          case 403:
            return Exception('错误 403 Forbidden: $errorMessage');
          default:
            return Exception('失败请求: $statusCode $errorMessage');
        }
      }
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Exception('请求超时');
        case DioExceptionType.receiveTimeout:
          return Exception('响应超时');
        default:
          return Exception('网络错误: ${error.message}');
      }
    }
    return Exception('未知错误: $error');
  }

  Map<String, String> generateHeaders(String method, String path) {
    final nonce = Uuid().v4().replaceAll('-', '');
    final time = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final signature = getSignature(path, time, nonce, method);
    return {
      ...staticHeaders,
      'nonce': nonce,
      'signature': signature,
      'time': time,
    };
  }

  String getSignature(String path, String time, String nonce, String method) {
    final rawSignature = '$path$time$nonce$method$apiKey';
    final rawSignatureLower = rawSignature.toLowerCase();
    final key = utf8.encode(apiSecret);
    final bytes = utf8.encode(rawSignatureLower);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    return digest.toString();
  }
}

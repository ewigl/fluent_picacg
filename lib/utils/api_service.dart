import 'package:dio/dio.dart';
import 'dio_network_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal(DioNetworkService());
  factory ApiService() => _instance;
  ApiService._internal(this._networkService);

  final DioNetworkService _networkService;

  // 登录
  Future<Response> signIn({
    required String username,
    required String password,
  }) async {
    return await _networkService.post(
      'auth/sign-in',
      data: {'email': username, 'password': password},
    );
  }

  // 首页推荐
  Future<Response> getCollections() async {
    return await _networkService.get('collections');
  }

  // 漫画信息
  Future<Response> getComics({Map<String, dynamic>? queryParameters}) async {
    return await _networkService.get(
      'comics',
      queryParameters: queryParameters,
    );
  }
}

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../api_url.dart';

class AuthLoginResponse {
  final String message;
  final String mrId;
  final String fullName;
  final String phoneNo;

  AuthLoginResponse({
    required this.message,
    required this.mrId,
    required this.fullName,
    required this.phoneNo,
  });

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    return AuthLoginResponse(
      message: (json['message'] ?? '').toString(),
      mrId: (json['mr_id'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
      phoneNo: (json['phone_no'] ?? '').toString(),
    );
  }
}

class AuthService {
  AuthService({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;

  static Dio _buildDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
    );

    return dio;
  }

  Future<AuthLoginResponse> login({
    required String phoneNo,
    required String password,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        ApiUrl.mrLogin,
        data: {'phone_no': phoneNo, 'password': password},
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid login response from server');
      }

      return AuthLoginResponse.fromJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  String _readDioError(DioException e) {
    final dynamic body = e.response?.data;
    if (body is Map<String, dynamic>) {
      final dynamic detail = body['detail'] ?? body['message'];
      if (detail != null && detail.toString().trim().isNotEmpty) {
        return detail.toString();
      }
    }
    return e.message ?? 'Request failed';
  }
}

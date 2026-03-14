import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/distributor.dart';
import '../api_url.dart';

class DistributorServices {
  DistributorServices({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiUrl.baseUrl,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 20),
            ),
          ) {
    if (!_dio.interceptors.any((it) => it is PrettyDioLogger)) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          compact: true,
          enabled: kDebugMode,
        ),
      );
    }
  }

  final Dio _dio;

  Future<List<Distributor>> fetchAllDistributors() async {
    try {
      final response = await _dio.get(ApiUrl.distributorGetAll);
      final data = response.data;
      if (data is! List) {
        throw Exception(
          'Invalid distributor list response received from server.',
        );
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(Distributor.fromJson)
          .map(_normalizePhotoPath)
          .toList();
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load distributors right now.');
    }
  }

  Future<Distributor> fetchDistributorById(String distId) async {
    try {
      final response = await _dio.get(ApiUrl.distributorGetById(distId));
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid distributor response received from server.');
      }

      return _normalizePhotoPath(Distributor.fromJson(data));
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load distributor details right now.');
    }
  }

  Distributor _normalizePhotoPath(Distributor distributor) {
    final path = distributor.photoUrl;
    if (path == null || path.trim().isEmpty) {
      return distributor;
    }

    final trimmed = path.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return distributor;
    }

    return distributor.copyWith(
      photoUrl: trimmed.startsWith('/')
          ? ApiUrl.getFullUrl(trimmed)
          : ApiUrl.getFullUrl('/$trimmed'),
    );
  }

  String _extractErrorMessage(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final detail = responseData['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail.trim();
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Request timed out. Please check your connection and try again.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Unable to reach the server. Please check your connection.';
    }

    return 'Something went wrong while talking to the server.';
  }
}
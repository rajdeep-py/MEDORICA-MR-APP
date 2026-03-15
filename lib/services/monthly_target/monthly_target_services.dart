import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/monthly_target.dart';
import '../api_url.dart';

class MonthlyTargetServices {
  MonthlyTargetServices({Dio? dio})
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

  Future<List<HomeMonthlyTarget>> fetchMonthlyTargetsBymrId(
    String mrId,
  ) async {
    try {
      final response = await _dio.get(ApiUrl.monthlyTargetmrGetByMrId(mrId));
      final data = response.data;
      if (data is! List) {
        throw Exception(
          'Invalid monthly target list response received from server.',
        );
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(HomeMonthlyTarget.fromJson)
          .toList();
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load monthly targets right now.');
    }
  }

  Future<HomeMonthlyTarget> fetchMonthlyTargetByAsmYearMonth({
    required String mrId,
    required int year,
    required int month,
  }) async {
    try {
      final response = await _dio.get(
        ApiUrl.monthlyTargetmrGetByMrYearMonth(mrId, year, month),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception(
          'Invalid monthly target response received from server.',
        );
      }

      return HomeMonthlyTarget.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load monthly target right now.');
    }
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
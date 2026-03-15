// ignore_for_file: use_null_aware_elements

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/order.dart';
import '../api_url.dart';

class OrderServices {
  OrderServices({Dio? dio})
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

  Future<List<Order>> fetchOrdersBymrId(String mrId) async {
    try {
      final response = await _dio.get(ApiUrl.orderMrGetByMrId(mrId));
      final data = response.data;
      if (data is! List) {
        throw Exception('Invalid order list response received from server.');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(Order.fromJson)
          .toList();
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load orders right now.');
    }
  }

  Future<Order> createOrder({
    required String mrId,
    String? distributorId,
    String? chemistShopId,
    String? doctorId,
    required List<Medicine> medicines,
    required double totalAmountRupees,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (distributorId != null && distributorId.trim().isNotEmpty)
          'distributor_id': distributorId,
        if (chemistShopId != null && chemistShopId.trim().isNotEmpty)
          'chemist_shop_id': chemistShopId,
        if (doctorId != null && doctorId.trim().isNotEmpty)
          'doctor_id': doctorId,
        'products_with_price': jsonEncode(
          medicines.map((medicine) => medicine.toJson()).toList(),
        ),
        'total_amount_rupees': totalAmountRupees,
      });

      final response = await _dio.post(
        ApiUrl.orderMrPostByMrId(mrId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid order create response from server.');
      }

      return Order.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to create order right now.');
    }
  }

  Future<Order> updateOrder({
    required String orderId,
    String? distributorId,
    String? chemistShopId,
    String? doctorId,
    List<Medicine>? medicines,
    double? totalAmountRupees,
  }) async {
    try {
      final payload = <String, dynamic>{
        if (distributorId != null) 'distributor_id': distributorId,
        if (chemistShopId != null) 'chemist_shop_id': chemistShopId,
        if (doctorId != null) 'doctor_id': doctorId,
        if (medicines != null)
          'products_with_price': jsonEncode(
            medicines.map((medicine) => medicine.toJson()).toList(),
          ),
        if (totalAmountRupees != null) 'total_amount_rupees': totalAmountRupees,
      };

      final response = await _dio.put(
        ApiUrl.orderMrUpdateByOrderId(orderId),
        data: FormData.fromMap(payload),
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid order update response from server.');
      }

      return Order.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to update order right now.');
    }
  }

  Future<void> deleteOrderById(String orderId) async {
    try {
      await _dio.delete(ApiUrl.orderMrDeleteByOrderId(orderId));
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to delete order right now.');
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
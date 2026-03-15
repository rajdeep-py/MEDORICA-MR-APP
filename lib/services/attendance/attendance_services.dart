import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/attendance.dart';
import '../api_url.dart';

class AttendanceServices {
  AttendanceServices({Dio? dio}) : _dio = dio ?? _buildDio();

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

  Future<List<Attendance>> fetchAttendanceByMrId(String mrId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.attendanceMrGetByMrId(mrId),
      );

      final dynamic body = response.data;
      if (body is! List) {
        throw Exception('Invalid attendance response from server');
      }

      return body
          .whereType<Map<String, dynamic>>()
          .map(Attendance.fromJson)
          .toList()
        ..sort((a, b) {
          final int dateSort = b.date.compareTo(a.date);
          if (dateSort != 0) return dateSort;
          final DateTime aCheckIn =
              a.checkIn ?? DateTime.fromMillisecondsSinceEpoch(0);
          final DateTime bCheckIn =
              b.checkIn ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bCheckIn.compareTo(aCheckIn);
        });
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<List<Attendance>> fetchAllAttendance() async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.attendanceMrGetAll,
      );
      final dynamic body = response.data;
      if (body is! List) {
        throw Exception('Invalid attendance response from server');
      }

      return body
          .whereType<Map<String, dynamic>>()
          .map(Attendance.fromJson)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<Attendance> fetchAttendanceByMrIdAndAttendanceId({
    required String mrId,
    required int attendanceId,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.attendanceMrGetByMrIdAndAttendanceId(mrId, attendanceId),
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid attendance response from server');
      }

      return Attendance.fromJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<Attendance?> fetchTodayAttendanceByMrId(
    String mrId, {
    DateTime? today,
  }) async {
    final DateTime targetDate = today ?? DateTime.now();
    final DateTime normalized = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    final List<Attendance> records = await fetchAttendanceByMrId(mrId);

    for (final Attendance record in records) {
      final DateTime d = DateTime(
        record.date.year,
        record.date.month,
        record.date.day,
      );
      if (d == normalized) {
        return record;
      }
    }

    return null;
  }

  Future<Attendance> createAttendance({
    required String mrId,
    required DateTime attendanceDate,
    String attendanceStatus = 'present',
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInSelfiePath,
    String? checkOutSelfiePath,
  }) async {
    try {
      final Map<String, dynamic> fields = <String, dynamic>{
        'mr_id': mrId,
        'attendance_date': _formatDate(attendanceDate),
        'attendance_status': attendanceStatus,
      };

      if (checkInTime != null) {
        fields['check_in_time'] = checkInTime.toIso8601String();
      }
      if (checkOutTime != null) {
        fields['check_out_time'] = checkOutTime.toIso8601String();
      }

      if (checkInSelfiePath != null && checkInSelfiePath.trim().isNotEmpty) {
        fields['check_in_selfie'] = await MultipartFile.fromFile(
          checkInSelfiePath,
          filename: checkInSelfiePath.split('/').last,
        );
      }

      if (checkOutSelfiePath != null && checkOutSelfiePath.trim().isNotEmpty) {
        fields['check_out_selfie'] = await MultipartFile.fromFile(
          checkOutSelfiePath,
          filename: checkOutSelfiePath.split('/').last,
        );
      }

      final FormData payload = FormData.fromMap(fields);
      final Response<dynamic> response = await _dio.post(
        ApiUrl.attendanceMrPost,
        data: payload,
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid attendance response from server');
      }

      return Attendance.fromJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<Attendance> updateAttendance({
    required String mrId,
    required int attendanceId,
    String? attendanceStatus,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInSelfiePath,
    String? checkOutSelfiePath,
  }) async {
    try {
      final Map<String, dynamic> fields = <String, dynamic>{};

      if (attendanceStatus != null && attendanceStatus.trim().isNotEmpty) {
        fields['attendance_status'] = attendanceStatus;
      }
      if (checkInTime != null) {
        fields['check_in_time'] = checkInTime.toIso8601String();
      }
      if (checkOutTime != null) {
        fields['check_out_time'] = checkOutTime.toIso8601String();
      }

      if (checkInSelfiePath != null && checkInSelfiePath.trim().isNotEmpty) {
        fields['check_in_selfie'] = await MultipartFile.fromFile(
          checkInSelfiePath,
          filename: checkInSelfiePath.split('/').last,
        );
      }

      if (checkOutSelfiePath != null && checkOutSelfiePath.trim().isNotEmpty) {
        fields['check_out_selfie'] = await MultipartFile.fromFile(
          checkOutSelfiePath,
          filename: checkOutSelfiePath.split('/').last,
        );
      }

      final FormData payload = FormData.fromMap(fields);
      final Response<dynamic> response = await _dio.put(
        ApiUrl.attendanceMrUpdateByMrIdAndAttendanceId(mrId, attendanceId),
        data: payload,
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid attendance response from server');
      }

      return Attendance.fromJson(body);
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

  String _formatDate(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }
}

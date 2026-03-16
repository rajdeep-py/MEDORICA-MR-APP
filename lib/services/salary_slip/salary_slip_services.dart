import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart' as open_filex;
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/salary_slip.dart';
import '../api_url.dart';

class SalarySlipServices {
	SalarySlipServices({Dio? dio})
		: _dio =
				dio ??
				Dio(
					BaseOptions(
						baseUrl: ApiUrl.baseUrl,
						connectTimeout: const Duration(seconds: 25),
						receiveTimeout: const Duration(seconds: 25),
						sendTimeout: const Duration(seconds: 25),
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

	Future<SalarySlip> downloadSalarySlipByMrId(String mrId) async {
		final normalizedMrId = mrId.trim();
		if (normalizedMrId.isEmpty) {
			throw Exception('MR ID is required to download salary slip.');
		}

		try {
			final saveDirectory = await _getSaveDirectory();
			final safeMr = normalizedMrId.replaceAll(
				RegExp(r'[^a-zA-Z0-9_-]'),
				'_',
			);
			final fileName = '${safeMr}_salary_slip.pdf';
			final filePath = '${saveDirectory.path}/$fileName';

			await _dio.download(
				ApiUrl.salarySlipDownloadByMrId(normalizedMrId),
				filePath,
				options: Options(responseType: ResponseType.bytes),
			);

			final file = File(filePath);
			if (!await file.exists()) {
				throw Exception('Salary slip could not be saved on device.');
			}

			// Open the PDF file automatically after download
			try {
				// Use open_filex to open the PDF
				await Future.delayed(const Duration(milliseconds: 300)); // Small delay for file system
				await openFile(filePath);
			} catch (_) {}

			return SalarySlip.fromJson({
				'mr_id': normalizedMrId,
				'salary_slip_url': ApiUrl.getFullUrl(
					ApiUrl.salarySlipDownloadByMrId(normalizedMrId),
				),
				'local_file_path': filePath,
			});
		} on DioException catch (error) {
			throw Exception(_extractErrorMessage(error));
		} catch (error) {
			final message = error.toString();
			if (message.startsWith('Exception: ')) {
				throw Exception(message.substring('Exception: '.length));
			}
			throw Exception('Unable to download salary slip right now.');
		}
	}
Future<void> openFile(String filePath) async {
	try {
		// Use open_filex if available, otherwise fallback
		await open_filex.OpenFilex.open(filePath);
	} catch (e) {
		// Optionally handle error or fallback
	}
}

	Future<Directory> _getSaveDirectory() async {
		if (Platform.isAndroid) {
			final dir = await getExternalStorageDirectory();
			if (dir != null) {
				return dir;
			}
		}

		return getApplicationDocumentsDirectory();
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

		return 'Unable to download salary slip right now.';
	}
}

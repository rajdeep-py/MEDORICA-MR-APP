import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/attendance.dart';
import '../notifiers/attendance_notifier.dart';
import '../services/attendance/attendance_services.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'home_provider.dart';

final attendanceServiceProvider = Provider<AttendanceServices>((ref) {
  return AttendanceServices();
});

final attendanceNotifierProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
      return AttendanceNotifier(ref.read(attendanceServiceProvider), ref.read);
    });

final todaysAttendanceProvider = Provider.autoDispose<Attendance?>((ref) {
  return ref.watch(attendanceNotifierProvider).todayAttendance;
});

final attendanceRecordsProvider = Provider.autoDispose<List<Attendance>>((ref) {
  return ref.watch(attendanceNotifierProvider).records;
});

final attendanceLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(attendanceNotifierProvider).isLoading;
});

final attendanceSubmittingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(attendanceNotifierProvider).isSubmitting;
});

final attendanceErrorProvider = Provider.autoDispose<String?>((ref) {
  return ref.watch(attendanceNotifierProvider).error;
});

final selectedMonthAttendancesProvider = Provider.autoDispose<List<Attendance>>(
  (ref) {
    final DateTime selectedMonth = ref.watch(homeSelectedMonthProvider);
    final List<Attendance> records = ref.watch(attendanceRecordsProvider);

    return records
        .where(
          (record) =>
              record.date.year == selectedMonth.year &&
              record.date.month == selectedMonth.month,
        )
        .toList();
  },
);

final selectedMonthAttendanceCountProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(selectedMonthAttendancesProvider).length;
});

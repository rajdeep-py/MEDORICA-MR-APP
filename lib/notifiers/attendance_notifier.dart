import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';

import '../models/attendance.dart';
import '../provider/auth_provider.dart';
import '../services/attendance/attendance_services.dart';

typedef Reader = T Function<T>(ProviderListenable<T> provider);

class AttendanceState {
  final List<Attendance> records;
  final Attendance? todayAttendance;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  const AttendanceState({
    this.records = const <Attendance>[],
    this.todayAttendance,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  AttendanceState copyWith({
    List<Attendance>? records,
    Attendance? todayAttendance,
    bool clearTodayAttendance = false,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
  }) {
    return AttendanceState(
      records: records ?? this.records,
      todayAttendance: clearTodayAttendance
          ? null
          : (todayAttendance ?? this.todayAttendance),
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier(this._attendanceServices, this._read)
    : super(const AttendanceState());

  final AttendanceServices _attendanceServices;
  final Reader _read;

  Future<void> loadCurrentMrAttendance() async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isSubmitting: false,
        clearTodayAttendance: true,
        records: <Attendance>[],
        error: 'No logged in MR found',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final List<Attendance> records = await _attendanceServices
          .fetchAttendanceByMrId(mrId);
      state = state.copyWith(
        records: records,
        todayAttendance: _findTodayRecord(records),
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> checkIn({required String photoPath}) async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      state = state.copyWith(error: 'No logged in MR found');
      return;
    }

    if (state.todayAttendance?.isCheckedIn == true) {
      state = state.copyWith(error: 'You are already checked in for today');
      return;
    }

    final DateTime now = DateTime.now();
    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final Attendance created = await _attendanceServices.createAttendance(
        mrId: mrId,
        attendanceDate: now,
        attendanceStatus: 'present',
        checkInTime: now,
        checkInSelfiePath: photoPath,
      );

      final List<Attendance> updated = <Attendance>[created, ...state.records];

      state = state.copyWith(
        records: _sortRecords(updated),
        todayAttendance: created,
        isSubmitting: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );

      // If backend reports duplicate attendance, refresh state to reflect server truth.
      final String message = e.toString().toLowerCase();
      if (message.contains('already exists')) {
        await loadCurrentMrAttendance();
      }
    }
  }

  Future<void> checkOut({required String photoPath}) async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      state = state.copyWith(error: 'No logged in MR found');
      return;
    }

    final Attendance? today = state.todayAttendance;
    if (today == null || !today.isCheckedIn) {
      state = state.copyWith(error: 'Please check in first');
      return;
    }
    if (today.isCheckedOut) {
      state = state.copyWith(error: 'You are already checked out for today');
      return;
    }
    if (today.id == null) {
      state = state.copyWith(
        error: 'Attendance id is missing. Please refresh and try again.',
      );
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final Attendance updated = await _attendanceServices.updateAttendance(
        mrId: mrId,
        attendanceId: today.id!,
        checkOutTime: DateTime.now(),
        checkOutSelfiePath: photoPath,
      );

      final List<Attendance> nextRecords = state.records.map((Attendance item) {
        if (item.id == updated.id) {
          return updated;
        }
        return item;
      }).toList();

      state = state.copyWith(
        records: _sortRecords(nextRecords),
        todayAttendance: updated,
        isSubmitting: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Attendance? _findTodayRecord(List<Attendance> records) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    for (final Attendance record in records) {
      final DateTime d = DateTime(
        record.date.year,
        record.date.month,
        record.date.day,
      );
      if (d == today) {
        return record;
      }
    }
    return null;
  }

  List<Attendance> _sortRecords(List<Attendance> records) {
    final List<Attendance> sorted = List<Attendance>.from(records);
    sorted.sort((a, b) {
      final int byDate = b.date.compareTo(a.date);
      if (byDate != 0) return byDate;
      final DateTime aCheckIn =
          a.checkIn ?? DateTime.fromMillisecondsSinceEpoch(0);
      final DateTime bCheckIn =
          b.checkIn ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bCheckIn.compareTo(aCheckIn);
    });
    return sorted;
  }
}

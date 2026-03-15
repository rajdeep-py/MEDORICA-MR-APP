import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';
import '../models/monthly_target.dart';
import '../provider/auth_provider.dart';
import '../services/attendance/attendance_services.dart';
import '../services/monthly_target/monthly_target_services.dart';

class HomeState {
  final DateTime selectedMonth;
  final Map<String, HomeMonthlyTarget> monthlyTargets;
  final bool isLoading;
  final String? error;

  const HomeState({
    required this.selectedMonth,
    required this.monthlyTargets,
    this.isLoading = false,
    this.error,
  });

  HomeMonthlyTarget get selectedMonthTarget {
    final key = _monthKey(selectedMonth.year, selectedMonth.month);
    return monthlyTargets[key] ??
        HomeMonthlyTarget(
          month: DateTime(selectedMonth.year, selectedMonth.month),
          targetAmount: 0,
          achievedAmount: 0,
        );
  }

  HomeState copyWith({
    DateTime? selectedMonth,
    Map<String, HomeMonthlyTarget>? monthlyTargets,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      monthlyTargets: monthlyTargets ?? this.monthlyTargets,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier({
    AttendanceServices? attendanceServices,
    MonthlyTargetServices? monthlyTargetServices,
  }) : _attendanceServices = attendanceServices ?? AttendanceServices(),
       _monthlyTargetServices =
           monthlyTargetServices ?? MonthlyTargetServices(),
       super(
         HomeState(
           selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
           monthlyTargets: const {},
         ),
       );

  final AttendanceServices _attendanceServices;
  final MonthlyTargetServices _monthlyTargetServices;
  String? _activemrId;

  Future<void> syncAsm(String? mrId) async {
    final nextmrId = mrId?.trim();
    if (nextmrId == null || nextmrId.isEmpty) {
      _activemrId = null;
      state = state.copyWith(
        monthlyTargets: const {},
        isLoading: false,
        error: null,
      );
      return;
    }

    if (_activemrId == nextmrId &&
        (state.monthlyTargets.isNotEmpty || state.isLoading)) {
      return;
    }

    _activemrId = nextmrId;
    await loadMonthlyTargetsBymrId(nextmrId);
  }

  void setSelectedMonthYear({required int year, required int month}) {
    state = state.copyWith(selectedMonth: DateTime(year, month));

    final mrId = _activemrId;
    if (mrId != null && mrId.isNotEmpty) {
      unawaited(
        loadMonthlyTargetByAsmYearMonth(mrId: mrId, year: year, month: month),
      );
    }
  }

  Future<void> loadMonthlyTargetsBymrId(String mrId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final targets = await _monthlyTargetServices.fetchMonthlyTargetsBymrId(
        mrId,
      );
      state = state.copyWith(
        monthlyTargets: {for (final target in targets) target.monthKey: target},
        isLoading: false,
        error: null,
      );

      final selected = state.selectedMonth;
      await loadMonthlyTargetByAsmYearMonth(
        mrId: mrId,
        year: selected.year,
        month: selected.month,
      );
    } catch (error) {
      state = state.copyWith(
        monthlyTargets: const {},
        isLoading: false,
        error: _readErrorMessage(error),
      );
    }
  }

  Future<void> loadMonthlyTargetByAsmYearMonth({
    required String mrId,
    required int year,
    required int month,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final target = await _monthlyTargetServices
          .fetchMonthlyTargetByAsmYearMonth(
            mrId: mrId,
            year: year,
            month: month,
          );
      upsertMonthlyTarget(target);
      state = state.copyWith(isLoading: false, error: null);
    } catch (error) {
      final message = _readErrorMessage(error);
      if (message.toLowerCase().contains('monthly target not found')) {
        upsertMonthlyTarget(
          HomeMonthlyTarget(
            month: DateTime(year, month),
            targetAmount: 0,
            achievedAmount: 0,
          ),
        );
        state = state.copyWith(isLoading: false, error: null);
        return;
      }

      state = state.copyWith(isLoading: false, error: message);
    }
  }

  void upsertMonthlyTarget(HomeMonthlyTarget target) {
    final updatedTargets = Map<String, HomeMonthlyTarget>.from(
      state.monthlyTargets,
    )..[target.monthKey] = target;

    state = state.copyWith(monthlyTargets: updatedTargets);
  }

  void updateAchievedAmount({
    required int year,
    required int month,
    required double achievedAmount,
  }) {
    final key = _monthKey(year, month);
    final existing =
        state.monthlyTargets[key] ??
        HomeMonthlyTarget(
          month: DateTime(year, month),
          targetAmount: 0,
          achievedAmount: 0,
        );

    upsertMonthlyTarget(existing.copyWith(achievedAmount: achievedAmount));
  }

  Future<Attendance?> fetchTodaysAttendance(String mrId) {
    return _attendanceServices.fetchTodayAttendanceByMrId(mrId);
  }

  String _readErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }
}

String _monthKey(int year, int month) {
  final monthString = month.toString().padLeft(2, '0');
  return '$year-$monthString';
}

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  final notifier = HomeNotifier();

  ref.listen(authNotifierProvider, (previous, next) {
    final mrId = next.mr?.mrId;
    if (!next.isAuthenticated || mrId == null) {
      notifier.syncAsm(null);
      return;
    }
    notifier.syncAsm(mrId);
  }, fireImmediately: true);

  return notifier;
});
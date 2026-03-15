import '../models/attendance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/monthly_target.dart';
import '../notifiers/home_notifier.dart';
import 'auth_provider.dart';

final homeProvider = Provider<HomeMonthlyTarget>((ref) {
  final homeState = ref.watch(homeNotifierProvider);
  return homeState.selectedMonthTarget;
});

final homeSelectedMonthProvider = Provider<DateTime>((ref) {
  final homeState = ref.watch(homeNotifierProvider);
  return homeState.selectedMonth;
});

final homeMonthlyTargetLoadingProvider = Provider<bool>((ref) {
  return ref.watch(homeNotifierProvider).isLoading;
});

final homeMonthlyTargetErrorProvider = Provider<String?>((ref) {
  return ref.watch(homeNotifierProvider).error;
});

final homeTodaysAttendanceProvider = FutureProvider<Attendance?>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final mrId = authState.mr?.mrId;
  if (mrId == null || mrId.isEmpty) {
    return null;
  }

  return ref.read(homeNotifierProvider.notifier).fetchTodaysAttendance(mrId);
});
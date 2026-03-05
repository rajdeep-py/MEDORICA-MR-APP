import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/monthly_target.dart';
import '../notifiers/home_notifier.dart';

final homeProvider = Provider<HomeMonthlyTarget>((ref) {
  final homeState = ref.watch(homeNotifierProvider);
  return homeState.selectedMonthTarget;
});

final homeSelectedMonthProvider = Provider<DateTime>((ref) {
  final homeState = ref.watch(homeNotifierProvider);
  return homeState.selectedMonth;
});
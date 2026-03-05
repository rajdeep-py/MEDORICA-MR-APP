import 'package:flutter_riverpod/legacy.dart';
import '../models/monthly_target.dart';

class HomeState {
  final DateTime selectedMonth;
  final Map<String, HomeMonthlyTarget> monthlyTargets;

  const HomeState({
    required this.selectedMonth,
    required this.monthlyTargets,
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
  }) {
    return HomeState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      monthlyTargets: monthlyTargets ?? this.monthlyTargets,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier()
      : super(
          HomeState(
            selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
            monthlyTargets: _seedMonthlyTargets(),
          ),
        );

  static Map<String, HomeMonthlyTarget> _seedMonthlyTargets() {
    final now = DateTime.now();
    final current = DateTime(now.year, now.month);
    final previous = DateTime(now.year, now.month - 1);
    final next = DateTime(now.year, now.month + 1);

    final targets = <HomeMonthlyTarget>[
      HomeMonthlyTarget(
        month: previous,
        targetAmount: 120000,
        achievedAmount: 96000,
      ),
      HomeMonthlyTarget(
        month: current,
        targetAmount: 150000,
        achievedAmount: 87500,
      ),
      HomeMonthlyTarget(
        month: next,
        targetAmount: 165000,
        achievedAmount: 22500,
      ),
    ];

    return {
      for (final target in targets) target.monthKey: target,
    };
  }

  void setSelectedMonthYear({required int year, required int month}) {
    state = state.copyWith(selectedMonth: DateTime(year, month));
  }

  void upsertMonthlyTarget(HomeMonthlyTarget target) {
    final updatedTargets = Map<String, HomeMonthlyTarget>.from(state.monthlyTargets)
      ..[target.monthKey] = target;

    state = state.copyWith(monthlyTargets: updatedTargets);
  }

  void updateAchievedAmount({required int year, required int month, required double achievedAmount}) {
    final key = _monthKey(year, month);
    final existing = state.monthlyTargets[key] ??
        HomeMonthlyTarget(
          month: DateTime(year, month),
          targetAmount: 0,
          achievedAmount: 0,
        );

    upsertMonthlyTarget(existing.copyWith(achievedAmount: achievedAmount));
  }
}

String _monthKey(int year, int month) {
  final monthString = month.toString().padLeft(2, '0');
  return '$year-$monthString';
}

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
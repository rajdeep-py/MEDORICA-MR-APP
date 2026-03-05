class HomeMonthlyTarget {
	final DateTime month;
	final double targetAmount;
	final double achievedAmount;

	const HomeMonthlyTarget({
		required this.month,
		required this.targetAmount,
		required this.achievedAmount,
	});

	double get remainingAmount {
		final remaining = targetAmount - achievedAmount;
		return remaining < 0 ? 0 : remaining;
	}

	double get achievedPercentage {
		if (targetAmount <= 0) return 0;
		final ratio = achievedAmount / targetAmount;
		if (ratio < 0) return 0;
		if (ratio > 1) return 1;
		return ratio;
	}

	String get monthKey {
		final monthString = month.month.toString().padLeft(2, '0');
		return '${month.year}-$monthString';
	}

	HomeMonthlyTarget copyWith({
		DateTime? month,
		double? targetAmount,
		double? achievedAmount,
	}) {
		return HomeMonthlyTarget(
			month: month ?? this.month,
			targetAmount: targetAmount ?? this.targetAmount,
			achievedAmount: achievedAmount ?? this.achievedAmount,
		);
	}
}
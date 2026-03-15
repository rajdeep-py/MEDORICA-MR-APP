class HomeMonthlyTarget {
  final DateTime month;
  final double targetAmount;
  final double achievedAmount;
  final double? apiRemainingAmount;
  final String mrId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const HomeMonthlyTarget({
    required this.month,
    required this.targetAmount,
    required this.achievedAmount,
    this.apiRemainingAmount,
    this.mrId = '',
    this.createdAt,
    this.updatedAt,
  });

  factory HomeMonthlyTarget.fromJson(Map<String, dynamic> json) {
    final year = _readInt(json['year']) ?? DateTime.now().year;
    final month = _readInt(json['month']) ?? DateTime.now().month;

    return HomeMonthlyTarget(
      month: DateTime(year, month),
      targetAmount: _readDouble(json['opening_target_rupees']) ?? 0,
      achievedAmount: _readDouble(json['deducted_target_rupees']) ?? 0,
      apiRemainingAmount: _readDouble(json['remaining_target_rupees']),
      mrId: _readString(json['mr_id']) ?? '',
      createdAt: _readDateTime(json['created_at']),
      updatedAt: _readDateTime(json['updated_at']),
    );
  }

  double get remainingAmount {
    if (apiRemainingAmount != null) {
      return apiRemainingAmount! < 0 ? 0 : apiRemainingAmount!;
    }
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
    double? apiRemainingAmount,
    String? mrId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HomeMonthlyTarget(
      month: month ?? this.month,
      targetAmount: targetAmount ?? this.targetAmount,
      achievedAmount: achievedAmount ?? this.achievedAmount,
      apiRemainingAmount: apiRemainingAmount ?? this.apiRemainingAmount,
      mrId: mrId ?? this.mrId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

String? _readString(dynamic value) {
  if (value == null) {
    return null;
  }
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int? _readInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  return int.tryParse(value.toString());
}

double? _readDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  return double.tryParse(value.toString());
}

DateTime? _readDateTime(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value.isUtc ? value.toLocal() : value;
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    return null;
  }

  return parsed.isUtc ? parsed.toLocal() : parsed;
}
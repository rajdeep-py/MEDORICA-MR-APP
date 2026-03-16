import 'package:flutter/material.dart';
import '../../models/attendance.dart';
import '../../theme/app_theme.dart';

class ReportCard extends StatelessWidget {
  final Attendance attendance;

  const ReportCard({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Attendance Report', style: AppTypography.h3.copyWith(color: AppColors.primary)),
          const SizedBox(height: AppSpacing.md),
          Text('Status: ${attendance.status}', style: AppTypography.bodyLarge),
          Text('Check In: ${attendance.checkIn?.toString() ?? 'N/A'}', style: AppTypography.body),
          Text('Check Out: ${attendance.checkOut?.toString() ?? 'N/A'}', style: AppTypography.body),
        ],
      ),
    );
  }
}

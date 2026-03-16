import 'package:flutter/material.dart';
import '../../models/attendance.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class ReportCard extends StatelessWidget {
    String _formatDateWithSuffix(DateTime dt) {
      final day = dt.day;
      final suffix = _getDaySuffix(day);
      final month = _monthName(dt.month);
      return '$day$suffix $month ${dt.year}';
    }

    String _getDaySuffix(int day) {
      if (day >= 11 && day <= 13) return 'th';
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    String _monthName(int month) {
      const months = [
        '',
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return months[month];
    }
  final Attendance attendance;

  const ReportCard({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final isPresent = attendance.status.toLowerCase() == 'present';
    final statusColor = isPresent ? AppColors.success : AppColors.error;
    final statusIcon = isPresent ? Iconsax.tick_circle : Iconsax.close_circle;
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
          Row(
            children: [
              Icon(Iconsax.document, color: AppColors.primary, size: 24),
              const SizedBox(width: AppSpacing.md),
              Text('Attendance Report', style: AppTypography.h3.copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isPresent ? 'Present' : 'Absent',
                style: AppTypography.bodyLarge.copyWith(color: statusColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Iconsax.login, color: AppColors.primary, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Check In:',
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                attendance.checkIn != null
                    ? _formatTime(attendance.checkIn!)
                    : 'N/A',
                style: AppTypography.body.copyWith(color: AppColors.quaternary),
              ),
              if (attendance.checkIn != null)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md),
                  child: Text(
                    _formatDateWithSuffix(attendance.checkIn!),
                    style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Iconsax.logout, color: AppColors.primary, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Check Out:',
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                attendance.checkOut != null
                    ? _formatTime(attendance.checkOut!)
                    : 'N/A',
                style: AppTypography.body.copyWith(color: AppColors.quaternary),
              ),
              if (attendance.checkOut != null)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md),
                  child: Text(
                    _formatDateWithSuffix(attendance.checkOut!),
                    style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    // Indian format: dd-MM-yyyy hh:mm a
    return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year} '
      '${_formatHour(dt.hour)}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _formatHour(int hour) {
    final h = hour % 12;
    return h == 0 ? '12' : h.toString().padLeft(2, '0');
  }
}

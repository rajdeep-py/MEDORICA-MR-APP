import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../cards/month_plan/calendar_card.dart';
import '../../cards/month_plan/plan_card.dart';
import '../../theme/app_theme.dart';
import '../../provider/month_plan_provider.dart';

class MonthPlanScreen extends ConsumerWidget {
  const MonthPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Monthly Planning',
        subtitleText: 'Organize your visits and tasks',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calendar Card
            const CalendarCard(),
            
            // Plan Card (shown when a date is selected)
            if (selectedDate != null) ...[
              const SizedBox(height: AppSpacing.lg),
              PlanCard(date: selectedDate),
            ],
            
            // Instruction text when no date is selected
            if (selectedDate == null) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.touch_app_outlined,
                      size: 48,
                      color: AppColors.quaternary.withAlpha(150),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Select a date with a dot',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tap on any date marked with a dot to view your planned activities for that day',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.quaternary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

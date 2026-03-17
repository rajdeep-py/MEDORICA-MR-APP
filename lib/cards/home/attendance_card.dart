import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import '../../provider/attendance_provider.dart';
import '../../services/api_url.dart';

class MRAttendanceCard extends ConsumerStatefulWidget {
  const MRAttendanceCard({super.key});

  @override
  ConsumerState<MRAttendanceCard> createState() => _MRAttendanceCardState();
}

class _MRAttendanceCardState extends ConsumerState<MRAttendanceCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(attendanceNotifierProvider.notifier).loadCurrentMrAttendance();
    });
  }

  String _formatTime(DateTime? t) {
    if (t == null) return '-';
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<XFile?> _takeSelfie() async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 75,
      );
      return file;
    } catch (_) {
      return null;
    }
  }

  Future<void> _onCheckInPressed(BuildContext context) async {
    final file = await _takeSelfie();
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selfie required to Check In.')),
      );
      return;
    }

    await ref
        .read(attendanceNotifierProvider.notifier)
        .checkIn(photoPath: file.path);
    final String? error = ref.read(attendanceErrorProvider);
    if (!mounted) return;

    if (error != null && error.trim().isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Checked in successfully.')));
  }

  Future<void> _onCheckOutPressed(BuildContext context) async {
    final file = await _takeSelfie();
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selfie required to Check Out.')),
      );
      return;
    }

    await ref
        .read(attendanceNotifierProvider.notifier)
        .checkOut(photoPath: file.path);
    final String? error = ref.read(attendanceErrorProvider);
    if (!mounted) return;

    if (error != null && error.trim().isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Checked out successfully.')));
  }

  Widget _buildSelfiePreview(String path) {
    final String trimmed = path.trim();
    final bool isHttp =
        trimmed.startsWith('http://') || trimmed.startsWith('https://');
    final bool isBackendRelative =
        trimmed.startsWith('/') || trimmed.startsWith('uploads/');

    if (isHttp || isBackendRelative) {
      final String url = isHttp ? trimmed : ApiUrl.getFullUrl(trimmed);
      return Image.network(
        url,
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(trimmed),
      width: double.infinity,
      height: 160,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendance = ref.watch(todaysAttendanceProvider);
    ref.read(attendanceNotifierProvider.notifier);
    final bool isLoading = ref.watch(attendanceLoadingProvider);
    final bool isSubmitting = ref.watch(attendanceSubmittingProvider);
    final String? error = ref.watch(attendanceErrorProvider);
    ref.watch(
      selectedMonthAttendanceCountProvider,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: LinearProgressIndicator(minHeight: 3),
              ),
            Row(
              children: [
                Text(
                  'Attendance',
                  style: AppTypography.h3.copyWith(color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              AppBorderRadius.lg,
                            ),
                          ),
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(
                                      AppSpacing.sm,
                                    ),
                                    decoration: AppCardStyles.minimalCard(
                                      backgroundColor: AppColors.primaryLight,
                                    ),
                                    child: Icon(
                                      Icons.info_outline,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      'How attendance works',
                                      style: AppTypography.h3.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                '• A selfie is taken using your front camera.',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.quaternary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                '• Each selfie is saved with a timestamp and attached to your attendance record.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.quaternary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                '• Photos are used only for verification and may be retained according to company policy.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.quaternary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                '• You must check out with a selfie to complete the day\'s record.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.quaternary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    minimumSize: const Size(0, 36),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Close'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
                const Spacer(),
                if (attendance != null && attendance.isCheckedIn)
                  Text(
                    'Checked in at ${_formatTime(attendance.checkIn)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.quaternary,
                    ),
                  ),
              ],
            ),
           
            const SizedBox(height: AppSpacing.xs),
            Text(
              'We capture a timestamped selfie as proof of your visit. The photo and time are stored securely and used by your organization for verification.',
              style: AppTypography.description.copyWith(
                color: AppColors.quaternary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            if (error != null && error.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  error,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),

            if (attendance == null || !attendance.isCheckedIn) ...[
              ElevatedButton.icon(
                style: AppButtonStyles.primaryButton(),
                onPressed: isSubmitting
                    ? null
                    : () => _onCheckInPressed(context),
                icon: const Icon(Iconsax.camera),
                label: Text(isSubmitting ? 'Checking in...' : 'Check In Now!'),
              ),
            ] else if (attendance.isCheckedIn && !attendance.isCheckedOut) ...[
              if (attendance.checkInPhotoPath != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: AppBorderRadius.mdRadius,
                        child: _buildSelfiePreview(
                          attendance.checkInPhotoPath!,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Selfie captured at ${_formatTime(attendance.checkIn)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                    ],
                  ),
                ),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                  elevation: AppElevation.sm,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.lgRadius,
                  ),
                ),
                onPressed: isSubmitting
                    ? null
                    : () => _onCheckOutPressed(context),
                icon: const Icon(Iconsax.camera),
                label: Text(isSubmitting ? 'Submitting...' : 'Check Out...'),
              ),
            ] else ...[
              Text(
                'You have checked out for today at ${_formatTime(attendance.checkOut)}.',
                style: AppTypography.body,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (attendance.checkOutPhotoPath != null)
                ClipRRect(
                  borderRadius: AppBorderRadius.mdRadius,
                  child: _buildSelfiePreview(attendance.checkOutPhotoPath!),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

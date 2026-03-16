import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/team.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class TeamMemberDetailsScreen extends StatelessWidget {
  final List<TeamMember> members;
  const TeamMemberDetailsScreen({required this.members, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Team Members',
        subtitleText: 'Know your team better',
        onBack: () => context.pop(),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final m = members[index];
          final String? photoUrl = m.profilePhoto != null
              ? ApiUrl.getFullUrl(m.profilePhoto!)
              : null;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            elevation: 4,
            color: AppColors.white,
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingHorizontal,
              vertical: AppSpacing.md,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                    radius: 36,
                    backgroundColor: AppColors.primaryLight,
                    child: photoUrl == null ? Icon(Iconsax.user, color: AppColors.primary, size: 32) : null,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.fullName, style: AppTypography.h3.copyWith(color: AppColors.primary)),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(Iconsax.call, size: 18, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(m.phoneNo, style: AppTypography.bodySmall),
                          ],
                        ),
                        if (m.altPhoneNo != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Icon(Iconsax.call_add, size: 18, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(m.altPhoneNo!, style: AppTypography.bodySmall),
                              ],
                            ),
                          ),
                        if (m.email != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Icon(Iconsax.sms, size: 18, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(m.email!, style: AppTypography.bodySmall),
                              ],
                            ),
                          ),
                        if (m.headquarterAssigned != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Icon(Iconsax.location, size: 18, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(m.headquarterAssigned!, style: AppTypography.bodySmall),
                              ],
                            ),
                          ),
                        if (m.territoriesOfWork != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Iconsax.map, size: 18, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    m.territoriesOfWork!.join(", "),
                                    style: AppTypography.bodySmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (m.address != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Iconsax.home, size: 18, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    m.address!,
                                    style: AppTypography.bodySmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

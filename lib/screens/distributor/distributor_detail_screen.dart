import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/distributor/distributor_contact_card.dart';
import '../../cards/distributor/distributor_description_card.dart';
import '../../cards/distributor/distributor_header_card.dart';
import '../../cards/distributor/distributor_order_info_card.dart';
import '../../provider/distributor_provider.dart';
import '../../theme/app_theme.dart';

class DistributorDetailScreen extends ConsumerWidget {
  final String distributorId;

  const DistributorDetailScreen({super.key, required this.distributorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distributor = ref.watch(distributorDetailProvider(distributorId));

    if (distributor == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_circle_left,
                color: AppColors.primary),
            onPressed: () => context.go('/mr/distributor'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Iconsax.info_circle,
                size: 80,
                color: AppColors.quaternary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Distributor not found',
                style: AppTypography.h3.copyWith(
                  color: AppColors.quaternary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_circle_left,
                  color: AppColors.white),
              onPressed: () => context.go('/mr/distributor'),
            ),
            title: Text(
              'Distributor Details',
              style: AppTypography.h3.copyWith(color: AppColors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: DistributorHeaderCard(distributor: distributor),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Info Card
                  DistributorOrderInfoCard(
                    distributor: distributor,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Description Card
                  DistributorDescriptionCard(
                    description: distributor.description,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Contact Card
                  DistributorContactCard(distributor: distributor),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

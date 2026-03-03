import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mr_app/cards/home/home_footer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cards/profile/profile_header_card.dart';
import '../../cards/profile/profile_options_card.dart';
import '../../provider/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'My Profile',
        subtitleText: 'View and manage your profile',
        onBack: () => context.pop(),
      ),
      body: profile == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  ProfileHeaderCard(profile: profile),

                  const SizedBox(height: AppSpacing.lg),

                  // Profile Options
                  ProfileOptionsCard(
                    onUpdateProfile: () {
                      context.push('/profile/update');
                    },
                    onAboutUs: () {
                      context.push('/about-us');
                    },
                    onContactSupport: () {
                      _launchPhoneDialer('+916289398298');
                    },
                    onNotifications: () {
                      context.push('/notifications');
                    },
                  ),

                  const SizedBox(height: AppSpacing.xl),
                  HomeFooter()
                ],
              ),
            ),
    );
  }
}

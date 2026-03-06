import 'package:flutter_riverpod/legacy.dart';
import '../models/visual_ads.dart';

class VisualAdsNotifier extends StateNotifier<List<VisualAd>> {
  VisualAdsNotifier()
      : super([
          VisualAd(
            id: 'ad_001',
            title: 'Campaign Banner 1',
            imagePath: 'assets/images/asm_role.png',
            category: 'Campaign',
            createdAt: DateTime.now().subtract(const Duration(days: 10)),
          ),
          VisualAd(
            id: 'ad_002',
            title: 'Product Showcase',
            imagePath: 'assets/images/home_footer.png',
            category: 'Product',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          VisualAd(
            id: 'ad_003',
            title: 'Promotional Offer',
            imagePath: 'assets/images/mr_role.png',
            category: 'Promotion',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          VisualAd(
            id: 'ad_004',
            title: 'Campaign Banner 2',
            imagePath: 'assets/logo/logo.png',
            category: 'Campaign',
            createdAt: DateTime.now(),
          ),
        ]);

  void addVisualAd(VisualAd ad) {
    state = [...state, ad];
  }

  void removeVisualAd(String id) {
    state = state.where((ad) => ad.id != id).toList();
  }

  void updateVisualAd(VisualAd ad) {
    state = [
      for (final existingAd in state) existingAd.id == ad.id ? ad : existingAd,
    ];
  }
}

final visualAdsNotifierProvider =
    StateNotifierProvider<VisualAdsNotifier, List<VisualAd>>((ref) {
  return VisualAdsNotifier();
});
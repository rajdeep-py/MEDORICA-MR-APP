import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/visual_ads.dart';
import '../notifiers/visual_ads_notifier.dart';

final visualAdsProvider = StateNotifierProvider<VisualAdsNotifier, List<VisualAd>>(
  (ref) => VisualAdsNotifier(),
);

final visualAdsCategoriesProvider = Provider<List<String>>((ref) {
  final ads = ref.watch(visualAdsProvider);
  final categories = ads.map((ad) => ad.category).toSet().toList();
  categories.sort();
  return categories;
});

final filteredVisualAdsProvider = StateProvider<String?>((ref) => null);

final visualAdsFilteredProvider = Provider<List<VisualAd>>((ref) {
  final ads = ref.watch(visualAdsProvider);
  final selectedCategory = ref.watch(filteredVisualAdsProvider);

  if (selectedCategory == null || selectedCategory.isEmpty) {
    return ads;
  }

  return ads.where((ad) => ad.category == selectedCategory).toList();
});
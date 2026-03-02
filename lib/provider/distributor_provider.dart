import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/distributor.dart';
import '../notifiers/distributor_notifier.dart';

// Provider for the list of distributors
final distributorProvider =
    StateNotifierProvider<DistributorNotifier, List<Distributor>>((ref) {
  return DistributorNotifier();
});

// Provider for a single distributor by ID
final distributorDetailProvider =
    Provider.family<Distributor?, String>((ref, id) {
  final distributors = ref.watch(distributorProvider);
  try {
    return distributors.firstWhere((distributor) => distributor.id == id);
  } catch (e) {
    return null;
  }
});

// Provider for searched distributors
final searchDistributorProvider =
    Provider.family<List<Distributor>, String>((ref, query) {
  final distributors = ref.watch(distributorProvider);
  if (query.isEmpty) return distributors;
  final lowerQuery = query.toLowerCase();
  return distributors
      .where((distributor) =>
          distributor.name.toLowerCase().contains(lowerQuery) ||
          distributor.location.toLowerCase().contains(lowerQuery))
      .toList();
});

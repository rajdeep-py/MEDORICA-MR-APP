import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/distributor.dart';
import '../notifiers/distributor_notifier.dart';
import '../services/distributor/distributor_services.dart';

final distributorServicesProvider = Provider<DistributorServices>((ref) {
  return DistributorServices();
});

final distributorNotifierProvider =
    StateNotifierProvider<DistributorNotifier, DistributorState>((ref) {
      final notifier = DistributorNotifier(
        ref.read(distributorServicesProvider),
      );
      unawaited(notifier.loadDistributors());
      return notifier;
    });

final distributorListProvider = Provider<List<Distributor>>((ref) {
  return ref.watch(distributorNotifierProvider).distributors;
});

final distributorLoadingProvider = Provider<bool>((ref) {
  return ref.watch(distributorNotifierProvider).isLoading;
});

final distributorErrorProvider = Provider<String?>((ref) {
  return ref.watch(distributorNotifierProvider).error;
});

final filteredDistributorsProvider = StateProvider<List<Distributor>>((ref) {
  return ref.watch(distributorListProvider);
});

final distributorByIdProvider = FutureProvider.family<Distributor?, String>((
  ref,
  id,
) async {
  final distributors = ref.watch(distributorListProvider);
  for (final distributor in distributors) {
    if (distributor.id == id) {
      return distributor;
    }
  }

  return ref
      .read(distributorNotifierProvider.notifier)
      .fetchDistributorById(id);
});
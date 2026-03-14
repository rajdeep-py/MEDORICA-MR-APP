import 'package:flutter_riverpod/legacy.dart';

import '../models/distributor.dart';
import '../services/distributor/distributor_services.dart';

class DistributorState {
  final List<Distributor> distributors;
  final bool isLoading;
  final String? error;

  const DistributorState({
    this.distributors = const [],
    this.isLoading = false,
    this.error,
  });

  DistributorState copyWith({
    List<Distributor>? distributors,
    bool? isLoading,
    String? error,
  }) {
    return DistributorState(
      distributors: distributors ?? this.distributors,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DistributorNotifier extends StateNotifier<DistributorState> {
  DistributorNotifier(this._distributorServices)
    : super(const DistributorState());

  final DistributorServices _distributorServices;

  Future<void> loadDistributors({bool forceRefresh = false}) async {
    if (!forceRefresh && state.distributors.isNotEmpty) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final distributors = await _distributorServices.fetchAllDistributors();
      state = state.copyWith(
        distributors: distributors,
        isLoading: false,
        error: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
    }
  }

  Future<Distributor?> fetchDistributorById(String id) async {
    for (final distributor in state.distributors) {
      if (distributor.id == id) {
        return distributor;
      }
    }

    try {
      final distributor = await _distributorServices.fetchDistributorById(id);
      state = state.copyWith(
        distributors: [...state.distributors, distributor],
        error: null,
      );
      return distributor;
    } catch (error) {
      state = state.copyWith(error: _readErrorMessage(error));
      rethrow;
    }
  }

  String _readErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }
}
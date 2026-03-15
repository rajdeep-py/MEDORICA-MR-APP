import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../notifiers/order_notifier.dart';
import '../models/order.dart';
import '../services/order/order_services.dart';
import 'auth_provider.dart';

final orderServicesProvider = Provider<OrderServices>((ref) {
  return OrderServices();
});

final orderNotifierProvider = StateNotifierProvider<OrderNotifier, OrderState>((
  ref,
) {
  final notifier = OrderNotifier(ref.read(orderServicesProvider));

  ref.listen(authNotifierProvider, (previous, next) {
    final mrId = next.mr?.mrId;
    if (!next.isAuthenticated || mrId == null) {
      notifier.syncAsm(null);
      return;
    }
    notifier.syncAsm(mrId);
  }, fireImmediately: true);

  return notifier;
});

final orderListProvider = Provider<List<Order>>((ref) {
  return ref.watch(orderNotifierProvider).orders;
});

final orderLoadingProvider = Provider<bool>((ref) {
  return ref.watch(orderNotifierProvider).isLoading;
});

final orderErrorProvider = Provider<String?>((ref) {
  return ref.watch(orderNotifierProvider).error;
});

final filteredOrdersProvider = StateProvider<List<Order>>((ref) {
  return ref.watch(orderListProvider);
});

final orderByIdProvider = Provider.family<Order?, String>((ref, id) {
  final orders = ref.watch(orderListProvider);
  try {
    return orders.firstWhere((order) => order.id == id);
  } catch (e) {
    return null;
  }
});
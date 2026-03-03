import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/order.dart';
import '../notifiers/order_notifier.dart';

// Provider for the list of orders
final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier();
});

// Provider for a single order by ID
final orderDetailProvider = Provider.family<Order?, String>((ref, id) {
  final orders = ref.watch(orderProvider);
  try {
    return orders.firstWhere((order) => order.id == id);
  } catch (e) {
    return null;
  }
});

// Provider for searched orders
final searchOrderProvider = Provider.family<List<Order>, String>((ref, query) {
  final orders = ref.watch(orderProvider);
  if (query.isEmpty) return orders;
  final lowerQuery = query.toLowerCase();
  return orders
      .where((order) => order.id.toLowerCase().contains(lowerQuery))
      .toList();
});

// Provider for filtered orders by doctor
final filterOrderByDoctorProvider =
    Provider.family<List<Order>, String>((ref, doctorId) {
  final orders = ref.watch(orderProvider);
  if (doctorId.isEmpty) return orders;
  return orders.where((order) => order.doctorId == doctorId).toList();
});

// Provider for filtered orders by chemist shop
final filterOrderByChemistShopProvider =
    Provider.family<List<Order>, String>((ref, chemistShopId) {
  final orders = ref.watch(orderProvider);
  if (chemistShopId.isEmpty) return orders;
  return orders.where((order) => order.chemistShopId == chemistShopId).toList();
});

// Provider for filtered orders by distributor
final filterOrderByDistributorProvider =
    Provider.family<List<Order>, String>((ref, distributorId) {
  final orders = ref.watch(orderProvider);
  if (distributorId.isEmpty) return orders;
  return orders.where((order) => order.distributorId == distributorId).toList();
});

// Provider for filtered orders by status
final filterOrderByStatusProvider =
    Provider.family<List<Order>, OrderStatus>((ref, status) {
  final orders = ref.watch(orderProvider);
  return orders.where((order) => order.status == status).toList();
});

// Provider for orders sorted by date (newest first)
final sortedOrdersProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(orderProvider);
  final sorted = List<Order>.from(orders);
  sorted.sort((a, b) => b.orderDate.compareTo(a.orderDate));
  return sorted;
});

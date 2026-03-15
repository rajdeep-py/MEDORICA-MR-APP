import 'package:flutter_riverpod/legacy.dart';

import '../models/order.dart';
import '../services/order/order_services.dart';

class OrderState {
  final List<Order> orders;
  final bool isLoading;
  final String? error;

  const OrderState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({List<Order>? orders, bool? isLoading, String? error}) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier(this._orderServices) : super(const OrderState());

  final OrderServices _orderServices;
  String? _activemrId;

  Future<void> syncAsm(String? mrId) async {
    final nextmrId = mrId?.trim();
    if (nextmrId == null || nextmrId.isEmpty) {
      _activemrId = null;
      state = const OrderState();
      return;
    }

    if (_activemrId == nextmrId &&
        (state.orders.isNotEmpty || state.isLoading)) {
      return;
    }

    _activemrId = nextmrId;
    await loadOrdersBymrId(nextmrId);
  }

  Future<void> loadOrdersBymrId(String mrId) async {
    final trimmedmrId = mrId.trim();
    if (trimmedmrId.isEmpty) {
      state = const OrderState(error: 'ASM ID is required to load orders.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final orders = await _orderServices.fetchOrdersBymrId(trimmedmrId);
      state = state.copyWith(orders: orders, isLoading: false, error: null);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        orders: const [],
        error: _readErrorMessage(error),
      );
    }
  }

  Future<void> createOrder({
    required String mrId,
    String? distributorId,
    String? chemistShopId,
    String? doctorId,
    required List<Medicine> medicines,
    required double totalAmountRupees,
    String distributorName = '',
    String distributorPhoneNo = '',
    String distributorAddress = '',
    String distributorDeliveryTime = '',
    String chemistShopName = '',
    String chemistShopPhoneNo = '',
    String chemistShopAddress = '',
    String doctorName = '',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final createdOrder = await _orderServices.createOrder(
        mrId: mrId,
        distributorId: distributorId,
        chemistShopId: chemistShopId,
        doctorId: doctorId,
        medicines: medicines,
        totalAmountRupees: totalAmountRupees,
      );

      final enrichedOrder = createdOrder.copyWith(
        distributorName: createdOrder.distributorName.isEmpty
            ? distributorName
            : createdOrder.distributorName,
        distributorPhoneNo: createdOrder.distributorPhoneNo.isEmpty
            ? distributorPhoneNo
            : createdOrder.distributorPhoneNo,
        distributorAddress: createdOrder.distributorAddress.isEmpty
            ? distributorAddress
            : createdOrder.distributorAddress,
        distributorDeliveryTime: createdOrder.distributorDeliveryTime.isEmpty
            ? distributorDeliveryTime
            : createdOrder.distributorDeliveryTime,
        chemistShopName: createdOrder.chemistShopName.isEmpty
            ? chemistShopName
            : createdOrder.chemistShopName,
        chemistShopPhoneNo: createdOrder.chemistShopPhoneNo.isEmpty
            ? chemistShopPhoneNo
            : createdOrder.chemistShopPhoneNo,
        chemistShopAddress: createdOrder.chemistShopAddress.isEmpty
            ? chemistShopAddress
            : createdOrder.chemistShopAddress,
        doctorName: createdOrder.doctorName.isEmpty
            ? doctorName
            : createdOrder.doctorName,
      );

      state = state.copyWith(
        isLoading: false,
        error: null,
        orders: [enrichedOrder, ...state.orders],
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    state = state.copyWith(
      orders: [
        for (final order in state.orders)
          if (order.id == orderId) order.copyWith(status: newStatus) else order,
      ],
    );
  }

  Future<void> updateOrder({
    required String orderId,
    String? distributorId,
    String? chemistShopId,
    String? doctorId,
    List<Medicine>? medicines,
    double? totalAmountRupees,
    String distributorName = '',
    String distributorPhoneNo = '',
    String distributorAddress = '',
    String distributorDeliveryTime = '',
    String chemistShopName = '',
    String chemistShopPhoneNo = '',
    String chemistShopAddress = '',
    String doctorName = '',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedOrder = await _orderServices.updateOrder(
        orderId: orderId,
        distributorId: distributorId,
        chemistShopId: chemistShopId,
        doctorId: doctorId,
        medicines: medicines,
        totalAmountRupees: totalAmountRupees,
      );

      final enrichedOrder = updatedOrder.copyWith(
        distributorName: updatedOrder.distributorName.isEmpty
            ? distributorName
            : updatedOrder.distributorName,
        distributorPhoneNo: updatedOrder.distributorPhoneNo.isEmpty
            ? distributorPhoneNo
            : updatedOrder.distributorPhoneNo,
        distributorAddress: updatedOrder.distributorAddress.isEmpty
            ? distributorAddress
            : updatedOrder.distributorAddress,
        distributorDeliveryTime: updatedOrder.distributorDeliveryTime.isEmpty
            ? distributorDeliveryTime
            : updatedOrder.distributorDeliveryTime,
        chemistShopName: updatedOrder.chemistShopName.isEmpty
            ? chemistShopName
            : updatedOrder.chemistShopName,
        chemistShopPhoneNo: updatedOrder.chemistShopPhoneNo.isEmpty
            ? chemistShopPhoneNo
            : updatedOrder.chemistShopPhoneNo,
        chemistShopAddress: updatedOrder.chemistShopAddress.isEmpty
            ? chemistShopAddress
            : updatedOrder.chemistShopAddress,
        doctorName: updatedOrder.doctorName.isEmpty
            ? doctorName
            : updatedOrder.doctorName,
      );

      state = state.copyWith(
        isLoading: false,
        error: null,
        orders: [
          for (final order in state.orders)
            if (order.id == orderId) enrichedOrder else order,
        ],
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  Future<void> deleteOrder(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _orderServices.deleteOrderById(id);
      state = state.copyWith(
        isLoading: false,
        orders: state.orders.where((order) => order.id != id).toList(),
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _readErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }
}
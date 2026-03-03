import 'package:flutter_riverpod/legacy.dart';
import '../models/order.dart';

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]) {
    _loadOrders();
  }

  // Load orders - mock data for now
  void _loadOrders() {
    state = [
      Order(
        id: 'ORD001',
        doctorId: '1', // Dr. Ahmed Khan
        chemistShopId: '1', // MediCare Pharmacy
        distributorId: '1', // MedSupply Distributors
        medicines: [
          OrderMedicine(
            id: 'MED001',
            name: 'Paracetamol 500mg',
            quantity: 500,
            unit: 'Tablets',
            batchNumber: 'BATCH2024001',
          ),
          OrderMedicine(
            id: 'MED002',
            name: 'Amoxicillin 250mg',
            quantity: 300,
            unit: 'Capsules',
            batchNumber: 'BATCH2024002',
          ),
        ],
        status: OrderStatus.confirmed,
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        notes: 'Urgent delivery required for cardiac patients',
      ),
      Order(
        id: 'ORD002',
        doctorId: '2', // Dr. Fatima Begum
        chemistShopId: '2', // HealthPlus Chemist
        distributorId: '2', // PharmaCare Distribution
        medicines: [
          OrderMedicine(
            id: 'MED003',
            name: 'Ibuprofen 400mg',
            quantity: 400,
            unit: 'Tablets',
            batchNumber: 'BATCH2024003',
          ),
          OrderMedicine(
            id: 'MED004',
            name: 'Calcium Supplements',
            quantity: 200,
            unit: 'Tablets',
            batchNumber: 'BATCH2024004',
          ),
          OrderMedicine(
            id: 'MED005',
            name: 'Vitamin D3',
            quantity: 150,
            unit: 'Capsules',
            batchNumber: 'BATCH2024005',
          ),
        ],
        status: OrderStatus.shipped,
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        deliveryDate: DateTime.now(),
        notes: 'For orthopedic patients, handle with care',
      ),
      Order(
        id: 'ORD003',
        doctorId: '3', // Dr. Rajesh Sharma
        chemistShopId: '3', // City Pharmacy
        distributorId: '3', // Global Pharma Supply
        medicines: [
          OrderMedicine(
            id: 'MED006',
            name: 'Aspirin 75mg',
            quantity: 600,
            unit: 'Tablets',
            batchNumber: 'BATCH2024006',
          ),
        ],
        status: OrderStatus.pending,
        orderDate: DateTime.now().subtract(const Duration(hours: 12)),
        notes: 'Check stock availability before confirmation',
      ),
      Order(
        id: 'ORD004',
        doctorId: '1', // Dr. Ahmed Khan
        chemistShopId: '1', // MediCare Pharmacy
        distributorId: '2', // PharmaCare Distribution
        medicines: [
          OrderMedicine(
            id: 'MED007',
            name: 'Metformin 500mg',
            quantity: 800,
            unit: 'Tablets',
            batchNumber: 'BATCH2024007',
          ),
          OrderMedicine(
            id: 'MED008',
            name: 'Atorvastatin 10mg',
            quantity: 400,
            unit: 'Tablets',
            batchNumber: 'BATCH2024008',
          ),
        ],
        status: OrderStatus.delivered,
        orderDate: DateTime.now().subtract(const Duration(days: 10)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 5)),
        notes: 'Delivered successfully, patient satisfied',
      ),
      Order(
        id: 'ORD005',
        doctorId: '2', // Dr. Fatima Begum
        chemistShopId: '3', // City Pharmacy
        distributorId: '1', // MedSupply Distributors
        medicines: [
          OrderMedicine(
            id: 'MED009',
            name: 'Gabapentin 300mg',
            quantity: 250,
            unit: 'Capsules',
            batchNumber: 'BATCH2024009',
          ),
        ],
        status: OrderStatus.processing,
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        deliveryDate: DateTime.now().add(const Duration(days: 2)),
        notes: 'Priority shipment for pain management',
      ),
    ];
  }

  // Add a new order
  void addOrder(Order order) {
    state = [...state, order.copyWith(id: 'ORD${state.length + 1}'.padLeft(6, '0'))];
  }

  // Update an order
  void updateOrder(Order updatedOrder) {
    state = [
      for (final order in state)
        if (order.id == updatedOrder.id) updatedOrder else order,
    ];
  }

  // Delete an order
  void deleteOrder(String id) {
    state = [for (final order in state) if (order.id != id) order];
  }

  // Get an order by id
  Order? getOrderById(String id) {
    try {
      return state.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search orders by multiple criteria
  List<Order> searchOrders(String query) {
    if (query.isEmpty) return state;
    final lowerQuery = query.toLowerCase();
    return state.where((order) => order.id.toLowerCase().contains(lowerQuery)).toList();
  }

  // Filter by doctor
  List<Order> filterByDoctor(String doctorId) {
    if (doctorId.isEmpty) return state;
    return state.where((order) => order.doctorId == doctorId).toList();
  }

  // Filter by chemist shop
  List<Order> filterByChemistShop(String chemistShopId) {
    if (chemistShopId.isEmpty) return state;
    return state.where((order) => order.chemistShopId == chemistShopId).toList();
  }

  // Filter by distributor
  List<Order> filterByDistributor(String distributorId) {
    if (distributorId.isEmpty) return state;
    return state.where((order) => order.distributorId == distributorId).toList();
  }

  // Filter by status
  List<Order> filterByStatus(OrderStatus status) {
    return state.where((order) => order.status == status).toList();
  }

  // Update order status
  void updateOrderStatus(String id, OrderStatus newStatus) {
    state = [
      for (final order in state)
        if (order.id == id) order.copyWith(status: newStatus) else order,
    ];
  }
}

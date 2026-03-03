class Order {
  final String id;
  final String doctorId;
  final String chemistShopId;
  final String distributorId;
  final List<OrderMedicine> medicines;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? notes;

  Order({
    required this.id,
    required this.doctorId,
    required this.chemistShopId,
    required this.distributorId,
    required this.medicines,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    this.notes,
  });

  // Copy with method for updates
  Order copyWith({
    String? id,
    String? doctorId,
    String? chemistShopId,
    String? distributorId,
    List<OrderMedicine>? medicines,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      chemistShopId: chemistShopId ?? this.chemistShopId,
      distributorId: distributorId ?? this.distributorId,
      medicines: medicines ?? this.medicines,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      notes: notes ?? this.notes,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'chemistShopId': chemistShopId,
        'distributorId': distributorId,
        'medicines': medicines.map((m) => m.toJson()).toList(),
        'status': status.name,
        'orderDate': orderDate.toIso8601String(),
        'deliveryDate': deliveryDate?.toIso8601String(),
        'notes': notes,
      };

  // Create from JSON
  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] ?? '',
        doctorId: json['doctorId'] ?? '',
        chemistShopId: json['chemistShopId'] ?? '',
        distributorId: json['distributorId'] ?? '',
        medicines: (json['medicines'] as List?)
                ?.map((m) => OrderMedicine.fromJson(m))
                .toList() ??
            [],
        status: OrderStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => OrderStatus.pending,
        ),
        orderDate: json['orderDate'] != null
            ? DateTime.parse(json['orderDate'])
            : DateTime.now(),
        deliveryDate: json['deliveryDate'] != null
            ? DateTime.parse(json['deliveryDate'])
            : null,
        notes: json['notes'],
      );

  // Calculate total quantity
  int get totalQuantity {
    return medicines.fold(0, (sum, medicine) => sum + medicine.quantity);
  }
}

class OrderMedicine {
  final String id;
  final String name;
  final int quantity;
  final String? unit;
  final String? batchNumber;

  OrderMedicine({
    required this.id,
    required this.name,
    required this.quantity,
    this.unit,
    this.batchNumber,
  });

  OrderMedicine copyWith({
    String? id,
    String? name,
    int? quantity,
    String? unit,
    String? batchNumber,
  }) {
    return OrderMedicine(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      batchNumber: batchNumber ?? this.batchNumber,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'batchNumber': batchNumber,
      };

  factory OrderMedicine.fromJson(Map<String, dynamic> json) => OrderMedicine(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        quantity: json['quantity'] ?? 0,
        unit: json['unit'],
        batchNumber: json['batchNumber'],
      );
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

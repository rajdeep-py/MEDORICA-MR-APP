import 'dart:convert';

class Medicine {
  final String id;
  final String name;
  final int quantity;
  final String pack;
  final double totalAmount;

  Medicine({
    required this.id,
    required this.name,
    required this.quantity,
    required this.pack,
    required this.totalAmount,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id:
          _readString(json['id'] ?? json['medicine_id']) ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: _readString(json['name'] ?? json['medicine_name']) ?? '',
      quantity: _readInt(json['quantity'] ?? json['qty']) ?? 0,
      pack: _readString(json['pack']) ?? '',
      totalAmount:
          _readDouble(
            json['totalAmount'] ??
                json['total_amount'] ??
                json['price'] ??
                json['amount'],
          ) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'pack': pack,
      'totalAmount': totalAmount,
    };
  }
}

enum OrderStatus {
  approved,
  rejected,
  pending,
  cancelled,
  delivered,
  received,
  shipped,
}

class Order {
  final int? recordId;
  final String id;
  final String mrId;
  final String chemistShopName;
  final String chemistShopPhoneNo;
  final String chemistShopAddress;
  final String chemistShopId;
  final String doctorName;
  final String doctorId;
  final String distributorName;
  final String distributorPhoneNo;
  final String distributorAddress;
  final String distributorDeliveryTime;
  final String distributorId;
  final List<Medicine> medicines;
  final double totalAmountRupees;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Order({
    this.recordId,
    required this.id,
    this.mrId = '',
    required this.chemistShopName,
    required this.chemistShopPhoneNo,
    required this.chemistShopAddress,
    required this.chemistShopId,
    required this.doctorName,
    this.doctorId = '',
    required this.distributorName,
    required this.distributorPhoneNo,
    required this.distributorAddress,
    required this.distributorDeliveryTime,
    required this.distributorId,
    required this.medicines,
    this.totalAmountRupees = 0,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final parsedMedicines = _parseProducts(json['products_with_price']);
    return Order(
      recordId: _readInt(json['id']),
      id: _readString(json['order_id'] ?? json['id']) ?? '',
      mrId: _readString(json['mr_id']) ?? '',
      chemistShopName:
          _readString(json['chemist_shop_name'] ?? json['chemistShopName']) ??
          '',
      chemistShopPhoneNo:
          _readString(
            json['chemist_shop_phone_no'] ?? json['chemistShopPhoneNo'],
          ) ??
          '',
      chemistShopAddress:
          _readString(
            json['chemist_shop_address'] ?? json['chemistShopAddress'],
          ) ??
          '',
      chemistShopId:
          _readString(json['chemist_shop_id'] ?? json['chemistShopId']) ?? '',
      doctorName: _readString(json['doctor_name'] ?? json['doctorName']) ?? '',
      doctorId: _readString(json['doctor_id'] ?? json['doctorId']) ?? '',
      distributorName:
          _readString(json['distributor_name'] ?? json['distributorName']) ??
          '',
      distributorPhoneNo:
          _readString(
            json['distributor_phone_no'] ?? json['distributorPhoneNo'],
          ) ??
          '',
      distributorAddress:
          _readString(
            json['distributor_address'] ?? json['distributorAddress'],
          ) ??
          '',
      distributorDeliveryTime:
          _readString(
            json['distributor_delivery_time'] ??
                json['distributorDeliveryTime'],
          ) ??
          '',
      distributorId:
          _readString(json['distributor_id'] ?? json['distributorId']) ?? '',
      medicines: parsedMedicines,
      totalAmountRupees:
          _readDouble(
            json['total_amount_rupees'] ?? json['totalAmountRupees'],
          ) ??
          parsedMedicines.fold<double>(
            0,
            (sum, item) => sum + item.totalAmount,
          ),
      status: _parseStatus(_readString(json['status']) ?? ''),
      createdAt:
          _readDateTime(json['created_at'] ?? json['createdAt']) ??
          DateTime.now(),
      updatedAt: _readDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': recordId,
      'order_id': id,
      'mr_id': mrId,
      'distributor_id': distributorId,
      'chemist_shop_id': chemistShopId,
      'doctor_id': doctorId,
      'products_with_price': medicines
          .map((medicine) => medicine.toJson())
          .toList(),
      'total_amount_rupees': totalAmountRupees,
      'status': _statusToApi(status),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String productsAsJsonString() =>
      jsonEncode(medicines.map((medicine) => medicine.toJson()).toList());

  Order copyWith({
    int? recordId,
    String? id,
    String? mrId,
    String? chemistShopName,
    String? chemistShopPhoneNo,
    String? chemistShopAddress,
    String? chemistShopId,
    String? doctorName,
    String? doctorId,
    String? distributorName,
    String? distributorPhoneNo,
    String? distributorAddress,
    String? distributorDeliveryTime,
    String? distributorId,
    List<Medicine>? medicines,
    double? totalAmountRupees,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      recordId: recordId ?? this.recordId,
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      chemistShopName: chemistShopName ?? this.chemistShopName,
      chemistShopPhoneNo: chemistShopPhoneNo ?? this.chemistShopPhoneNo,
      chemistShopAddress: chemistShopAddress ?? this.chemistShopAddress,
      chemistShopId: chemistShopId ?? this.chemistShopId,
      doctorName: doctorName ?? this.doctorName,
      doctorId: doctorId ?? this.doctorId,
      distributorName: distributorName ?? this.distributorName,
      distributorPhoneNo: distributorPhoneNo ?? this.distributorPhoneNo,
      distributorAddress: distributorAddress ?? this.distributorAddress,
      distributorDeliveryTime:
          distributorDeliveryTime ?? this.distributorDeliveryTime,
      distributorId: distributorId ?? this.distributorId,
      medicines: medicines ?? this.medicines,
      totalAmountRupees: totalAmountRupees ?? this.totalAmountRupees,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

List<Medicine> _parseProducts(dynamic rawProducts) {
  if (rawProducts == null) {
    return const [];
  }

  if (rawProducts is List) {
    return rawProducts
        .whereType<Map<String, dynamic>>()
        .map(Medicine.fromJson)
        .toList();
  }

  if (rawProducts is Map<String, dynamic>) {
    final nestedItems = rawProducts['items'];
    if (nestedItems is List) {
      return nestedItems
          .whereType<Map<String, dynamic>>()
          .map(Medicine.fromJson)
          .toList();
    }

    return [Medicine.fromJson(rawProducts)];
  }

  if (rawProducts is String) {
    final decoded = jsonDecode(rawProducts);
    return _parseProducts(decoded);
  }

  return const [];
}

OrderStatus _parseStatus(String value) {
  switch (value.trim().toLowerCase()) {
    case 'approved':
      return OrderStatus.approved;
    case 'shipped':
      return OrderStatus.shipped;
    case 'delivered':
      return OrderStatus.delivered;
    case 'rejected':
      return OrderStatus.rejected;
    case 'cancelled':
      return OrderStatus.cancelled;
    case 'received':
      return OrderStatus.received;
    default:
      return OrderStatus.pending;
  }
}

String _statusToApi(OrderStatus status) {
  switch (status) {
    case OrderStatus.approved:
      return 'approved';
    case OrderStatus.shipped:
      return 'shipped';
    case OrderStatus.delivered:
      return 'delivered';
    case OrderStatus.pending:
      return 'pending';
    case OrderStatus.rejected:
      return 'rejected';
    case OrderStatus.cancelled:
      return 'cancelled';
    case OrderStatus.received:
      return 'received';
  }
}

DateTime? _readDateTime(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value.isUtc ? value.toLocal() : value;
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    return null;
  }
  return parsed.isUtc ? parsed.toLocal() : parsed;
}

String? _readString(dynamic value) {
  if (value == null) {
    return null;
  }
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int? _readInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  return int.tryParse(value.toString());
}

double? _readDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  return double.tryParse(value.toString());
}
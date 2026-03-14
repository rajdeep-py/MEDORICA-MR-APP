class Distributor {
  final int? recordId;
  final String id;
  final String name;
  final String? location;
  final String phoneNo;
  final String? email;
  final String? address;
  final String? photoUrl;
  final double? minimumOrderValue;
  final String? deliveryTime;
  final String? description;
  final List<String> products;
  final int? expectedDeliveryTimeDays;
  final String? paymentTerms;
  final String? bankName;
  final String? bankAccountNo;
  final String? branchName;
  final String? ifscCode;
  final List<String> deliveryTerritories;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Distributor({
    this.recordId,
    required this.id,
    required this.name,
    this.location,
    required this.phoneNo,
    this.email,
    this.address,
    this.photoUrl,
    this.minimumOrderValue,
    this.deliveryTime,
    this.description,
    this.products = const [],
    this.expectedDeliveryTimeDays,
    this.paymentTerms,
    this.bankName,
    this.bankAccountNo,
    this.branchName,
    this.ifscCode,
    this.deliveryTerritories = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Distributor.fromJson(Map<String, dynamic> json) {
    final location = _readString(json['dist_location']);
    final expectedDays = _readInt(json['dist_expected_delivery_time_days']);

    return Distributor(
      recordId: _readInt(json['id']),
      id: _readString(json['dist_id']) ?? '',
      name: _readString(json['dist_name']) ?? '',
      location: location,
      phoneNo: _readString(json['dist_phone_no']) ?? '',
      email: _readString(json['dist_email']),
      address: location,
      photoUrl: _readString(json['dist_photo']),
      minimumOrderValue: _readDouble(json['dist_min_order_value_rupees']),
      deliveryTime: _deliveryTimeLabel(expectedDays),
      description: _readString(json['dist_description']),
      products: _readStringList(json['dist_products']),
      expectedDeliveryTimeDays: expectedDays,
      paymentTerms: _readString(json['payment_terms']),
      bankName: _readString(json['bank_name']),
      bankAccountNo: _readString(json['bank_ac_no']),
      branchName: _readString(json['branch_name']),
      ifscCode: _readString(json['ifsc_code']),
      deliveryTerritories: _readStringList(json['delivery_territories']),
      createdAt: _readDateTime(json['created_at']),
      updatedAt: _readDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': recordId,
      'dist_id': id,
      'dist_name': name,
      'dist_location': location,
      'dist_phone_no': phoneNo,
      'dist_email': email,
      'dist_description': description,
      'dist_photo': photoUrl,
      'dist_min_order_value_rupees': minimumOrderValue,
      'dist_products': products,
      'dist_expected_delivery_time_days': expectedDeliveryTimeDays,
      'payment_terms': paymentTerms,
      'bank_name': bankName,
      'bank_ac_no': bankAccountNo,
      'branch_name': branchName,
      'ifsc_code': ifscCode,
      'delivery_territories': deliveryTerritories,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Distributor copyWith({
    int? recordId,
    String? id,
    String? name,
    String? location,
    String? phoneNo,
    String? email,
    String? address,
    String? photoUrl,
    double? minimumOrderValue,
    String? deliveryTime,
    String? description,
    List<String>? products,
    int? expectedDeliveryTimeDays,
    String? paymentTerms,
    String? bankName,
    String? bankAccountNo,
    String? branchName,
    String? ifscCode,
    List<String>? deliveryTerritories,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Distributor(
      recordId: recordId ?? this.recordId,
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      minimumOrderValue: minimumOrderValue ?? this.minimumOrderValue,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      description: description ?? this.description,
      products: products ?? this.products,
      expectedDeliveryTimeDays:
          expectedDeliveryTimeDays ?? this.expectedDeliveryTimeDays,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      bankName: bankName ?? this.bankName,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      branchName: branchName ?? this.branchName,
      ifscCode: ifscCode ?? this.ifscCode,
      deliveryTerritories: deliveryTerritories ?? this.deliveryTerritories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Distributor &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

DateTime? _readDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.isUtc ? value.toLocal() : value;

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) return null;
  return parsed.isUtc ? parsed.toLocal() : parsed;
}

String? _readString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int? _readInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

double? _readDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}

List<String> _readStringList(dynamic value) {
  if (value == null) return const [];
  if (value is List) {
    return value
        .map((item) => item?.toString().trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toList();
  }

  final raw = value.toString().trim();
  if (raw.isEmpty) return const [];
  return raw
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}

String? _deliveryTimeLabel(int? days) {
  if (days == null) return null;
  if (days == 1) return '1 day';
  return '$days days';
}
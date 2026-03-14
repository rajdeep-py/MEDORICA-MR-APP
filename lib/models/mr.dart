class MedicalRepresentative {
  final String id;
  final String mrId;
  final String name;
  final String phone;
  final String email;
  final String designation;
  final String territory;
  final String? altPhoneNo;
  final String? address;
  final DateTime? joiningDate;
  final String? profileImage;
  final String? bankAccountNo;
  final String? bankName;
  final String? branchName;
  final String? ifscCode;
  final String? password;
  final String? headquarterAssigned;
  final dynamic territoriesOfWork;
  final double? monthlyTargetRupees;
  final double? basicSalaryRupees;
  final double? dailyAllowancesRupees;
  final double? hraRupees;
  final double? phoneAllowancesRupees;
  final double? childrenAllowancesRupees;
  final double? specialAllowancesRupees;
  final double? medicalAllowancesRupees;
  final double? esicRupees;
  final double? totalMonthlyCompensationRupees;
  final bool active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MedicalRepresentative({
    required this.id,
    required this.mrId,
    required this.name,
    required this.phone,
    required this.email,
    required this.designation,
    required this.territory,
    this.altPhoneNo,
    this.address,
    this.joiningDate,
    this.profileImage,
    this.bankAccountNo,
    this.bankName,
    this.branchName,
    this.ifscCode,
    this.password,
    this.headquarterAssigned,
    this.territoriesOfWork,
    this.monthlyTargetRupees,
    this.basicSalaryRupees,
    this.dailyAllowancesRupees,
    this.hraRupees,
    this.phoneAllowancesRupees,
    this.childrenAllowancesRupees,
    this.specialAllowancesRupees,
    this.medicalAllowancesRupees,
    this.esicRupees,
    this.totalMonthlyCompensationRupees,
    this.active = true,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicalRepresentative.fromJson(Map<String, dynamic> json) {
    final dynamic territoriesRaw =
        json['territories_of_work'] ?? json['territoriesOfWork'];
    final String? headquarter = _asString(
      json['headquarter_assigned'] ?? json['headquarterAssigned'],
    );

    final String territoryValue =
        _asString(json['territory']) ??
        _territoryFromDynamic(territoriesRaw) ??
        headquarter ??
        '';

    return MedicalRepresentative(
      id: _asString(json['id']) ?? '',
      mrId:
          _asString(json['mr_id'] ?? json['mrId']) ??
          _asString(json['id']) ??
          '',
      name: _asString(json['full_name'] ?? json['name']) ?? '',
      phone: _asString(json['phone_no'] ?? json['phone']) ?? '',
      email: _asString(json['email']) ?? '',
      designation: _asString(json['designation']) ?? 'Medical Representative',
      territory: territoryValue,
      altPhoneNo: _asString(json['alt_phone_no'] ?? json['altPhoneNo']),
      address: _asString(json['address']),
      joiningDate: _asDateTime(json['joining_date'] ?? json['joiningDate']),
      profileImage: _asString(json['profile_photo'] ?? json['profileImage']),
      bankAccountNo: _asString(
        json['bank_account_no'] ?? json['bankAccountNo'],
      ),
      bankName: _asString(json['bank_name'] ?? json['bankName']),
      branchName: _asString(json['branch_name'] ?? json['branchName']),
      ifscCode: _asString(json['ifsc_code'] ?? json['ifscCode']),
      password: _asString(json['password']),
      headquarterAssigned: headquarter,
      territoriesOfWork: territoriesRaw,
      monthlyTargetRupees: _asDouble(
        json['monthly_target_rupees'] ?? json['monthlyTargetRupees'],
      ),
      basicSalaryRupees: _asDouble(
        json['basic_salary_rupees'] ?? json['basicSalaryRupees'],
      ),
      dailyAllowancesRupees: _asDouble(
        json['daily_allowances_rupees'] ?? json['dailyAllowancesRupees'],
      ),
      hraRupees: _asDouble(json['hra_rupees'] ?? json['hraRupees']),
      phoneAllowancesRupees: _asDouble(
        json['phone_allowances_rupees'] ?? json['phoneAllowancesRupees'],
      ),
      childrenAllowancesRupees: _asDouble(
        json['children_allowances_rupees'] ?? json['childrenAllowancesRupees'],
      ),
      specialAllowancesRupees: _asDouble(
        json['special_allowances_rupees'] ?? json['specialAllowancesRupees'],
      ),
      medicalAllowancesRupees: _asDouble(
        json['medical_allowances_rupees'] ?? json['medicalAllowancesRupees'],
      ),
      esicRupees: _asDouble(json['esic_rupees'] ?? json['esicRupees']),
      totalMonthlyCompensationRupees: _asDouble(
        json['total_monthly_compensation_rupees'] ??
            json['totalMonthlyCompensationRupees'],
      ),
      active: (json['active'] as bool?) ?? true,
      createdAt: _asDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: _asDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(id) ?? id,
      'mr_id': mrId,
      'full_name': name,
      'phone_no': phone,
      'alt_phone_no': altPhoneNo,
      'email': email,
      'address': address,
      'joining_date': joiningDate?.toIso8601String(),
      'password': password,
      'profile_photo': profileImage,
      'bank_name': bankName,
      'bank_account_no': bankAccountNo,
      'ifsc_code': ifscCode,
      'branch_name': branchName,
      'headquarter_assigned': headquarterAssigned,
      'territories_of_work': territoriesOfWork,
      'monthly_target_rupees': monthlyTargetRupees,
      'basic_salary_rupees': basicSalaryRupees,
      'daily_allowances_rupees': dailyAllowancesRupees,
      'hra_rupees': hraRupees,
      'phone_allowances_rupees': phoneAllowancesRupees,
      'children_allowances_rupees': childrenAllowancesRupees,
      'special_allowances_rupees': specialAllowancesRupees,
      'medical_allowances_rupees': medicalAllowancesRupees,
      'esic_rupees': esicRupees,
      'total_monthly_compensation_rupees': totalMonthlyCompensationRupees,
      'active': active,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MedicalRepresentative copyWith({
    String? id,
    String? mrId,
    String? name,
    String? phone,
    String? email,
    String? designation,
    String? territory,
    String? altPhoneNo,
    String? address,
    DateTime? joiningDate,
    String? profileImage,
    String? bankAccountNo,
    String? bankName,
    String? branchName,
    String? ifscCode,
    String? password,
    String? headquarterAssigned,
    dynamic territoriesOfWork,
    double? monthlyTargetRupees,
    double? basicSalaryRupees,
    double? dailyAllowancesRupees,
    double? hraRupees,
    double? phoneAllowancesRupees,
    double? childrenAllowancesRupees,
    double? specialAllowancesRupees,
    double? medicalAllowancesRupees,
    double? esicRupees,
    double? totalMonthlyCompensationRupees,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalRepresentative(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      designation: designation ?? this.designation,
      territory: territory ?? this.territory,
      altPhoneNo: altPhoneNo ?? this.altPhoneNo,
      address: address ?? this.address,
      joiningDate: joiningDate ?? this.joiningDate,
      profileImage: profileImage ?? this.profileImage,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      ifscCode: ifscCode ?? this.ifscCode,
      password: password ?? this.password,
      headquarterAssigned: headquarterAssigned ?? this.headquarterAssigned,
      territoriesOfWork: territoriesOfWork ?? this.territoriesOfWork,
      monthlyTargetRupees: monthlyTargetRupees ?? this.monthlyTargetRupees,
      basicSalaryRupees: basicSalaryRupees ?? this.basicSalaryRupees,
      dailyAllowancesRupees:
          dailyAllowancesRupees ?? this.dailyAllowancesRupees,
      hraRupees: hraRupees ?? this.hraRupees,
      phoneAllowancesRupees:
          phoneAllowancesRupees ?? this.phoneAllowancesRupees,
      childrenAllowancesRupees:
          childrenAllowancesRupees ?? this.childrenAllowancesRupees,
      specialAllowancesRupees:
          specialAllowancesRupees ?? this.specialAllowancesRupees,
      medicalAllowancesRupees:
          medicalAllowancesRupees ?? this.medicalAllowancesRupees,
      esicRupees: esicRupees ?? this.esicRupees,
      totalMonthlyCompensationRupees:
          totalMonthlyCompensationRupees ?? this.totalMonthlyCompensationRupees,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String? _asString(dynamic value) {
    if (value == null) {
      return null;
    }
    return value.toString();
  }

  static DateTime? _asDateTime(dynamic value) {
    final String? raw = _asString(value);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  static double? _asDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  static String? _territoryFromDynamic(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is List) {
      final List<String> values = value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
      return values.isEmpty ? null : values.join(', ');
    }
    final String raw = value.toString().trim();
    return raw.isEmpty ? null : raw;
  }
}

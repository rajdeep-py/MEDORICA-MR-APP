class MedicalRepresentative {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String designation;
  final String territory;
  final String? profileImage;
  final String? bankAccountNo;
  final String? bankName;
  final String? branchName;
  final String? ifscCode;
  final String? password;

  MedicalRepresentative({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.designation,
    required this.territory,
    this.profileImage,
    this.bankAccountNo,
    this.bankName,
    this.branchName,
    this.ifscCode,
    this.password,
  });

  factory MedicalRepresentative.fromJson(Map<String, dynamic> json) {
    return MedicalRepresentative(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      designation: json['designation'] as String,
      territory: json['territory'] as String,
      profileImage: json['profileImage'] as String?,
      bankAccountNo: json['bankAccountNo'] as String?,
      bankName: json['bankName'] as String?,
      branchName: json['branchName'] as String?,
      ifscCode: json['ifscCode'] as String?,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'designation': designation,
      'territory': territory,
      'profileImage': profileImage,
      'bankAccountNo': bankAccountNo,
      'bankName': bankName,
      'branchName': branchName,
      'ifscCode': ifscCode,
      'password': password,
    };
  }

  MedicalRepresentative copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? designation,
    String? territory,
    String? profileImage,
    String? bankAccountNo,
    String? bankName,
    String? branchName,
    String? ifscCode,
    String? password,
  }) {
    return MedicalRepresentative(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      designation: designation ?? this.designation,
      territory: territory ?? this.territory,
      profileImage: profileImage ?? this.profileImage,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      ifscCode: ifscCode ?? this.ifscCode,
      password: password ?? this.password,
    );
  }
}

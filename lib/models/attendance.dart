class Attendance {
  final int? id;
  final String? mrId;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? checkInPhotoPath;
  final String? checkOutPhotoPath;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Attendance({
    this.id,
    this.mrId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.checkInPhotoPath,
    this.checkOutPhotoPath,
    this.status = 'present',
    this.createdAt,
    this.updatedAt,
  });

  bool get isCheckedIn => checkIn != null;
  bool get isCheckedOut => checkOut != null;

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: _asInt(json['id']),
      mrId: _asString(json['mr_id'] ?? json['mrId']),
      date: _parseDateOnly(json['date']) ?? DateTime.now(),
      checkIn: _parseDateTime(json['check_in_time'] ?? json['checkInTime']),
      checkOut: _parseDateTime(json['check_out_time'] ?? json['checkOutTime']),
      checkInPhotoPath: _asString(
        json['check_in_selfie'] ??
            json['checkInSelfie'] ??
            json['check_in_photo_path'],
      ),
      checkOutPhotoPath: _asString(
        json['check_out_selfie'] ??
            json['checkOutSelfie'] ??
            json['check_out_photo_path'],
      ),
      status: _asString(json['status']) ?? 'present',
      createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: _parseDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'mr_id': mrId,
      'date': _formatDateOnly(date),
      'check_in_time': checkIn?.toIso8601String(),
      'check_out_time': checkOut?.toIso8601String(),
      'check_in_selfie': checkInPhotoPath,
      'check_out_selfie': checkOutPhotoPath,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Attendance copyWith({
    int? id,
    String? mrId,
    DateTime? date,
    DateTime? checkIn,
    DateTime? checkOut,
    String? checkInPhotoPath,
    String? checkOutPhotoPath,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Attendance(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      date: date ?? this.date,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      checkInPhotoPath: checkInPhotoPath ?? this.checkInPhotoPath,
      checkOutPhotoPath: checkOutPhotoPath ?? this.checkOutPhotoPath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    final String parsed = value.toString().trim();
    return parsed.isEmpty ? null : parsed;
  }

  static DateTime? _parseDateOnly(dynamic value) {
    final String? text = _asString(value);
    if (text == null) return null;
    final DateTime? parsed = DateTime.tryParse(text);
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  static DateTime? _parseDateTime(dynamic value) {
    final String? text = _asString(value);
    if (text == null) return null;
    final DateTime? parsed = DateTime.tryParse(text);
    if (parsed == null) return null;
    return parsed.toLocal();
  }

  static String _formatDateOnly(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }
}

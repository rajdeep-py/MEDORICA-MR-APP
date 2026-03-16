class SalarySlip {
	final int? id;
	final String mrId;
	final String salarySlipUrl;
	final DateTime? createdAt;
	final DateTime? updatedAt;
	final String? localFilePath;

	const SalarySlip({
		this.id,
		required this.mrId,
		required this.salarySlipUrl,
		this.createdAt,
		this.updatedAt,
		this.localFilePath,
	});

	factory SalarySlip.fromJson(Map<String, dynamic> json) {
		return SalarySlip(
			id: _toIntOrNull(json['id']),
			mrId: _readString(json['mr_id']) ?? '',
			salarySlipUrl: _readString(json['salary_slip_url']) ?? '',
			createdAt: _parseDateTime(json['created_at']),
			updatedAt: _parseDateTime(json['updated_at']),
			localFilePath: _readString(json['local_file_path']),
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'mr_id': mrId,
			'salary_slip_url': salarySlipUrl,
			'created_at': createdAt?.toIso8601String(),
			'updated_at': updatedAt?.toIso8601String(),
			'local_file_path': localFilePath,
		};
	}

	SalarySlip copyWith({
		int? id,
		String? mrId,
		String? salarySlipUrl,
		DateTime? createdAt,
		DateTime? updatedAt,
		String? localFilePath,
	}) {
		return SalarySlip(
			id: id ?? this.id,
			mrId: mrId ?? this.mrId,
			salarySlipUrl: salarySlipUrl ?? this.salarySlipUrl,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
			localFilePath: localFilePath ?? this.localFilePath,
		);
	}
}

String? _readString(dynamic value) {
	if (value == null) {
		return null;
	}
	final text = value.toString().trim();
	return text.isEmpty ? null : text;
}

int? _toIntOrNull(dynamic value) {
	if (value == null) {
		return null;
	}
	if (value is int) {
		return value;
	}
	return int.tryParse(value.toString());
}

DateTime? _parseDateTime(dynamic value) {
	final text = _readString(value);
	if (text == null) {
		return null;
	}
	return DateTime.tryParse(text);
}

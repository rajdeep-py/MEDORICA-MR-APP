enum PlanActivityType {
  doctorVisit,
  chemistVisit,
  distributorVisit,
  meeting,
  other,
}

class PlanActivity {
  final String id;
  final PlanActivityType type;
  final String title;
  final String? description;
  final String? time;
  final String? location;
  final String? contactId; // doctor/chemist/distributor ID
  final bool isCompleted;

  PlanActivity({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.time,
    this.location,
    this.contactId,
    this.isCompleted = false,
  });

  PlanActivity copyWith({
    String? id,
    PlanActivityType? type,
    String? title,
    String? description,
    String? time,
    String? location,
    String? contactId,
    bool? isCompleted,
  }) {
    return PlanActivity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      location: location ?? this.location,
      contactId: contactId ?? this.contactId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'description': description,
        'time': time,
        'location': location,
        'contactId': contactId,
        'isCompleted': isCompleted,
      };

  factory PlanActivity.fromJson(Map<String, dynamic> json) => PlanActivity(
        id: json['id'],
        type: PlanActivityType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => PlanActivityType.other,
        ),
        title: json['title'],
        description: json['description'],
        time: json['time'],
        location: json['location'],
        contactId: json['contactId'],
        isCompleted: json['isCompleted'] ?? false,
      );

  String get typeLabel {
    switch (type) {
      case PlanActivityType.doctorVisit:
        return 'Doctor Visit';
      case PlanActivityType.chemistVisit:
        return 'Chemist Visit';
      case PlanActivityType.distributorVisit:
        return 'Distributor Visit';
      case PlanActivityType.meeting:
        return 'Meeting';
      case PlanActivityType.other:
        return 'Other';
    }
  }
}

class MonthPlan {
  final String id;
  final DateTime date;
  final List<PlanActivity> activities;
  final String? notes;

  MonthPlan({
    required this.id,
    required this.date,
    required this.activities,
    this.notes,
  });

  MonthPlan copyWith({
    String? id,
    DateTime? date,
    List<PlanActivity>? activities,
    String? notes,
  }) {
    return MonthPlan(
      id: id ?? this.id,
      date: date ?? this.date,
      activities: activities ?? this.activities,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'activities': activities.map((a) => a.toJson()).toList(),
        'notes': notes,
      };

  factory MonthPlan.fromJson(Map<String, dynamic> json) => MonthPlan(
        id: json['id'],
        date: DateTime.parse(json['date']),
        activities: (json['activities'] as List)
            .map((a) => PlanActivity.fromJson(a))
            .toList(),
        notes: json['notes'],
      );

  bool get hasActivities => activities.isNotEmpty;
  
  int get completedCount => activities.where((a) => a.isCompleted).length;
  
  int get totalCount => activities.length;
  
  double get completionPercentage =>
      totalCount == 0 ? 0 : (completedCount / totalCount) * 100;
}

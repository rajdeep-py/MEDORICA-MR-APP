class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'order', 'appointment', 'message', 'system'
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final String? icon;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.icon,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      actionUrl: json['actionUrl'] as String?,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'actionUrl': actionUrl,
      'icon': icon,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    String? actionUrl,
    String? icon,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      icon: icon ?? this.icon,
    );
  }
}

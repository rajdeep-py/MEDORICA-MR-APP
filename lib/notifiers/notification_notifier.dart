import 'package:flutter_riverpod/legacy.dart';
import '../models/notification.dart';

class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationNotifier()
      : super([
          NotificationModel(
            id: '1',
            title: 'Order Confirmed',
            message: 'Your order #ORD-001 has been confirmed by HealthPlus Chemist',
            type: 'order',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            isRead: false,
          ),
          NotificationModel(
            id: '2',
            title: 'Appointment Scheduled',
            message: 'Dr. Ahmed Hasan has accepted your appointment for tomorrow at 10:00 AM',
            type: 'appointment',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            isRead: false,
          ),
          NotificationModel(
            id: '3',
            title: 'New Message',
            message: 'You have a new message from PharmaCare Distribution',
            type: 'message',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            isRead: true,
          ),
          NotificationModel(
            id: '4',
            title: 'System Update',
            message: 'Medorica Pharma has been updated to version 2.1.0',
            type: 'system',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            isRead: true,
          ),
          NotificationModel(
            id: '5',
            title: 'Order Delivered',
            message: 'Your order #ORD-002 has been delivered successfully',
            type: 'order',
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
            isRead: true,
          ),
        ]);

  void markAsRead(String notificationId) {
    state = [
      for (final notification in state)
        if (notification.id == notificationId)
          notification.copyWith(isRead: true)
        else
          notification,
    ];
  }

  void markAllAsRead() {
    state = [
      for (final notification in state)
        notification.copyWith(isRead: true),
    ];
  }

  void deleteNotification(String notificationId) {
    state = state.where((notification) => notification.id != notificationId).toList();
  }

  void addNotification(NotificationModel notification) {
    state = [notification, ...state];
  }

  int getUnreadCount() {
    return state.where((notification) => !notification.isRead).length;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/notification_notifier.dart';
import '../models/notification.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<NotificationModel>>((ref) {
  return NotificationNotifier();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationProvider);
  return notifications.where((notification) => !notification.isRead).length;
});

final unreadNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifications = ref.watch(notificationProvider);
  return notifications.where((notification) => !notification.isRead).toList();
});

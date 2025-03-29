import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<void> scheduleNotification(Notification notification);
  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotifications();
}

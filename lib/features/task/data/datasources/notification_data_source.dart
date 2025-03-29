abstract class NotificationDataSource {
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  });
  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotifications();
}
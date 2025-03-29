import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_data_source.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepositoryImpl({required this.dataSource});

  @override
  Future<void> scheduleNotification(Notification notification) async {
    final notificationModel = NotificationModel.fromEntity(notification);

    await dataSource.scheduleNotification(
      id: notificationModel.id,
      title: notificationModel.title,
      body: notificationModel.body,
      scheduledDate: notificationModel.scheduledDate,
    );
  }

  @override
  Future<void> cancelNotification(int id) async {
    await dataSource.cancelNotification(id);
  }

  @override
  Future<void> cancelAllNotifications() async {
    await dataSource.cancelAllNotifications();
  }
}

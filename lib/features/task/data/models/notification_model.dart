import '../../domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.scheduledDate,
  });

  factory NotificationModel.fromEntity(Notification notification) {
    return NotificationModel(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      scheduledDate: notification.scheduledDate,
    );
  }
}
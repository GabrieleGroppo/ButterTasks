import '../entities/notification.dart';
import '../entities/task.dart';
import '../repositories/notification_repository.dart';

class ScheduleTaskDueDateNotificationUseCase {
  final NotificationRepository repository;

  ScheduleTaskDueDateNotificationUseCase({required this.repository});

  Future<void> call(Task task) async {
    if (task.dueDate != null) {
      final notification = Notification(
        id: task.id.hashCode, // Usa l'hash dell'ID come identificatore unico
        title: 'Task expired',
        body: 'Task "${task.title}" is expired on ${task.dueDate}.',
        scheduledDate: task.dueDate!,
      );

      await repository.scheduleNotification(notification);
    }
  }
}
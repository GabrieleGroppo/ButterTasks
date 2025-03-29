import 'package:butter_task/features/task/domain/usecases/schedule_task_due_date_notification_use_case.dart';

import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository taskRepository;
  final ScheduleTaskDueDateNotificationUseCase scheduleNotification;

  CreateTaskUseCase({
    required this.taskRepository,
    required this.scheduleNotification,
  });

  Future<void> call(Task task) async {
    await taskRepository.addTask(task);

    if (task.dueDate != null && task.dueDate!.isAfter(DateTime.now()) && task.dateSelected) {
      await scheduleNotification(task);
    }
  }
}
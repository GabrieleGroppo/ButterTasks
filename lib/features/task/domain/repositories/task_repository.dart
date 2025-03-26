import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> addTask(Task task);
  void removeTask(Task task);
}
import 'package:butter_task/features/task/domain/entities/task.dart';
import 'package:butter_task/features/task/domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getTasks() async {
    try {
      final localTasks = await localDataSource.getAllTasks();
      print('Retrieved local tasks:');
      for (var task in localTasks) {
        print(task.toString());
      }

      return localTasks;
    } catch (e) {
      print('Error retrieving tasks: $e');
      return [];
    }
  }

  @override
  Future<Task> addTask(Task task) async {
    try {
      return await localDataSource.insertTask(task);
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      await localDataSource.updateTask(task);
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  @override
  Future<void> removeTask(Task task) async {
    try {
      await localDataSource.deleteTask(task.id);
    } catch (e) {
      print('Error removing task: $e');
      rethrow;
    }
  }
}

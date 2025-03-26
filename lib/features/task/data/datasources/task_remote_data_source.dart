import 'package:butter_task/features/task/domain/entities/task.dart';

abstract class TaskRemoteDataSource {
  Future<List<Task>> getTasks();
  Future<Task> addTask(Task task);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final List<Task> _tasks = [];

  @override
  Future<List<Task>> getTasks() async {
    throw UnimplementedError();
  }

  @override
  Future<Task> addTask(Task task) async {
    throw UnimplementedError();
  }
}
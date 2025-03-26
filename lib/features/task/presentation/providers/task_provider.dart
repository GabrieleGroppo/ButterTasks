import 'package:flutter/foundation.dart';
import 'package:butter_task/features/task/domain/entities/task.dart';
import 'package:butter_task/features/task/domain/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository;
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  TaskProvider(this._repository);

  Future<void> fetchTasks() async {
    try {
      // Call repository to get tasks
      final fetchedTasks = await _repository.getTasks();

      // Update the tasks list
      _tasks = fetchedTasks;

      // Notify listeners that the state has changed
      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during task fetching
      print('Error fetching tasks: $e');
    }
  }

  // Method to add a new task
  Future<void> addTask(Task task) async {
    try {
      // Call repository to add task
      final addedTask = await _repository.addTask(task);

      // Add the new task to the list
      _tasks.add(addedTask);

      // Notify listeners that the state has changed
      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during task addition
      print('Error adding task: $e');
    }
  }

  // Method to remove a task
  void removeTask(Task task) {
    _tasks.remove(task);
    _repository.removeTask(task);
    notifyListeners();
  }

  // Method to toggle task completion status
  void toggleTaskCompletion(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task.copyWith(done: !task.done);
      _repository.updateTask(_tasks[index]);
      print("task updated ==> " + task.done.toString());
      notifyListeners();
    }
  }
}
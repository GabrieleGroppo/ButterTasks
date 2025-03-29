import 'package:flutter/foundation.dart';
import 'package:butter_task/features/task/domain/entities/task.dart';
import 'package:butter_task/features/task/domain/repositories/task_repository.dart';

import '../../domain/usecases/create_task_use_case.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository;
  List<Task> _tasks = [];
  bool showDoneTasks = false;

  final CreateTaskUseCase createTaskUseCase;

  List<Task> get selectedTasks => _tasks.where((task) => task.done == showDoneTasks).toList();
  List<Task> get tasks => _tasks;

  TaskProvider(this._repository, this.createTaskUseCase);

  Future<void> fetchTasks() async {
    try {
      // Call repository to get tasks
      final fetchedTasks = await _repository.getTasks();

      // Update the tasks list
      _tasks = fetchedTasks;
      _tasks.sort((a, b) => a.position.compareTo(b.position));
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
      task.position = _tasks.length;
      /*// Call repository to add task
      final addedTask = await _repository.addTask(task);

      // Add the new task to the list
      _tasks.add(addedTask);
      */
      createTaskUseCase.call(task);
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
      notifyListeners();
    }
  }

  void updateTask(newTask) {
    final index = _tasks.indexWhere((t) => t.id == newTask.id);
    if (index != -1) {
      _tasks[index] = newTask;
      _repository.updateTask(_tasks[index]);
      notifyListeners();
    }
  }

  void updateTaskOrder(List<Task> updatedTasks) {
    for (Task task in tasks) {
      task.position = updatedTasks.indexOf(task);
    }
    //sort tasks by position
    _tasks.sort((a, b) => a.position.compareTo(b.position));
    for (Task task in _tasks) {
      _repository.updateTask(task);
    }
    notifyListeners();
  }
}

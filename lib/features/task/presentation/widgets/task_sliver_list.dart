import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:butter_task/features/task/presentation/providers/task_provider.dart';
import 'package:butter_task/features/task/presentation/widgets/task_item_widget.dart';
import 'package:butter_task/features/task/domain/entities/task.dart';

class TaskSliverList extends StatefulWidget {
  const TaskSliverList({super.key});

  @override
  State<TaskSliverList> createState() => _TaskSliverListState();
}

class _TaskSliverListState extends State<TaskSliverList> {
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    tasks = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final taskProvider = Provider.of<TaskProvider>(context);
    setState(() {
      tasks = taskProvider.selectedTasks;
    });
  }

  void _deleteTask(Task task) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.removeTask(task);
  }

  void _updateTaskOrder(List<Task> updatedTasks) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.updateTaskOrder(updatedTasks);
  }

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
      child: Text(
        Provider.of<TaskProvider>(context).showDoneTasks
            ? 'No tasks already done.'
            : 'No tasks yet. Add a task!',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    )
        : ReorderableListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(tasks[index].id.toString()),
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _deleteTask(tasks[index]);
          },
          child: TaskItem(task: tasks[index]),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final Task removedTask = tasks.removeAt(oldIndex);
          tasks.insert(newIndex, removedTask);

          // Update task order in the provider
          _updateTaskOrder(tasks);
        });
      },
    );
  }
}
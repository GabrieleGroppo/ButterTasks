import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:butter_task/features/task/presentation/providers/task_provider.dart';
import 'package:butter_task/features/task/presentation/widgets/task_item_widget.dart';
import 'package:butter_task/features/task/domain/entities/task.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
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
      tasks = taskProvider.tasks;
    });
  }

  void _deleteTask(Task task) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.removeTask(task);
  }

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
          child: Text(
            'No tasks yet. Add a task!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        )
        : ListView.builder(
          shrinkWrap: true,
          itemCount: tasks.length,
          itemBuilder: (context, index) {
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
        );
  }
}

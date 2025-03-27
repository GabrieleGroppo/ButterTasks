import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:butter_task/features/task/presentation/providers/task_provider.dart';
import 'package:butter_task/features/task/presentation/widgets/task_list.dart';
import 'package:butter_task/features/task/domain/entities/task.dart';
import 'package:butter_task/features/task/presentation/widgets/task_form.dart'; // Make sure this import is correct

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<StatefulWidget> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  bool showDone = false;

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the page is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  void _showTaskForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: TaskForm(),
              ),
            ),
          ),
    ).then((newTask) {
      if (newTask != null) {
        _addTask(newTask);
      }
    });
  }

  void _addTask(Task task) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.addTask(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage('assets/images/butter.png'),
              width: 200,
              height: 200,
            ),
            Text(
              "Butter Tasks",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: FilterChip(
                    label: Text('Show done tasks'),
                    selected: showDone,
                    onSelected: (selected) {
                      setState(() {
                        Provider.of<TaskProvider>(context, listen: false)
                            .showDoneTasks = selected;
                        showDone = selected;
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return TaskList(key: UniqueKey());
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskForm,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

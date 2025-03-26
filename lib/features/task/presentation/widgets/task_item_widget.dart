import 'package:butter_task/features/task/presentation/widgets/task_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';

class TaskItem extends StatefulWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  IconData iconData = Icons.check_box_outline_blank;
  List<Color> priorityColors = [
    Colors.black,
    Colors.blue,
    Colors.orange,
    Colors.red,
  ];

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
            child: TaskForm(existingTask: widget.task,),
          ),
        ),
      ),
    ).then((newTask) {
      print("created task ==> " + newTask.toString());
      if (newTask != null) {
        print("newTask != null");
        Provider.of<TaskProvider>(context, listen: false).updateTask(newTask);
      }else {
        print("newTask == null");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints.tightForFinite(),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2.0)),
        ),
        child: ListTile(
          selectedColor: Colors.grey,
          onTap: () {
            print('Task selezionata');
          },
          leading: IconButton(
            icon: Icon(
              widget.task.done
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              size: 35,
              color: priorityColors[widget.task.priority - 1],
            ),
            onPressed: () {
              setState(() {
                Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).toggleTaskCompletion(widget.task);
              });
            },
          ),
          title: Text(
            widget.task.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration:
                  widget.task.done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.task.description),
              //print date and time like so 20-10-2023 12:00 in bold
              Text(widget.task.getDate(), style: TextStyle(fontWeight: FontWeight.bold)),
            ]
          ),
          trailing: IconButton(
            onPressed: _showTaskForm,
            icon: Icon(Icons.edit, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class TaskItem extends StatefulWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool check = false;
  IconData iconData = Icons.check_box_outline_blank;
  List<Color> priorityColors = [
    Colors.black,
    Colors.blue,
    Colors.orange,
    Colors.red
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints.tightForFinite(),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2.0)),
          //color: Colors.yellow,
          //borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: ListTile(
          selectedColor: Colors.grey,
          onTap: (){print('Task selezionata');},
          //trailing: Icon(Icons.drag_handle),
          leading: IconButton(
            icon: Icon(
                check ? Icons.check_box : Icons.check_box_outline_blank,
                size: 35,
                color: priorityColors[widget.task.priority-1]
            ), //Colors.yellow[600], Colors.red[600], Colors.blue[600]
            onPressed: () {
              setState(() {
                check = !check;
                widget.task.toggleTask();
                //Navigator.of(context).
              });
            },
          ),
          title: Text(
            widget.task.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                decoration: check
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          subtitle: Text(widget.task.description,)
        ),
      ),
    );
  }
}
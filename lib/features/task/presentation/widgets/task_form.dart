import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import 'package:uuid/uuid.dart';

class TaskForm extends StatefulWidget {
  final Task? existingTask;

  const TaskForm({super.key, this.existingTask});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late int _selectedPriority;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late bool timeSelected;
  late bool dateSelected;

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    // Initialize with existing task values if provided
    titleController = TextEditingController(
      text: widget.existingTask?.title ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.existingTask?.description ?? '',
    );

    // Set priority, default to 1 if not provided
    _selectedPriority = widget.existingTask?.priority ?? 1;

    // Set date and time if provided
    selectedDate = widget.existingTask?.dueDate;
    selectedTime = TimeOfDay.fromDateTime(
      widget.existingTask?.dueDate ?? DateTime.now(),
    );
    timeSelected = widget.existingTask?.timeSelected ?? false;
    dateSelected = widget.existingTask?.dateSelected ?? false;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateSelected = true;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
        timeSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title TextField
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 30, 8.0, 8.0),
            child: TextField(
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLength: 50,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.text_fields),
                labelText: 'Task title',
                hintText: 'Get some butter',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              autofocus: true,
              controller: titleController,
            ),
          ),

          // Description TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 250,
              decoration: const InputDecoration(
                labelText: 'Task description',
                hintText: 'Butter is so tasty :)',
              ),
              controller: descriptionController,
            ),
          ),

          // Priority Segmented Button
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<int>(
              segments: const <ButtonSegment<int>>[
                ButtonSegment(
                  value: 1,
                  label: Text('P1'),
                  icon: Icon(Icons.flag, color: Colors.black),
                ),
                ButtonSegment(
                  value: 2,
                  label: Text('P2'),
                  icon: Icon(Icons.flag, color: Colors.blue),
                ),
                ButtonSegment(
                  value: 3,
                  label: Text('P3'),
                  icon: Icon(Icons.flag, color: Colors.orange),
                ),
                ButtonSegment(
                  value: 4,
                  label: Text('P4'),
                  icon: Icon(Icons.flag, color: Colors.red),
                ),
              ],
              selected: <int>{_selectedPriority},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _selectedPriority = newSelection.first;
                });
              },
            ),
          ),
          // Date and Time Chips
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: [
                // Date Chip
                InputChip(
                  avatar: const Icon(Icons.calendar_month),
                  label: Text(
                    dateSelected
                        ? '${selectedDate!.day}-${selectedDate!.month}'
                        : 'Date',
                  ),
                  onPressed: () => _selectDate(context),
                  onDeleted:
                      dateSelected
                          ? () => setState(() {
                            dateSelected = false;
                            //selectedDate = null;
                          })
                          : null,
                ),

                // Time Chip
                InputChip(
                  avatar: const Icon(Icons.access_time),
                  label: Text(
                    timeSelected
                        ? '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                        : 'Time',
                  ),
                  onPressed: () => _selectTime(context),
                  onDeleted:
                      timeSelected
                          ? () => setState(() {
                            timeSelected = false;
                          })
                          : null,
                ),
              ],
            ),
          ),
          // Save Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 55.0,
              child: ElevatedButton(
                onPressed: () {
                  //add selected time to selected date
                  if (dateSelected == false && timeSelected == true) {
                        selectedDate = DateTime.now();
                        dateSelected = true;
                  }

                  if (selectedDate != null && selectedTime != null) {
                    selectedDate = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );
                  }
                  // Create or update Task with form data
                  if(titleController.text.isEmpty) {
                    return;
                  }
                  Task task = Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    priority: _selectedPriority,
                    done: widget.existingTask?.done ?? false,
                    id: widget.existingTask?.id ?? Uuid().v4(),
                    dueDate: selectedDate,
                    timeSelected: timeSelected,
                    dateSelected: dateSelected,
                  );
                  // Return the task to the previous screen
                  Navigator.pop(context, task);
                },
                child: Text(
                  widget.existingTask == null ? 'Save Task' : 'Update Task',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

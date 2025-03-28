class Task {
  late final String id;
  String title;
  String description;
  bool done;
  int priority;
  DateTime? dueDate;
  bool timeSelected;
  bool dateSelected;
  int position;

  Task({
    String? id,
    required this.title,
    this.description = '',
    this.done = false,
    this.priority = 1,
    this.dueDate,
    this.timeSelected = false,
    this.dateSelected = false,
    this.position = 0,
  }) : id = id ?? DateTime.now().toString();

  // copyWith method
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? done,
    int? priority,
    DateTime? dueDate,
    bool? timeSelected,
    bool? dateSelected,
    int? position,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      done: done ?? this.done,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      timeSelected: this.timeSelected,
      dateSelected: this.dateSelected,
      position: position ?? this.position,
    );
  }

  bool isDone() => done;

  void toggleTask() {
    done = !done;
  }

  String getDate() {
    String date = '';
    if (dueDate != null) {
      if (dateSelected) {
        date = '${dueDate!.day}-${dueDate!.month}-${dueDate!.year}';
      }
      if (timeSelected) {
        date += ' ${dueDate!.hour}:${dueDate!.minute}';
      }
    }

    return date;
  }
}
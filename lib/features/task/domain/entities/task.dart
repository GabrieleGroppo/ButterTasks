class Task {
  late final String id;
  String title;
  String description;
  bool done;
  int priority;

  Task({
    String? id,
    required this.title,
    this.description = '',
    this.done = false,
    this.priority = 1, // Default priority
  }) : id = id ?? DateTime.now().toString();

  // copyWith method
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? done,
    int? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      done: done ?? this.done,
      priority: priority ?? this.priority,
    );
  }

  bool isDone() => done;

  void toggleTask() {
    done = !done;
  }
}
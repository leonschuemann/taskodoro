import 'package:taskodoro/models/task.dart';

class TaskList {
  int? id;
  String name;
  List<Task> tasks;
  bool isNameEditable = false;
  static final TaskList _defaultTaskList = TaskList(id: 0, name: 'Default', tasks: <Task>[]); // TODO Localization

  TaskList({required this.id, required this.name, required this.tasks});

  Map<String, dynamic> toDatabaseMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  static TaskList fromDatabaseMap(Map<String, dynamic> map) {
    final TaskList taskList = TaskList(
      id: map['id'] as int,
      name: map['name'] as String,
      tasks: map['tasks'] as List<Task>,
    );

    return taskList;
  }

  static TaskList getDefaultTaskList() {
    return _defaultTaskList;
  }

  List<Task> getTasks() {
    return tasks;
  }

  void addTask(Task task) {
    tasks.add(task);
  }
}

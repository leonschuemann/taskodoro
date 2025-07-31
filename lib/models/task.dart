import 'package:taskodoro/managers/priority_manager.dart';
import 'package:taskodoro/models/priority.dart';

class Task {
  final int? id;
  late String name;
  late bool isDone;
  late DateTime timeAdded;
  DateTime? timeStart;
  DateTime? timeDue;
  Priority priority = PriorityManager().getDefaultPriority();
  String? description;

  Task({
    required this.id,
    required this.name,
    required this.isDone,
    required this.timeAdded,
  });

  Map<String, dynamic> toDatabaseMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'isDone': isDone ? 1 : 0,
      'timeAdded': timeAdded.toIso8601String(),
      'timeStart': timeStart?.toIso8601String(),
      'timeDue': timeDue?.toIso8601String(),
      'priority': priority.id != 0 ? priority.id : null,
      'description': description,
    };
  }

  static Future<Task> fromDatabaseMap(Map<String, dynamic> map) async {
    final Task task = Task(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      isDone: !(map['isDone'] == 0),
      timeAdded: DateTime.parse(map['timeAdded'] as String),
    );

    final PriorityManager priorityService = PriorityManager();
    final List<Priority> priorities = await priorityService.getPriorities();

    task.timeStart = map['timeStart'] != null ? DateTime.parse(map['timeStart'] as String) : null;
    task.timeDue = map['timeDue'] != null ? DateTime.parse(map['timeDue'] as String) : null;
    task.priority = map['priority'] != 0 && map['priority'] != null
        ? priorityService.getPriority(priorities, map['priority'] as int) ?? priorityService.getDefaultPriority()
        : priorityService.getDefaultPriority();
    task.description = map['description'] as String?;

    return task;
  }
}

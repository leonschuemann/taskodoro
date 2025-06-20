import 'package:taskodoro/models/priority.dart';
import 'package:taskodoro/utils/priority_service.dart';

class Task {
  final int? id;
  late String name;
  late bool isDone;
  late DateTime timeAdded;
  DateTime? timeStart;
  DateTime? timeDue;
  Priority priority = PriorityService().getDefaultPriority();
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

  factory Task.fromDatabaseMap(Map<String, dynamic> map) {
    final Task task = Task(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      isDone: !(map['isDone'] == 0),
      timeAdded: DateTime.parse(map['timeAdded'] as String),
    );

    final PriorityService priorityService = PriorityService();

    task.timeStart = map['timeStart'] != null ? DateTime.parse(map['timeStart'] as String) : null;
    task.timeDue = map['timeDue'] != null ? DateTime.parse(map['timeDue'] as String) : null;
    task.priority = map['priority'] != 0 && map['priority'] != null
        ? priorityService.getPriority(map['priority'] as int) ?? priorityService.getDefaultPriority()
        : priorityService.getDefaultPriority();
    task.description = map['description'] as String?;

    return task;
  }
}

import 'package:taskodoro/models/priority.dart';
import 'package:taskodoro/utils/database_service.dart';

class PriorityManager {
  final DatabaseService _databaseService = DatabaseService();

  final List<Priority> _defaultPriorities = <Priority>[
    Priority(id: 1, level: 1, name: 'Low', isCreatedByUser: false), // TODO Localization
    Priority(id: 2, level: 2, name: 'Medium', isCreatedByUser: false),
    Priority(id: 3, level: 3, name: 'High', isCreatedByUser: false),
  ];
  final Priority choosePriority = Priority(
    id: 0,
    level: 0,
    name: 'Choose Priority',
    isCreatedByUser: false,
  );

  Future<List<Priority>> _getPrioritiesFromDatabase() async {
    final List<Priority> priorities = <Priority>[choosePriority];
    priorities.addAll(await _databaseService.getPriorities());

    return priorities;
  }

  Future<List<Priority>> getPriorities() async {
    final List<Priority> priorities = await _getPrioritiesFromDatabase();
    priorities.sort((Priority a, Priority b) => a.level.compareTo(b.level));

    return priorities;
  }

  List<Priority> getDefaultPriorities() {
    return _defaultPriorities;
  }

  Priority? getPriority(List<Priority> priorities, int id) {
    for (final Priority priority in priorities) {
      if (priority.id == id) {
        return priority;
      }
    }

    return null;
  }

  Priority getDefaultPriority() {
    return choosePriority;
  }

  void addPriority(Priority priority) {
    // TODO
  }
}

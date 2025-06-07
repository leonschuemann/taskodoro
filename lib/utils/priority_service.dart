import 'package:taskodoro/models/priority.dart';
import 'package:taskodoro/utils/database_service.dart';

class PriorityService {
  static final PriorityService _instance = PriorityService._internal();
  factory PriorityService() => _instance;
  PriorityService._internal();

  final DatabaseService _databaseService = DatabaseService();

  final List<Priority> _defaultPriorities = <Priority>[
    Priority(id: 1, level: 1, name: 'Low', isCreatedByUser: false), // TODO Localization
    Priority(id: 2, level: 2, name: 'Medium', isCreatedByUser: false),
    Priority(id: 3, level: 3, name: 'High', isCreatedByUser: false),
  ];
  List<Priority> _priorities = <Priority>[];
  final Priority choosePriority = Priority(
    id: 0,
    level: 0,
    name: 'Choose Priority',
    isCreatedByUser: false,
  );

  Future<void> loadPriorities() async {
    final List<Priority> priorities = await _databaseService.getPriorities();
    _priorities = <Priority>[choosePriority];
    _priorities.addAll(priorities);
  }

  List<Priority> getPriorities() {
    _priorities.sort((Priority a, Priority b) => a.level.compareTo(b.level));

    return _priorities;
  }

  List<Priority> getDefaultPriorities() {
    return _defaultPriorities;
  }

  int getPrioritiesCount() {
    return _priorities.length;
  }

  Priority? getPriority(int id) {
    for (final Priority priority in _priorities) {
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

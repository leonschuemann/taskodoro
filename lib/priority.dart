import 'database_service.dart';

class PriorityManager {
  static final PriorityManager _instance = PriorityManager._internal();
  factory PriorityManager() => _instance;
  PriorityManager._internal();

  final DatabaseService _databaseService = DatabaseService();

  final List<Priority> _defaultPriorities = [
    Priority(id: 1, level: 1, name: 'Low', isCreatedByUser: false), // TODO Localization
    Priority(id: 2, level: 2, name: 'Medium', isCreatedByUser: false),
    Priority(id: 3, level: 3, name: 'High', isCreatedByUser: false)
  ];
  List<Priority> _priorities = [];
  final Priority choosePriority = Priority(id: 0, level: 0, name: "Choose Priority", isCreatedByUser: false);

  Future<void> loadPriorities() async {
    List<Priority> priorities = await _databaseService.getPriorities();
    _priorities = [choosePriority];
    _priorities.addAll(priorities);
  }

  List<Priority> getPriorities() {
    _priorities.sort((a, b) => a.level.compareTo(b.level));
    
    return _priorities;
  }

  List<Priority> getDefaultPriorities() {
    return _defaultPriorities;
  }

  int getPrioritiesCount() {
    return _priorities.length;
  }

  Priority? getPriority(int id) {
    for (Priority priority in _priorities) {
      if (priority.id == id) {
        return priority;
      }
    }

    return null;
  }

  Priority getDefaultPriority() {
    return _priorities[0];
  }

  void addPriority(Priority priority) {
    // TODO
  }
}

class Priority {
  int id;
  int level;
  String name;
  bool isCreatedByUser;

  Priority({
    required this.id,
    required this.level,
    required this.name,
    required this.isCreatedByUser
  });

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toDatabaseMap() {
    return {
      'id': id,
      'level': level,
      'name': name,
      'isCreatedByUser': isCreatedByUser ? 1 : 0,
    };
  }

  factory Priority.fromDatabaseMap(Map<String, dynamic> map) {
    return Priority(
      id: map['id'],
      level: map['level'],
      name: map['name'],
      isCreatedByUser: map['isCreatedByUser'] == 0 ? false : true,
    );
  }
}
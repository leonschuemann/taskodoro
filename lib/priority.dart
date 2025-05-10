class PriorityManager {
  final List<Priority> _priorities = [
    Priority(0, "Choose Priority"),
    Priority(1, "Low"),
    Priority(2, "Medium"),
    Priority(3, "High"),
  ];

  List<Priority> getPriorities() {
    _priorities.sort((a, b) => a.level.compareTo(b.level));
    
    return _priorities;
  }

  int getPrioritiesCount() {
    return _priorities.length;
  }

  Priority getDefaultPriority() {
    return _priorities[0];
  }

  void addPriority(Priority priority) {
    // TODO
  }
}

class Priority {
  int level;
  String name;

  Priority(this.level, this.name);

  @override
  String toString() {
    return name;
  }
}
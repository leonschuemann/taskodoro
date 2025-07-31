class Priority {
  int id;
  int level;
  String name;
  bool isCreatedByUser;

  Priority({
    required this.id,
    required this.level,
    required this.name,
    required this.isCreatedByUser,
  });

  static Priority fromDatabaseMap(Map<String, dynamic> map) {
    return Priority(
      id: map['id'] as int,
      level: map['level'] as int,
      name: map['name'] as String,
      isCreatedByUser: !(map['isCreatedByUser'] == 0),
    );
  }

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toDatabaseMap() {
    return <String, dynamic>{
      'id': id,
      'level': level,
      'name': name,
      'isCreatedByUser': isCreatedByUser ? 1 : 0,
    };
  }
}

class Task {
  final int id;
  late String name;
  late bool isDone;
  late DateTime timeAdded;
  DateTime? timeStart;
  DateTime? timeDue;
  int? priorityId;
  String? description;

  Task(this.id, this.name, this.isDone, this.timeAdded);
}
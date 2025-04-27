import 'package:taskodoro/priority.dart';
import 'package:taskodoro/task.dart';
import 'package:flutter/material.dart';

class CardTask extends StatefulWidget {
  final Task task;
  const CardTask(this.task, {super.key});

  @override
  State<StatefulWidget> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  late Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    PriorityManager priorityManager = PriorityManager();

    List<DropdownMenuItem> priorities = [
      for (Priority priority in priorityManager.getPriorities())
        DropdownMenuItem(
          value: priority.name,
          child: Text(priority.name),
        )
    ];

    String priority = priorityManager.getPriorities()[0].toString();

    return Card.filled(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 6),
          Row(
            children: [
              const SizedBox(width: 6),
              Checkbox(
                value: task.isDone,
                onChanged: (value) {
                  setState(() {
                    task.isDone = value!;
                  });
                }
              ),
              const SizedBox(width: 6),
              Text(task.name),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  throw ErrorDescription("Not yet implemented");
                },
                label: Text('Delete'),
                icon: Icon(Icons.delete)),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              const Text("Due Date:"),
              // SizedBox(width: 4),
              TextButton.icon(
                onPressed: () {
                  throw ErrorDescription("Not yet implemented");
                },
                label: Text("Choose Date")
              ),
              const SizedBox(width: 10),
              const Text("Priority:"),
              const SizedBox(width: 6),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField(
                  value: priority,
                  items: priorities,
                  dropdownColor: Theme.of(context).colorScheme.primaryContainer,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                  onChanged: (newPriority) {
                    setState(() {
                      priority = newPriority;
                    });
                  }
                ),
              )
            ],
          ),
          task.description != null ? Row(
            children: [
              const SizedBox(width: 10),
              Text(task.description ?? ""),
            ],
          ) : SizedBox(),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}

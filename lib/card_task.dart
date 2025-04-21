import 'package:taskodoro/priority.dart';
import 'package:taskodoro/task.dart';
import 'package:flutter/material.dart';

class CardTask extends StatelessWidget { // TODO Change to StatefulWidget
  @override
  Widget build(BuildContext context) {
    PriorityManager priorityManager = PriorityManager();

    List<DropdownMenuEntry> priorities = [
      for (Priority priority in priorityManager.getPriorities())
        DropdownMenuEntry(
          value: priority.level,
          label: priority.name
        )
    ];

    return Card.filled(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 6),
              Checkbox(
                value: task.isDone,
                onChanged: (value) {
                  throw ErrorDescription("Not yet implemented");
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
              DropdownMenu(
                dropdownMenuEntries: priorities,
                label: Text(
                  "Priority",
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),

              )
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Text(task.description ?? ""),
            ],
          ),
          SizedBox(height: 6)
        ],
      ),
    );
  }

  Task task;

  CardTask(this.task, {super.key});
}
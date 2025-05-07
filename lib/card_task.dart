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

    String priority = priorityManager.getPriorities()[0].toString();

    List<MenuItemButton> priorities = [
      for (Priority currentPriority in priorityManager.getPriorities())
        MenuItemButton(
          child: Text(currentPriority.toString()),
          onPressed: () => setState(() {
            priority = currentPriority.toString();
          }),
        )
    ];

    final FocusNode buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

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
              TextButton.icon(
                onPressed: () {
                  throw ErrorDescription("Not yet implemented");
                },
                label: Text("Choose Date"),
                icon: Icon(Icons.calendar_month_outlined),
              ),
              const SizedBox(width: 10),
              const Text("Priority:"),
              const SizedBox(width: 6),
              MenuAnchor(
                childFocusNode: buttonFocusNode,
                menuChildren: priorities,
                builder: (BuildContext context, MenuController controller, Widget? child) {
                  return TextButton(
                    focusNode: buttonFocusNode,
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    child: Text(priority),
                  );
                },
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

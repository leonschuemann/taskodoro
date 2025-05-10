import 'package:taskodoro/priority.dart';
import 'package:taskodoro/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardTask extends StatefulWidget {
  final Task task;
  final String priority;
  const CardTask(this.task, {super.key, required this.priority});

  @override
  State<StatefulWidget> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  late Task task;
  late String priority;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    priority = widget.priority;
  }

  @override
  Widget build(BuildContext context) {
    PriorityManager priorityManager = PriorityManager();

    List<MenuItemButton> priorities = [
      for (Priority currentPriority in priorityManager.getPriorities())
        MenuItemButton(
          child: Text(currentPriority.toString()),
          onPressed: () => {
            setState(() {
              priority = currentPriority.toString();
              task.priority = currentPriority;
            })
          },
        )
    ];

    final FocusNode buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
    final localizations = AppLocalizations.of(context);

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
                label: Text(localizations!.taskDelete),
                icon: Icon(Icons.delete)),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Text('${localizations.dueDate}:'),
              TextButton.icon(
                onPressed: () {
                  throw ErrorDescription("Not yet implemented");
                },
                label: Text(localizations.chooseDate),
                icon: Icon(Icons.calendar_month_outlined),
              ),
              const SizedBox(width: 10),
              Text('${localizations.priority}:'),
              const SizedBox(width: 6),
              MenuAnchor(
                childFocusNode: buttonFocusNode,
                menuChildren: priorities,
                builder: (BuildContext context, MenuController controller, Widget? child) {
                  return SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      focusNode: buttonFocusNode,
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      child: Text(priority),
                    ),
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

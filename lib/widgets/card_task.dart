import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskodoro/models/priority.dart';
import 'package:taskodoro/models/task.dart';
import 'package:taskodoro/utils/database_service.dart';
import 'package:taskodoro/utils/priority_manager.dart';

class CardTask extends StatefulWidget {
  const CardTask(this.task, {required this.priority, required this.deleteTask, super.key});
  final Task task;
  final String priority;
  final VoidCallback deleteTask;

  @override
  State<StatefulWidget> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  DatabaseService databaseService = DatabaseService();
  late Task task;
  late String priority;
  late VoidCallback deleteTask;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    priority = widget.priority;
    deleteTask = widget.deleteTask;
  }

  Future<void> _updateTask(Task task) async {
    await databaseService.updateTask(task);
  }

  @override
  Widget build(BuildContext context) {
    final PriorityService priorityManager = PriorityService();

    final List<MenuItemButton> priorities = <MenuItemButton>[
      for (final Priority currentPriority in priorityManager.getPriorities())
        MenuItemButton(
          child: Text(currentPriority.toString()),
          onPressed: () => <void>{
            setState(() {
              priority = currentPriority.toString();
              task.priority = currentPriority;
              _updateTask(task);
            }),
          },
        ),
    ];

    final FocusNode buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
    final AppLocalizations? localizations = AppLocalizations.of(context);
    final TextEditingController taskNameController = TextEditingController();
    final TextEditingController taskDescriptionController = TextEditingController();
    taskNameController.text = task.name;
    taskDescriptionController.text = task.description ?? '';

    return Card.filled(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              const SizedBox(width: 6),
              Checkbox(
                value: task.isDone,
                onChanged: (bool? value) {
                  setState(() {
                    task.isDone = value!;
                    _updateTask(task);
                  });
                },
              ),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  controller: taskNameController,
                  onSubmitted: (String str) {
                    setState(() {
                      taskNameController.text = str;
                      task.name = str;

                      _updateTask(task);
                    });
                  },
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => <void>{
                  deleteTask(),
                },
                label: Text(localizations!.taskDelete),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              const SizedBox(width: 10),
              Text('${localizations.dueDate}:'),
              TextButton.icon(
                onPressed: () {
                  throw ArgumentError('Not yet implemented');
                },
                label: Text(localizations.chooseDate),
                icon: const Icon(Icons.calendar_month_outlined),
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
              ),
            ],
          ),
          Row(
            children: <Widget>[
              const SizedBox(width: margin),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  controller: taskDescriptionController,
                  onSubmitted: (String str) {
                    setState(() {
                      taskDescriptionController.text = str;
                      task.description = str;

                      _updateTask(task);
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
            ],
          ) else const SizedBox(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/managers/priority_manager.dart';
import 'package:taskodoro/models/priority.dart';
import 'package:taskodoro/models/task.dart';
import 'package:taskodoro/themes/spacing_theme.dart';
import 'package:taskodoro/utils/database_service.dart';
import 'package:taskodoro/widgets/task_form_body.dart';
import 'package:taskodoro/widgets/task_name_field.dart';

class CardTask extends StatefulWidget {
  const CardTask(this.task,
      {required this.priority, required this.deleteTask, required this.selectTaskDate, super.key});
  final Task task;
  final String priority;
  final VoidCallback deleteTask;
  final ValueChanged<Task> selectTaskDate;

  @override
  State<StatefulWidget> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();

  late Task task;
  late String priority;
  late VoidCallback deleteTask;
  List<Priority> priorities = <Priority>[];

  Timer? debounce;
  final int debounceTimeMs = 250;

  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    task = widget.task;
    priority = widget.priority;
    deleteTask = widget.deleteTask;
    _loadPriorities();
  }

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadPriorities() async {
    final PriorityManager priorityService = PriorityManager();
    final List<Priority> priorities = await priorityService.getPriorities();

    setState(() {
      this.priorities = priorities;
    });
  }

  Future<void> _updateTask(Task task) async {
    await databaseService.updateTask(task);
  }

  @override
  Widget build(BuildContext context) {
    const double margin = SpacingTheme.margin;
    const double gap = SpacingTheme.gap;

    final List<MenuItemButton> priorities = <MenuItemButton>[
      for (final Priority currentPriority in this.priorities)
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

    final AppLocalizations? localizations = AppLocalizations.of(context);
    final String locale = Localizations.localeOf(context).languageCode;
    taskNameController.text = task.name;
    taskDescriptionController.text = task.description ?? '';


    return Card.filled(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: margin),
          Row(
            children: <Widget>[
              const SizedBox(width: margin),
              Center(
                child: Checkbox(
                  value: task.isDone,
                  onChanged: (bool? value) {
                    setState(() {
                      task.isDone = value!;
                      _updateTask(task);
                    });
                  },
                ),
              ),
              const SizedBox(width: SpacingTheme.smallGap),
              Expanded(
                child: TaskNameField(
                  onChanged: onTaskNameChange,
                  localizations: localizations!,
                  taskName: task.name,
                )
              ),
              const SizedBox(width: gap,),
              TextButton.icon(
                onPressed: () => <void>{
                  deleteTask(),
                },
                label: Text(
                  localizations!.taskDelete,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                icon: const Icon(Icons.delete),
              ),
              const SizedBox(width: margin,),
            ],
          ),
          const SizedBox(height: margin,),
          TaskFormBody(
            onDueDatePressed: onDueDatePressed,
            onClearDueDate: onClearDueDate,
            localizations: localizations,
            locale: locale,
            priorities: priorities,
            onClearPriority: onClearPriority,
            onChangedDescription: onChangedDescription,
            priority: priority,
            taskTimeDue: task.timeDue,
            description: task.description,
          ),
          const SizedBox(height: margin,),
        ],
      ),
    );
  }

  void onTaskNameChange(String value) {
    task.name = value;

    debounce?.cancel();
    debounce = Timer(Duration(milliseconds: debounceTimeMs), () {
      _updateTask(task);
    });
  }

  Future<void> onDueDatePressed() async {
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(1970),
      lastDate: DateTime(2037, 12),
      initialDate: task.timeDue ?? DateTime.now(),
    );

    if (date == null) {
      return;
    }

    task.timeDue = date;
    widget.selectTaskDate(task);
  }

  void onClearDueDate() {
    task.timeDue = null;

    widget.selectTaskDate(task);
  }

  void onClearPriority() {
    final PriorityManager priorityManager = PriorityManager();

    setState(() {
      task.priority = priorityManager.getDefaultPriority();
      priority = task.priority.toString();

      _updateTask(task);
    });
  }

  void onChangedDescription(String value) {
    task.description = value;

    debounce?.cancel();
    debounce = Timer(Duration(milliseconds: debounceTimeMs), () {
      _updateTask(task);
    });
  }
}

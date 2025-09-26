import 'package:flutter/material.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/managers/priority_manager.dart';
import 'package:taskodoro/models/priority.dart';
import 'package:taskodoro/models/task.dart';
import 'package:taskodoro/themes/spacing_theme.dart';
import 'package:taskodoro/widgets/task_form_body.dart';
import 'package:taskodoro/widgets/task_name_field.dart';

class AddTaskDialog extends StatefulWidget {
  final ValueChanged<Task> addTask;

  const AddTaskDialog({super.key, required this.addTask});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  String? taskName;
  FocusNode priorityButtonFocusNode = FocusNode();
  Priority? priority;
  List<Priority> priorities = <Priority>[];
  DateTime? pickedDate;
  String? description;

  @override
  void initState() {
    _loadPriorities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String locale = Localizations.localeOf(context).languageCode;

    final List<MenuItemButton> priorities = <MenuItemButton>[
      for (final Priority currentPriority in this.priorities)
        MenuItemButton(
          child: Text(currentPriority.toString()),
          onPressed: () {
            setState(() {
              priority = currentPriority;
            });
          },
        ),
    ];

    return AlertDialog(
      title: Text(localizations.addNewTask),
      actions: <Widget>[
        TextButton(
          onPressed: addTask,
          child: Text(localizations.addTask)
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: SpacingTheme.margin),
          TaskNameField(
            taskName: taskName,
            localizations: localizations,
            onChanged: onChangedTaskName,
          ),
          const SizedBox(height: SpacingTheme.margin,),
          TaskFormBody(
            onDueDatePressed: onDueDatePressed,
            onClearDueDate: onClearDueDate,
            localizations: localizations,
            locale: locale,
            priorities: priorities,
            onClearPriority: onClearPriority,
            onChangedDescription: onChangedDescription,
            priority: priority?.toString(),
            taskTimeDue: pickedDate,
            description: description,
          ),
          const SizedBox(height: SpacingTheme.margin,),
        ],
      ),
    );
  }

  void onChangedTaskName(String name) {
    taskName = name;
  }

    Future<void> _loadPriorities() async {
      final PriorityManager priorityService = PriorityManager();
      final List<Priority> priorities = await priorityService.getPriorities();

      setState(() {
        this.priorities = priorities;
      });
    }

    Future<void> onDueDatePressed() async {
      final DateTime? date = await showDatePicker(
        context: context,
        firstDate: DateTime(1970),
        lastDate: DateTime(2037, 12),
        initialDate: pickedDate ?? DateTime.now(),
      );

      if (date == null) {
        return;
      }

      setState(() {
        pickedDate = date;
      });
    }

    void addTask() {
      final Task task = Task(
        id: null,
        name: taskName ?? '',
        isDone: false,
        timeAdded: DateTime.now(),
      );
      task.description = description;
      task.timeDue = pickedDate;

      if (priority != null) {
        task.priority = priority!;
      }

      widget.addTask(task);

      Navigator.of(context).pop();
    }

    void onClearDueDate() {
      setState(() {
        pickedDate = null;
      });
    }

    void onClearPriority() {
      setState(() {
        priority = null;
      });
    }

  void onChangedDescription(String description) {
    this.description = description;
  }
}

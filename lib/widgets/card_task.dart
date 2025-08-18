import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/managers/priority_manager.dart';
import 'package:taskodoro/models/priority.dart';
import 'package:taskodoro/models/task.dart';
import 'package:taskodoro/themes/spacing_theme.dart';
import 'package:taskodoro/utils/database_service.dart';

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
    final PriorityManager priorityService = PriorityManager();

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

    final FocusNode priorityButtonFocusNode = FocusNode(debugLabel: 'Priority Menu Button');
    final AppLocalizations? localizations = AppLocalizations.of(context);
    final String locale = Localizations
        .localeOf(context)
        .languageCode;
    taskNameController.text = task.name;
    taskDescriptionController.text = task.description ?? '';

    Timer? debounce;
    const int debounceTimeMs = 250;

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
                child: TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: localizations?.name,
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                  controller: taskNameController,
                  onChanged: (String value) {
                    task.name = value;

                    debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: debounceTimeMs), () {
                      _updateTask(task);
                    });
                  },
                ),
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
          Row(
            children: <Widget>[
              const SizedBox(width: margin),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: SpacingTheme.roundedRectangleBorderRadius,
                  ),
                  padding: SpacingTheme.outlinedButtonPadding,
                ),
                onPressed: () async {
                  final DateTime? date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1970),
                    lastDate: DateTime(2037, 12),
                    initialDate: task.timeDue,
                  );

                  if (date == null) {
                    return;
                  }

                  task.timeDue = date;
                  widget.selectTaskDate(task);
                },
                label: Row(
                  children: <Widget>[
                    Text(
                      task.timeDue == null
                          ? localizations.chooseDate
                          : DateFormat('dd.MM.yyyy', locale).format(task.timeDue!),
                      // TODO: Make format configurable
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: gap,),
                    IconButton(
                      onPressed: () {
                        task.timeDue = null;

                        widget.selectTaskDate(task);
                      },
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: SpacingTheme.smallIconButtonConstraints,
                    ),
                  ],
                ),
                icon: const Icon(Icons.calendar_month_outlined),
              ),
              const SizedBox(width: 10),
              MenuAnchor(
                childFocusNode: priorityButtonFocusNode,
                menuChildren: priorities,
                builder: (BuildContext context, MenuController controller, Widget? child) {
                  return SizedBox(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: SpacingTheme.roundedRectangleBorderRadius,
                        ),
                        padding: SpacingTheme.outlinedButtonPadding,
                      ),
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.flag_outlined),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            priority,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: margin,),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                task.priority = priorityService.getDefaultPriority();
                                priority = task.priority.toString();

                                _updateTask(task);
                              });
                            },
                            icon: const Icon(Icons.close),
                            padding: SpacingTheme.smallIconButtonPadding,
                            constraints: SpacingTheme.smallIconButtonConstraints,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: margin,),
          Row(
            children: <Widget>[
              const SizedBox(width: margin),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: SpacingTheme.roundedRectangleBorderRadius),
                    isDense: true,
                    labelText: localizations.description,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: taskDescriptionController,
                  onChanged: (String value) {
                    task.description = value;

                    debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: debounceTimeMs), () {
                      _updateTask(task);
                    });
                  },
                ),
              ),
              const SizedBox(width: margin),
            ],
          ),
          const SizedBox(height: margin,),
        ],
      ),
    );
  }
}

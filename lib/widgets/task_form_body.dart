import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/managers/priority_manager.dart';
import 'package:taskodoro/themes/spacing_theme.dart';

class TaskFormBody extends StatelessWidget {
  final DateTime? taskTimeDue;
  final VoidCallback onDueDatePressed;
  final VoidCallback onClearDueDate;
  final AppLocalizations localizations;
  final String locale;
  final String? priority;
  final List<Widget> priorities;
  final VoidCallback onClearPriority;
  final ValueChanged<String> onChangedDescription;
  final String? description;
  final bool shouldExpandPriorityMenu;

  final FocusNode priorityButtonFocusNode = FocusNode();
  final TextEditingController taskDescriptionController = TextEditingController();

  TaskFormBody({super.key, required this.onDueDatePressed, required this.onClearDueDate,
    required this.localizations, required this.locale, required this.priorities,
    required this.onClearPriority, required this.onChangedDescription, this.priority,
    this.taskTimeDue, this.description, required this.shouldExpandPriorityMenu,
  });

  @override
  Widget build(BuildContext context) {
    final PriorityManager priorityManager = PriorityManager();
    taskDescriptionController.text = description ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingTheme.margin),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: SpacingTheme.roundedRectangleBorderRadius,
                  ),
                  padding: SpacingTheme.outlinedButtonPadding,
                ),
                onPressed: onDueDatePressed,
                label: Row(
                  children: <Widget>[
                    Text(
                      taskTimeDue == null
                          ? localizations.chooseDate
                          : DateFormat('dd.MM.yyyy', locale).format(taskTimeDue!),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: SpacingTheme.gap,),
                    IconButton(
                      onPressed: onClearDueDate,
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: SpacingTheme.smallIconButtonConstraints,
                    ),
                  ],
                ),
                icon: const Icon(Icons.calendar_month_outlined),
              ),
              const SizedBox(width: 10),

              if (shouldExpandPriorityMenu) Expanded(child: getPriorityMenuAnchor(priorityManager))
              else Flexible(child: getPriorityMenuAnchor(priorityManager)),
            ],
          ),
          const SizedBox(height: SpacingTheme.margin,),
          Row(
            children: <Widget>[
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
                  onChanged: onChangedDescription,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getPriorityMenuAnchor(PriorityManager priorityManager) {
    return MenuAnchor(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: shouldExpandPriorityMenu ? MainAxisSize.max : MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Text(
                    priority ?? priorityManager.choosePriority.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: SpacingTheme.margin,),
                IconButton(
                  onPressed: onClearPriority,
                  icon: const Icon(Icons.close),
                  padding: SpacingTheme.smallIconButtonPadding,
                  constraints: SpacingTheme.smallIconButtonConstraints,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

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
  final VoidCallback onSetPriority;
  final ValueChanged<String> onChangedDescription;
  final String? description;

  final FocusNode priorityButtonFocusNode = FocusNode();
  final TextEditingController taskDescriptionController = TextEditingController();

  TaskFormBody({super.key, required this.onDueDatePressed, required this.onClearDueDate, required this.localizations, required this.locale, required this.priorities, required this.onSetPriority, required this.onChangedDescription, this.priority, this.taskTimeDue, this.description,});

  @override
  Widget build(BuildContext context) {
    final PriorityManager priorityManager = PriorityManager();
    taskDescriptionController.text = description ?? '';

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox(width: SpacingTheme.margin),
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
                          priority ?? priorityManager.choosePriority.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: SpacingTheme.margin,),
                        IconButton(
                          onPressed: onSetPriority,
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
        const SizedBox(height: SpacingTheme.margin,),
        Row(
          children: <Widget>[
            const SizedBox(width: SpacingTheme.margin),
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
            const SizedBox(width: SpacingTheme.margin),
          ],
        ),
      ],
    );
  }
  
}
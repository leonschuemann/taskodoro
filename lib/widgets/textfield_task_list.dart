import 'package:flutter/material.dart';
import 'package:taskodoro/models/task_list.dart';
import 'package:taskodoro/themes/spacing_theme.dart';

class TextFieldTaskList extends StatelessWidget {
  final TaskList taskList;
  final VoidCallback selectTaskList;
  final bool isSelected;

  const TextFieldTaskList({
    super.key,
    required this.taskList,
    required this.selectTaskList,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: selectTaskList,
      style: TextButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: SpacingTheme.roundedRectangleBorderRadius,
        ),
        overlayColor: Theme.of(context)
            .colorScheme
            .onPrimaryContainer
            .withOpacity(0.1),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          taskList.name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:taskodoro/l10n/app_localizations.dart';

class TaskNameField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final AppLocalizations localizations;
  final String? taskName;
  final TextEditingController taskNameController = TextEditingController();

  TaskNameField({super.key, required this.localizations, this.onChanged, this.taskName});

  @override
  Widget build(BuildContext context) {
    taskNameController.text = taskName ?? '';

    return TextField(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        hintText: localizations.name,
      ),
      style: Theme.of(context).textTheme.titleMedium,
      controller: taskNameController,
      onChanged: onChanged,
    );
  }
}

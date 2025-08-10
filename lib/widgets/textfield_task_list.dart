import 'package:flutter/material.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/models/task_list.dart';
import 'package:taskodoro/themes/spacing_theme.dart';

class TextFieldTaskList extends StatefulWidget {
  final TaskList taskList;
  final bool isSelected;
  final bool isEditing;
  final AppLocalizations localizations;
  final ValueChanged<String>? onEditingComplete;
  final VoidCallback? onEditingCanceled;
  final VoidCallback? selectTaskList;

  const TextFieldTaskList({
    super.key,
    required this.taskList,
    required this.isSelected,
    required this.localizations,
    this.onEditingComplete,
    this.onEditingCanceled,
    this.selectTaskList,
    this.isEditing = false,
  });

  @override
  State<StatefulWidget> createState() => _TextFieldTaskListState();
}

class _TextFieldTaskListState extends State<TextFieldTaskList> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(focusHasChanged);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.selectTaskList,
      style: TextButton.styleFrom(
        backgroundColor: widget.isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: SpacingTheme.roundedRectangleBorderRadius,
        ),
        overlayColor: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.1),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: widget.isEditing
          ? TextField(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            hintText: widget.localizations.enterListName,
          ),
          controller: controller,
            focusNode: focusNode,
            autofocus: true,
            onSubmitted: (String name) {
              widget.onEditingComplete!(name);
            },
          )
          : Text(
            widget.taskList.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: widget.isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
      ),
    );
  }

  void focusHasChanged() {
    if (!focusNode.hasFocus && widget.onEditingCanceled != null) {
      widget.onEditingCanceled!();
    }
  }
}

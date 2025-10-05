import 'dart:io';

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
  final VoidCallback? editTasklist;
  final VoidCallback? deleteTaskList;

  const TextFieldTaskList({
    super.key,
    required this.taskList,
    required this.isSelected,
    required this.localizations,
    this.onEditingComplete,
    this.onEditingCanceled,
    this.selectTaskList,
    this.isEditing = false,
    this.editTasklist,
    this.deleteTaskList,
  });

  @override
  State<StatefulWidget> createState() => _TextFieldTaskListState();
}

class _TextFieldTaskListState extends State<TextFieldTaskList> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  final bool isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(focusHasChanged);
    controller.text = widget.taskList.name;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (TapDownDetails tapDownDetails) {
        _showContextMenu(context, tapDownDetails.globalPosition);
      },
      onLongPressStart: (!isDesktop ?
        (LongPressStartDetails longPressStartDetails) {
          _showContextMenu(context, longPressStartDetails.globalPosition);
        }
        : null
      ),
      child: TextButton(
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
      ),
    );
  }

  void focusHasChanged() {
    if (!focusNode.hasFocus && widget.onEditingCanceled != null) {
      widget.onEditingCanceled!();
    }
  }

  Future<void> _showContextMenu(BuildContext buildContext, Offset position) async {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final String? selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'rename',
          enabled: widget.taskList.id != 0,
          child: Text(localizations.rename),
        ),
        PopupMenuItem(
          value: 'delete',
          enabled: widget.taskList.id != 0,
          child: Text(localizations.delete),
        ),
      ]
    );

    if (selected == 'rename') {
      widget.editTasklist!();
    } else if (selected == 'delete') {
      widget.deleteTaskList!();
    }
  }
}

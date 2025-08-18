import 'package:flutter/material.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/models/task.dart';
import 'package:taskodoro/models/task_list.dart';
import 'package:taskodoro/themes/spacing_theme.dart';
import 'package:taskodoro/utils/database_service.dart';
import 'package:taskodoro/widgets/card_task.dart';
import 'package:taskodoro/widgets/date_divider.dart';
import 'package:taskodoro/widgets/textfield_task_list.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _newTaskController = TextEditingController();
  late List<TaskList> taskLists = <TaskList>[];
  late int selectedTaskListId = 0;
  bool isCreatingNewTaskList = false;

  TaskList get selectedTaskList {
    return taskLists.firstWhere(
      (TaskList list) => list.id == selectedTaskListId,
      orElse: () => taskLists.isNotEmpty ? taskLists.first : TaskList.getDefaultTaskList(),
    );
  }

  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTaskLists();
  }

  @override
  void dispose() {
    _newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 8,),
          appBar(localizations),
          const Divider(),
          body(localizations, context),
        ],
      ),
    );
  }

  Widget appBar(AppLocalizations localizations) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 80,),
        const Spacer(flex: 2,),
        Expanded(
          flex: 6,
          child: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: localizations.enterNewTask,
            ),
            controller: _newTaskController,
            onSubmitted: (String taskName) {
              if (taskName.isEmpty) {
                return;
              }
              
              _addTask(taskName, selectedTaskListId);
            },
          ),
        ),
        const Spacer(flex: 2,),
        IconButton(
          onPressed: () {
            throw ArgumentError('Not yet implemented');
          },
          icon: const Icon(Icons.settings),
          iconSize: SpacingTheme.smallIconSize,
        ),
        IconButton(
          onPressed: () {
            throw ArgumentError('Not yet implemented');
          },
          icon: const Icon(Icons.timer),
          iconSize: SpacingTheme.smallIconSize,
        ),
      ],
    );
  }

  Widget body(AppLocalizations localizations, BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth >= 1000) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: taskListsView(localizations)
                ),
                const VerticalDivider(),
                Expanded(
                  flex: 4,
                  child: tasksView(localizations),
                ),
              ],
            );
          } else {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000, minWidth: 400),
              child: tasksView(localizations),
            );
          }
        },
      ),
    );
  }

  Widget tasksView(AppLocalizations localizations) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Column(
        children: <Widget>[
          const SizedBox(height: SpacingTheme.gapAboveDateDividers),
          DateDivider(localizations.noDueDate),
          Expanded(
            child: selectedTaskList.getTasks().isEmpty && !hasLoaded
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              children: selectedTaskList.getTasks().map((Task task) {
                return CardTask(
                  key: ValueKey<int>(task.id!),
                  task,
                  priority: task.priority.toString(),
                  deleteTask: () => deleteTask(task.id!),
                  selectTaskDate: selectTaskDate,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget taskListsView(AppLocalizations localizations) {
    final List<Widget> taskListsAndAddButton = taskLists.map<Widget>((TaskList taskList) {
      return TextFieldTaskList(
        taskList: taskList,
        isSelected: taskList.id == selectedTaskListId,
        localizations: localizations,
        selectTaskList: () => selectTaskList(taskList),
      );
    }).toList();

    if (isCreatingNewTaskList) {
      taskListsAndAddButton.add(
        TextFieldTaskList(
          taskList: TaskList(id: -1, name: '', tasks: <Task>[]),
          isSelected: false,
          localizations: localizations,
          onEditingComplete: (String name) {
            _addTaskList(name);
          },
          onEditingCanceled: _cancelAddingTaskList,
          isEditing: true,
        )
      );
    } else {
      taskListsAndAddButton.add(
        TextButton.icon(
          onPressed: () {
            setState(() {
              isCreatingNewTaskList = true;
            });
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: SpacingTheme.roundedRectangleBorderRadius,
            ),
          ),
          label: Text(localizations.addTaskList),
          icon: const Icon(Icons.add),
        )
      );
    }

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return taskListsAndAddButton[index];
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: SpacingTheme.smallGap);
        },
        itemCount: taskListsAndAddButton.length,
      ),
    );
  }

  Future<void> _addTask(String taskName, int taskListId) async {
    final Task task = Task(id: null, name: taskName, isDone: false, timeAdded: DateTime.now());
    await _databaseService.insertTask(task, taskListId);
    await _loadTaskLists();
    _newTaskController.clear();
  }

  Future<void> _loadTaskLists() async {
    final List<TaskList> taskLists = await _databaseService.getTaskLists();

    setState(() {
      this.taskLists = taskLists;
    });

    hasLoaded = true;
  }

  Future<void> deleteTask(int id) async {
    await _databaseService.deleteTask(id);
    await _loadTaskLists();
  }

  void selectTaskList(TaskList taskList) {
    if (selectedTaskListId == taskList.id) {
      return;
    }

    setState(() {
      selectedTaskListId = taskList.id!;
    });
  }

  Future<void> _addTaskList(String taskListName) async {
    final TaskList taskList = TaskList(
      id: null,
      name: taskListName,
      tasks: <Task>[]
    );

    final int id = await _databaseService.insertTaskList(taskList);

    setState(() {
      selectedTaskListId = id;
      isCreatingNewTaskList = false;
      _loadTaskLists();
    });
  }

  void _cancelAddingTaskList() {
    setState(() {
      isCreatingNewTaskList = false;
    });
  }

  Future<void> selectTaskDate(Task task) async {
    await _databaseService.updateTask(task);

    await _loadTaskLists();
  }
}

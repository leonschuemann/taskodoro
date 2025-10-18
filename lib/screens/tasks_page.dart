import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/models/task.dart';
import 'package:taskodoro/models/task_list.dart';
import 'package:taskodoro/screens/pomodoro_page.dart';
import 'package:taskodoro/screens/settings_page.dart';
import 'package:taskodoro/themes/spacing_theme.dart';
import 'package:taskodoro/utils/database_service.dart';
import 'package:taskodoro/widgets/add_task_dialog.dart';
import 'package:taskodoro/widgets/card_task.dart';
import 'package:taskodoro/widgets/date_divider.dart';
import 'package:taskodoro/widgets/textfield_task_list.dart';

class TasksPage extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const TasksPage({super.key, required this.sharedPreferences});

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
              
              _addTaskHelper(taskName, selectedTaskListId);
            },
          ),
        ),
        const Spacer(flex: 2,),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<PomodoroPage>(
                builder: (BuildContext context) => SettingsPage(sharedPreferences: widget.sharedPreferences)
              )
            );
          },
          icon: const Icon(Icons.settings),
          iconSize: SpacingTheme.smallIconSize,
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<PomodoroPage>(
                builder: (BuildContext context) => PomodoroPage(sharedPreferences: widget.sharedPreferences)
              )
            );
          },
          icon: const Icon(Icons.timer),
          iconSize: SpacingTheme.smallIconSize,
        ),
      ],
    );
  }

  Widget body(AppLocalizations localizations, BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          LayoutBuilder(
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  showDialog<AddTaskDialog>(context: context, builder: (BuildContext context) {
                    return AddTaskDialog(
                      addTask: (Task task) async {
                        await _addTask(task, selectedTaskListId);
                      },
                    );
                  });
                },
                label: Text(localizations.addTask),
                icon: const Icon(Icons.add),
              ),
            ),
          ),
        ]
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
        editTasklist: () {
          setState(() {
            taskList.isNameEditable = true;
          });
        },
        deleteTaskList: () async {
          await deleteTaskList(taskList);

          if (taskList.id == selectedTaskListId) {
            selectTaskList(taskLists[0]);
          }
        },
        isEditing: taskList.isNameEditable,
        onEditingComplete: (String newName) async {
          taskList.name = newName;

          await _updateTaskList(taskList);

          setState(() {
            taskList.isNameEditable = true;
          });
        },
        onEditingCanceled: () {
          setState(() {
            taskList.isNameEditable = false;
          });
        },
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

  Future<void> _addTaskHelper(String taskName, int taskListId) async {
    final Task task = Task(id: null, name: taskName, isDone: false, timeAdded: DateTime.now());
    await _addTask(task, taskListId);
    _newTaskController.clear();
  }
  
  Future<void> _addTask(Task task, int taskListId) async {
    await _databaseService.insertTask(task, taskListId);
    await _loadTaskLists();
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

  Future<void> _updateTaskList(TaskList taskList) async {
    await _databaseService.updateTaskList(taskList);
    await _loadTaskLists();
  }

  Future<void> deleteTaskList(TaskList taskList) async {
    await _databaseService.deleteTaskList(taskList);
    await _loadTaskLists();
  }

  Future<void> selectTaskDate(Task task) async {
    await _databaseService.updateTask(task);

    await _loadTaskLists();
  }
}

import 'package:flutter/material.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/models/task.dart';
import 'package:taskodoro/themes/spacing_theme.dart';
import 'package:taskodoro/utils/database_service.dart';
import 'package:taskodoro/widgets/card_task.dart';

class MyHomePage extends StatefulWidget {
  final List<Task> tasks = <Task>[];

  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _newTaskController = TextEditingController();
  late List<Task> tasks = <Task>[];
  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final List<Task> loadedTasks = await _databaseService.getTasks();

    setState(() {
      tasks = loadedTasks;
    });

    hasLoaded = true;
  }

  Future<void> deleteTask(int id) async {
    await _databaseService.deleteTask(id);
    await _loadTasks();
  }

  @override
  void dispose() {
    _newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 8,),
          Row(
            children: <Widget>[
              const SizedBox(width: 80,),
              const Spacer(flex: 2,),
              Expanded(
                flex: 6,
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: localizations!.enterNewTask,
                  ),
                  controller: _newTaskController,
                  onSubmitted: (String str) {
                    if (str.isEmpty) {
                      return;
                    }

                    setState(() {
                      final Task task = Task(id: null, name: str, isDone: false, timeAdded: DateTime.now());
                      _databaseService.insertTask(task);
                      _loadTasks();
                      _newTaskController.clear();
                    });
                  },
                ),
              ),
              const Spacer(flex: 2,),
              IconButton(
                onPressed: () {
                  throw ArgumentError('Not yet implemented');
                },
                icon: const Icon(Icons.settings),
                iconSize: 24,
              ),
              IconButton(
                onPressed: () {
                  throw ArgumentError('Not yet implemented');
                },
                icon: const Icon(Icons.timer),
                iconSize: 24,
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200, minWidth: 400),
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          const Expanded(child: Divider()),
                          const SizedBox(width: SpacingTheme.dueDateDividerGap),
                          Text(
                            localizations.noDueDate,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: SpacingTheme.dueDateDividerGap),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      Expanded(
                        child: tasks.isEmpty && !hasLoaded
                            ? const Center(child: CircularProgressIndicator())
                            : ListView(
                              children: tasks.map((Task task) {
                                return CardTask(
                                  key: ValueKey<int>(task.id!),
                                  task,
                                  priority: task.priority.toString(),
                                  deleteTask: () => deleteTask(task.id!),
                                );
                              }).toList(),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

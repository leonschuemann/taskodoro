import 'package:taskodoro/card_task.dart';
import 'package:taskodoro/database_service.dart';
import 'package:taskodoro/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHomePage extends StatefulWidget {
  final List<Task> tasks = [];

  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _newTaskController = TextEditingController();
  late List<Task> tasks = [];
  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await _databaseService.getTasks();

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: () {
            throw ErrorDescription('Not yet implemented');
          },
          icon: Icon(Icons.menu),
          alignment: Alignment.centerLeft,
        ),
        actions: [
          Spacer(),
          SizedBox(
            width: 600,
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: localizations!.enterNewTask
              ),
              autofocus: true, // TODO: Use FocusNode to auto-focus when typing
              controller: _newTaskController,
              onSubmitted: (str) {
                if (str.isEmpty) {
                  return;
                }

                setState(() {
                  Task task = Task(id: null, name: str, isDone: false, timeAdded: DateTime.now());
                  _databaseService.insertTask(task);
                  _loadTasks();
                  _newTaskController.clear();
                });
              },
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              throw ErrorDescription('Not yet implemented');
            },
            icon: Icon(Icons.timer),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200, minWidth: 400),
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          const SizedBox(width: 8),
                          Text(localizations.noDueDate),
                          const SizedBox(width: 8),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      Expanded(
                        child: tasks.isEmpty && !hasLoaded
                            ? const Center(child: CircularProgressIndicator())
                            : ListView(
                              scrollDirection: Axis.vertical,
                              children: tasks.map((task) {
                                return CardTask(
                                  key: ValueKey(task.id),
                                  task,
                                  priority: task.priority.toString(),
                                  deleteTask: () => deleteTask(task.id!),
                                );
                              }).toList(),
                            )
                      ),
                    ],
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:taskodoro/card_task.dart';
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
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    tasks = widget.tasks;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: () {
            throw ErrorDescription("Not yet implemented");
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
              onSubmitted: (str) {
                int id = tasks.isNotEmpty ? tasks[tasks.length - 1].id : 0;

                setState(() {
                  tasks.add(Task(id, str, false, DateTime.now()));
                });
              },
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              throw ErrorDescription("Not yet implemented");
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
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [for (var task in tasks) CardTask(task, priority: task.priority.toString())], // TODO
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
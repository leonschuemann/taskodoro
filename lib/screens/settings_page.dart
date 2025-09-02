import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: FractionallySizedBox(
                child: Column(
                  children: [
                    Text("Sections"),
                  ],
                )
              ),
            ),
            const VerticalDivider(),
            Expanded(
              flex: 4,
              child: FractionallySizedBox(
                child: Column(
                  children: [
                    Text("Setting")
                  ],
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}

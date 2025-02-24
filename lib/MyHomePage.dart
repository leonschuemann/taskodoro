import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            width: 500,
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a new task'
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              throw ErrorDescription("Not yet implemented");
            },
            icon: Icon(Icons.timer),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
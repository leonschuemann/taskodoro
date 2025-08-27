import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/screens/tasks_page.dart';
import 'package:taskodoro/themes/text_theme.dart';
import 'package:taskodoro/themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', ''),
        Locale('de', ''),
      ],
      theme: MaterialTheme(
        ApplicationTextTheme().createTextTheme(context, 'Lato', 'Lato'),
      ).theme(MaterialTheme.lightScheme()),
      darkTheme: MaterialTheme(
          ApplicationTextTheme().createTextTheme(context, 'Lato', 'Lato'),
      ).theme(MaterialTheme.darkScheme()),
      home: const TasksPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

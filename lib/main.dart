import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/screens/tasks_page.dart';
import 'package:taskodoro/themes/text_theme.dart';
import 'package:taskodoro/themes/theme.dart';

void main() async {
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

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
      home: TasksPage(sharedPreferences: sharedPreferences,),
      debugShowCheckedModeBanner: false,
    );
  }
}

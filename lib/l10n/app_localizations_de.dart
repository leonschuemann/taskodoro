// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get enterNewTask => 'Neue Aufgabe eingeben';

  @override
  String get noDueDate => 'Kein Fälligkeitsdatum';

  @override
  String get dueDate => 'Fälligkeitsdatum';

  @override
  String get chooseDate => 'Datum auswählen';

  @override
  String get priority => 'Priorität';

  @override
  String get taskDelete => 'Löschen';

  @override
  String get name => 'Name';

  @override
  String get description => 'Beschreibung';

  @override
  String get addTaskList => 'Liste hinzufügen';

  @override
  String get enterListName => 'Name der Liste eingeben';

  @override
  String get settings => 'Einstellungen';

  @override
  String get pomodoroTimer => 'Pomodoro Timer';

  @override
  String get focusTimer => 'Focus Timer';

  @override
  String get longBreakTimer => 'Langer Pausen-Timer';

  @override
  String get shortBreakTimer => 'Kurzer Pausen-Timer';

  @override
  String get amountOfRepetitions => 'Anzahl der Wiederholungen';
}

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
}

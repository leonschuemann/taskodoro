// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get enterNewTask => 'Enter a new task';

  @override
  String get noDueDate => 'No due date';

  @override
  String get dueDate => 'Due Date';

  @override
  String get chooseDate => 'Choose Date';

  @override
  String get priority => 'Priority';

  @override
  String get taskDelete => 'Delete';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';
}

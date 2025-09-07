import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskodoro/constants/default_settings.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/themes/spacing_theme.dart';
import 'package:taskodoro/widgets/slider_setting.dart';
import 'package:taskodoro/widgets/text_input_setting.dart';

class SettingsPage extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const SettingsPage({super.key, required this.sharedPreferences});

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late final SharedPreferences _sharedPreferences;

  @override
  void initState() {
    _sharedPreferences = widget.sharedPreferences;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    const double textFieldWidth = 56;

    final GlobalKey<State<StatefulWidget>> pomodoroKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        scrolledUnderElevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: FractionallySizedBox(
                child: Column(
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: SpacingTheme.roundedRectangleBorderRadius,
                        ),
                        overlayColor: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.1),
                      ),
                      onPressed: () {
                        Scrollable.ensureVisible(pomodoroKey.currentContext!);
                      },
                      child: Text(localizations.pomodoroTimer)
                    ),
                  ],
                )
              ),
            ),
            const VerticalDivider(),
            Expanded(
              flex: 4,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          key: pomodoroKey,
                          localizations.pomodoroTimer,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        TextInputSetting(
                          text: localizations.focusTimer,
                          textFieldWidth: textFieldWidth,
                          onSave: (String value) async {
                            await _updateSharedPreferences('focusTime', value);
                          },
                          initialValue: _sharedPreferences.getInt('focusTime') ?? DefaultSettings.focusTime,
                          maxInputLength: 3,
                        ),
                        TextInputSetting(
                          text: localizations.longBreakTimer,
                          textFieldWidth: textFieldWidth,
                          onSave: (String value) async {
                            await _updateSharedPreferences('longBreakTime', value);
                          },
                          initialValue: _sharedPreferences.getInt('longBreakTime') ?? DefaultSettings.longBreakTime,
                          maxInputLength: 3,
                        ),
                        TextInputSetting(
                          text: localizations.shortBreakTimer,
                          textFieldWidth: textFieldWidth,
                          onSave: (String value) async {
                            await _updateSharedPreferences('shortBreakTime', value);
                          },
                          initialValue: _sharedPreferences.getInt('shortBreakTime') ?? DefaultSettings.shortBreakTime,
                          maxInputLength: 3,
                        ),
                        SliderSettings(
                          settingName: localizations.amountOfRepetitions,
                          minValue: DefaultSettings.minRepetitions,
                          maxValue: DefaultSettings.maxRepetitions,
                          standardValue: _sharedPreferences.getInt('repetitions') ?? DefaultSettings.repetitions,
                          sharedPreferences: _sharedPreferences
                        )
                      ]
                    ),
                  ),
                )
              ),
            )
          ]
        ),
      ),
    );
  }

  Future<void> _updateSharedPreferences(String setting, String value) async {
    if (value.isEmpty) {
      return;
    }
    
    await _sharedPreferences.setInt(setting, int.parse(value));
  }
}

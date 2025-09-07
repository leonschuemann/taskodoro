import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskodoro/constants/default_settings.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/themes/spacing_theme.dart';

class SettingsPage extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const SettingsPage({super.key, required this.sharedPreferences});

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late final SharedPreferences _sharedPreferences;
  final TextEditingController _focusTimerController = TextEditingController();
  final TextEditingController _shortBreakTimerController = TextEditingController();
  final TextEditingController _longBreakTimerController = TextEditingController();
  final FocusNode _focusTimerFocusNode = FocusNode();
  final FocusNode _shortBreakTimerFocusNode = FocusNode();
  final FocusNode _longBreakTimerFocusNode = FocusNode();

  @override
  void initState() {
    _initializeSharedPreferences();
    super.initState();

    _focusTimerFocusNode.addListener(() {
      _updateSharedPreferencesFocusNodeHelper(_focusTimerFocusNode, 'focusTime', _focusTimerController.text);
    });
    _shortBreakTimerFocusNode.addListener(() {
      _updateSharedPreferencesFocusNodeHelper(_shortBreakTimerFocusNode, 'shortBreakTime', _shortBreakTimerController.text);
    });
    _longBreakTimerFocusNode.addListener(() {
      _updateSharedPreferencesFocusNodeHelper(_longBreakTimerFocusNode, 'longBreakTime', _longBreakTimerController.text);
    });
  }

  @override
  void dispose() {
    _focusTimerController.dispose();
    _shortBreakTimerController.dispose();
    _longBreakTimerController.dispose();
    _focusTimerFocusNode.dispose();
    _shortBreakTimerFocusNode.dispose();
    _longBreakTimerFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    const double textFieldWidth = 56;
    int repetitions;

    repetitions = _sharedPreferences.getInt('repetitions')!;

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
                        textInputSetting(
                          text: localizations.focusTimer,
                          textFieldWidth: textFieldWidth,
                          onSave: (String value) async {
                            await _updateSharedPreferences('focusTime', value);
                          },
                          controller: _focusTimerController,
                          maxInputLength: 3,
                          focusNode: _focusTimerFocusNode
                        ),
                        textInputSetting(
                          text: localizations.longBreakTimer,
                          textFieldWidth: textFieldWidth,
                          onSave: (String value) async {
                            await _updateSharedPreferences('longBreakTime', value);
                          },
                          controller: _longBreakTimerController,
                          maxInputLength: 3,
                          focusNode: _longBreakTimerFocusNode
                        ),
                        textInputSetting(
                          text: localizations.shortBreakTimer,
                          textFieldWidth: textFieldWidth,
                          onSave: (String value) async {
                            await _updateSharedPreferences('shortBreakTime', value);
                          },
                          controller: _shortBreakTimerController,
                          maxInputLength: 3,
                          focusNode: _shortBreakTimerFocusNode
                        ),
                        Row(
                          children: <Widget>[
                            Text(localizations.amountOfRepetitions),
                            const Spacer(),
                            Text(DefaultSettings.minRepetitions.toString()),
                            Slider(
                              value: repetitions.toDouble(),
                              onChanged: (double value) async {
                                _sharedPreferences.setInt('repetitions', value.toInt());

                                setState(() {
                                  repetitions = value.toInt();
                                });
                              },
                              min: DefaultSettings.minRepetitions.toDouble(),
                              max: DefaultSettings.maxRepetitions.toDouble(),
                              divisions: DefaultSettings.maxRepetitions - DefaultSettings.minRepetitions,
                              label: repetitions.toString(),
                            ),
                            Text(DefaultSettings.maxRepetitions.toString()),
                          ],
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
  
  void _initializeSharedPreferences() {
    _sharedPreferences = widget.sharedPreferences; // TODO: exchange with own YAML file
    final int focusTime = _sharedPreferences.getInt('focusTime') ?? DefaultSettings.focusTime;
    final int longBreakTime = _sharedPreferences.getInt('longBreakTime') ?? DefaultSettings.longBreakTime;
    final int shortBreakTime = _sharedPreferences.getInt('shortBreakTime') ?? DefaultSettings.shortBreakTime;

    setState(() {
      _focusTimerController.text = focusTime.toString();
      _longBreakTimerController.text = longBreakTime.toString();
      _shortBreakTimerController.text = shortBreakTime.toString();
    });
  }

  Widget textInputSetting({
    required String text,
    required double textFieldWidth,
    required ValueChanged<String> onSave,
    required TextEditingController controller,
    required int maxInputLength,
    required FocusNode focusNode
  }) {
    return Row(
      children: <Widget>[
        Text(text),
        const Spacer(),
        SizedBox(
          width: textFieldWidth,
          child: TextField(
            onSubmitted: onSave,
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: SpacingTheme.roundedRectangleBorderRadius,
              ),
              isDense: true,
            ),
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(maxInputLength),
            ],
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }

  Future<void> _updateSharedPreferences(String setting, String value) async {
    if (value.isEmpty) {
      return;
    }
    
    await _sharedPreferences.setInt(setting, int.parse(value));
  }

  void _updateSharedPreferencesFocusNodeHelper(FocusNode focusNode, String setting, String value) {
    if (!focusNode.hasFocus) {
      _updateSharedPreferences(setting, value);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskodoro/constants/default_settings.dart';
import 'package:taskodoro/l10n/app_localizations.dart';
import 'package:taskodoro/themes/spacing_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late final SharedPreferences _sharedPreferences;
  final TextEditingController _focusTimerController = TextEditingController();
  final TextEditingController _shortBreakTimerController = TextEditingController();
  final TextEditingController _longBreakTimerController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    _initializeSharedPreferences();
    super.initState();
  }

  @override
  void dispose() {
    _focusTimerController.dispose();
    _shortBreakTimerController.dispose();
    _longBreakTimerController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    const double textFieldWidth = 56;
    int repetitions;

    if (!_isLoading && _sharedPreferences.getInt('repetitions') != null) {
      repetitions = _sharedPreferences.getInt('repetitions')!;
    } else {
      repetitions = DefaultSettings.repetitions;
    }

    final List<Widget> settings = <Widget>[
      Text(
        localizations.pomodoroTimer,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      textInputSetting(
        text: localizations.focusTimer,
        textFieldWidth: textFieldWidth,
        onTextFieldChanged: (String value) async {
          await _sharedPreferences.setInt('focusTime', int.parse(value));
        },
        controller: _focusTimerController,
        maxInputLength: 3,
      ),
      textInputSetting(
        text: localizations.longBreakTimer,
        textFieldWidth: textFieldWidth,
        onTextFieldChanged: (String value) async {
          await _sharedPreferences.setInt('longBreakTime', int.parse(value));
        },
        controller: _longBreakTimerController,
        maxInputLength: 3,
      ),
      textInputSetting(
        text: localizations.shortBreakTimer,
        textFieldWidth: textFieldWidth,
        onTextFieldChanged: (String value) async {
          await _sharedPreferences.setInt('shortBreakTime', int.parse(value));
        },
        controller: _shortBreakTimerController,
        maxInputLength: 3,
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
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: FractionallySizedBox(
                child: Column(
                  children: <Widget>[
                    Text('Sections'),
                  ],
                )
              ),
            ),
            const VerticalDivider(),
            Expanded(
              flex: 4,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return settings[index];
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: SpacingTheme.smallGap);
                    },
                    itemCount: settings.length,
                )
              ),
            )
          ]
        ),
      ),
    );
  }
  
  Future<void> _initializeSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance(); // TODO: exchange with own YAML file
    final int focusTime = _sharedPreferences.getInt('focusTime') ?? DefaultSettings.focusTime;
    final int longBreakTime = _sharedPreferences.getInt('longBreakTime') ?? DefaultSettings.longBreakTime;
    final int shortBreakTime = _sharedPreferences.getInt('shortBreakTime') ?? DefaultSettings.shortBreakTime;

    setState(() {
      _focusTimerController.text = focusTime.toString();
      _longBreakTimerController.text = longBreakTime.toString();
      _shortBreakTimerController.text = shortBreakTime.toString();
      _isLoading = false;
    });
  }

  Widget textInputSetting({
    required String text,
    required double textFieldWidth,
    required ValueChanged<String> onTextFieldChanged,
    required TextEditingController controller,
    required int maxInputLength
  }) {
    return Row(
      children: <Widget>[
        Text(text),
        const Spacer(),
        SizedBox(
          width: textFieldWidth,
          child: TextField(
            onChanged: onTextFieldChanged,
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
          ),
        ),
      ],
    );
  }
}

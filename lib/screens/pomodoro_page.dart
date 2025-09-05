import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskodoro/constants/default_settings.dart';
import 'package:taskodoro/l10n/app_localizations.dart';

class PomodoroPage extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const PomodoroPage({super.key, required this.sharedPreferences});

  @override
  State<StatefulWidget> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  final CountDownController countDownController = CountDownController();
  late final SharedPreferences sharedPreferences;
  late int repetitionCount = 1;
  bool isTimerRunning = false;
  bool hasTimerBeenStarted = false;
  bool isInPause = false;

  @override
  void initState() {
    sharedPreferences = widget.sharedPreferences;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final int focusTime = sharedPreferences.getInt('focusTime') ?? DefaultSettings.focusTime;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.pomodoroTimer),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                const Expanded(child: SizedBox()),
                Expanded(
                  flex: 3,
                  child: FractionallySizedBox(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircularCountDownTimer(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 2,
                            duration: focusTime * 60,
                            fillColor: Theme.of(context).colorScheme.primary,
                            ringColor: Theme.of(context).colorScheme.primary,
                            controller: countDownController,
                            autoStart: false,
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            textFormat: CountdownTextFormat.MM_SS,
                            isReverse: true,
                            onComplete: resetTimerWithNewTime,
                          ),
                          const SizedBox(height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                onPressed: resetTimer,
                                icon: const Icon(Icons.skip_previous_rounded),
                              ),
                              IconButton(
                                onPressed: playResumePauseTimer,
                                icon: isTimerRunning
                                    ? const Icon(Icons.pause_rounded)
                                    : const Icon(Icons.play_arrow_rounded)
                              ),
                              IconButton(
                                onPressed: resetTimerWithNewTime,
                                icon: const Icon(Icons.skip_next_rounded),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: FractionallySizedBox(child: Center(child: Text('Selected tasks'))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void playResumePauseTimer() {
    if (isTimerRunning) {
      countDownController.pause();
    } else if (!hasTimerBeenStarted) {
      countDownController.start();
    
      setState(() {
        hasTimerBeenStarted = true;
      });
    } else {
      countDownController.resume();
    }
    
    setState(() {
      isTimerRunning = !isTimerRunning;
    });
  }

  int getNextTime() {
    final int repetitionSetting = sharedPreferences.getInt('repetitions') ?? DefaultSettings.repetitions;
    int nextTime;

    if (!isInPause) {
      if (repetitionCount == repetitionSetting) {
        nextTime = sharedPreferences.getInt('longBreakTime') ?? DefaultSettings.longBreakTime;
      } else {
        nextTime = sharedPreferences.getInt('shortBreakTime') ?? DefaultSettings.shortBreakTime;
      }
    } else {
      nextTime = sharedPreferences.getInt('focusTime') ?? DefaultSettings.focusTime;
    }

    return nextTime * 60;
  }

  void resetTimerWithNewTime() {
    final int repetitionSetting = sharedPreferences.getInt('repetitions') ?? DefaultSettings.repetitions;
    countDownController.restart(duration: getNextTime());
    countDownController.pause();
    int newRepetitions = repetitionCount;

    if (!isInPause) {
      newRepetitions += 1;
    }

    if (newRepetitions == repetitionSetting + 1) {
      newRepetitions = 1;
    }

    setState(() {
      repetitionCount = newRepetitions;
      isInPause = !isInPause;
      isTimerRunning = false;
      hasTimerBeenStarted = false;
    });
  }

  void resetTimer() {
    countDownController.reset();

    setState(() {
      isTimerRunning = false;
      hasTimerBeenStarted = false;
    });
  }
}

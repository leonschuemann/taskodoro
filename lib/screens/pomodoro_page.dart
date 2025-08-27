import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<StatefulWidget> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  final CountDownController countDownController = CountDownController();
  bool isTimerRunning = false;
  bool hasTimerBeenStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
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
                            duration: 25 * 60,
                            fillColor: Theme.of(context).colorScheme.primary,
                            ringColor: Theme.of(context).colorScheme.primary,
                            controller: countDownController,
                            autoStart: false,
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            textFormat: CountdownTextFormat.MM_SS,
                            isReverse: true,
                          ),
                          const SizedBox(height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  countDownController.reset();

                                  setState(() {
                                    isTimerRunning = false;
                                    hasTimerBeenStarted = false;
                                  });
                                },
                                icon: const Icon(Icons.skip_previous_rounded),
                              ),
                              IconButton(
                                onPressed: () {
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
                                },
                                icon: isTimerRunning
                                    ? const Icon(Icons.pause_rounded)
                                    : const Icon(Icons.play_arrow_rounded)
                              ),
                              IconButton(
                                onPressed: () {
                                  countDownController.reset();

                                  setState(() {
                                    isTimerRunning = false;
                                    hasTimerBeenStarted = false;
                                  });
                                },
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
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}

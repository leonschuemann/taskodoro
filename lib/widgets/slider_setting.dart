import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SliderSettings extends StatefulWidget{
  final SharedPreferences sharedPreferences;
  final String settingName;
  final int minValue;
  final int maxValue;
  final int standardValue;

  const SliderSettings({
    super.key,
    required this.settingName,
    required this.minValue,
    required this.maxValue,
    required this.standardValue,
    required this.sharedPreferences,
  });

  @override
  State<SliderSettings> createState() => _SliderSettingsState();
}

class _SliderSettingsState extends State<SliderSettings> {
  late int value;
  
  @override
  void initState() {
    value = widget.standardValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(widget.settingName),
        const Spacer(),
        Text(widget.minValue.toString()),
        Slider(
          value: value.toDouble(),
          onChanged: (double value) async {
            widget.sharedPreferences.setInt('repetitions', value.toInt());

            setState(() {
              this.value = value.toInt();
            });
          },
          min: widget.minValue.toDouble(),
          max: widget.maxValue.toDouble(),
          divisions: widget.maxValue - widget.minValue,
          label: value.toString(),
        ),
        Text(widget.maxValue.toString()),
      ],
    );
  }
}

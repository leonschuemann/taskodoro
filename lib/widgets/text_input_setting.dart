import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskodoro/themes/spacing_theme.dart';

class TextInputSetting extends StatefulWidget {
  final String text;
  final double textFieldWidth;
  final ValueChanged<String> onSave;
  final int initialValue;
  final int maxInputLength;

  const TextInputSetting({
    super.key,
    required this.text,
    required this.textFieldWidth,
    required this.onSave,
    required this.initialValue,
    required this.maxInputLength,
  });

  @override
  State<TextInputSetting> createState() => _TextInputSettingState();
}

class _TextInputSettingState extends State<TextInputSetting> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    focusNode.addListener(() async {
      if (!focusNode.hasFocus) {
        widget.onSave(controller.text);
      }
    });

    setState(() {
      controller.text = widget.initialValue.toString();
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(widget.text),
        const Spacer(),
        SizedBox(
          width: widget.textFieldWidth,
          child: TextField(
            onSubmitted: widget.onSave,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: SpacingTheme.roundedRectangleBorderRadius,
              ),
              isDense: true,
            ),
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(widget.maxInputLength),
              TextInputFormatter.withFunction((TextEditingValue oldValue, TextEditingValue newValue) {
                const List<String> numbers = <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

                final int? parsedNewValue = int.tryParse(newValue.text);

                if (parsedNewValue == null && newValue.text.isNotEmpty || parsedNewValue == 0) {
                  return oldValue;
                }

                for (int i = 0; i < newValue.text.length; i++) {
                  if (!numbers.contains(newValue.text[i])) {
                    return oldValue;
                  }
                }

                return newValue;
              })
            ],
            focusNode: focusNode,
            controller: controller,
          ),
        ),
      ],
    );
  }
}

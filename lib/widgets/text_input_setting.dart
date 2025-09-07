import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskodoro/themes/spacing_theme.dart';

class TextInputSetting extends StatelessWidget {
  final String text;
  final double textFieldWidth;
  final ValueChanged<String> onSave;
  final TextEditingController controller;
  final int maxInputLength;
  final FocusNode focusNode;

  const TextInputSetting({
    super.key,
    required this.text,
    required this.textFieldWidth,
    required this.onSave,
    required this.controller,
    required this.maxInputLength,
    required this.focusNode
  });

  @override
  Widget build(BuildContext context) {
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
}

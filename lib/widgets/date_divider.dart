import 'package:flutter/material.dart';
import 'package:taskodoro/themes/spacing_theme.dart';

class DateDivider extends StatelessWidget {
  final String text;
  const DateDivider(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        const SizedBox(width: SpacingTheme.dueDateDividerGap),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: SpacingTheme.dueDateDividerGap),
        const Expanded(child: Divider()),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';

class SpacingTheme {
  static const double margin = 14.0;
  static const double smallGap = 6.0;
  static const double gap = 14.0;
  static const double dueDateDividerGap = 8.0;

  static const double smallIconSize = 24;
  static const BoxConstraints smallIconButtonConstraints = BoxConstraints(
    minHeight: smallIconSize,
    minWidth: smallIconSize,
  );
  static const EdgeInsets smallIconButtonPadding = EdgeInsets.zero;
  static EdgeInsets outlinedButtonPadding = const EdgeInsets.all(14.0);
  static BorderRadius roundedRectangleBorderRadius = BorderRadius.circular(10.0);
}

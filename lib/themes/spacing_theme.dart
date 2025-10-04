import 'package:flutter/material.dart';

class SpacingTheme {
  static const double margin = 14.0;
  static const double smallGap = 6.0;
  static const double gap = 14.0;
  static const double dueDateDividerGap = 8.0;
  static const double gapAboveDateDividers = 4.0;

  static const double smallIconSize = 24;
  static const BoxConstraints smallIconButtonConstraints = BoxConstraints(
    minHeight: smallIconSize,
    minWidth: smallIconSize,
  );
  static const EdgeInsets smallIconButtonPadding = EdgeInsets.zero;
  static const EdgeInsets outlinedButtonPadding = EdgeInsets.all(14.0);
  static BorderRadius roundedRectangleBorderRadius = BorderRadius.circular(10.0);
}

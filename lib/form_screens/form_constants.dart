import 'package:flutter/material.dart';

const double kLabelFontSize = 16.0;
const double kTextInputHeightFromLabel = 12.5;
const double kErrorTextFontSize = 14.0;

BoxDecoration kContainerElevationDecoration = BoxDecoration(
  border: Border.all(color: Colors.grey.shade300, width: 0.5),
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
);

TextStyle kHintTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey.shade600,
);

TextStyle kFormWidgetLabelStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

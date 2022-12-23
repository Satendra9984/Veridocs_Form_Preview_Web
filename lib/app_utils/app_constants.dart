import 'package:flutter/material.dart';

enum Status {
  assigned,
  working,
  pending,
  completed,
}

enum FilterOptions { oldest, all }

enum ScreenNumber {
  home,
  saved,
  profile,
  completed,
}

const double kBRad = 13;
final kBorderRadius = BorderRadius.circular(kBRad);
const double kElevation = 25;

final theme = ThemeData(
    primaryColor: Colors.lightBlue,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.lightBlueAccent));

BoxDecoration containerElevationDecoration = BoxDecoration(
  border: Border.all(
    color: Colors.grey.shade400,
  ),
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.shade400,
      offset: const Offset(0.0, 2.5), //(x,y)
      blurRadius: 3.5,
    ),
  ],
);

TextStyle kHintTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey.shade600,
);

TextStyle kFormWidgetLabelStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

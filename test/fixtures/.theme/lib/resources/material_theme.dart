import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class MaterialTheme {
  const MaterialTheme._();

  static final ThemeData lightExampleName = ThemeData(
    brightness: Brightness.light,
    textTheme: textThemeName,
    colorScheme: lightColorSchemeName,
  );

  static const ColorScheme lightColorSchemeName = ColorScheme.light(
    primary: Colors.lightPrimary,
    onPrimary: Colors.lightOnPrimary,
    primaryContainer: Colors.lightContainer,
    onPrimaryContainer: Colors.lightOnContainer,
  );

  static const TextTheme textThemeName = TextTheme(
    displayMedium: Typography.bodyMedium,
    displaySmall: Typography.darkBlueBodySmall,
  );
}

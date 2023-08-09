class Strings {
  const Strings._();

  static const String libDir = 'lib';
  static const String paletteClass = 'Palette';
  static const String typographyClass = 'Typography';
  static const String effectsClass = 'Effects';
  static const String materialImport = 'package:flutter/material.dart';
  static const String dartExt = '.dart';
  static const String gettingFileLog = 'Fetching Figma file';
  static const String lookupStylesLog = 'Fetching styles from the file';
  static const String successLog = 'Done! 🥳 🎉';
  static const String failParseLog = 'Cannot parse the file.';
  static const String loadingConfigLog = 'Loading config from pubspec.yaml';
  static const String readingThemeReferenceLog = 'Reading theme reference file';
  static const String generatingThemeLog = 'Generating theme';
  static const String creatingThemeReferenceLog = 'Creating theme reference';
  static const String autoGenThemeLog =
      'Trying to generate theme by using auto lookup...';
  static const String filesWithColorsAndTextStylesNotFound =
      'Files with Colors and TextStyles not found.';

  static const String requiredAutoOrPathOptionsNotSpecifiedLog =
      '--auto OR --path option is required, but not specified.';

  static const String shouldIncludeAutoOrPathNotBothLog =
      'You should include --auto OR --path option. Not both.';

  static String skipStyleBecauseNotFoundLog(
    String name,
  ) =>
      'Style $name has been skipped because a style of that type is not found.';

  static String generateStylesLog(
    int amount,
    String className,
  ) =>
      'Generating $amount items for class $className';

  static String themeParamNotFoundLog(
    String type,
    String name,
    String themeName,
  ) =>
      '$type $name for theme $themeName not found.';

  static String styleSkipInfoLog(
    String type,
    String name,
  ) =>
      '[INFO] $type $name was skipped, because it has less than 3 params.';

  static String styleNotFoundLog(
    String type,
    String typoName,
    String fieldName,
  ) =>
      '$type item $fieldName for $typoName not found.';

  static String pubspecYaml = 'pubspec.yaml';

  static String themeRefYaml = 'figma_importer_theme_ref.yaml';
}

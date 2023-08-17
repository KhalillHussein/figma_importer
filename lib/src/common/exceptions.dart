/// {@template figma_importer_exception}
/// An exception thrown by an internal command.
/// {@endtemplate}
class FigmaImporterException implements Exception {
  /// {@macro figma_importer_exception}
  const FigmaImporterException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// {@template styles_not_found_exception}
/// Thrown when a styles cannot be found in the Figma file.
/// {@endtemplate}
class StylesNotFoundException extends FigmaImporterException {
  /// {@macro styles_not_found_exception}
  const StylesNotFoundException() : super('Styles not found in the file.');
}

/// {@template styles_parse_exception}
/// Thrown when a styles cannot be parsed from the Figma file.
/// {@endtemplate}
class StylesParseException extends FigmaImporterException {
  /// {@macro styles_parse_exception}
  const StylesParseException() : super('Cannot get styles from the file.');
}

/// {@template config_not_found_exception}
/// Thrown when a config created in the `pubspec.yaml` cannot be found.
/// {@endtemplate}
class ConfigNotFoundException extends FigmaImporterException {
  /// {@macro config_not_found_exception}
  const ConfigNotFoundException() : super('''
Config not found. Please create config first.''');
}

/// {@template theme_reference_not_found_exception}
/// Thrown when a theme reference .yaml file cannot be found locally.
/// {@endtemplate}
class ThemeReferenceNotFoundException extends FigmaImporterException {
  /// {@macro theme_reference_not_found_exception}
  const ThemeReferenceNotFoundException() : super('''
Theme reference not found.''');
}

/// {@template empty_theme_object_exception}
/// Thrown when a theme object has no non nullable fields.
/// {@endtemplate}
class EmptyThemeObjectException extends FigmaImporterException {
  /// {@macro empty_theme_object_exception}
  const EmptyThemeObjectException() : super('''
Cannot generate the field class because object is empty.''');
}

/// {@template empty_theme_class_exception}
/// Thrown when a generated theme class doesn't include ColorScheme and
/// TextTheme params.
/// {@endtemplate}
class EmptyThemeClassException extends FigmaImporterException {
  /// {@macro empty_theme_class_exception}
  const EmptyThemeClassException() : super('''
Cannot generate the theme class because no matching fields were found.''');
}

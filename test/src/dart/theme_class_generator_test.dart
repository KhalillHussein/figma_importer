import 'dart:io';

import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/config/config.dart';
import 'package:figma_importer/src/dart/dart.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../utils.dart';

class _MockLogger extends Mock implements Logger {}

const _config = '''
figma_importer:
  api_token: test-token
  file_id: test-id
  node_ids: [1-2]
  output_directory_path: lib/resources
  style_class_configs:
    - style: color
      class_name: Palette
    - style: typography
      class_name: TextStyles
    - style: shadows
      class_name: Shadows
  theme_class_config:
    class_name: MaterialTheme
    output_directory_path: lib/resources
''';

const _colorsCodeString = '''
import 'package:flutter/material.dart';

class ColorPalette {
  const ColorPalette._();

  static const Color color01 = Color(0xFF4CB219);

  static const Color color02 = Color(0xFFB28C2B);

  static const Color color03 = Color(0xFF1C6BE2);

  static const Color color03WithAlpha = Color(0x7F1C6BE2);

  static const Color color04 = Color(0xFF5470E0);

  static const Color color05 = Color(0xFF5470E0);

  static const Gradient linearGradient = LinearGradient(
    colors: (
      Color(0xFF5470E0),
      Color(0xFF991E54),
      Color(0xFF33A351),
    ),
    begin: FractionalOffset(0.00, 0.00),
    end: FractionalOffset(0.20, 0.40),
    stops: (
      0.20,
      0.60,
      1.00,
    ),
  );
}
''';

const _typographyCodeString = '''
import 'package:flutter/material.dart';

class Typography {
  const Typography._();

  static const TextStyle h1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 28,
    height: 1.50,
    fontFamily: 'Inter',
  );

  static const TextStyle h2 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 36,
    height: 1.56,
    fontFamily: 'Inter',
  );

  static const TextStyle h3 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 48,
    fontFamily: 'Inter',
  );

  static const TextStyle h4 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 56,
    height: 1.00,
    fontFamily: 'Inter',
  );

  static const TextStyle h5 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 68,
    height: 1.00,
    fontFamily: 'Inter',
  );

  static const TextStyle h6 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 82,
    height: 1.00,
    fontFamily: 'Inter',
  );

  static const TextStyle decoratedBodyText1 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.00,
    fontFamily: 'Manrope',
    fontStyle: FontStyle.italic,
    decoration: TextDecoration.underline,
  );

  static const TextStyle decoratedBodyText2 = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 18,
    height: 1.00,
    fontFamily: 'Manrope',
    decoration: TextDecoration.lineThrough,
  );
}
''';

const _themeClassString = '''
import 'package:flutter/material.dart';
import 'palette.dart';
import 'text_styles.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData lightExampleName = ThemeData(
    brightness: Brightness.light,
    textTheme: textThemeName,
    colorScheme: lightColorSchemeName,
  );

  static final ThemeData darkExampleName = ThemeData(
    brightness: Brightness.dark,
    textTheme: textThemeName,
    colorScheme: darkColorSchemeName,
  );

  static const ColorScheme lightColorSchemeName = ColorScheme.light(
    primary: Palette.color02,
    onPrimary: Palette.color02,
    primaryContainer: Palette.color03WithAlpha,
    onPrimaryContainer: Palette.color04,
    onSecondary: Palette.color05,
  );

  static const ColorScheme darkColorSchemeName = ColorScheme.dark(
    primary: Palette.color04,
    onPrimary: Palette.color05,
    secondary: Palette.color01,
    onSecondary: Palette.color02,
  );

  static const TextTheme textThemeName = TextTheme(
    titleLarge: TextStyles.h6,
    titleMedium: TextStyles.h5,
    titleSmall: TextStyles.h4,
    bodyLarge: TextStyles.h3,
    bodyMedium: TextStyles.h2,
    bodySmall: TextStyles.h1,
  );
}
''';

const _themeClassWithSingleThemeData = '''
import 'package:flutter/material.dart';
import 'palette.dart';
import 'text_styles.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData lightExampleName =
      ThemeData(brightness: Brightness.light);

  static final ThemeData darkExampleName = ThemeData(
    brightness: Brightness.dark,
    colorScheme: darkColorSchemeName,
  );

  static const ColorScheme darkColorSchemeName = ColorScheme.dark(
    primary: Palette.color04,
    onPrimary: Palette.color05,
    secondary: Palette.color01,
    onSecondary: Palette.color02,
  );
}
''';

const styleClassConfigs = [
  StyleClassConfig(
    style: StyleDefinition.color,
    className: 'Palette',
  ),
  StyleClassConfig(
    style: StyleDefinition.typography,
    className: 'TextStyles',
  ),
  StyleClassConfig(
    style: StyleDefinition.shadows,
    className: 'Shadows',
  ),
];

const themeReference = ThemeReference(
  themes: [
    Theme(
      name: 'lightExampleName',
      brightness: Brightness.light,
      textTheme: 'textThemeName',
      colorScheme: 'lightColorSchemeName',
    ),
    Theme(
      name: 'darkExampleName',
      brightness: Brightness.dark,
      textTheme: 'textThemeName',
      colorScheme: 'darkColorSchemeName',
    ),
  ],
  textThemes: [
    TextTheme(
      name: 'textThemeName',
      properties: TextThemeProperties(
        titleLarge: 'h6',
        titleMedium: 'h5',
        titleSmall: 'h4',
        bodyLarge: 'h3',
        bodyMedium: 'h2',
        bodySmall: 'h1',
      ),
    ),
  ],
  colorSchemes: [
    ColorScheme(
      name: 'lightColorSchemeName',
      factory: ColorSchemeFactory.light,
      properties: ColorSchemeProperties(
        primary: 'color02',
        onPrimary: 'color02',
        primaryContainer: 'color03',
        onPrimaryContainer: 'color04',
        secondary: 'colour01',
        onSecondary: 'color05',
      ),
    ),
    ColorScheme(
      name: 'darkColorSchemeName',
      factory: ColorSchemeFactory.dark,
      properties: ColorSchemeProperties(
        primary: 'color04',
        onPrimary: 'color05',
        primaryContainer: 'color06',
        onPrimaryContainer: 'color07',
        secondary: 'color01',
        onSecondary: 'color02',
      ),
    ),
  ],
);

const themeReferenceWithEmptyColorSchemesAndTextThemes = ThemeReference(
  themes: [
    Theme(
      name: 'lightExampleName',
      brightness: Brightness.light,
      textTheme: 'textThemeName',
      colorScheme: 'lightColorSchemeName',
    ),
    Theme(
      name: 'darkExampleName',
      brightness: Brightness.dark,
      textTheme: 'textThemeName',
      colorScheme: 'darkColorSchemeName',
    ),
  ],
  textThemes: [],
  colorSchemes: [],
);

const themeReferenceWithWrongColorSchemeAndTextTheme = ThemeReference(
  themes: [
    Theme(
      name: 'lightExampleName',
      brightness: Brightness.light,
      textTheme: 'textThemeName',
      colorScheme: 'lightColorSchemeName',
    ),
    Theme(
      name: 'darkExampleName',
      brightness: Brightness.dark,
      textTheme: 'textThemeName',
      colorScheme: 'darkColorSchemeName',
    ),
  ],
  textThemes: [
    TextTheme(
      name: 'textThemeName',
      properties: TextThemeProperties(
        titleLarge: 'h6',
        titleMedium: 'h5',
        titleSmall: 'h4',
        bodyLarge: 'h3',
        bodyMedium: 'h2',
        bodySmall: 'h1',
      ),
    ),
  ],
  colorSchemes: [
    ColorScheme(
      name: 'lightColorSchemeName',
      factory: ColorSchemeFactory.light,
      properties: ColorSchemeProperties(
        primary: 'someColor',
        onPrimary: 'text',
        primaryContainer: '5@#',
        onPrimaryContainer: 'ddd',
        secondary: 'string',
        onSecondary: '1241',
      ),
    ),
    ColorScheme(
      name: 'darkColorSchemeName',
      factory: ColorSchemeFactory.dark,
      properties: ColorSchemeProperties(
        primary: 'fff',
        onPrimary: 'somestring',
        primaryContainer: '',
        onPrimaryContainer: ')31()',
        secondary: '222',
        onSecondary: 'randomworld',
      ),
    ),
  ],
);

const themeReferenceWithWrongColorSchemeAndEmptyTextTheme = ThemeReference(
  themes: [
    Theme(
      name: 'lightExampleName',
      brightness: Brightness.light,
      textTheme: 'textThemeName',
      colorScheme: 'lightColorSchemeName',
    ),
    Theme(
      name: 'darkExampleName',
      brightness: Brightness.dark,
      textTheme: 'textThemeName',
      colorScheme: 'darkColorSchemeName',
    ),
  ],
  textThemes: [],
  colorSchemes: [
    ColorScheme(
      name: 'lightColorSchemeName',
      factory: ColorSchemeFactory.light,
      properties: ColorSchemeProperties(
        primary: 'c',
        onPrimary: 'c',
        primaryContainer: 'c',
        onPrimaryContainer: 'c',
        secondary: 'c',
        onSecondary: 'c',
      ),
    ),
    ColorScheme(
      name: 'darkColorSchemeName',
      factory: ColorSchemeFactory.dark,
      properties: ColorSchemeProperties(
        primary: 'color04',
        onPrimary: 'color05',
        primaryContainer: 'color06',
        onPrimaryContainer: 'color07',
        secondary: 'color01',
        onSecondary: 'color02',
      ),
    ),
  ],
);

void main() {
  final cwd = Directory.current;
  group('ThemeClassGenerator', () {
    late Logger logger;
    late ThemeClassGenerator themeClassGenerator;

    setUp(() {
      logger = _MockLogger();

      themeClassGenerator = ThemeClassGenerator(logger: logger);

      setUpTestingEnvironment(cwd);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('correctly generate two ThemeData with colorSchemes and textThemes',
        () {
      File(path.join(testFixturesPath(cwd), 'pubspec.yaml'))
        ..createSync()
        ..writeAsStringSync(_config);

      Directory(path.join(Directory.current.path, 'lib', 'resources'))
          .createSync(recursive: true);
      File(path.join(testFixturesPath(cwd), 'lib', 'resources', 'palette.dart'))
        ..createSync()
        ..writeAsStringSync(_colorsCodeString);
      File(
        path.join(
          testFixturesPath(cwd),
          'lib',
          'resources',
          'text_styles.dart',
        ),
      )
        ..createSync()
        ..writeAsStringSync(_typographyCodeString);
      final output = themeClassGenerator.generateThemeClass(
        'lib/resources',
        styleClassConfigs,
        themeReference,
        'AppTheme',
        'lib/resources',
      );

      expect(output, equals(_themeClassString));
    });

    test('correctly generate single ThemeData with colorScheme and textTheme',
        () {
      File(path.join(testFixturesPath(cwd), 'pubspec.yaml'))
        ..createSync()
        ..writeAsStringSync(_config);

      Directory(path.join(Directory.current.path, 'lib', 'resources'))
          .createSync(recursive: true);
      File(path.join(testFixturesPath(cwd), 'lib', 'resources', 'palette.dart'))
        ..createSync()
        ..writeAsStringSync(_colorsCodeString);
      File(
        path.join(
          testFixturesPath(cwd),
          'lib',
          'resources',
          'text_styles.dart',
        ),
      )
        ..createSync()
        ..writeAsStringSync(_typographyCodeString);
      final output = themeClassGenerator.generateThemeClass(
        'lib/resources',
        styleClassConfigs,
        themeReferenceWithWrongColorSchemeAndEmptyTextTheme,
        'AppTheme',
        'lib/resources',
      );

      expect(output, equals(_themeClassWithSingleThemeData));
    });

    test('throw EmptyThemeClassException when style files content is empty',
        () {
      File(path.join(testFixturesPath(cwd), 'pubspec.yaml'))
        ..createSync()
        ..writeAsStringSync(_config);

      Directory(path.join(Directory.current.path, 'lib', 'resources'))
          .createSync(recursive: true);
      File(path.join(testFixturesPath(cwd), 'lib', 'resources', 'palette.dart'))
        ..createSync()
        ..writeAsStringSync('');
      File(
        path.join(
          testFixturesPath(cwd),
          'lib',
          'resources',
          'text_styles.dart',
        ),
      )
        ..createSync()
        ..writeAsStringSync('');
      expect(
        () => themeClassGenerator.generateThemeClass(
          'lib/resources',
          styleClassConfigs,
          themeReference,
          'AppTheme',
          'lib/resources',
        ),
        throwsA(isA<EmptyThemeClassException>()),
      );
    });
  });
}

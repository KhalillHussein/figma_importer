import 'dart:io';

import 'package:figma_importer/src/command_runner.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/version.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';

import '../utils.dart';

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockPubUpdater extends Mock implements PubUpdater {}

const _config = '''
figma_importer:
  api_token: test-token
  file_id: test-id
  node_ids: [1-2]
  output_directory_path: lib/resources
  style_class_configs:
    - style: color
      class_name: Colors
    - style: typography
      class_name: Typography
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

  static const Color lightPrimary = Color(0xFF4CB219);

  static const Color lightOnPrimary = Color(0xFFB28C2B);

  static const Color lightSecondary = Color(0xFF1C6BE2);

  static const Color lightOnSecondary = Color(0x7F1C6BE2);

  static const Color lightContainer = Color(0xFF5470E0);

  static const Color lightOnContainer = Color(0xFF5470E0);

  static const Color darkPrimary = Color(0xFF4CB219);

  static const Color darkOnPrimary = Color(0xFFB28C2B);

  static const Color darkSecondary = Color(0xFF1C6BE2);

  static const Color darkBluePrimary = Color(0xFF1C6BE2);

  static const Color darkBlueOnPrimary = Color(0xFFB28C2B);
}
''';

const _typographyCodeString = '''
import 'package:flutter/material.dart';

class Typography {
  const Typography._();

  static const TextStyle displaySmall = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 28,
    height: 1.50,
    fontFamily: 'Inter',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 36,
    height: 1.56,
    fontFamily: 'Inter',
  );

  static const TextStyle bodySmall = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 48,
    fontFamily: 'Inter',
  );

  static const TextStyle titleSmall = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 56,
    height: 1.00,
    fontFamily: 'Inter',
  );

   static const TextStyle darkBlueTitleSmall = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 56,
    height: 1.00,
    fontFamily: 'Inter',
  );

   static const TextStyle darkBlueBodySmall = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 56,
    height: 1.00,
    fontFamily: 'Inter',
  );
}
''';

const _themeReferenceYamlString = '''
theme_reference:
  themes:
    - name: lightExampleName
      brightness: light
      text_theme: textThemeName
      color_scheme: lightColorSchemeName
  text_themes:
    - name: textThemeName
      properties:
        display_large: display_large
        display_medium: body_medium
        display_small: body_small
        headline_large: h4
        headline_medium: h5
        headline_small: h6

  color_schemes:
    - name: lightColorSchemeName
      factory: light
      properties:
        primary: light_primary
        on_primary: light_on_primary
        primary_container: light_container
        on_primary_container: light_on_container
''';

const _themeReferenceYamlStringEmpty = '''
theme_reference:
''';

void main() {
  final cwd = Directory.current;
  group('gen-theme', () {
    late Logger logger;
    late Progress progress;
    late FigmaImporterCommandRunner commandRunner;
    late PubUpdater pubUpdater;

    setUp(
      () {
        logger = _MockLogger();
        pubUpdater = _MockPubUpdater();
        progress = _MockProgress();

        when(
          () => pubUpdater.getLatestVersion(any()),
        ).thenAnswer((_) async => packageVersion);
        when(() => logger.progress(any())).thenReturn(progress);

        commandRunner = FigmaImporterCommandRunner(
          logger: logger,
        );
        setUpTestingEnvironment(cwd, suffix: '.theme');

        File(
          path.join(Directory.current.path, 'pubspec.yaml'),
        ).writeAsStringSync(_config);
      },
    );

    tearDown(() {
      Directory.current = cwd;
    });

    test('handles empty args', () async {
      final exitCode = await commandRunner.run(['gen-theme']);

      expect(exitCode, equals(ExitCode.usage.code));

      verify(
        () => logger.err(Strings.requiredAutoOrPathOptionsNotSpecifiedLog),
      );
      verifyNever(() => logger.progress(Strings.loadingConfigLog));
    });

    test('handles wrong args combination', () async {
      final exitCode =
          await commandRunner.run(['gen-theme', '--auto', '--path=path']);

      expect(exitCode, equals(ExitCode.usage.code));

      verify(() => logger.err(Strings.shouldIncludeAutoOrPathNotBothLog));
      verifyNever(() => logger.progress(Strings.loadingConfigLog));
    });

    test('wrong usage', () async {
      final exitCode = await commandRunner.run(['gen-theme', '-r']);

      expect(exitCode, equals(ExitCode.usage.code));

      verify(() => logger.err('Could not find an option or flag "-r".'));
      verify(
        () => logger.info(
          '''
Usage: $executableName gen-theme [arguments]
-h, --help           Print this usage information.
-a, --[no-]auto      Trying to generate theme by using auto lookup along the styles.
-p, --path=<path>    Path for the theme reference. Required when --auto is not specified.

Run "$executableName help" to see global options.''',
        ),
      ).called(1);
    });
    test('auto generate theme', () async {
      final dir = Directory(
        path.join(Directory.current.path, 'lib', 'resources'),
      );
      await dir.create(recursive: true);
      final palette = File(
        path.join(
          testFixturesPath(cwd, suffix: '.theme'),
          'lib',
          'resources',
          'colors.dart',
        ),
      );
      await palette.create();
      await palette.writeAsString(_colorsCodeString);

      final textStyles = File(
        path.join(
          testFixturesPath(cwd, suffix: '.theme'),
          'lib',
          'resources',
          'typography.dart',
        ),
      );

      await textStyles.create();
      await textStyles.writeAsString(_typographyCodeString);

      final exitCode = await commandRunner.run(['gen-theme', '--auto']);

      expect(exitCode, equals(ExitCode.success.code));

      verify(() => logger.progress(Strings.autoGenThemeLog)).called(1);

      verify(
        () => logger.info(
          Strings.themeSkipInfoLog('ColorScheme', 'darkBlue'),
        ),
      ).called(1);

      verify(
        () => logger.info(
          Strings.themeSkipInfoLog('TextTheme', 'darkBlue'),
        ),
      ).called(1);

      verify(() => logger.info(Strings.successLog)).called(1);
    });

    test('handle config not found error', () async {
      final exitCode = await commandRunner.run(['gen-theme', '--auto']);

      expect(exitCode, equals(ExitCode.software.code));
      verify(() => logger.progress(Strings.autoGenThemeLog)).called(1);
      verifyNever(() => logger.info(Strings.successLog));
    });

    test('handle wrong path to config error', () async {
      final exitCode = await commandRunner.run(['gen-theme', '--path=path/to']);

      expect(exitCode, equals(ExitCode.software.code));
      verify(() => logger.progress(Strings.readingThemeReferenceLog)).called(1);
      verifyNever(() => logger.info(Strings.successLog));
    });

    test('handle empty theme reference error', () async {
      File(
        path.join(
          testFixturesPath(cwd, suffix: '.theme'),
          'figma_importer_theme_ref.yaml',
        ),
      )
        ..createSync()
        ..writeAsStringSync(_themeReferenceYamlStringEmpty);

      final exitCode = await commandRunner
          .run(['gen-theme', '--path=figma_importer_theme_ref.yaml']);

      expect(exitCode, equals(ExitCode.usage.code));
      verify(() => logger.progress(Strings.readingThemeReferenceLog)).called(1);
      verify(() => logger.err('Theme reference not found.')).called(1);
      verifyNever(() => logger.info(Strings.successLog));
    });

    test('correctly generate theme file by specified path', () async {
      File(
        path.join(
          testFixturesPath(cwd, suffix: '.theme'),
          'figma_importer_theme_ref.yaml',
        ),
      )
        ..createSync()
        ..writeAsStringSync(_themeReferenceYamlString);

      final dir = Directory(
        path.join(Directory.current.path, 'lib', 'resources'),
      );
      await dir.create(recursive: true);
      final palette = File(
        path.join(
          testFixturesPath(cwd, suffix: '.theme'),
          'lib',
          'resources',
          'colors.dart',
        ),
      );
      await palette.create();
      await palette.writeAsString(_colorsCodeString);
      final textStyle = File(
        path.join(
          testFixturesPath(cwd, suffix: '.theme'),
          'lib',
          'resources',
          'typography.dart',
        ),
      );
      await textStyle.create();
      await textStyle.writeAsString(_typographyCodeString);
      final refTestPath =
          path.join(Directory.current.path, 'figma_importer_theme_ref.yaml');
      final exitCode =
          await commandRunner.run(['gen-theme', '--path=$refTestPath']);

      expect(exitCode, equals(ExitCode.success.code));
      verify(() => logger.progress(Strings.readingThemeReferenceLog)).called(1);
    });
  });
}

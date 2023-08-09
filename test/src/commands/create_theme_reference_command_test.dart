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

class _MockPubUpdater extends Mock implements PubUpdater {}

class _MockProgress extends Mock implements Progress {}

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
        display_large: #TODO
        display_medium: #TODO
        display_small: #TODO
        headline_large: #TODO
        headline_medium: #TODO
        headline_small: #TODO
        title_large: #TODO
        title_medium: #TODO
        title_small: #TODO
        body_large: #TODO
        body_medium: #TODO
        body_small: #TODO
        label_large: #TODO
        label_medium: #TODO
        label_small: #TODO
  color_schemes:
    - name: lightColorSchemeName
      factory: light
      properties:
        primary: #TODO
        on_primary: #TODO
        primary_container: #TODO
        on_primary_container: #TODO
        secondary: #TODO
        on_secondary: #TODO
        secondary_container: #TODO
        on_secondary_container: #TODO
        tertiary: #TODO
        on_tertiary: #TODO
        tertiary_container: #TODO
        on_tertiary_container: #TODO
        error: #TODO
        on_error: #TODO
        error_container: #TODO
        on_error_container: #TODO
        background: #TODO
        on_background: #TODO
        surface: #TODO
        on_surface: #TODO
        surface_variant: #TODO
        on_surface_variant: #TODO
        outline: #TODO
        outline_variant: #TODO
        shadow: #TODO
        scrim: #TODO
        inverse_surface: #TODO
        on_inverse_surface: #TODO
        inverse_primary: #TODO
        surface_tint: #TODO
''';

void main() {
  final cwd = Directory.current;
  group('create-theme-ref', () {
    late Logger logger;
    late FigmaImporterCommandRunner commandRunner;
    late PubUpdater pubUpdater;

    setUp(() {
      logger = _MockLogger();
      pubUpdater = _MockPubUpdater();
      final progress = _MockProgress();

      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => packageVersion);

      when(() => logger.progress(any())).thenReturn(progress);

      commandRunner = FigmaImporterCommandRunner(
        logger: logger,
        pubUpdater: pubUpdater,
      );
      setUpTestingEnvironment(cwd);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('creates a new theme reference', () async {
      final testDir = Directory(
        path.join(Directory.current.path, 'create_theme_reference'),
      )..createSync(recursive: true);
      Directory.current = testDir.path;
      final exitCode = await commandRunner.run(['create-theme-ref']);
      expect(exitCode, equals(ExitCode.success.code));
      final file = File(
        path.join(
          testFixturesPath(cwd),
          'create_theme_reference',
          'figma_importer_theme_ref.yaml',
        ),
      );
      final actual = file.readAsStringSync();

      expect(actual, contains(_themeReferenceYamlString));
      verify(
        () => logger.progress(Strings.creatingThemeReferenceLog),
      ).called(1);
    });
  });
}

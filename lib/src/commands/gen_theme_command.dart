import 'package:args/command_runner.dart';
import 'package:figma_importer/src/command.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/config/config.dart';
import 'package:figma_importer/src/theme_gen.dart';
import 'package:figma_importer/src/utils/utils.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template gen_theme}
///
/// `figma_importer gen-theme`
/// A [Command] to generate theme from the style files
/// {@endtemplate}
class GenThemeCommand extends FigmaImporterCommand with ThemeGenMixin {
  /// {@macro gen_theme}
  GenThemeCommand({super.logger}) {
    argParser
      ..addFlag(
        'auto',
        abbr: 'a',
        help: 'Trying to generate theme by using auto lookup along the styles.',
      )
      ..addOption(
        'path',
        abbr: 'p',
        help: 'Path for the theme reference. Required when --auto '
            'is not specified.',
        valueHelp: 'path',
      );
  }

  @override
  String get description => 'Generate theme from the style files.';

  @override
  String get name => 'gen-theme';

  @override
  Future<int> run() async {
    late final Progress progress;
    final auto = results['auto'] as bool;
    final themeRefPath = results['path'] as String?;

    if ((themeRefPath == null || themeRefPath.isEmpty) && !auto) {
      usageException(Strings.requiredAutoOrPathOptionsNotSpecifiedLog);
    }
    if (themeRefPath != null && auto) {
      usageException(Strings.shouldIncludeAutoOrPathNotBothLog);
    }

    try {
      if (themeRefPath != null) {
        progress = logger.progress(Strings.readingThemeReferenceLog);
        final pubspec = YamlUtils.load(themeRefPath);
        final themeReference =
            ThemeReferenceRoot.fromJson(pubspec).themeReference;

        if (themeReference == null) {
          throw const ThemeReferenceNotFoundException();
        }
        progress.complete();
        logger.info(Strings.generatingThemeLog);
        genTheme(config, themeReference);
      } else if (auto) {
        progress = logger.progress(Strings.autoGenThemeLog);
        autoGenTheme(config);
        progress.complete();
      }
    } catch (_) {
      progress.fail();
      rethrow;
    }

    logger.info(Strings.successLog);

    return ExitCode.success.code;
  }
}

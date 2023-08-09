import 'package:args/command_runner.dart';
import 'package:figma_importer/src/command.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/config/config.dart';
import 'package:figma_importer/src/utils/utils.dart';

import 'package:mason_logger/mason_logger.dart';

/// {@template create_theme_reference_command}
///
/// `figma_importer create-theme-ref`
/// A [Command] to create the theme reference .yaml file to manually fill in
/// the params. All properties are optional.
/// {@endtemplate}
class CreateThemeReferenceCommand extends FigmaImporterCommand {
  /// {@macro create_theme_reference_command}
  CreateThemeReferenceCommand({super.logger});

  @override
  String get description => 'Create theme reference .yaml file.';

  @override
  String get name => 'create-theme-ref';

  @override
  Future<int> run() async {
    final progress = logger.progress(Strings.creatingThemeReferenceLog);
    const themeReference = ThemeReferenceRoot.template;
    final yaml = YamlUtils.toYamlString(themeReference.toJson());
    FileUtils.writeToFile(Strings.themeRefYaml, yaml);
    progress.complete();
    return ExitCode.success.code;
  }
}

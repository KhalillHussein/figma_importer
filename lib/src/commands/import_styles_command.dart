import 'package:args/command_runner.dart';
import 'package:figma_importer/src/command.dart';
import 'package:figma_importer/src/command_runner.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/config/figma_importer_config.dart';
import 'package:figma_importer/src/dart/dart.dart';
import 'package:figma_importer/src/figma/figma.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:figma_importer/src/utils/utils.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:recase/recase.dart';

/// {@template import}
///
/// `figma_importer import`
/// A [Command] to import styles from the Figma file
/// {@endtemplate}
class ImportStylesCommand extends FigmaImporterCommand {
  /// {@macro import}
  ImportStylesCommand({
    super.logger,
    FigmaImporterBuilder? figmaImporter,
  }) : _figmaImporter = figmaImporter ?? FigmaImporter.new;

  @override
  String get description => 'Import styles from the Figma page.';

  @override
  String get name => 'import';

  final FigmaImporterBuilder _figmaImporter;

  @override
  Future<int> run() async {
    final importer = _figmaImporter(
      apiToken: config.apiToken,
      fileId: config.fileId,
      nodeIds: config.nodeIds,
    );

    final progress = logger.progress(Strings.gettingFileLog);
    try {
      // import Figma file
      final file = await importer.getFile();
      progress.update(Strings.lookupStylesLog);
      // Parse file to get styles list
      final styles = await importer.getFileStyles(file);
      progress.complete();

      _genFiles(styles, config);
    } catch (_) {
      progress.fail();
      rethrow;
    }
    logger.info(Strings.successLog);
    return ExitCode.success.code;
  }

  void _genFiles(
    Map<StyleDefinition, List<BaseStyle>> styles,
    FigmaImporterConfig config,
  ) {
    const classGenerator = StylesClassGenerator();
    for (final classConfig in config.styleClassConfigs) {
      if (styles.containsKey(classConfig.style)) {
        if (styles[classConfig.style] == null ||
            styles[classConfig.style]!.isEmpty) {
          logger.progress(
            Strings.skipStyleBecauseNotFoundLog(
              classConfig.className,
            ),
          );
          continue;
        }
        final progress = logger.progress(
          Strings.generateStylesLog(
            styles[classConfig.style]!.length,
            classConfig.className,
          ),
        );
        final code = classGenerator.generateStylesClass(
          styles[classConfig.style]!,
          classConfig.className,
        );
        final dir = config.outputDirectoryPath;
        final className = classConfig.className.snakeCase;
        final path = '$dir/$className${Strings.dartExt}';

        FileUtils.createDir(config.outputDirectoryPath);
        FileUtils.writeToFile(path, code);
        progress.complete();
      }
    }
  }
}

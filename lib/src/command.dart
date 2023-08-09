import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/config/config.dart';
import 'package:figma_importer/src/utils/utils.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:meta/meta.dart';

abstract class FigmaImporterCommand extends Command<int> {
  FigmaImporterCommand({Logger? logger}) : _logger = logger;

  /// [ArgResults] used for testing purposes only.
  @visibleForTesting
  ArgResults? testArgResults;

  /// [ArgResults] for the current command.
  ArgResults get results => testArgResults ?? argResults!;

  /// [Logger] instance used to wrap stdout.
  Logger get logger => _logger ??= Logger();

  Logger? _logger;

  /// Gets the config from the `pubspec.yaml` file.
  FigmaImporterConfig get config {
    final pubspec = YamlUtils.load(Strings.pubspecYaml);

    final config = ConfigRoot.fromJson(pubspec).content;

    if (config == null) throw const ConfigNotFoundException();

    return config;
  }
}

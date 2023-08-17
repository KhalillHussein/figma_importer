import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli_completion/cli_completion.dart';
import 'package:figma_importer/src/command_runner.dart';
import 'package:figma_importer/src/version.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockPubUpdater extends Mock implements PubUpdater {}

const latestVersion = '0.0.0';

final updatePrompt = '''
${lightYellow.wrap('Update available!')} ${lightCyan.wrap(packageVersion)} \u2192 ${lightCyan.wrap(latestVersion)}
Run ${lightCyan.wrap('$executableName update')} to update''';

const expectedUsage = [
  '🎨 figma_importer • transform design to code and more.\n',
  '\n',
  'Usage: figma_importer <command> [arguments]\n',
  '\n',
  'Global options:\n',
  '-h, --help       Print this usage information.\n',
  '-v, --version    Print the current version.\n',
  '\n',
  'Available commands:\n',
  '  create-theme-ref   Create theme reference .yaml file.\n',
  '  gen-theme          Generate theme from the style files.\n',
  '  import             Import styles from the Figma page.\n',
  '  update             Update the CLI.\n',
  '\n',
  'Run "figma_importer help <command>" for more information about a command.',
];

void main() {
  group('FigmaImporterCommandRunner', () {
    late PubUpdater pubUpdater;
    late Logger logger;
    late FigmaImporterCommandRunner commandRunner;

    setUp(() {
      pubUpdater = _MockPubUpdater();

      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => packageVersion);

      logger = _MockLogger();

      commandRunner =
          FigmaImporterCommandRunner(logger: logger, pubUpdater: pubUpdater);
    });

    test('shows update message when newer version exists', () async {
      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => latestVersion);

      final result = await commandRunner.run(['--version']);
      expect(result, equals(ExitCode.success.code));
      verify(() => logger.info(updatePrompt)).called(1);
    });

    test(
      'Does not show update message when the shell calls the '
      'completion command',
      () async {
        when(
          () => pubUpdater.getLatestVersion(any()),
        ).thenAnswer((_) async => latestVersion);

        final result = await commandRunner.run(['completion']);
        expect(result, equals(ExitCode.success.code));
        verifyNever(() => logger.info(updatePrompt));
      },
    );

    test('does not show update message when using update command', () async {
      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => latestVersion);
      when(
        () => pubUpdater.update(
          packageName: packageName,
          versionConstraint: any(named: 'versionConstraint'),
        ),
      ).thenAnswer(
        (_) async => ProcessResult(0, ExitCode.success.code, null, null),
      );
      when(
        () => pubUpdater.isUpToDate(
          packageName: any(named: 'packageName'),
          currentVersion: any(named: 'currentVersion'),
        ),
      ).thenAnswer((_) async => true);

      final progress = _MockProgress();
      final progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      final result = await commandRunner.run(['update']);
      expect(result, equals(ExitCode.success.code));
      verifyNever(() => logger.info(updatePrompt));
    });

    test('can be instantiated without an explicit analytics/logger instance',
        () {
      final commandRunner = FigmaImporterCommandRunner();
      expect(commandRunner, isNotNull);
      expect(commandRunner, isA<CompletionCommandRunner<int>>());
    });

    test('handles FormatException', () async {
      const exception = FormatException('oops!');
      var isFirstInvocation = true;
      when(() => logger.info(any())).thenAnswer((_) {
        if (isFirstInvocation) {
          isFirstInvocation = false;
          throw exception;
        }
      });
      final result = await commandRunner.run(['--version']);
      expect(result, equals(ExitCode.usage.code));
      verify(() => logger.err(exception.message)).called(1);
      verify(() => logger.info(commandRunner.usage)).called(1);
    });

    test('handles UsageException', () async {
      final exception = UsageException('oops!', 'exception usage');
      var isFirstInvocation = true;
      when(() => logger.info(any())).thenAnswer((_) {
        if (isFirstInvocation) {
          isFirstInvocation = false;
          throw exception;
        }
      });
      final result = await commandRunner.run(['--version']);
      expect(result, equals(ExitCode.usage.code));
      verify(() => logger.err(exception.message)).called(1);
      verify(() => logger.info('exception usage')).called(1);
    });

    test('handles ProcessException', () async {
      const exception = ProcessException('oops!', ['args']);
      var isFirstInvocation = true;
      when(() => logger.info(any())).thenAnswer((_) {
        if (isFirstInvocation) {
          isFirstInvocation = false;
          throw exception;
        }
      });
      final result = await commandRunner.run(['--version']);
      expect(result, equals(ExitCode.unavailable.code));
      verify(() => logger.err(exception.message)).called(1);
    });

    group('--version', () {
      test('outputs current version', () async {
        final result = await commandRunner.run(['--version']);
        expect(result, equals(ExitCode.success.code));
        verify(() => logger.info(packageVersion)).called(1);
      });
    });

    group('--help', () {
      test('outputs usage', () async {
        final result = await commandRunner.run(['--help']);
        verify(() => logger.info(expectedUsage.join())).called(1);
        expect(result, equals(ExitCode.success.code));

        final resultAbbr = await commandRunner.run(['-h']);
        verify(() => logger.info(expectedUsage.join())).called(1);
        expect(resultAbbr, equals(ExitCode.success.code));
      });
    });
  });
}

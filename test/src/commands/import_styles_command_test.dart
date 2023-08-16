import 'dart:io';

import 'package:figma/figma.dart';
import 'package:figma_importer/src/commands/commands.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/figma/figma.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../utils.dart';

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockNodeResponse extends Mock implements NodesResponse {}

class _MockFigmaImporter extends Mock implements FigmaImporter {}

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

const _nodes = {
  'test-key': FileResponse(
    name: 'test-file',
    document: Node(id: '1', visible: true),
    styles: {
      '23:11': Style(
        key: 'key_1',
        name: 'test-style-1',
        type: StyleType.fill,
      ),
      '65:12': Style(
        key: 'key_2',
        name: 'test-style-2',
        type: StyleType.text,
      ),
      '54:1': Style(
        key: 'key_3',
        name: 'test-style-3',
        type: StyleType.effect,
      ),
    },
  ),
};

const _styleMap = {
  StyleDefinition.color: [
    ColorStyle(
      name: 'test-color-1',
      paint: Paint(
        visible: true,
        color: Color(r: 0.2, g: 0.6, b: 0.1, a: 1),
      ),
    ),
  ],
  StyleDefinition.shadows: [
    EffectStyle(
      name: 'test-shadow-1',
      effect: [
        Effect(
          visible: false,
          type: EffectType.dropShadow,
          color: Color(r: 0.2, g: 0.6, b: 0.1, a: 0.4),
          spread: 2,
          offset: Vector2D(x: 0, y: -2),
        ),
      ],
    ),
  ],
  StyleDefinition.typography: [
    TextStyle(
      name: 'test-textstyle-1',
      typeStyle: TypeStyle(),
    ),
  ],
};

void main() {
  final cwd = Directory.current;
  group('import', () {
    late Logger logger;
    late ImportStylesCommand importStylesCommand;
    late FigmaImporter figmaImporter;

    setUpAll(() {
      registerFallbackValue(_MockNodeResponse());
    });

    setUp(
      () {
        logger = _MockLogger();
        final progress = _MockProgress();

        figmaImporter = _MockFigmaImporter();

        importStylesCommand = ImportStylesCommand(
          logger: logger,
          figmaImporter: ({
            apiToken = 'test-token',
            fileId = 'test-fileId',
            nodeIds = const ['1', '2'],
          }) =>
              figmaImporter,
        );

        when(() => logger.progress(any())).thenReturn(progress);

        setUpTestingEnvironment(cwd);
      },
    );

    tearDown(() {
      Directory.current = cwd;
    });

    test('can be instantiated without any parameters', () {
      expect(ImportStylesCommand.new, returnsNormally);
    });

    test('throws StylesParseException', () async {
      final testDir = Directory(
        path.join(Directory.current.path, 'import_styles', 'fail'),
      )..createSync(recursive: true);
      Directory.current = testDir.path;
      File(
        path.join(
          testFixturesPath(cwd),
          'import_styles',
          'fail',
          'pubspec.yaml',
        ),
      )
        ..createSync()
        ..writeAsStringSync(_config);

      final nodeResponse = _MockNodeResponse();

      when(() => figmaImporter.getFile()).thenAnswer(
        (_) => Future.value(nodeResponse),
      );

      when(() => figmaImporter.getFileStyles(any()))
          .thenThrow(const StylesParseException());

      expect(
        () async => importStylesCommand.run(),
        throwsA(isA<StylesParseException>()),
      );
      verify(() => logger.progress(Strings.gettingFileLog)).called(1);
      verifyNever(() => logger.info(Strings.successLog));
    });

    test('throws StylesNotFoundException', () async {
      final testDir = Directory(
        path.join(Directory.current.path, 'import_styles', 'fail'),
      )..createSync(recursive: true);
      Directory.current = testDir.path;
      File(
        path.join(
          testFixturesPath(cwd),
          'import_styles',
          'fail',
          'pubspec.yaml',
        ),
      )
        ..createSync()
        ..writeAsStringSync(_config);

      final nodeResponse = _MockNodeResponse();

      when(() => figmaImporter.getFile()).thenAnswer(
        (_) => Future.value(nodeResponse),
      );

      when(() => figmaImporter.getFileStyles(any()))
          .thenThrow(const StylesNotFoundException());

      expect(
        () async => importStylesCommand.run(),
        throwsA(isA<StylesNotFoundException>()),
      );
      verify(() => logger.progress(Strings.gettingFileLog)).called(1);
      verifyNever(() => logger.info(Strings.successLog));
    });

    test('successfully creates the styles', () async {
      final nodeResponse = _MockNodeResponse();
      final testDir = Directory(
        path.join(Directory.current.path, 'import_styles'),
      )..createSync(recursive: true);
      Directory.current = testDir.path;
      File(path.join(testFixturesPath(cwd), 'import_styles', 'pubspec.yaml'))
        ..createSync()
        ..writeAsStringSync(_config);

      when(() => nodeResponse.nodes).thenReturn(_nodes);

      when(() => figmaImporter.getFile()).thenAnswer(
        (_) => Future.value(nodeResponse),
      );

      when(() => figmaImporter.getFileStyles(nodeResponse))
          .thenAnswer((_) => Future.value(_styleMap));

      final result = await importStylesCommand.run();
      expect(result, equals(ExitCode.success.code));
      verify(() => logger.progress(Strings.gettingFileLog)).called(1);
      verify(() => logger.info(Strings.successLog)).called(1);
    });
  });
}

import 'package:figma_importer/src/config/config.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:test/test.dart';

const _figmaImporterConfig = ConfigRoot(
  FigmaImporterConfig(
    apiToken: 'test-token',
    fileId: 'test-id',
    nodeIds: ['1', '2'],
    outputDirectoryPath: 'lib/resources',
    themeClassConfig: ThemeConfig(
      className: 'MaterialTheme',
      outputDirectoryPath: 'lib/resources',
    ),
    styleClassConfigs: [
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
    ],
  ),
);

void main() {
  group('ConfigRoot', () {
    test('can be (de)serialized', () {
      final result = ConfigRoot.fromJson(_figmaImporterConfig.toJson());
      expect(result.content?.styleClassConfigs.length, equals(3));
      expect(result.content?.apiToken, equals('test-token'));
      expect(result.content?.fileId, equals('test-id'));
      expect(result.content?.nodeIds, equals(['1', '2']));
      expect(result.content?.outputDirectoryPath, equals('lib/resources'));
      expect(
        result.content?.themeClassConfig?.className,
        equals('MaterialTheme'),
      );
      expect(
        result.content?.themeClassConfig?.outputDirectoryPath,
        equals('lib/resources'),
      );
    });

    test('object equality', () {
      expect(_figmaImporterConfig, same(_figmaImporterConfig));
    });
    test('ConfigRoot props equality', () {
      expect(_figmaImporterConfig.props, equals(_figmaImporterConfig.props));
    });

    test('FigmaImporterConfig props equality', () {
      expect(
        _figmaImporterConfig.content!.props,
        equals(_figmaImporterConfig.content!.props),
      );
    });

    test('ThemeConfig props equality', () {
      expect(
        _figmaImporterConfig.content!.themeClassConfig!.props,
        equals(_figmaImporterConfig.content!.themeClassConfig!.props),
      );
    });

    test('StyleClassConfig props equality', () {
      expect(
        _figmaImporterConfig.content!.styleClassConfigs.first.props,
        equals(
          _figmaImporterConfig.content!.styleClassConfigs.first.props,
        ),
      );
    });
  });
}

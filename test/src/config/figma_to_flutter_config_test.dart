import 'package:figma_importer/src/config/config.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:test/test.dart';

const figmaImporterConfig = ConfigRoot(
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
      final result = ConfigRoot.fromJson(figmaImporterConfig.toJson());
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
  });
}

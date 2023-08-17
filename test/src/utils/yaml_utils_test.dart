import 'dart:io';

import 'package:figma_importer/src/utils/utils.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../utils.dart';

const _yamlMap = {
  'test_yaml_content': {
    'test_data': [
      {
        'name': 'test-name',
        'params': 'test-params',
      }
    ]
  }
};

const _yamlString = '''
test_yaml_content:
  test_data:
    - name: test-name
      params: test-params
''';

void main() {
  final cwd = Directory.current;
  group('YamlUtils', () {
    setUp(() {
      setUpTestingEnvironment(cwd, suffix: '.yamlUtils');
    });

    tearDown(() {
      Directory.current = cwd;
    });
    group('load', () {
      test('correctly load yaml file', () {
        final testPath = path.join(testFixturesPath(cwd), 'test.yaml');

        File(testPath)
          ..createSync()
          ..writeAsStringSync(_yamlString);
        final result = YamlUtils.load(testPath);
        expect(result, equals(_yamlMap));
      });
    });

    group('toYamlString', () {
      test('correctly transform Map to yaml string', () {
        final content = YamlUtils.toYamlString(_yamlMap);
        expect(content, equals(_yamlString));
      });
    });
  });
}

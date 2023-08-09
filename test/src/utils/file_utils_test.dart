import 'dart:io';

import 'package:figma_importer/src/utils/utils.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  final cwd = Directory.current;
  group('FileUtils', () {
    setUp(() {
      setUpTestingEnvironment(cwd);
    });

    tearDown(() {
      Directory.current = cwd;
    });
    group('createDir', () {
      test('correctly creates subdirs', () {
        final testPath = path.join(testFixturesPath(cwd), 'path', 'to', 'foo');
        FileUtils.createDir(testPath);
        final isExists = Directory(testPath).existsSync();
        expect(isExists, equals(true));
      });
    });

    group('readFile', () {
      test('correctly read the file', () {
        final testPath = path.join(testFixturesPath(cwd), 'text.txt');
        const text = 'some text';
        File(testPath)
          ..createSync()
          ..writeAsStringSync(text);
        final content = FileUtils.readFile(testPath);
        expect(content, equals(text));
      });
    });

    group('writeToFile', () {
      test('correctly writeToFile to the file', () {
        final testPath = path.join(testFixturesPath(cwd), 'text.txt');
        const text = 'text will be overwritten';
        final file = File(testPath)
          ..createSync()
          ..writeAsStringSync(text);
        FileUtils.writeToFile(testPath, 'new text here');
        final content = file.readAsStringSync();
        expect(content, equals('new text here'));
      });
    });
  });
}

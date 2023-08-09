import 'package:figma_importer/src/dart/dart.dart';
import 'package:test/test.dart';

void main() {
  group('DartObjectBuilder', () {
    test('correctly build an empty object string', () {
      final dateTimeStringObject = DartObjectBuilder.createObject('Empty');

      expect(dateTimeStringObject.result, equals('Empty()'));
    });
    test('correctly build an object string with positioned params', () {
      final dateTimeStringObject = DartObjectBuilder.createObject('DateTime')
        ..addProperty(value: 2021)
        ..addProperty(value: 6)
        ..addProperty(value: 25);
      expect(dateTimeStringObject.result, equals('DateTime(2021, 6, 25)'));
    });

    test('correctly build an object string with named params', () {
      final dateTimeStringObject = DartObjectBuilder.createObject('TextStyle')
        ..addProperty(name: 'fontSize', value: 16)
        ..addProperty(name: 'fontWeight', value: 'FontWeight.w400')
        ..addProperty(name: 'height', value: 1.6)
        ..addProperty(name: 'name', value: '"Inter"');
      expect(
        dateTimeStringObject.result,
        equals(
          '''TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6, name: "Inter",)''',
        ),
      );
    });
  });
}

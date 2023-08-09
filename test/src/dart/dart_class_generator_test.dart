import 'package:code_builder/code_builder.dart';
import 'package:figma_importer/src/dart/dart.dart';
import 'package:test/test.dart';

const emptyClassString = '''
class EmptyClass {
  const EmptyClass._();
}
''';

const classStringWithFields = '''
import 'package:somelib/somefile.dart';

class ClassWithFields {
  const ClassWithFields._();

  static const String field1 = "someString";

  static const String field2 = "someString";
}
''';

final field1 = Field((FieldBuilder builder) {
  builder
    ..static = true
    ..modifier = FieldModifier.constant
    ..type = TypeReference(
      (TypeReferenceBuilder builder) => builder
        ..isNullable = false
        ..symbol = 'String',
    )
    ..name = 'field1'
    ..assignment = const Code('"someString"');
});

final field2 = Field((FieldBuilder builder) {
  builder
    ..static = true
    ..modifier = FieldModifier.constant
    ..type = TypeReference(
      (TypeReferenceBuilder builder) => builder
        ..isNullable = false
        ..symbol = 'String',
    )
    ..name = 'field2'
    ..assignment = const Code('"someString"');
});

void main() {
  group('DartClassGenerator', () {
    late DartClassGenerator dartClassGenerator;

    setUp(() {
      dartClassGenerator = const DartClassGenerator();
    });
    group('buildClass', () {
      test('correctly build an empty class', () {
        final emptyClass = dartClassGenerator.buildClass([], 'EmptyClass', []);
        expect(emptyClass, equals(emptyClassString));
      });

      test('correctly build a class with fields', () {
        final classWithTwoFields = dartClassGenerator.buildClass(
          [field1, field2],
          'ClassWithFields',
          ['package:somelib/somefile.dart'],
        );
        expect(classWithTwoFields, equals(classStringWithFields));
      });
    });
    group('buildField', () {
      test('correctly build a field', () {
        final finalField = dartClassGenerator.buildField(
          modifier: FieldModifier.constant,
          type: 'String',
          name: 'field1',
          code: '"someString"',
        );
        expect(finalField.name, equals(field1.name));
        expect(finalField.type, equals(field1.type));
        expect(finalField.modifier, equals(field1.modifier));
      });
    });
  });
}

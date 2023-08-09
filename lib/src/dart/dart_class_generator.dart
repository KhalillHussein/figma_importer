import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:figma_importer/src/common/common.dart';

import 'package:recase/recase.dart';

///A Class with base methods to generate any dart class/field.
class DartClassGenerator {
  const DartClassGenerator();

  String buildClass(
    List<Field> fields,
    String className,
    List<String> directives,
  ) {
    final styleClass = Class((ClassBuilder builder) {
      builder.name = className.pascalCase;
      builder.constructors.add(
        Constructor(
          (builder) => builder
            ..constant = true
            ..name = '_',
        ),
      );
      for (final field in fields) {
        builder.fields.add(field);
      }
    });

    final library = Library((LibraryBuilder builder) {
      for (final directive in directives) {
        builder.directives.add(Directive.import(directive));
      }

      builder.body.add(styleClass);
    });

    final emitter = DartEmitter(allocator: Allocator.simplePrefixing());
    final emitted = library.accept(emitter);
    final formatted = DartFormatter().format('$emitted');

    return formatted;
  }

  Field buildField({
    required FieldModifier modifier,
    required String type,
    required String name,
    required String code,
    String? description,
  }) {
    return Field((FieldBuilder builder) {
      if (description != null && description.isNotEmpty) {
        builder.docs.add('\n///$description');
      }
      builder
        ..static = true
        ..modifier = modifier
        ..type = TypeReference(
          (TypeReferenceBuilder builder) => builder
            ..isNullable = false
            ..symbol = type,
        )
        ..name = name.replaceSpecialCharactersWithUnderscore.camelCase
        ..assignment = Code(code);
    });
  }
}

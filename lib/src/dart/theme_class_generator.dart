import 'package:code_builder/code_builder.dart';

import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/config/config.dart';
import 'package:figma_importer/src/dart/dart.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:figma_importer/src/utils/utils.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

class ThemeClassGenerator extends DartClassGenerator {
  ThemeClassGenerator({required Logger logger}) : _logger = logger;

  final Logger _logger;

  String generateThemeClass(
    String outputStylesDir,
    List<StyleClassConfig> classConfigs,
    ThemeReference themeRef,
    String className,
    String themeOutputDir,
  ) {
    final stylePaths = <String>[];
    late List<Field> colorSchemeFields;
    late List<Field> textThemeFields;

    // if the theme does not include both objects, throw an exception
    if (themeRef.colorSchemes == null && themeRef.textThemes == null) {
      throw const EmptyThemeClassException();
    }
    for (final config in classConfigs) {
      if (config.style case StyleDefinition.color) {
        colorSchemeFields = _getColorSchemeFields(
          config: config,
          outputStylesDir: outputStylesDir,
          stylePaths: stylePaths,
          themeRef: themeRef,
        );
      }
      if (config.style case StyleDefinition.typography) {
        textThemeFields = _getTextThemeFields(
          config: config,
          outputStylesDir: outputStylesDir,
          stylePaths: stylePaths,
          themeRef: themeRef,
        );
      }
    }
    if (colorSchemeFields.isEmpty && textThemeFields.isEmpty) {
      throw const EmptyThemeClassException();
    }
    final themeFields = themeRef.themes
        .map(
          (theme) => _getThemeDataField(
            theme,
            colorSchemeFields,
            textThemeFields,
          ),
        )
        .toList();
    final relativePaths =
        stylePaths.map((e) => p.relative(e, from: themeOutputDir));
    return buildClass(
      themeFields + colorSchemeFields + textThemeFields,
      className,
      [Strings.materialImport, ...relativePaths],
    );
  }

  List<Field> _getTextThemeFields({
    required String outputStylesDir,
    required StyleClassConfig config,
    required List<String> stylePaths,
    required ThemeReference themeRef,
  }) {
    final stylePath =
        '$outputStylesDir/${config.className.snakeCase}${Strings.dartExt}';
    stylePaths.add(stylePath);
    final content = FileUtils.readFile(stylePath);

    return themeRef.textThemes!.expand<Field>((e) {
      final field = _getThemeObjectField(
        params: e,
        styleClassConfig: config,
        code: content,
      );
      return [if (field != null) field];
    }).toList();
  }

  List<Field> _getColorSchemeFields({
    required String outputStylesDir,
    required StyleClassConfig config,
    required List<String> stylePaths,
    required ThemeReference themeRef,
  }) {
    final stylePath =
        '$outputStylesDir/${config.className.snakeCase}${Strings.dartExt}';
    stylePaths.add(stylePath);
    final content = FileUtils.readFile(stylePath);
    return themeRef.colorSchemes!.expand<Field>((colorScheme) {
      final field = _getThemeObjectField(
        params: colorScheme,
        styleClassConfig: config,
        code: content,
        factoryName: colorScheme.factory.name,
      );
      return [if (field != null) field];
    }).toList();
  }

  /// General method for the [ColorScheme] and [TextTheme] object fields.
  /// [params] is the object itself. [styleClassConfig] is a style field that
  /// will be included in that object. [code] is content from the style file
  /// that contains properties. for that theme object. [factoryName] should be
  /// dark or light and is required for [ColorScheme] object.
  Field? _getThemeObjectField({
    required BaseThemeParams params,
    required StyleClassConfig styleClassConfig,
    required String code,
    String? factoryName,
  }) {
    final type = params.runtimeType.toString();
    final codeSequence = code.allMatchedStyleFields;
    final codeBuilder = DartObjectBuilder.createObject(
      factoryName != null ? '$type.$factoryName' : type,
    );
    final properties = params.properties.toJson()
      ..removeWhere((key, value) => value == null);
    for (final property in properties.entries) {
      final fieldName = property.value
          .toString()
          .replaceSpecialCharactersWithUnderscore
          .camelCase
          .trim();
      final matchedIndex = codeSequence.lastIndexWhere((element) {
        if (element == null) return false;
        if (fieldName.isEmpty || fieldName.length < 2) return false;

        return element.containsSubstringNoCase(fieldName);
      });
      if (matchedIndex != -1) {
        codeBuilder.addProperty(
          name: property.key.camelCase,
          value: '${styleClassConfig.className}.${codeSequence[matchedIndex]}',
        );
        continue;
      }
      _logger.warn(
        Strings.styleNotFoundLog(
          styleClassConfig.className,
          params.name,
          fieldName,
        ),
      );
    }
    if (codeBuilder.params.isEmpty) return null;

    return buildField(
      modifier: FieldModifier.constant,
      type: type,
      name: params.name,
      code: codeBuilder.result,
    );
  }

  /// Create the ThemeData field. [themeConfig] is a config from pubspec.yaml
  /// that describes themes with params that should be created.
  /// [colorSchemes] is a list of [ColorScheme] created previously.
  /// They are needed for checking if the colorScheme with name from the
  /// [themeConfig] exists. If true, create a field in the ThemeData object.
  /// [textThemes] is a list of [TextTheme] created previously. They are needed
  /// for checking if the colorScheme with a name in the [themeConfig] exists.
  /// If true, create a field in the ThemeData object.
  Field _getThemeDataField(
    Theme themeConfig,
    List<Field>? colorSchemes,
    List<Field>? textThemes,
  ) {
    final isTextThemeExists =
        textThemes?.any((element) => element.name == themeConfig.textTheme) ??
            false;
    final isColorSchemeExists = colorSchemes
            ?.any((element) => element.name == themeConfig.colorScheme) ??
        false;

    const type = 'ThemeData';
    final codeBuilder = DartObjectBuilder.createObject(type)
      ..addProperty(name: 'brightness', value: themeConfig.brightness);

    if (isTextThemeExists) {
      codeBuilder.addProperty(name: 'textTheme', value: themeConfig.textTheme!);
    } else {
      _logger.warn(
        Strings.themeParamNotFoundLog(
          'TextTheme',
          themeConfig.textTheme!,
          themeConfig.name,
        ),
      );
    }
    if (isColorSchemeExists) {
      codeBuilder.addProperty(
        name: 'colorScheme',
        value: themeConfig.colorScheme!,
      );
    } else {
      _logger.warn(
        Strings.themeParamNotFoundLog(
          'ColorScheme',
          themeConfig.colorScheme!,
          themeConfig.name,
        ),
      );
    }
    return buildField(
      modifier: FieldModifier.final$,
      type: type,
      name: themeConfig.name,
      code: codeBuilder.result,
    );
  }
}

import 'package:collection/collection.dart';
import 'package:figma_importer/src/command.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/config/config.dart';
import 'package:figma_importer/src/dart/dart.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:figma_importer/src/utils/utils.dart';
import 'package:recase/recase.dart';

const String _theme = 'Theme';
const String _colorScheme = 'ColorScheme';
const String _textTheme = 'TextTheme';
const String _textThemeLower = 'textTheme';

///A record which represents a [TextTheme] object.
///Used to simplify creation process.
typedef TextThemeRecord = ({
  String name,
  Map<String, dynamic> properties,
});

///A record which represents a [ColorScheme] object.
///Used to simplify creation process.
typedef ColorSchemeRecord = ({
  String name,
  ColorSchemeFactory factoryName,
  Map<String, dynamic> properties,
});

/// Mixin on [FigmaImporterCommand] which adds support for creating theme.
mixin ThemeGenMixin on FigmaImporterCommand {
  /// Generate file with the theme data properties.
  void genTheme(
    FigmaImporterConfig config,
    ThemeReference themeReference,
  ) {
    final className = config.themeClassConfig!.className;
    final codeGenerator = ThemeClassGenerator(logger: logger);
    final code = codeGenerator.generateThemeClass(
      config.outputDirectoryPath,
      config.styleClassConfigs,
      themeReference,
      className,
      config.themeClassConfig!.outputDirectoryPath,
    );
    final dir = config.themeClassConfig!.outputDirectoryPath;
    final path = '$dir/${className.snakeCase}${Strings.dartExt}';
    FileUtils.createDir(dir);
    FileUtils.writeToFile(path, code);
  }

  /// Auto generates [ThemeConfig] if the Figma style names is the same as the
  /// Flutter theme names.
  void autoGenTheme(FigmaImporterConfig config) {
    final colorSchemes = <ColorSchemeRecord>[];
    final colorSchemeFields =
        const ColorSchemeProperties().toJson().keys.toList();
    final textThemes = <TextThemeRecord>[];
    final textThemeFields = const TextThemeProperties().toJson().keys.toList();
    for (final styleConfig in config.styleClassConfigs) {
      if (styleConfig.style case StyleDefinition.color) {
        final fileContent = FileUtils.readFile(
          '${config.outputDirectoryPath}/${styleConfig.className.snakeCase}${Strings.dartExt}',
        );

        _createColorScheme(
          fileContent.allMatchedStyleFields,
          colorSchemeFields,
          colorSchemes,
        );
      }
      if (styleConfig.style case StyleDefinition.typography) {
        final fileContent = FileUtils.readFile(
          '${config.outputDirectoryPath}/${styleConfig.className.snakeCase}${Strings.dartExt}',
        );
        _createTextTheme(
          fileContent.allMatchedStyleFields,
          textThemeFields,
          textThemes,
        );
      }
    }

    _filterFields(colorSchemes, textThemes);
    final themeRef = _createThemeReference(colorSchemes, textThemes);
    genTheme(config, themeRef);
  }

  /// Remove theme objects that contain less than 3 params.
  void _filterFields(
    List<ColorSchemeRecord> colorSchemes,
    List<TextThemeRecord> textThemes,
  ) {
    colorSchemes.removeWhere((element) {
      final isLessThan =
          element.properties.values.where((element) => element != null).length <
              3;
      if (isLessThan) {
        logger.info(
          Strings.themeSkipInfoLog(
            _colorScheme,
            element.name.replaceAll(_colorScheme, ''),
          ),
        );
      }
      return isLessThan;
    });

    textThemes.removeWhere((element) {
      final isLessThan =
          element.properties.values.where((element) => element != null).length <
              3;
      if (isLessThan) {
        logger.info(
          Strings.themeSkipInfoLog(
            _textTheme,
            element.name.replaceAll(_textTheme, ''),
          ),
        );
      }
      return isLessThan;
    });
  }

  ThemeReference _createThemeReference(
    List<ColorSchemeRecord> colorSchemes,
    List<TextThemeRecord> textThemes,
  ) {
    final themeRef = ThemeReference(
      themes: [
        for (final colorScheme in colorSchemes)
          _createTheme(colorScheme, textThemes),
      ],
      textThemes: textThemes
          .map(
            (e) => TextTheme(
              name: e.name,
              properties: TextThemeProperties.fromJson(e.properties),
            ),
          )
          .toList(),
      colorSchemes: colorSchemes
          .map(
            (e) => ColorScheme(
              name: e.name,
              factory: e.factoryName,
              properties: ColorSchemeProperties.fromJson(e.properties),
            ),
          )
          .toList(),
    );

    return themeRef;
  }

  Theme _createTheme(
    ColorSchemeRecord colorSchemeRecord,
    List<TextThemeRecord> textThemes,
  ) {
    final nameNoSuffix = colorSchemeRecord.name.replaceAll(_colorScheme, '');
    final textThemeRecord = textThemes.firstWhereOrNull(
      (element) => element.name.containsSubstringNoCase(nameNoSuffix),
    );
    final textThemeName = textThemeRecord?.name ??
        (textThemes.isNotEmpty ? textThemes.first.name : null);
    final brightness = colorSchemeRecord.factoryName == ColorSchemeFactory.dark
        ? Brightness.dark
        : Brightness.light;

    return Theme(
      name: '$nameNoSuffix$_theme',
      brightness: brightness,
      colorScheme: colorSchemeRecord.name,
      textTheme: textThemeName,
    );
  }

  void _createTextTheme(
    List<String?> codeFields,
    List<String> textThemeFields,
    List<TextThemeRecord> textThemes,
  ) {
    for (final codeString in codeFields) {
      if (codeString == null) continue;
      final keyToUpdate = textThemeFields.lastWhereOrNull(
        (key) => codeString.containsSubstringNoCase(key.camelCase),
      );

      if (keyToUpdate == null) continue;
      _addOrUpdateTextTheme(keyToUpdate, textThemes, codeString);
    }
  }

  void _addOrUpdateTextTheme(
    String keyToUpdate,
    List<TextThemeRecord> textThemes,
    String styleName,
  ) {
    final prefix = styleName.replaceAll(
      RegExp(keyToUpdate.camelCase, caseSensitive: false),
      '',
    );
    final name = prefix.isEmpty
        ? _textThemeLower
        : '$prefix${_textThemeLower.pascalCase}';

    final indexToUpdate =
        textThemes.indexWhere((element) => element.name == name);
    if (indexToUpdate == -1) {
      //add new text theme if does not exists
      textThemes.add((name: name, properties: {keyToUpdate: styleName}));
    } else {
      //or update an existing text theme properties if exists
      textThemes[indexToUpdate] = (
        name: textThemes[indexToUpdate].name,
        properties: textThemes[indexToUpdate].properties
          ..update(keyToUpdate, (_) => styleName, ifAbsent: () => styleName),
      );
    }
  }

  void _createColorScheme(
    List<String?> codeFields,
    List<String> colorSchemeFields,
    List<ColorSchemeRecord> colorSchemes,
  ) {
    for (final codeString in codeFields) {
      if (codeString == null) continue;
      final keyToUpdate = colorSchemeFields.lastWhereOrNull(
        (key) => codeString.containsSubstringNoCase(key.camelCase),
      );

      if (keyToUpdate == null) continue;

      if (codeString.containsSubstringNoCase(ColorSchemeFactory.dark.name)) {
        _addOrUpdateColorScheme(
          keyToUpdate,
          colorSchemes,
          codeString,
          ColorSchemeFactory.dark,
        );
      }
      if (codeString.containsSubstringNoCase(ColorSchemeFactory.light.name)) {
        _addOrUpdateColorScheme(
          keyToUpdate,
          colorSchemes,
          codeString,
          ColorSchemeFactory.light,
        );
      }
    }
  }

  void _addOrUpdateColorScheme(
    String keyToUpdate,
    List<ColorSchemeRecord> colorSchemes,
    String styleName,
    ColorSchemeFactory colorSchemeFactory,
  ) {
    final prefix = styleName.replaceAll(
      RegExp(keyToUpdate.camelCase, caseSensitive: false),
      '',
    );
    final schemeName = '$prefix$_colorScheme';
    final colorScheme = (
      name: schemeName,
      factoryName: colorSchemeFactory,
      properties: {keyToUpdate: styleName},
    );
    final index =
        colorSchemes.indexWhere((element) => element.name == schemeName);
    if (index == -1) {
      colorSchemes.add(colorScheme);
    } else {
      colorSchemes[index] = (
        name: colorSchemes[index].name,
        factoryName: colorSchemes[index].factoryName,
        properties: colorSchemes[index].properties
          ..update(keyToUpdate, (_) => styleName, ifAbsent: () => styleName),
      );
    }
  }
}

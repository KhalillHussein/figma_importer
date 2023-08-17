import 'package:figma_importer/src/config/config.dart';
import 'package:test/test.dart';

const _themeReference = ThemeReferenceRoot(
  ThemeReference(
    themes: [
      Theme(
        name: 'lightExampleName',
        brightness: Brightness.light,
        textTheme: 'textThemeName',
        colorScheme: 'lightColorSchemeName',
      ),
      Theme(
        name: 'darkExampleName',
        brightness: Brightness.dark,
        textTheme: 'textThemeName',
        colorScheme: 'darkColorSchemeName',
      ),
    ],
    textThemes: [
      TextTheme(
        name: 'textThemeName',
        properties: TextThemeProperties(
          titleLarge: 'h6',
          titleMedium: 'h5',
          titleSmall: 'h4',
          bodyLarge: 'h3',
          bodyMedium: 'h2',
          bodySmall: 'h1',
        ),
      ),
    ],
    colorSchemes: [
      ColorScheme(
        name: 'lightColorSchemeName',
        factory: ColorSchemeFactory.light,
        properties: ColorSchemeProperties(
          primary: 'colour13',
          onPrimary: 'colour14',
          primaryContainer: 'colour15',
          onPrimaryContainer: 'colour16',
          secondary: 'colour01',
          onSecondary: 'colour02',
        ),
      ),
      ColorScheme(
        name: 'darkColorSchemeName',
        factory: ColorSchemeFactory.dark,
        properties: ColorSchemeProperties(
          primary: 'colour04',
          onPrimary: 'colour05',
          primaryContainer: 'colour06',
          onPrimaryContainer: 'colour07',
          secondary: 'colour01',
          onSecondary: 'colour02',
        ),
      ),
    ],
  ),
);
void main() {
  group('ThemeReferenceRoot', () {
    test('can be (de)serialized', () {
      final result = ThemeReferenceRoot.fromJson(_themeReference.toJson());
      expect(result.themeReference?.colorSchemes?.length, equals(2));
      expect(result.themeReference?.textThemes?.length, equals(1));
      expect(result.themeReference?.themes.length, equals(2));
      expect(
        result.themeReference?.themes.first.name,
        equals('lightExampleName'),
      );
      expect(
        result.themeReference?.textThemes?.first.name,
        equals('textThemeName'),
      );
      expect(
        result.themeReference?.colorSchemes?.first.name,
        equals('lightColorSchemeName'),
      );
    });

    test('object equality', () {
      expect(_themeReference, same(_themeReference));
    });
    test('ThemeReferenceRoot props equality', () {
      expect(_themeReference.props, equals(_themeReference.props));
    });

    test('ThemeReference props equality', () {
      expect(
        _themeReference.themeReference!.props,
        equals(_themeReference.themeReference!.props),
      );
    });

    test('Theme props equality', () {
      expect(
        _themeReference.themeReference!.themes.first.props,
        equals(_themeReference.themeReference!.themes.first.props),
      );
    });
    test('TextTheme props equality', () {
      expect(
        _themeReference.themeReference!.textThemes!.first.props,
        equals(_themeReference.themeReference!.textThemes!.first.props),
      );
    });

    test('TextThemeProperties props equality', () {
      expect(
        _themeReference.themeReference!.textThemes!.first.properties.props,
        equals(
          _themeReference.themeReference!.textThemes!.first.properties.props,
        ),
      );
    });

    test('ColorScheme props equality', () {
      expect(
        _themeReference.themeReference!.colorSchemes!.first.props,
        equals(_themeReference.themeReference!.colorSchemes!.first.props),
      );
    });

    test('ColorScheme props equality', () {
      expect(
        _themeReference.themeReference!.colorSchemes!.first.properties.props,
        equals(
          _themeReference.themeReference!.colorSchemes!.first.properties.props,
        ),
      );
    });

    test('ColorScheme props equality', () {
      expect(
        _themeReference.themeReference!.colorSchemes!.first.properties.props,
        equals(
          _themeReference.themeReference!.colorSchemes!.first.properties.props,
        ),
      );
    });
  });
}

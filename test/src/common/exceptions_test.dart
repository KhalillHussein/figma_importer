import 'package:figma_importer/src/common/common.dart';
import 'package:test/test.dart';

void main() {
  group('Exceptions', () {
    group('FigmaImporterException', () {
      test('can be instantiated', () {
        const message = 'test message';
        const exception = FigmaImporterException(message);
        expect(exception.message, equals(message));
      });

      test('overrides toString()', () {
        const message = 'test message';
        const exception = FigmaImporterException(message);
        expect(exception.toString(), equals(message));
      });
    });
    group('StylesNotFoundException', () {
      test('has the correct message', () {
        const message = 'Styles not found in the file.';
        const exception = StylesNotFoundException();
        expect(exception.message, equals(message));
      });
    });
    group('StylesParseException', () {
      test('has the correct message', () {
        const message = 'Cannot get styles from the file.';
        const exception = StylesParseException();
        expect(exception.message, equals(message));
      });
    });

    group('ConfigNotFoundException', () {
      test('has the correct message', () {
        const message = 'Config not found. Please create config first.';
        const exception = ConfigNotFoundException();
        expect(exception.message, equals(message));
      });
    });

    group('ThemeReferenceNotFoundException', () {
      test('has the correct message', () {
        const message = 'Theme reference not found.';
        const exception = ThemeReferenceNotFoundException();
        expect(exception.message, equals(message));
      });
    });

    group('EmptyThemeObjectException', () {
      test('has the correct message', () {
        const message =
            'Cannot generate the field class because object is empty.';
        const exception = EmptyThemeObjectException();
        expect(exception.message, equals(message));
      });
    });

    group('EmptyThemeClassException', () {
      test('has the correct message', () {
        const message =
            'Cannot generate the theme class because no matching fields '
            'were found.';
        const exception = EmptyThemeClassException();
        expect(exception.message, equals(message));
      });
    });
  });
}

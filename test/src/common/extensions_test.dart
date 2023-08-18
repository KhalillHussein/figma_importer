import 'package:figma/figma.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:test/test.dart';

const variablesString = '''
  static const Color m3Black = Color(0xFF000000);

  static const Color m3RefErrorError0 = Color(0xFF000000);

  static const Color m3RefErrorError10 = Color(0xFF410E0B);

  static const TextStyle m3BodyLarge = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    letterSpacing: 0.50,
    height: 1.50,
    fontFamily: 'Roboto',
  );

  static const TextStyle m3BodyMedium = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    letterSpacing: 0.25,
    height: 1.43,
    fontFamily: 'Roboto',
  );
''';

void main() {
  group('Extensions', () {
    group('ColorX', () {
      group('correctly transforms RGBA to HEX format', () {
        test('0xFFFFFFFF', () {
          final color = const Color(r: 1, g: 1, b: 1, a: 1).asHex;

          expect(color, equals('0xFFFFFFFF'));
        });
        test('0xFF000000', () {
          final color = const Color(r: 0, g: 0, b: 0, a: 1).asHex;

          expect(color, equals('0xFF000000'));
        });
        test('0xFF000000', () {
          final color = const Color(r: 0, g: 0, b: 0, a: 1).asHex;

          expect(color, equals('0xFF000000'));
        });
        test('0x00000000', () {
          final color = const Color(r: 0, g: 0, b: 0, a: 0).asHex;

          expect(color, equals('0x00000000'));
        });
        test('0xFFFF0000', () {
          final color = const Color(r: 1, g: 0, b: 0, a: 1).asHex;

          expect(color, equals('0xFFFF0000'));
        });
        test('0xFF00FF00', () {
          final color = const Color(r: 0, g: 1, b: 0, a: 1).asHex;

          expect(color, equals('0xFF00FF00'));
        });

        test('0xFF0000FF', () {
          final color = const Color(r: 0, g: 0, b: 1, a: 1).asHex;

          expect(color, equals('0xFF0000FF'));
        });
      });

      group('correctly handles wrong color input', () {
        test('values > 1', () {
          final color = const Color(r: 2, g: 10, b: 99, a: 3).asHex;

          expect(color, equals('0xFFFFFFFF'));
        });

        test('values < 0', () {
          final color = const Color(r: -0.5, g: -2, b: -1, a: -6).asHex;

          expect(color, equals('0x00000000'));
        });
      });
    });

    group('StringX', () {
      group('replaceByUnderscore', () {
        test('correctly replaces special characters', () {
          final sentence = 'A;bird/may@be!known^by&its song.'
              .replaceSpecialCharactersWithUnderscore;

          expect(sentence, equals('A_bird_may_be_known_by_its_song_'));
        });
      });
      group('allMatchedStyleFields', () {
        test('correctly determine variable keywords', () {
          final matchedFields = variablesString.allMatchedStyleFields;

          expect(
            matchedFields,
            equals(
              [
                'm3Black',
                'm3RefErrorError0',
                'm3RefErrorError10',
                'm3BodyLarge',
                'm3BodyMedium',
              ],
            ),
          );
        });
      });

      group('containsSubstringNoCase', () {
        test('correctly check if the word is included in lower case', () {
          final isContains = 'word'.containsSubstringNoCase('word');

          expect(isContains, equals(true));
        });
        test('correctly check if the word is included in upper case', () {
          final isContains = 'word'.containsSubstringNoCase('WORD');

          expect(isContains, equals(true));
        });
      });
    });
  });
}

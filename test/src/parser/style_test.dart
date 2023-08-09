import 'package:figma_importer/src/figma_api/figma_api.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:test/test.dart';

void main() {
  group('StyleTest', () {
    group('ColorStyle', () {
      test('can be instantiated', () {
        const paint = Paint(
          visible: true,
          opacity: 1,
          color: Color(r: 0.2, g: 0.4, b: 0.1, a: 1),
          type: PaintType.solid,
        );
        const colorStyle = ColorStyle(
          name: 'test-name',
          paint: paint,
          description: 'test-description',
        );
        expect(colorStyle.name, equals('test-name'));
        expect(colorStyle.paint, equals(paint));
        expect(colorStyle.description, equals('test-description'));
      });

      test('isEmpty when color and gradientStops is null', () {
        const colorStyle = ColorStyle(
          name: 'test-name',
          paint: Paint(visible: true),
          description: 'test-description',
        );
        expect(colorStyle.isEmpty, true);
      });

      test('isGradient when PaintType is gradientLinear', () {
        const colorStyle = ColorStyle(
          name: 'test-name',
          paint: Paint(
            visible: true,
            type: PaintType.gradientLinear,
          ),
          description: 'test-description',
        );
        expect(colorStyle.isEmpty, true);
      });
    });

    group('TextStyle', () {
      test('can be instantiated', () {
        const typeStyle = TypeStyle(
          fontFamily: 'Inter',
          fontWeight: 400,
          fontSize: 22,
          italic: true,
          letterSpacing: 0.4,
          lineHeightPx: 22,
          textDecoration: TextDecoration.underline,
        );
        const textStyle = TextStyle(
          name: 'test-name',
          typeStyle: typeStyle,
          description: 'test-description',
        );
        expect(textStyle.name, equals('test-name'));
        expect(textStyle.typeStyle, equals(typeStyle));
        expect(textStyle.description, equals('test-description'));
      });

      test('correctly get flutter line height', () {
        const typeStyle = TypeStyle(
          fontSize: 22,
          lineHeightPx: 44,
        );
        const textStyle = TextStyle(
          name: 'test-name',
          typeStyle: typeStyle,
          description: 'test-description',
        );
        expect(textStyle.flutterLineHeight, equals('2.00'));
      });
      test('flutter line height is null when lineHeightPx is null', () {
        const typeStyle = TypeStyle(
          fontSize: 22,
        );
        const textStyle = TextStyle(
          name: 'test-name',
          typeStyle: typeStyle,
          description: 'test-description',
        );
        expect(textStyle.flutterLineHeight, null);
      });

      test('flutter line height is null when fontSize is null', () {
        const typeStyle = TypeStyle(
          lineHeightPx: 44,
        );
        const textStyle = TextStyle(
          name: 'test-name',
          typeStyle: typeStyle,
          description: 'test-description',
        );
        expect(textStyle.flutterLineHeight, null);
      });
    });

    group('EffectStyle', () {
      test('can be instantiated', () {
        const effects = [
          Effect(
            visible: true,
            type: EffectType.dropShadow,
            color: Color(r: 0, g: 0, b: 0, a: 0.2),
          ),
          Effect(
            visible: true,
            type: EffectType.innerShadow,
            color: Color(r: 0, g: 0, b: 0, a: 0.4),
          ),
        ];
        const effectStyle = EffectStyle(
          name: 'test-name',
          effect: effects,
          description: 'test-description',
        );
        expect(effectStyle.name, equals('test-name'));
        expect(effectStyle.effect, equals(effects));
        expect(effectStyle.description, equals('test-description'));
      });

      test('correctly return shadow if the effect type is dropShadow', () {
        const effects = [
          Effect(
            visible: true,
            type: EffectType.dropShadow,
            color: Color(r: 0, g: 0, b: 0, a: 0.2),
            offset: Vector2D(x: 0, y: 2),
            spread: 4,
            radius: 16,
          ),
          Effect(
            visible: true,
            type: EffectType.dropShadow,
            color: Color(r: 0, g: 0, b: 0, a: 0.4),
            offset: Vector2D(x: 2, y: -2),
            spread: 1,
            radius: 4,
          ),
        ];
        const effectStyle = EffectStyle(
          name: 'test-name',
          effect: effects,
          description: 'test-description',
        );
        expect(effectStyle.shadow, [
          (
            color: const Color(r: 0, g: 0, b: 0, a: 0.2),
            offset: const Vector2D(x: 0, y: 2),
            blurRadius: '16.0',
            spread: '4.0',
          ),
          (
            color: const Color(r: 0, g: 0, b: 0, a: 0.4),
            offset: const Vector2D(x: 2, y: -2),
            blurRadius: '4.0',
            spread: '1.0',
          ),
        ]);
      });

      test('correctly return empty shadow if the effect type is not dropShadow',
          () {
        const effects = [
          Effect(
            visible: true,
            type: EffectType.innerShadow,
          ),
          Effect(
            visible: true,
            type: EffectType.layerBlur,
          ),
          Effect(
            visible: true,
            type: EffectType.backgroundBlur,
          ),
        ];
        const effectStyle = EffectStyle(
          name: 'test-name',
          effect: effects,
          description: 'test-description',
        );
        expect(effectStyle.shadow, <Shadow>[]);
      });
    });
  });
}

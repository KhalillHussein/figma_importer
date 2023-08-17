import 'package:figma/figma.dart';
import 'package:figma_importer/src/dart/dart.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:test/test.dart';

const styleColors = [
  ColorStyle(
    name: 'color01',
    paint: Paint(
      visible: true,
      color: Color(r: 0.3, g: 0.7, b: 0.1, a: 1),
    ),
  ),
  ColorStyle(
    name: 'color02',
    paint: Paint(
      visible: true,
      color: Color(r: 0.7, g: 0.55, b: 0.17, a: 1),
    ),
  ),
  ColorStyle(
    name: 'color03',
    paint: Paint(
      visible: true,
      color: Color(r: 0.11, g: 0.42, b: 0.89, a: 1),
    ),
  ),
  ColorStyle(
    name: 'color03_with_alpha',
    paint: Paint(
      visible: true,
      color: Color(r: 0.11, g: 0.42, b: 0.89, a: 0.5),
    ),
  ),
  ColorStyle(
    name: 'color04',
    paint: Paint(
      visible: true,
      color: Color(r: 0.33, g: 0.44, b: 0.88, a: 1),
    ),
  ),
  ColorStyle(
    name: 'color05',
    paint: Paint(
      visible: true,
      color: Color(r: 0.33, g: 0.44, b: 0.88, a: 1),
    ),
  ),
  ColorStyle(
    name: 'linearGradient',
    paint: Paint(
      visible: true,
      type: PaintType.gradientLinear,
      gradientHandlePositions: [
        Vector2D(x: 0, y: 0),
        Vector2D(x: 0.2, y: 0.4),
        Vector2D(x: 1, y: 1),
      ],
      gradientStops: [
        ColorStop(
          position: 0.2,
          color: Color(r: 0.33, g: 0.44, b: 0.88, a: 1),
        ),
        ColorStop(
          position: 0.6,
          color: Color(r: 0.6, g: 0.12, b: 0.33, a: 1),
        ),
        ColorStop(
          position: 1,
          color: Color(r: 0.2, g: 0.64, b: 0.32, a: 1),
        )
      ],
    ),
  ),
  ColorStyle(
    name: 'linearGradientNoAlignmentAndStops',
    paint: Paint(
      visible: true,
      type: PaintType.gradientLinear,
    ),
  ),
  ColorStyle(
    name: 'radialGradient',
    paint: Paint(
      visible: true,
      type: PaintType.gradientRadial,
      gradientHandlePositions: [
        Vector2D(x: 0, y: 0),
        Vector2D(x: 0.2, y: 0.4),
        Vector2D(x: 1, y: 1),
      ],
      gradientStops: [
        ColorStop(
          position: 0.2,
          color: Color(r: 0.33, g: 0.44, b: 0.88, a: 1),
        ),
        ColorStop(
          position: 0.6,
          color: Color(r: 0.6, g: 0.12, b: 0.33, a: 1),
        ),
        ColorStop(
          position: 1,
          color: Color(r: 0.2, g: 0.64, b: 0.32, a: 1),
        )
      ],
    ),
  ),
  ColorStyle(
    name: 'angularGradient',
    paint: Paint(
      visible: true,
      type: PaintType.gradientAngular,
      gradientHandlePositions: [
        Vector2D(x: 0, y: 0),
        Vector2D(x: 0.2, y: 0.4),
        Vector2D(x: 1, y: 1),
      ],
      gradientStops: [
        ColorStop(
          position: 0.2,
          color: Color(r: 0.33, g: 0.44, b: 0.88, a: 1),
        ),
        ColorStop(
          position: 0.6,
          color: Color(r: 0.6, g: 0.12, b: 0.33, a: 1),
        ),
        ColorStop(
          position: 1,
          color: Color(r: 0.2, g: 0.64, b: 0.32, a: 1),
        )
      ],
    ),
  ),
  ColorStyle(
    name: 'diamondGradient',
    paint: Paint(
      visible: true,
      type: PaintType.gradientDiamond,
      gradientHandlePositions: [
        Vector2D(x: 0, y: 0),
        Vector2D(x: 0.2, y: 0.4),
        Vector2D(x: 1, y: 1),
      ],
      gradientStops: [
        ColorStop(
          position: 0.2,
          color: Color(r: 0.33, g: 0.44, b: 0.88, a: 1),
        ),
        ColorStop(
          position: 0.6,
          color: Color(r: 0.6, g: 0.12, b: 0.33, a: 1),
        ),
        ColorStop(
          position: 1,
          color: Color(r: 0.2, g: 0.64, b: 0.32, a: 1),
        )
      ],
    ),
  ),
];

const textStyles = [
  TextStyle(
    name: 'h1',
    typeStyle: TypeStyle(
      fontFamily: 'Inter',
      fontWeight: 500,
      fontSize: 28,
      lineHeightPx: 42,
      letterSpacing: 0.4,
    ),
  ),
  TextStyle(
    name: 'h2',
    typeStyle: TypeStyle(
      fontFamily: 'Inter',
      fontWeight: 500,
      fontSize: 36,
      lineHeightPx: 56,
    ),
  ),
  TextStyle(
    name: 'h3',
    typeStyle: TypeStyle(
      fontFamily: 'Inter',
      fontWeight: 600,
      fontSize: 48,
    ),
  ),
  TextStyle(
    name: 'h4',
    typeStyle: TypeStyle(
      fontFamily: 'Inter',
      fontWeight: 400,
      fontSize: 56,
      lineHeightPx: 56,
    ),
  ),
  TextStyle(
    name: 'h5',
    typeStyle: TypeStyle(
      fontFamily: 'Inter',
      fontWeight: 500,
      fontSize: 68,
      lineHeightPx: 68,
    ),
  ),
  TextStyle(
    name: 'h6',
    typeStyle: TypeStyle(
      fontFamily: 'Inter',
      fontWeight: 700,
      fontSize: 82,
      lineHeightPx: 82,
    ),
  ),
  TextStyle(
    name: 'decoratedBodyText1',
    typeStyle: TypeStyle(
      fontFamily: 'Manrope',
      fontWeight: 700,
      fontSize: 18,
      lineHeightPx: 18,
      italic: true,
      textDecoration: TextDecoration.underline,
    ),
  ),
  TextStyle(
    name: 'decoratedBodyText2',
    typeStyle: TypeStyle(
      fontFamily: 'Manrope',
      fontWeight: 900,
      fontSize: 18,
      lineHeightPx: 18,
      textDecoration: TextDecoration.strikeThrough,
    ),
  ),
];

const effectStyles = [
  EffectStyle(
    name: 'small-shadow',
    effect: [
      Effect(
        visible: true,
        type: EffectType.dropShadow,
        radius: 4,
        spread: 2,
        color: Color(r: 0, g: 0, b: 0, a: 0.2),
        offset: Vector2D(x: 0, y: 2),
      ),
    ],
  ),
  EffectStyle(
    name: 'big-shadow',
    effect: [
      Effect(
        visible: true,
        type: EffectType.dropShadow,
        radius: 16,
        spread: 4,
        color: Color(r: 0, g: 0, b: 0, a: 0.12),
        offset: Vector2D(x: 0, y: 0),
      ),
    ],
  ),
  EffectStyle(
    name: 'composite-shadow',
    effect: [
      Effect(
        visible: true,
        type: EffectType.dropShadow,
        radius: 2,
        spread: 0,
        color: Color(r: 0, g: 0, b: 0, a: 0.05),
        offset: Vector2D(x: 2, y: 2),
      ),
      Effect(
        visible: true,
        type: EffectType.dropShadow,
        radius: 8,
        spread: 1,
        color: Color(r: 0, g: 0, b: 0, a: 0.4),
        offset: Vector2D(x: -2, y: 0),
      ),
      Effect(
        visible: true,
        type: EffectType.dropShadow,
        radius: 32,
        spread: 12,
        color: Color(r: 0, g: 0, b: 0, a: 0.33),
        offset: Vector2D(x: 0, y: -2),
      ),
    ],
  ),
  EffectStyle(
    name: 'inner-shadow',
    effect: [
      Effect(
        visible: true,
        type: EffectType.innerShadow,
        radius: 4,
        spread: 0,
        color: Color(r: 0, g: 0, b: 0, a: 0.44),
        offset: Vector2D(x: 2, y: 2),
      ),
    ],
  ),
];

const colorsCodeString = '''
import 'package:flutter/material.dart';

class ColorPalette {
  const ColorPalette._();

  static const Color color01 = Color(0xFF4CB219);

  static const Color color02 = Color(0xFFB28C2B);

  static const Color color03 = Color(0xFF1C6BE2);

  static const Color color03WithAlpha = Color(0x7F1C6BE2);

  static const Color color04 = Color(0xFF5470E0);

  static const Color color05 = Color(0xFF5470E0);

  static const Gradient linearGradient = LinearGradient(
    colors: [
      Color(0xFF5470E0),
      Color(0xFF991E54),
      Color(0xFF33A351),
    ],
    begin: FractionalOffset(0.00, 0.00),
    end: FractionalOffset(0.20, 0.40),
    stops: [
      0.20,
      0.60,
      1.00,
    ],
  );

  static const Gradient linearGradientNoAlignmentAndStops = LinearGradient(
    colors: [],
    begin: FractionalOffset(0.00, 0.00),
    end: FractionalOffset(0.00, 0.00),
    stops: [],
  );
}
''';

const typographyCodeString = '''
import 'package:flutter/material.dart';

class Typography {
  const Typography._();

  static const TextStyle h1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 28,
    letterSpacing: 0.40,
    height: 1.50,
    fontFamily: 'Inter',
  );

  static const TextStyle h2 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 36,
    height: 1.56,
    fontFamily: 'Inter',
  );

  static const TextStyle h3 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 48,
    fontFamily: 'Inter',
  );

  static const TextStyle h4 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 56,
    height: 1.00,
    fontFamily: 'Inter',
  );

  static const TextStyle h5 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 68,
    height: 1.00,
    fontFamily: 'Inter',
  );

  static const TextStyle h6 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 82,
    height: 1.00,
    fontFamily: 'Inter',
  );

  static const TextStyle decoratedBodyText1 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.00,
    fontFamily: 'Manrope',
    fontStyle: FontStyle.italic,
    decoration: TextDecoration.underline,
  );

  static const TextStyle decoratedBodyText2 = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 18,
    height: 1.00,
    fontFamily: 'Manrope',
    decoration: TextDecoration.lineThrough,
  );
}
''';

const shadowsString = '''
import 'package:flutter/material.dart';

class Shadows {
  const Shadows._();

  static const List<BoxShadow> smallShadow = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 4.0,
      spreadRadius: 2.0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> bigShadow = [
    BoxShadow(
      color: Color(0x1E000000),
      blurRadius: 16.0,
      spreadRadius: 4.0,
      offset: Offset(0, 0),
    ),
  ];

  static const List<BoxShadow> compositeShadow = [
    BoxShadow(
      color: Color(0x0C000000),
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(2, 2),
    ),
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 8.0,
      spreadRadius: 1.0,
      offset: Offset(-2, 0),
    ),
    BoxShadow(
      color: Color(0x54000000),
      blurRadius: 32.0,
      spreadRadius: 12.0,
      offset: Offset(0, -2),
    ),
  ];
}
''';

void main() {
  group('StylesClassGenerator', () {
    late StylesClassGenerator generator;

    setUpAll(() {
      generator = const StylesClassGenerator();
    });
    group('generateStylesClass', () {
      test('correctly generate "ColorPalette" class', () {
        final res = generator.generateStylesClass(
          styleColors,
          'ColorPalette',
        );
        expect(res, equals(colorsCodeString));
      });

      test('correctly generate "Typography" class', () {
        final res = generator.generateStylesClass(
          textStyles,
          'Typography',
        );
        expect(res, equals(typographyCodeString));
      });

      test('correctly generate "Shadows" class', () {
        final res = generator.generateStylesClass(
          effectStyles,
          'Shadows',
        );
        expect(res, equals(shadowsString));
      });
    });
  });
}

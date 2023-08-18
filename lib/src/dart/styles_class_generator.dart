import 'package:code_builder/code_builder.dart';
import 'package:figma_client/figma_client.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/dart/dart.dart';
import 'package:figma_importer/src/parser/parser.dart';

/// A class with methods to generate style classes. Suppports classes with
/// [Color], [TextStyle] and [Shadow] properties.
class StylesClassGenerator extends DartClassGenerator {
  const StylesClassGenerator();

  String generateStylesClass(
    List<BaseStyle> styles,
    String className,
  ) {
    final filteredStyles = _skipUnsupportedTypes(styles);
    final styleFields = filteredStyles.map(_getStyleField).toList();
    return buildClass(styleFields, className, [Strings.materialImport]);
  }

  List<BaseStyle> _skipUnsupportedTypes(List<BaseStyle> styles) {
    return styles.where((element) {
      if (element is ColorStyle) {
        final paintType = element.paint.type;
        return switch (paintType) {
          PaintType.gradientLinear => true,
          PaintType.solid => true,
          null => true, //null is usually a solid color
          _ => false,
        };
      }
      if (element is EffectStyle) {
        final effects = element.effect.where(
          (element) => element.type == EffectType.dropShadow,
        );
        if (effects.length == element.effect.length) {
          return true;
        }
        return false;
      }
      return true;
    }).toList();
  }

  Field _getStyleField(BaseStyle style) => switch (style) {
        ColorStyle _ => buildField(
            modifier: FieldModifier.constant,
            type: style.isGradient ? 'Gradient' : 'Color',
            name: style.name,
            code: style.isGradient
                ? _flutterGradient(style.paint)!
                : _flutterColor(style.paint.color!),
            description: style.description,
          ),
        TextStyle _ => buildField(
            modifier: FieldModifier.constant,
            type: 'TextStyle',
            name: style.name,
            code: _flutterTextStyle(style),
            description: style.description,
          ),
        EffectStyle _ => buildField(
            modifier: FieldModifier.constant,
            type: 'List<BoxShadow>',
            name: style.name,
            code: '${_flutterShadowsList(style).replaceFirst(']', '')},]',
            description: style.description,
          ),
      };

  String _flutterColor(Color color) {
    final builder = DartObjectBuilder.createObject('Color')
      ..addProperty(value: color.asHex);

    return builder.result;
  }

  String _flutterShadowsList(EffectStyle effectStyle) => effectStyle.shadow
      .map((shadow) {
        final builder = DartObjectBuilder.createObject('BoxShadow')
          ..addProperty(name: 'color', value: _flutterColor(shadow.color!))
          ..addProperty(name: 'blurRadius', value: shadow.blurRadius)
          ..addProperty(name: 'spreadRadius', value: shadow.spread)
          ..addProperty(name: 'offset', value: _flutterOffset(shadow.offset));
        return builder.result;
      })
      .toList()
      .toString();

  String _flutterOffset(Vector2D offset) {
    final builder = DartObjectBuilder.createObject('Offset')
      ..addProperty(value: offset.x)
      ..addProperty(value: offset.y);

    return builder.result;
  }

  String? _flutterFontStyle(TypeStyle typeStyle) {
    if (typeStyle.italic == null) return null;
    return typeStyle.italic! ? 'FontStyle.italic' : 'FontStyle.normal';
  }

  String? _flutterTextDecoration(TypeStyle typeStyle) =>
      switch (typeStyle.textDecoration) {
        TextDecoration.strikeThrough => 'TextDecoration.lineThrough',
        TextDecoration.underline => 'TextDecoration.underline',
        _ => null,
      };

  String _flutterFontWeight(TypeStyle typeStyle) =>
      switch (typeStyle.fontWeight) {
        100 => 'FontWeight.w100',
        200 => 'FontWeight.w200',
        300 => 'FontWeight.w300',
        400 => 'FontWeight.w400',
        500 => 'FontWeight.w500',
        600 => 'FontWeight.w600',
        700 => 'FontWeight.w700',
        800 => 'FontWeight.w800',
        900 => 'FontWeight.w900',
        _ => 'FontWeight.w400',
      };

  String _flutterTextStyle(TextStyle textStyle) {
    final typeStyle = textStyle.typeStyle;
    final fontStyle = _flutterFontStyle(typeStyle);
    final fontDecoration = _flutterTextDecoration(typeStyle);
    final codeBuilder = DartObjectBuilder.createObject('TextStyle')
      ..addProperty(name: 'fontWeight', value: _flutterFontWeight(typeStyle));

    if (typeStyle.fontSize != null) {
      codeBuilder.addProperty(name: 'fontSize', value: '${typeStyle.fontSize}');
    }
    if (typeStyle.letterSpacing != null && typeStyle.letterSpacing != 0.0) {
      codeBuilder.addProperty(
        name: 'letterSpacing',
        value: typeStyle.letterSpacing!.toStringAsFixed(2),
      );
    }
    if (textStyle.flutterLineHeight != null) {
      codeBuilder.addProperty(
        name: 'height',
        value: textStyle.flutterLineHeight!,
      );
    }
    if (typeStyle.fontFamily != null) {
      codeBuilder.addProperty(
        name: 'fontFamily',
        value: "'${typeStyle.fontFamily}'",
      );
    }
    if (fontStyle != null) {
      codeBuilder.addProperty(name: 'fontStyle', value: fontStyle);
    }

    if (fontDecoration != null) {
      codeBuilder.addProperty(name: 'decoration', value: fontDecoration);
    }

    return codeBuilder.result;
  }

  String _gradientAlignment(num x, num y) {
    final codeBuilder = DartObjectBuilder.createObject('FractionalOffset')
      ..addProperty(value: x.toStringAsFixed(2))
      ..addProperty(value: y.toStringAsFixed(2));

    return codeBuilder.result;
  }

  String _linearGradient({
    required List<String> colors,
    required String begin,
    required String end,
    required List<String> stops,
  }) {
    final codeBuilder = DartObjectBuilder.createObject('LinearGradient')
      ..addProperty(name: 'colors', value: colors)
      ..addProperty(name: 'begin', value: begin)
      ..addProperty(name: 'end', value: end)
      ..addProperty(name: 'stops', value: stops);
    return codeBuilder.result;
  }

  String? _flutterGradient(Paint paint) => switch (paint.type) {
        PaintType.gradientLinear => _linearGradient(
            colors: paint.gradientStops
                    ?.map((e) => _flutterColor(e.color!))
                    .toList() ??
                [],
            begin: paint.gradientHandlePositions != null &&
                    paint.gradientHandlePositions!.isNotEmpty
                ? _gradientAlignment(
                    paint.gradientHandlePositions![0].x,
                    paint.gradientHandlePositions![0].y,
                  )
                : _gradientAlignment(0, 0),
            end: paint.gradientHandlePositions != null &&
                    paint.gradientHandlePositions!.isNotEmpty
                ? _gradientAlignment(
                    paint.gradientHandlePositions![1].x,
                    paint.gradientHandlePositions![1].y,
                  )
                : _gradientAlignment(0, 0),
            stops: paint.gradientStops
                    ?.map((e) => e.position!.toStringAsFixed(2))
                    .toList() ??
                [],
          ),
        _ => null,
      };
}

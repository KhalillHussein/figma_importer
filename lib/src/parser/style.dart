import 'package:equatable/equatable.dart';

import 'package:figma_client/figma_client.dart';

enum StyleDefinition { color, typography, shadows }

typedef Shadow = ({
  Color? color,
  Vector2D offset,
  String blurRadius,
  String spread,
});

sealed class BaseStyle extends Equatable {
  const BaseStyle({
    required this.name,
    this.description,
  });

  final String name;
  final String? description;

  @override
  List<Object> get props => [name];
}

class ColorStyle extends BaseStyle {
  const ColorStyle({
    required super.name,
    required this.paint,
    super.description,
  });
  final Paint paint;

  bool get isEmpty => paint.color == null && paint.gradientStops == null;

  bool get isGradient => switch (paint.type) {
        PaintType.gradientLinear => true,
        _ => false,
      };
}

class TextStyle extends BaseStyle {
  const TextStyle({
    required this.typeStyle,
    required super.name,
    super.description,
  });
  final TypeStyle typeStyle;

  String? get flutterLineHeight {
    if (typeStyle.lineHeightPx == null || typeStyle.fontSize == null) {
      return null;
    }
    final lh = typeStyle.lineHeightPx! / typeStyle.fontSize!;
    return lh.toStringAsFixed(2);
  }
}

class EffectStyle extends BaseStyle {
  const EffectStyle({
    required this.effect,
    required super.name,
    super.description,
  });
  final List<Effect> effect;

  List<Shadow> get shadow {
    return effect.expand((e) {
      return [
        if (e.type == EffectType.dropShadow)
          (
            color: e.color,
            offset: e.offset ?? const Vector2D(x: 0, y: 0),
            blurRadius: (e.radius ?? 0).toStringAsFixed(1),
            spread: (e.spread ?? 0).toStringAsFixed(1),
          ),
      ];
    }).toList();
  }
}

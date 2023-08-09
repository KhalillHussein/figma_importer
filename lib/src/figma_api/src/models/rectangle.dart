import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:figma_importer/src/figma_api/figma_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rectangle.g.dart';

/// A rectangle is a rectangular-shaped vector that has a width and height and
/// may have rounded corners.
@JsonSerializable()
@CopyWith()
class Rectangle extends Vector {
  const Rectangle({
    required super.id,
    required super.visible,
    required super.locked,
    required super.exportSettings,
    required super.preserveRatio,
    required super.layoutGrow,
    required super.opacity,
    required super.isMask,
    required super.fills,
    required super.fillGeometry,
    required super.strokes,
    required super.strokeCap,
    required super.strokeJoin,
    required super.strokeDashes,
    required super.strokeMiterAngle,
    super.componentPropertyReferencesMap,
    super.name,
    super.rotation,
    super.pluginData,
    super.sharedPluginData,
    super.blendMode,
    super.layoutAlign,
    super.constraints,
    super.transitionNodeID,
    super.transitionDuration,
    super.transitionEasing,
    super.absoluteBoundingBox,
    super.effects,
    super.size,
    super.relativeTransform,
    super.strokeWeight,
    super.strokeGeometry,
    super.strokeAlign,
    super.styles,
    super.absoluteRenderBounds,
    super.fillOverrideTable,
    super.individualStrokeWeights,
    this.cornerRadius,
    this.rectangleCornerRadii,
  });
  factory Rectangle.fromJson(Map<String, dynamic> json) =>
      _$RectangleFromJson(json);

  /// Radius of each corner of the rectangle if
  /// a single radius is set for all corners.
  final double? cornerRadius;

  /// Array of length 4 of the radius of each corner of the rectangle,
  /// starting in the top left and proceeding clockwise.
  final List<double>? rectangleCornerRadii;

  @override
  List<Object?> get props => [
        ...super.props,
        cornerRadius,
        rectangleCornerRadii,
      ];

  @override
  Map<String, dynamic> toJson() => _$RectangleToJson(this);

  @override
  String toString() =>
      '''Rectangle(cornerRadius: $cornerRadius, rectangleCornerRadii: $rectangleCornerRadii)''';
}

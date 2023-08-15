import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:figma_importer/src/figma_api/figma_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ellipse.g.dart';

/// An ellipse shaped vector.
@JsonSerializable()
@CopyWith()
class Ellipse extends Vector {
  const Ellipse({
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
    required this.arcData,
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
    super.individualStrokeWeights,
  });

  factory Ellipse.fromJson(Map<String, dynamic> json) =>
      _$EllipseFromJson(json);

  /// Start and end angles of the ellipse measured clockwise from the x axis,
  /// plus the inner radius for donuts.
  final ArcData arcData;

  @override
  Map<String, dynamic> toJson() => _$EllipseToJson(this);
}

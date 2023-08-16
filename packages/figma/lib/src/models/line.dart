import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:figma/figma.dart';
import 'package:json_annotation/json_annotation.dart';

part 'line.g.dart';

@JsonSerializable()
@CopyWith()
class Line extends Vector {
  const Line({
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
    super.individualStrokeWeights,
  });

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LineToJson(this);
}
import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:figma/figma.dart';
import 'package:figma/src/converters/converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'section.g.dart';

/// A Figma frame.
@JsonSerializable()
@CopyWith()
class Section extends Node {
  const Section({
    required super.id,
    required super.visible,
    required this.locked,
    required this.fills,
    required this.strokes,
    required this.children,
    required this.opacity,
    super.componentPropertyReferencesMap,
    super.name,
    super.rotation,
    super.pluginData,
    super.sharedPluginData,
    super.type,
    this.absoluteBoundingBox,
    this.absoluteRenderBounds,
    this.strokeWeight,
    this.individualStrokeWeights,
    this.strokeAlign,
  });
  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);

  /// An array of nodes that are direct children of this node.
  @NodeJsonConverter()
  final List<Node?>? children;

  /// If true, layer is locked and cannot be edited.
  @JsonKey(defaultValue: false)
  final bool locked;

  /// An array of fill paints applied to the node.
  @JsonKey(defaultValue: [])
  final List<Paint> fills;

  /// An array of stroke paints applied to the node.
  @JsonKey(defaultValue: [])
  final List<Paint> strokes;

  /// The weight of strokes on the node.
  final double? strokeWeight;

  /// The weight of strokes on the node per side, if they vary.
  final StrokeWeights? individualStrokeWeights;

  /// Position of stroke relative to vector outline, as a string enum.
  final StrokeAlign? strokeAlign;

  /// Opacity of the node.
  @JsonKey(defaultValue: 1.0)
  final double opacity;

  /// Bounding box of the node in absolute space coordinates.
  final SizeRectangle? absoluteBoundingBox;

  /// The bounds of the rendered node in the file in absolute space coordinates.
  final SizeRectangle? absoluteRenderBounds;

  @override
  List<Object?> get props => [
        ...super.props,
        children,
        locked,
        fills,
        strokes,
        strokeWeight,
        individualStrokeWeights,
        strokeAlign,
        opacity,
        absoluteBoundingBox,
      ];

  @override
  Map<String, dynamic> toJson() => _$SectionToJson(this);
}

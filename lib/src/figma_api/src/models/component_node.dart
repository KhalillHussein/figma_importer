import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:figma_importer/src/figma_api/figma_api.dart';
import 'package:figma_importer/src/figma_api/src/converters/node.dart';
import 'package:json_annotation/json_annotation.dart';

part 'component_node.g.dart';

/// A component is a reusable piece of design that can be applied to different
/// frames. Components can contain other components.
@JsonSerializable()
@CopyWith()
class ComponentNode extends Frame {
  const ComponentNode({
    required super.id,
    required super.visible,
    required super.locked,
    required super.fills,
    required super.styles,
    required super.strokes,
    required super.exportSettings,
    required super.children,
    required super.opacity,
    required super.primaryAxisAlignItems,
    required super.counterAxisAlignItems,
    required super.primaryAxisSizingMode,
    required super.counterAxisSizingMode,
    required super.paddingBottom,
    required super.paddingLeft,
    required super.paddingRight,
    required super.paddingTop,
    required super.horizontalPadding,
    required super.verticalPadding,
    required super.itemSpacing,
    required super.layoutGrids,
    required super.overflowDirection,
    required super.effects,
    required super.isMask,
    required super.isMaskOutline,
    required super.layoutPositioning,
    required super.itemReverseZIndex,
    required super.strokesIncludedInLayout,
    required this.componentPropertyDefinitions,
  });
  factory ComponentNode.fromJson(Map<String, dynamic> json) =>
      _$ComponentNodeFromJson(json);

  /// A mapping of name to ComponentPropertyDefinition for every component
  /// property on this component. Each property has a type, defaultValue, and
  /// ther optional values.
  @JsonKey(defaultValue: {})
  final Map<String, ComponentPropertyDefinition> componentPropertyDefinitions;

  @override
  Map<String, dynamic> toJson() => _$ComponentNodeToJson(this);
}

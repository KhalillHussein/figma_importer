import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:figma_client/figma_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paint_override.g.dart';

/// Paint metadata to override default paints.
@JsonSerializable()
@CopyWith()
class PaintOverride {
  PaintOverride({
    required this.fills,
    this.inheritFillStyleId,
  });

  factory PaintOverride.fromJson(Map<String, dynamic> json) =>
      _$PaintOverrideFromJson(json);

  /// Paints applied to characters.
  @JsonKey(defaultValue: [])
  final List<Paint> fills;

  /// ID of style node, if any, that this inherits fill data from.
  final String? inheritFillStyleId;

  Map<String, dynamic> toJson() => _$PaintOverrideToJson(this);
}

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:figma_importer/src/figma_api/figma_api.dart';

import 'package:json_annotation/json_annotation.dart';

part 'component_property.g.dart';

/// Component properties.
@JsonSerializable()
@CopyWith()
class ComponentProperty {
  const ComponentProperty({
    required this.type,
    required this.value,
    this.preferredValues,
  });

  factory ComponentProperty.fromJson(Map<String, dynamic> json) =>
      _$ComponentPropertyFromJson(json);

  /// The type of the property.
  final String type;

  /// Value of this property for instances. Either a string or a boolean.
  final dynamic value;

  /// List of user-defined preferred values for this property. Only exists on
  /// INSTANCE_SWAP properties.
  final List<InstanceSwapPreferredValue>? preferredValues;

  Map<String, dynamic> toJson() => _$ComponentPropertyToJson(this);
}

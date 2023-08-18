import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import 'package:figma_client/figma_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'style.g.dart';

/// A set of properties that can be applied to nodes and published.
/// Styles for a property can be created in the corresponding property's panel
/// while editing a file.
@JsonSerializable()
@CopyWith()
class Style extends Equatable {
  const Style({
    this.key,
    this.name,
    this.description,
    this.type,
  });

  factory Style.fromJson(Map<String, dynamic> json) => _$StyleFromJson(json);

  /// The key of the style.
  final String? key;

  /// The name of the style.
  final String? name;

  /// The description of the style.
  final String? description;

  /// The type of style as string enum.
  @JsonKey(name: 'styleType')
  final StyleType? type;

  @override
  List<Object?> get props => [
        key,
        name,
        description,
        type,
      ];

  Map<String, dynamic> toJson() => _$StyleToJson(this);
}

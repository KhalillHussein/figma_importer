import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:figma/figma.dart';
import 'package:json_annotation/json_annotation.dart';

part 'components_meta.g.dart';

/// Response wrapping a list of [Component]s from the [Figma API docs](https://www.figma.com/developers/api#components-endpoints).
@JsonSerializable()
@CopyWith()
class ComponentsMeta extends Equatable {
  const ComponentsMeta({this.components, this.cursor});

  factory ComponentsMeta.fromJson(Map<String, dynamic> json) =>
      _$ComponentsMetaFromJson(json);

  /// List of components, if any.
  final List<Component>? components;

  /// Pagniation cursor, if any.
  final Cursor? cursor;

  @override
  List<Object?> get props => [components, cursor];

  Map<String, dynamic> toJson() => _$ComponentsMetaToJson(this);
}

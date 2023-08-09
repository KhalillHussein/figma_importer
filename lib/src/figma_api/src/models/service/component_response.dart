import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:figma_importer/src/figma_api/figma_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'component_response.g.dart';

/// Response wrapping a [Component] from the [Figma API docs](https://www.figma.com/developers/api#component-endpoints).
@JsonSerializable()
@CopyWith()
class ComponentResponse extends Equatable {
  const ComponentResponse({this.status, this.error, this.component});

  factory ComponentResponse.fromJson(Map<String, dynamic> json) =>
      _$ComponentResponseFromJson(json);

  /// Status code, if any.
  final int? status;

  /// If the operation ended in error.
  final bool? error;

  /// The requested component, if any.
  @JsonKey(name: 'meta')
  final Component? component;

  @override
  List<Object?> get props => [status, error, component];

  Map<String, dynamic> toJson() => _$ComponentResponseToJson(this);
}

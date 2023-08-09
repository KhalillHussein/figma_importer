import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:figma_importer/src/figma_api/figma_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'style_response.g.dart';

/// A response object containing a [Style] object.
@JsonSerializable()
@CopyWith()
class StyleResponse extends Equatable {
  const StyleResponse({this.status, this.error, this.style});

  factory StyleResponse.fromJson(Map<String, dynamic> json) =>
      _$StyleResponseFromJson(json);

  /// Status code.
  final int? status;

  /// If the operation ended in error.
  final bool? error;

  /// Requested [Style] object.
  @JsonKey(name: 'meta')
  final Style? style;

  @override
  List<Object?> get props => [status, error, style];

  Map<String, dynamic> toJson() => _$StyleResponseToJson(this);
}

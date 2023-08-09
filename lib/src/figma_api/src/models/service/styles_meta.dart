import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:figma_importer/src/figma_api/figma_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'styles_meta.g.dart';

/// Wrapper containing a [Style] list along some metadata.
@JsonSerializable()
@CopyWith()
class StylesMeta extends Equatable {
  const StylesMeta({this.styles, this.cursor});

  factory StylesMeta.fromJson(Map<String, dynamic> json) =>
      _$StylesMetaFromJson(json);

  /// List of [Style] objects.
  final List<Style>? styles;

  /// Pagination cursor.
  final Cursor? cursor;

  @override
  List<Object?> get props => [styles, cursor];

  Map<String, dynamic> toJson() => _$StylesMetaToJson(this);
}

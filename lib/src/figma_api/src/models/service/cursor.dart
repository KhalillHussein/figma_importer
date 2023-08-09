import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cursor.g.dart';

/// Pagination cursor.
@JsonSerializable()
@CopyWith()
class Cursor extends Equatable {
  const Cursor({this.before, this.after});

  factory Cursor.fromJson(Map<String, dynamic> json) => _$CursorFromJson(json);

  /// Page before.
  final int? before;

  /// Page after.
  final int? after;

  @override
  List<Object?> get props => [before, after];

  Map<String, dynamic> toJson() => _$CursorToJson(this);
}

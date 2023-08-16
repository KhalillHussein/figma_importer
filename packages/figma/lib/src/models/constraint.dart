import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'constraint.g.dart';

/// Type of constraint to apply.
enum ConstraintType {
  /// Scale by value.
  @JsonValue('SCALE')
  scale,

  /// Scale proportionally and set width to value.
  @JsonValue('WIDTH')
  width,

  /// Scale proportionally and set height to value.
  @JsonValue('HEIGHT')
  height
}

/// Sizing constraint for exports.
@JsonSerializable()
@CopyWith()
class Constraint extends Equatable {
  const Constraint({this.type, this.value});

  factory Constraint.fromJson(Map<String, dynamic> json) =>
      _$ConstraintFromJson(json);

  /// Type of constraint to apply.
  final ConstraintType? type;

  /// See type property for effect of this field.
  final num? value;

  @override
  List<Object?> get props => [type, value];

  Map<String, dynamic> toJson() => _$ConstraintToJson(this);
}

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import 'package:figma_client/figma_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version.g.dart';

/// A version of a file.
@JsonSerializable()
@CopyWith()
class Version extends Equatable {
  const Version({
    required this.id,
    required this.createdAt,
    required this.user,
    this.label,
    this.description,
  });
  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);

  /// Unique identifier for version.
  final String id;

  /// The UTC ISO 8601 time at which the version was created.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The label given to the version in the editor.
  final String? label;

  /// The description of the version as entered in the editor.
  final String? description;

  /// The user that created the version.
  final User user;

  @override
  List<Object?> get props => [
        id,
        createdAt,
        label,
        description,
        user,
      ];

  Map<String, dynamic> toJson() => _$VersionToJson(this);
}

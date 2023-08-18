import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:figma_client/figma_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'versions_response.g.dart';

/// A response object containing a list of versions.
@JsonSerializable()
@CopyWith()
class VersionsResponse extends Equatable {
  const VersionsResponse({this.versions});

  factory VersionsResponse.fromJson(Map<String, dynamic> json) =>
      _$VersionsResponseFromJson(json);

  /// List of versions.
  final List<Version>? versions;

  @override
  List<Object?> get props => [versions];

  Map<String, dynamic> toJson() => _$VersionsResponseToJson(this);
}

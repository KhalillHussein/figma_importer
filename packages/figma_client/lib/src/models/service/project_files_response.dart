import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:figma_client/figma_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_files_response.g.dart';

/// A response object containing a list of a project's files.
@JsonSerializable()
@CopyWith()
class ProjectFilesResponse extends Equatable {
  const ProjectFilesResponse({this.name, this.files});

  factory ProjectFilesResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectFilesResponseFromJson(json);

  /// Project name.
  final String? name;

  /// List of [ProjectFile] belonging to the project.
  final List<ProjectFile>? files;

  @override
  List<Object?> get props => [name, files];

  Map<String, dynamic> toJson() => _$ProjectFilesResponseToJson(this);
}

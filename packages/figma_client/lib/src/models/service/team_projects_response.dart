import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:figma_client/figma_client.dart';

import 'package:json_annotation/json_annotation.dart';

part 'team_projects_response.g.dart';

/// A response object containing a list of a team's projects.
@JsonSerializable()
@CopyWith()
class TeamProjectsResponse extends Equatable {
  const TeamProjectsResponse({this.name, this.projects});

  factory TeamProjectsResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamProjectsResponseFromJson(json);

  /// Team name.
  final String? name;

  /// List of project of this team.
  final List<Project>? projects;

  @override
  List<Object?> get props => [name, projects];

  Map<String, dynamic> toJson() => _$TeamProjectsResponseToJson(this);
}

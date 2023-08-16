import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:figma/figma.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comments_response.g.dart';

/// Response wrapping a list of [Comment]s from the [Figma API docs](https://www.figma.com/developers/api#comments).
@JsonSerializable()
@CopyWith()
class CommentsResponse extends Equatable {
  const CommentsResponse({this.comments});

  factory CommentsResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentsResponseFromJson(json);

  /// List of comments requested, if any.
  final List<Comment>? comments;

  @override
  List<Object?> get props => [comments];

  Map<String, dynamic> toJson() => _$CommentsResponseToJson(this);
}

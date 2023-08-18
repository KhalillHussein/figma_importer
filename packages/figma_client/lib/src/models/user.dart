import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// A description of a Figma user.
@JsonSerializable()
@CopyWith()
class User extends Equatable {
  const User({
    required this.id,
    required this.handle,
    this.imageUrl,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Unique stable ID of the user.
  final String id;

  /// Name of the user.
  final String handle;

  /// URL link to the user's profile image, if one exists.
  @JsonKey(name: 'img_url')
  final String? imageUrl;

  /// Email associated with the user's account.
  /// This will only be present on the /v1/me endpoint.
  final String? email;

  @override
  List<Object?> get props => [id, handle, imageUrl, email];

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

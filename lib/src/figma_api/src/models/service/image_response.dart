import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_response.g.dart';

/// A response object containing a list of images.
@JsonSerializable()
@CopyWith()
class ImageResponse extends Equatable {
  const ImageResponse({this.err, this.images, this.imageFills, this.status});

  factory ImageResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageResponseFromJson(json);

  /// Error message.
  final String? err;

  /// Images made by Figma.
  /// Map where the keys are image IDs and the value is an image URL.
  final Map<String, String>? images;

  /// Images imported by the user.
  /// Map where the keys are image IDs and the value is an image URL.
  @JsonKey(name: 'meta', readValue: _readValueWithString)
  final Map<String, String>? imageFills;

  /// Status code.
  final int? status;

  @override
  List<Object?> get props => [err, images, imageFills, status];

  Map<String, dynamic> toJson() => _$ImageResponseToJson(this);

  static Map<String, String>? _readValueWithString(
    Map<dynamic, dynamic> map,
    String key,
  ) {
    if (map['meta'] == null) {
      return null;
    }
    return Map<String, String>.from(
      (map['meta'] as Map?)!['images'] as Map,
    );
  }
}

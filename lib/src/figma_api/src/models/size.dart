import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'size.g.dart';

/// A width and a height.
@JsonSerializable()
@CopyWith()
class Size {
  Size({
    required this.width,
    required this.height,
  });

  factory Size.fromJson(Map<String, dynamic> json) => _$SizeFromJson(json);

  /// The width of a size.
  final double width;

  /// The height of a size.
  final double height;

  Map<String, dynamic> toJson() => _$SizeToJson(this);
}

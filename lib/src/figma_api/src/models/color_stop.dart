import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import 'package:figma_importer/src/figma_api/figma_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'color_stop.g.dart';

/// A position color pair representing a gradient stop.
@JsonSerializable()
@CopyWith()
class ColorStop extends Equatable {
  const ColorStop({this.position, this.color});

  factory ColorStop.fromJson(Map<String, dynamic> json) =>
      _$ColorStopFromJson(json);

  /// Value between 0 and 1 representing position along gradient axis.
  final double? position;

  /// Color attached to corresponding position.
  final Color? color;

  @override
  List<Object?> get props => [position, color];

  Map<String, dynamic> toJson() => _$ColorStopToJson(this);
}

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flow_starting_point.g.dart';

/// A starting point for a flow within a frame.
@JsonSerializable()
@CopyWith()
class FlowStartingPoint {
  const FlowStartingPoint({
    required this.nodeId,
    required this.name,
  });

  factory FlowStartingPoint.fromJson(Map<String, dynamic> json) =>
      _$FlowStartingPointFromJson(json);

  /// Unique identifier specifying the frame.
  final String nodeId;

  /// Name of flow.
  final String name;

  Map<String, dynamic> toJson() => _$FlowStartingPointToJson(this);
}

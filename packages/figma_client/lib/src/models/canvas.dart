import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:figma_client/figma_client.dart';
import 'package:figma_client/src/converters/converters.dart';

import 'package:json_annotation/json_annotation.dart';

part 'canvas.g.dart';

/// A Canvas node represents a Page in a Figma File.
/// A Canvas node can then have any number of nodes as its children.
/// Each subtree stemming from a Canvas node will represent a layer
/// (e.g an object) on the Canvas.
@JsonSerializable()
@CopyWith()
class Canvas extends Node {
  const Canvas({
    required super.id,
    required super.visible,
    required this.prototypeDevice,
    required this.flowStartingPoints,
    required this.exportSettings,
    super.componentPropertyReferencesMap,
    super.name,
    super.rotation,
    super.pluginData,
    super.sharedPluginData,
    super.type,
    this.children,
    this.backgroundColor,
  });

  @override
  factory Canvas.fromJson(Map<String, dynamic> json) => _$CanvasFromJson(json);

  /// An array of top level layers on the canvas.
  @NodeJsonConverter()
  final List<Node?>? children;

  /// Background color of the canvas.
  final Color? backgroundColor;

  /// An array of export settings representing images to export from the canvas.
  @JsonKey(defaultValue: [])
  final List<ExportSetting> exportSettings;

  /// An array of starting points for flows attached to the canvas.
  @JsonKey(defaultValue: [])
  final List<FlowStartingPoint> flowStartingPoints;

  /// The device that this canvas is a prototype for.
  final PrototypeDevice prototypeDevice;

  @override
  List<Object?> get props => [
        ...super.props,
        children,
        backgroundColor,
        exportSettings,
        flowStartingPoints,
        prototypeDevice,
      ];

  @override
  Map<String, dynamic> toJson() => _$CanvasToJson(this);
}

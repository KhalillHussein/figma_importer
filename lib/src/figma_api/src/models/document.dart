import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:figma_importer/src/figma_api/figma_api.dart';
import 'package:figma_importer/src/figma_api/src/converters/node.dart';

import 'package:json_annotation/json_annotation.dart';

part 'document.g.dart';

/// At the root of every File is a Document node, and from that Document
///  node stems any Canvas nodes.
@JsonSerializable()
@CopyWith()
class Document extends Node {
  const Document({
    required super.id,
    required super.visible,
    super.componentPropertyReferencesMap,
    super.rotation,
    super.type,
    super.name,
    super.pluginData,
    super.sharedPluginData,
    this.children,
  });

  @override
  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  /// An array of canvases attached to the document.
  @NodeJsonConverter()
  final List<Node?>? children;

  @override
  List<Object?> get props => [
        ...super.props,
        children,
      ];

  @override
  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}

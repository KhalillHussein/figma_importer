import 'package:collection/collection.dart';

import 'package:figma_client/figma_client.dart';
import 'package:figma_importer/src/parser/parser.dart';

///Class that parses style tokens from the Figma file.
class TokenParser {
  const TokenParser();

  ///Get style objects from the Figma file.
  Map<String, Style>? getStylesFromFile(
    NodesResponse file,
  ) {
    final styles = file.nodes?.values
        .map((e) => e.styles?.entries.toList())
        .whereNotNull();

    if (styles == null || styles.isEmpty) return null;

    return Map.fromEntries(
      styles.reduce((value, element) => value + element),
    );
  }

  /// Group style types by [StyleDefinition].
  Map<StyleDefinition, List<BaseStyle>> getStyleSets(List<BaseStyle> styles) {
    final styleSets = <StyleDefinition, List<BaseStyle>>{};
    for (final style in styles) {
      switch (style) {
        case ColorStyle _:
          styleSets.update(
            StyleDefinition.color,
            (value) {
              if (!value.contains(style) && !style.isEmpty) value.add(style);
              return value;
            },
            ifAbsent: () => [style],
          );
        case TextStyle _:
          styleSets.update(
            StyleDefinition.typography,
            (value) {
              if (!value.contains(style)) value.add(style);
              return value;
            },
            ifAbsent: () => [style],
          );
        case EffectStyle _:
          styleSets.update(
            StyleDefinition.shadows,
            (value) {
              if (!value.contains(style)) value.add(style);
              return value;
            },
            ifAbsent: () => [style],
          );
      }
    }

    return styleSets;
  }

  ///Alternative method to get style properties. Used when receiving a list of
  ///PaintStyles from the Figma API.
  List<BaseStyle>? findStylesPropertiesInPaintStyles(
    NodesResponse file,
    Map<String, Style> styles,
  ) {
    return file.nodes?.values
        .expand<BaseStyle>((fileResp) {
          if (fileResp.document == null ||
              styles[fileResp.document!.id] == null) {
            return [];
          }
          final mappedStyles = _mapStyleType(
            fileResp.document!,
            styles[fileResp.document!.id]!,
          );
          if (mappedStyles == null) return [];

          return [mappedStyles];
        })
        .toList()
        .alphabetize;
  }

  ///Iterate through each [Node] and get a list of styles from each [Node].
  ///The number of nodes is equal to the number of IDs in the config file.
  List<BaseStyle>? findStylesInNodes(
    NodesResponse file,
    Map<String, Style> styles,
  ) {
    return file.nodes?.values.map((fileResp) {
      final searchResult = _findStylesInTree(fileResp.document, styles);
      return searchResult;
    }).reduce((value, element) {
      if (element != null) value?.addAll(element);

      return value;
    })?.alphabetize;
  }

  ///Find style properties in the figma file by theirs ID's from the
  ///style definitions.
  List<BaseStyle>? _findStylesInTree(
    Node? root,
    Map<String, Style> styles, [
    List<BaseStyle>? tempStyles,
  ]) {
    final temp = tempStyles ?? <BaseStyle>[];

    final nodeStyles = _getStylesFromNode(root, styles);
    if (nodeStyles != null) temp.addAll(nodeStyles);

    if (_isLeaf(root)) return temp;

    final res =
        _getNodeChildren(root)?.map((e) => _findStylesInTree(e, styles, temp));
    if (res == null || res.isEmpty) return null;

    return res
        .reduce((acc, current) {
          return acc != null && current != null
              ? acc + current
              : acc ?? current;
        })
        ?.toSet()
        .toList();
  }

  ///Get style objects from the [Node].
  List<BaseStyle>? _getStylesFromNode(Node? node, Map<String, Style> styles) {
    final nodeStyles = _getStylesBasedOnNodeType(node);
    if (nodeStyles == null) return null;
    return nodeStyles.entries.expand<BaseStyle>((entry) {
      final style = styles.entries.firstWhereOrNull(
        (style) =>
            entry.value == style.key &&
            style.value.type != null &&
            entry.key == _getStyleTypeKey(style.value.type!),
      );

      if (style == null || node == null) return [];
      final mappedStyle = _mapStyleType(node, style.value);
      if (mappedStyle == null) return [];
      return [mappedStyle];
    }).toList();
  }

  ///Map the [Node] style property and [Style] to a single [BaseStyle] object.
  BaseStyle? _mapStyleType(Node node, Style style) {
    if (node is! Vector && node is! Frame) return null;
    final effects = _getNodeEffects(node);
    final fills = _getNodeFills(node);
    return switch (style.type) {
      StyleType.fill when fills != null && fills.isNotEmpty => ColorStyle(
          paint: fills.first,
          name: style.name ?? style.type!.name,
          description: style.description,
        ),
      StyleType.text when node is Text && node.style != null => TextStyle(
          typeStyle: node.style!,
          name: style.name ?? style.type!.name,
          description: style.description,
        ),
      StyleType.effect when effects != null => EffectStyle(
          effect: effects,
          name: style.name ?? style.type!.name,
          description: style.description,
        ),
      _ => null,
    };
  }

  Map<StyleTypeKey, String>? _getStylesBasedOnNodeType(Node? node) {
    return switch (node) {
      Frame _ => node.styles,
      Vector _ => node.styles,
      _ => null,
    };
  }

  List<Paint>? _getNodeFills(Node node) => switch (node) {
        Vector _ => node.fills,
        Frame _ => node.fills,
        _ => null,
      };

  List<Effect>? _getNodeEffects(Node node) => switch (node) {
        Vector _ => node.effects,
        Frame _ => node.effects,
        _ => null,
      };

  ///Checks if the [Node] is last in the node tree.
  bool _isLeaf(Node? node) {
    final children = _getNodeChildren(node);

    return node != null && children == null || children!.isEmpty;
  }

  ///Mapping [StyleType] in the [Style] object to the [StyleTypeKey] in the
  ///[Node] style property.
  StyleTypeKey? _getStyleTypeKey(StyleType styleType) => switch (styleType) {
        StyleType.fill => StyleTypeKey.fill,
        StyleType.text => StyleTypeKey.text,
        StyleType.effect => StyleTypeKey.effect,
        _ => null,
      };

  ///Only [Frame], [Section], [Canvas],[BooleanOperation] can have
  ///children nodes.
  List<Node?>? _getNodeChildren(Node? node) => switch (node) {
        Frame _ => node.children,
        Section _ => node.children,
        Canvas _ => node.children,
        BooleanOperation _ => node.children,
        _ => null,
      };
}

extension on List<BaseStyle> {
  List<BaseStyle> get alphabetize => this
    ..sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
}

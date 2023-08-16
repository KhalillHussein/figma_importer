import 'package:figma/figma.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/figma/figma.dart';
import 'package:figma_importer/src/parser/parser.dart';

///A Class to perform styles import from the Figma file.
class FigmaImporter implements Importer<NodesResponse> {
  FigmaImporter({
    required String apiToken,
    required String fileId,
    required List<String> nodeIds,
    FigmaClient? figmaClient,
  })  : _client = figmaClient ?? FigmaClient(apiToken),
        _fileId = fileId,
        _nodeIds = nodeIds;

  final FigmaClient _client;

  final String _fileId;
  final List<String> _nodeIds;

  @override
  Future<NodesResponse> getFile() async {
    return _client.getFileNodes(_fileId, FigmaQuery(ids: _nodeIds));
  }

  @override
  Future<Map<StyleDefinition, List<BaseStyle>>> getFileStyles(
    NodesResponse file,
  ) async {
    const tokenParser = TokenParser();
    final styles = tokenParser.getStylesFromFile(file);
    if (styles == null) throw const StylesNotFoundException();
    final paintStyles = await _client.getFileNodes(
      _fileId,
      FigmaQuery(ids: styles.keys.toList()),
    );

    final parsedStyles = tokenParser.findStylesPropertiesInPaintStyles(
      paintStyles,
      styles,
    );

    if (parsedStyles == null) throw const StylesParseException();
    final styleSets = tokenParser.getStyleSets(parsedStyles);
    return styleSets;
  }
}

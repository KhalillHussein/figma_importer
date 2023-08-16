import 'package:figma/figma.dart';
import 'package:figma_importer/src/common/common.dart';
import 'package:figma_importer/src/figma/figma.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFigmaClient extends Mock implements FigmaClient {}

const _styleMap = {
  StyleDefinition.color: [
    ColorStyle(
      name: 'test-style-1',
      paint: Paint(
        visible: true,
        color: Color(r: 0.2, g: 0.6, b: 0.1, a: 1),
      ),
    ),
  ],
  StyleDefinition.shadows: [
    EffectStyle(
      name: 'test-style-3',
      effect: [
        Effect(visible: false),
      ],
    ),
  ],
  StyleDefinition.typography: [
    TextStyle(
      name: 'test-style-2',
      typeStyle: TypeStyle(),
    ),
  ],
};

const _rawStyles = {
  '23:11': Style(
    key: 'key_1',
    name: 'test-style-1',
    type: StyleType.fill,
  ),
  '65:12': Style(
    key: 'key_2',
    name: 'test-style-2',
    type: StyleType.text,
  ),
  '54:1': Style(
    key: 'key_3',
    name: 'test-style-3',
    type: StyleType.effect,
  ),
};

const _nodesResponse = NodesResponse(
  name: 'test-node',
  nodes: {
    'test-key': FileResponse(
      name: 'test-file',
      document: Node(
        id: '1',
        visible: true,
        name: 'test-node-doc',
      ),
      styles: _rawStyles,
    ),
  },
);

const _paintStylesResponse = NodesResponse(
  name: 'test-node',
  nodes: {
    '23:11': FileResponse(
      document: Rectangle(
        id: '23:11',
        visible: true,
        locked: false,
        exportSettings: [],
        preserveRatio: true,
        layoutGrow: 1,
        opacity: 1,
        isMask: false,
        fills: [
          Paint(
            visible: true,
            type: PaintType.solid,
            color: Color(r: 1, g: 0.5, b: 0.1, a: 1),
          ),
        ],
        fillGeometry: [],
        strokes: [],
        strokeCap: StrokeCap.none,
        strokeJoin: StrokeJoin.miter,
        strokeDashes: [],
        strokeMiterAngle: 1,
      ),
    ),
    '65:12': FileResponse(
      document: Text(
        id: '65:12',
        visible: true,
        locked: false,
        exportSettings: [],
        preserveRatio: true,
        layoutGrow: 1,
        opacity: 1,
        isMask: false,
        fills: [],
        style: TypeStyle(
          fontFamily: 'Inter',
          fontWeight: 500,
          letterSpacing: 0.2,
          fontSize: 20,
          lineHeightPx: 20,
        ),
        fillGeometry: [],
        strokes: [],
        strokeCap: StrokeCap.none,
        strokeJoin: StrokeJoin.miter,
        strokeDashes: [],
        strokeMiterAngle: 1,
      ),
    ),
    '54:1': FileResponse(
      document: Rectangle(
        id: '54:1',
        visible: true,
        locked: false,
        exportSettings: [],
        preserveRatio: true,
        layoutGrow: 1,
        opacity: 1,
        isMask: false,
        fills: [],
        effects: [
          Effect(
            visible: true,
            spread: 2,
            type: EffectType.dropShadow,
            offset: Vector2D(x: 0, y: 2),
          ),
        ],
        fillGeometry: [],
        strokes: [],
        strokeCap: StrokeCap.none,
        strokeJoin: StrokeJoin.miter,
        strokeDashes: [],
        strokeMiterAngle: 1,
      ),
    ),
  },
);

const _nodesResponseWithEmptyStyles = NodesResponse(
  name: 'test-node',
  nodes: {
    'test-key': FileResponse(
      name: 'test-file',
      document: Node(
        id: '1',
        visible: true,
        name: 'test-node-doc',
      ),
    ),
  },
);

void main() {
  group('FigmaImporter', () {
    late FigmaClient figmaClient;
    late FigmaImporter figmaImporter;

    setUpAll(() {
      registerFallbackValue(const FigmaQuery(ids: []));
      registerFallbackValue(const NodesResponse());
    });

    setUp(() {
      figmaClient = _MockFigmaClient();
      figmaImporter = FigmaImporter(
        apiToken: 'test-token',
        fileId: 'test-id',
        nodeIds: ['1', '2'],
        figmaClient: figmaClient,
      );

      when(
        () => figmaClient.getFileNodes(any(), any()),
      ).thenAnswer((_) => Future.value(_nodesResponseWithEmptyStyles));
    });

    group('getFile', () {
      test('correctly get NodesResponse', () async {
        final resp = await figmaImporter.getFile();

        expect(resp, equals(_nodesResponseWithEmptyStyles));

        verify(
          () => figmaClient.getFileNodes(
            'test-id',
            const FigmaQuery(ids: ['1', '2']),
          ),
        ).called(1);
      });
    });

    group('getFileStyles', () {
      test('throw StylesNotFoundException when styles is null', () {
        expect(
          () async =>
              figmaImporter.getFileStyles(_nodesResponseWithEmptyStyles),
          throwsA(isA<StylesNotFoundException>()),
        );

        verifyNever(() => figmaClient.getFileNodes(any(), any()));
      });

      test('throw StylesParseException when styles is null', () {
        when(
          () => figmaClient.getFileNodes(any(), any()),
        ).thenAnswer((_) => Future.value(const NodesResponse()));

        expect(
          () async => figmaImporter.getFileStyles(_nodesResponse),
          throwsA(isA<StylesParseException>()),
        );
        verify(
          () => figmaClient.getFileNodes(
            'test-id',
            const FigmaQuery(ids: ['23:11', '65:12', '54:1']),
          ),
        ).called(1);
      });

      test('correctly get file styles', () async {
        when(
          () => figmaClient.getFileNodes(any(), any()),
        ).thenAnswer((_) => Future.value(_paintStylesResponse));

        final resp = await figmaImporter.getFileStyles(_nodesResponse);
        expect(resp, equals(_styleMap));
        verify(
          () => figmaClient.getFileNodes(
            'test-id',
            const FigmaQuery(ids: ['23:11', '65:12', '54:1']),
          ),
        ).called(1);
      });
    });
  });
}

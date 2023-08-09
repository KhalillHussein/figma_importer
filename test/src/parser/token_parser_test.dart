import 'package:figma_importer/src/figma_api/figma_api.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:test/test.dart';

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
      document: Section(
        id: '1',
        visible: true,
        name: 'test-node-doc',
        locked: false,
        fills: [],
        strokes: [],
        opacity: 1,
        children: [
          Rectangle(
            id: 'rectangle',
            visible: true,
            locked: false,
            styles: {StyleTypeKey.fill: '23:11'},
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
          Text(
            id: 'text',
            visible: true,
            locked: false,
            styles: {StyleTypeKey.text: '65:12'},
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
          Rectangle(
            id: 'rectangle-2',
            visible: true,
            locked: false,
            styles: {StyleTypeKey.effect: '54:1'},
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
        ],
      ),
      styles: _rawStyles,
    ),
  },
);

const _nodeResponseWithoutStyles = NodesResponse(
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

const _styles = [
  ColorStyle(
    name: 'color',
    paint: Paint(visible: true),
  ),
  TextStyle(
    name: 'h1',
    typeStyle: TypeStyle(),
  ),
  TextStyle(
    name: 'h2',
    typeStyle: TypeStyle(),
  ),
  EffectStyle(
    name: 'effect',
    effect: [Effect(visible: true)],
  ),
];

const _styleMap = {
  StyleDefinition.color: [
    ColorStyle(
      name: 'color',
      paint: Paint(visible: true),
    ),
  ],
  StyleDefinition.shadows: [
    EffectStyle(
      name: 'effect',
      effect: [Effect(visible: false)],
    ),
  ],
  StyleDefinition.typography: [
    TextStyle(
      name: 'h1',
      typeStyle: TypeStyle(),
    ),
    TextStyle(
      name: 'h2',
      typeStyle: TypeStyle(),
    ),
  ],
};

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

void main() {
  group('TokenParser', () {
    late TokenParser tokenParser;

    setUp(() {
      tokenParser = const TokenParser();
    });

    group('getStylesFromFile', () {
      test('correctly gets styles', () {
        final result = tokenParser.getStylesFromFile(_nodesResponse);
        expect(result, equals(_rawStyles));
      });

      test('returns null if the file does not contain styles', () {
        final result =
            tokenParser.getStylesFromFile(_nodeResponseWithoutStyles);
        expect(result, equals(null));
      });
    });

    group('getStyleSets', () {
      test('correctly gets style sets', () {
        final result = tokenParser.getStyleSets(_styles);
        expect(result, equals(_styleMap));
      });

      test('returns empty Map if the styles is empty', () {
        final result = tokenParser.getStyleSets([]);
        expect(result, equals({}));
      });
    });

    group('findStylesPropertiesInPaintStyles', () {
      test('correctly gets styles', () {
        final result = tokenParser.findStylesPropertiesInPaintStyles(
          _paintStylesResponse,
          _rawStyles,
        );
        expect(
          result,
          equals(
            const [
              ColorStyle(
                name: 'test-style-1',
                paint: Paint(visible: true),
              ),
              TextStyle(
                name: 'test-style-2',
                typeStyle: TypeStyle(),
              ),
              EffectStyle(
                name: 'test-style-3',
                effect: [Effect(visible: true)],
              ),
            ],
          ),
        );
      });

      test('returns null if the styles in the node tree not found', () {
        final result = tokenParser.findStylesPropertiesInPaintStyles(
          const NodesResponse(),
          _rawStyles,
        );
        expect(result, equals(null));
      });
    });

    group('findStylesInNodes', () {
      test('correctly find styles in the node tree', () {
        final result = tokenParser.findStylesInNodes(
          _nodesResponse,
          _rawStyles,
        );
        expect(
          result,
          equals(
            const [
              ColorStyle(
                name: 'test-style-1',
                paint: Paint(visible: true),
              ),
              TextStyle(
                name: 'test-style-2',
                typeStyle: TypeStyle(),
              ),
              EffectStyle(
                name: 'test-style-3',
                effect: [Effect(visible: true)],
              ),
            ],
          ),
        );
      });

      test('returns null if the styles not found', () {
        final result = tokenParser.findStylesInNodes(
          const NodesResponse(),
          _rawStyles,
        );
        expect(result, equals(null));
      });
    });
  });
}
